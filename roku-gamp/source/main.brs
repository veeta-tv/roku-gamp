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


'************************************************************
'** Application startup
'************************************************************
Function Main(args As Dynamic) As void
    m.port = CreateObject("roMessagePort")  'Need a port to handle GA async HTTP req
    
    gamobile_tracking_ids = ["tracking-id-here"] ' tracking id for this channel
    device = createObject("roDeviceInfo")
    gamobile_client_id = device.GetPublisherId() 'unique, anonymous, per-device id
    enable_tracking = NOT device.IsAdIdTrackingDisabled() 'setting in Roku menu to limit tracking

    ' Init analytics
    initGAMobile(gamobile_tracking_ids, gamobile_client_id, m.port)
    if enable_tracking then
      print "Enabling tracking analytics"
      enableGAMobile(true)
    endif

    ' Track channel screens
    gamobileScreenView("Home")

    ' Track an event
    gamobileEvent("Registration", "Complete")

    ' Track an exception (unexpected state)
    gamobileException("metadata request returned HTTP status 404")

    ' Track a transaction
    gamobileTransaction("Purchase-Code", "", "1.99")

    ' Main event loop    
    while true
        msg = wait(0, m.port)        
        msgType = type(msg)
        
        if msgType = "roUrlEvent"            
            requestId = msg.GetSourceIdentity().ToStr()
            ? "[Main] got roUrlEvent ";requestId 
            if isGaMobileHttpRequest(requestId)
                handleGaMobileHttpResponseEvent(msg)    'This cleans up resources
            endif                     
        endif
    end while
End Function

