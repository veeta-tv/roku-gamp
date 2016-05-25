' *********************************************************
' ** Google Analytics Measurement Protocol for Mobile App Analytics
' **
' ** Because this may be used often, we want to be as minimally
' ** invasive as possible.  For this reason we skip the NewHttp
' ** helper functions and instead manually construct the URI.
' **
' *********************************************************

' *********************************************************
' ** The MIT License (MIT)
' **
' ** Copyright (c) 2016 Christopher D Thompson
' **
' ** Permission is hereby granted, free of charge, to any person obtaining a copy
' ** of this software and associated documentation files (the "Software"), to deal
' ** in the Software without restriction, including without limitation the rights
' ** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' ** copies of the Software, and to permit persons to whom the Software is
' ** furnished to do so, subject to the following conditions:
' **
' ** The above copyright notice and this permission notice shall be included in all
' ** copies or substantial portions of the Software.
' **
' ** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' ** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' ** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' ** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' ** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' ** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

' *********************************************************


'*****************************
'** Initialization and request firing
'*****************************
Function initGAMobile(tracking_id As String, client_id As String) As Void
  gamobile = CreateObject("roAssociativeArray")

  ' Set up some invariants
  gamobile.url = "http://www.google-analytics.com/collect"
  gamobile.version = "1"
  gamobile.tracking_id = tracking_id
  gamobile.client_id = client_id
  gamobile.next_z = 1

  app_info = CreateObject("roAppInfo")
  gamobile.app_name = app_info.GetTitle()
  gamobile.app_version = app_info.GetVersion()
  gamobile.app_id = app_info.GetID()
  device = createObject("roDeviceInfo")
  gamobile.installer_id = device.getModel()
  ' single point of on/off for analytics
  gamobile.enable = false
  'set global attributes
  m.gamobile = gamobile
End Function


Function enableGAMobile(enable As Boolean) As Void
  m.gamobile.enable = enable
End Function


'*****************************
'** Hit types
'*****************************

'**
'** PageView is primarily intended for web site tracking but is included here for completeness.
'**
Function gamobilePageView(hostname="" As String, page="" As String, title="" As String) As Void
  print "Analytics:PageView: " + page

  params = "&t=pageview"
  params = params + "&dh=" + URLEncode(hostname)   ' Document hostname
  params = params + "&dp=" + URLEncode(page)       ' Page
  params = params + "&dt=" + URLEncode(title)      ' Title
  gamobileSendHit(params)
End Function

'**
'** Use the Event for application state events, such as a login or registration.
'**
Function gamobileEvent(category As String, action As String, label="" As String, value="" As String) As Void
  print "Analytics:Event: " + category + "/" + action

  params = "&t=event"
  params = params + "&ec=" + URLEncode(category)   ' Event Category. Required.
  params = params + "&ea=" + URLEncode(action)     ' Event Action. Required.
  if label <> "" then params = params + "&el=" + URLEncode(label)      ' Event label.
  if value <> "" then params = params + "&ev=" + URLEncode(value)      ' Event value.
  gamobileSendHit(params)
End Function

'**
'** Use the ScreenView for navigation of screens.  This is useful for identifying popular
'** categories or determining conversion rates for a video stream.
'**
Function gamobileScreenView(screen_name As String) As Void
  print "Analytics:Screen: " + screen_name

  params = "&t=screenview"
  params = params + "&cd=" + URLEncode(screen_name)                ' Screen name / content description.
  gamobileSendHit(params)
End Function

'**
'** Use the Transaction for in-app purchases or launching a stream.  Some channel publishers may
'** pay content owners based on number of plays and Transaction would easily track this.
'**
'**
Function gamobileTransaction(transaction_id As String, affiliation="" As String, revenue="" As String, shipping="" As String, tax="" As String) As Void
  print "Analytics:Transaction: " + transaction_id

  params = "&t=transaction"
  params = params + "&ti=" + URLEncode(transaction_id)  ' Transaction ID
  if affiliation <> "" then params = params + "&ta=" + URLEncode(affiliation)   ' Transaction Affiliation
  if revenue <> "" then params = params + "&tr=" + URLEncode(revenue)           ' Transaction Revenue ("This value should include any shipping or tax costs" - Google)
  if shipping <> "" then params = params + "&ts=" + URLEncode(shipping)         ' Transaction Shipping
  if tax <> "" then params = params + "&tt=" + URLEncode(tax)                   ' Transaction Tax
  gamobileSendHit(params)
End Function

Function gamobileItem() As Void
  'TODO: implement this
End Function

Function gamobileSocial() As Void
  'TODO: implement this
End Function

'**
'** Use Exception for reporting unexpected exceptions and errors. This is useful for identifying bad streams
'** or misbehaving CDNs.
'**
Function gamobileException(description As String) As Void
  print "Analytics:Exception: "
  params = "&t=exception"
  params = params + "&exd=" + URLEncode(description)  ' Exception description.
  params = params + "&exf=0"                          ' Exception is fatal? (we can't capture fatals in brightscript)
  gamobileSendHit(params)
End Function

Function gamobileTiming() As Void
  'TODO: implement this
End Function

' @params   Stringified, encoded parameters appropriate for the hit. Must start with '&'
Function gamobileSendHit(hit_params As String) As Void
  if m.gamobile.enable <> true then
    print "Analytics disabled. Skipping report"
    return
  endif

  url = m.gamobile.url

  'all formatted body params for the POST
  full_params = "v=" + tostr(m.gamobile.version)
  full_params = full_params + "&tid=" + URLEncode(m.gamobile.tracking_id)
  full_params = full_params + "&cid=" + URLEncode(m.gamobile.client_id)
  full_params = full_params + "&an=" + URLEncode(m.gamobile.app_name)        ' App name.
  full_params = full_params + "&av=" + URLEncode(m.gamobile.app_version)     ' App version.
  full_params = full_params + "&aid=" + URLEncode(m.gamobile.app_id)         ' App Id.
  full_params = full_params + "&aiid=" + URLEncode(m.gamobile.installer_id)  ' App Installer Id.
  full_params = full_params + hit_params
  full_params = full_params + "&z=" + tostr(m.gamobile.next_z)  ' Cache buster

  request = CreateObject("roURLTransfer")
  request.SetRequest("POST")
  request.SetUrl(url)

  ' Asynchronously fire this request off, ignore any response
  ' TODO: later we want to track all outbound HTTP, even analytics
  '       for error reporting
  'request.AsyncPostFromString(full_params)
  'TODO: For some reason Async doesn't execute, but the following line does.
  '      Fix this.
  response = request.PostFromString(full_params)

  ' Increment the cache buster
  m.gamobile.next_z = m.gamobile.next_z + 1

End Function
