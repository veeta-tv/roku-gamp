Function TestSuite__GoogleAnalytics()
  this = BaseTestSuite()

  this.Name = "GoogleAnalyticsTestSuite"

  this.SetUp = GoogleAnalyticsTestSuite__SetUp

  this.BeforeEach = GoogleAnalyticsTestSuite__BeforeEach  ' not officially supported, just a suite member variable

  this.addTest("initializeSingleTIDString", TestCase__GoogleAnalytics_initializeSingleTIDString)
  this.addTest("initializeSingleTIDroString", TestCase__GoogleAnalytics_initializeSingleTIDroString)
  this.addTest("initializeMultipleTID", TestCase__GoogleAnalytics_initializeMultipleTID)
  this.addTest("requestIsTracked", TestCase__GoogleAnalytics_requestIsTracked)
  this.addTest("requestIsCleanedUp", TestCase__GoogleAnalytics_requestIsCleanedUp)
  this.addTest("sendHit", TestCase__GoogleAnalytics_sendHit)
  this.addTest("pageView", TestCase__GoogleAnalytics_pageView)
  this.addTest("event", TestCase__GoogleAnalytics_event)
  this.addTest("screenView", TestCase__GoogleAnalytics_screenView)
  this.addTest("transaction", TestCase__GoogleAnalytics_transaction)
  this.addTest("exception", TestCase__GoogleAnalytics_exception)
  this.addTest("customHitParams", TestCase__GoogleAnalytics_customHitParams)
  this.addTest("customHitParamsOverrideSessionParams", TestCase__GoogleAnalytics_customHitParamsOverrideSessionParams)
  return this
End Function

Function GoogleAnalyticsTestSuite__SetUp()
  m.mockGA = GoogleAnalyticsTestSuite__CreateMockGAServer(21457) ' arbitrary port number
End Function

Function TestCase__GoogleAnalytics_initializeSingleTIDString() as String 
  initGAMobile("test-tracking-id", "test-client-id")
  result = m.AssertNotInvalid(GetGlobalAA().gamobile)
  result = result + m.AssertEqual(type(GetGlobalAA().gamobile.tracking_ids), "roArray")
  result = result + m.AssertArrayContainsOnly(GetGlobalAA().gamobile.tracking_ids, "String")
  return result
End Function

Function TestCase__GoogleAnalytics_initializeSingleTIDroString() as String 
  trackingId = CreateObject("roString")
  trackingId.SetString("test-tracking-id")
  initGAMobile(trackingId, "test-client-id")
  result = m.AssertNotInvalid(GetGlobalAA().gamobile)
  result = result + m.AssertEqual(type(GetGlobalAA().gamobile.tracking_ids), "roArray")
  return result
End Function

Function TestCase__GoogleAnalytics_initializeMultipleTID() as String 
  initGAMobile(["test-tracking-id-1", "test-tracking-id-2"], "test-client-id")
  result = m.AssertNotInvalid(GetGlobalAA().gamobile)
  result = result + m.AssertEqual(type(GetGlobalAA().gamobile.tracking_ids), "roArray")
  return result
End Function

Function GoogleAnalyticsTestSuite__BeforeEach()
  initGAMobile("test-tracking-id-1", "test_client_id")
  GetGlobalAA().gamobile.url = "http://127.0.0.1:21457/"
  GetGlobalAA().gamobile.session_params.aiid = "1234X" ' override device model so we have a predictable aiid value
  enableGAMobile(true)
  ' clear out any connection backlog
  while GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA) <> "": end while
End Function

Function TestCase__GoogleAnalytics_requestIsTracked() As String
  m.BeforeEach()
  gamobileSendHit({})
  return m.AssertNotEmpty(GetGlobalAA().gamobile.asyncReqById)
End Function

Function TestCase__GoogleAnalytics_requestIsCleanedUp() As String
  m.BeforeEach()
  gamobileSendHit({})
  GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  sleep(100)  ' allow OS to read network closure
  gamobileCleanupAsyncReq()
  return m.AssertEmpty(GetGlobalAA().gamobile.asyncReqById)
End Function

Function TestCase__GoogleAnalytics_sendHit() As String
  m.BeforeEach()
  gamobileSendHit({})
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&av=1.0.2&aid=dev&cid=test_client_id&aiid=1234X&an=roku-gamp&tid=test-tracking-id-1")
End Function

Function TestCase__GoogleAnalytics_pageView() As String
  m.BeforeEach()
  gamobilePageView("roku-gamp", "/some/page/", "SomePage")
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&av=1.0.2&dp=%2Fsome%2Fpage%2F&dt=SomePage&dh=roku-gamp&aid=dev&cid=test_client_id&aiid=1234X&t=pageview&an=roku-gamp&tid=test-tracking-id-1")

End Function

Function TestCase__GoogleAnalytics_event() As String
  m.BeforeEach()
  gamobileEvent("registration", "success")
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&av=1.0.2&ea=success&aid=dev&ec=registration&cid=test_client_id&aiid=1234X&t=event&an=roku-gamp&tid=test-tracking-id-1")
End Function

Function TestCase__GoogleAnalytics_screenView() As String
  m.BeforeEach()
  gamobileScreenView("HomeScreen")
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&cd=HomeScreen&av=1.0.2&aid=dev&cid=test_client_id&aiid=1234X&t=screenview&an=roku-gamp&tid=test-tracking-id-1")
End Function

Function TestCase__GoogleAnalytics_transaction() As String
  m.BeforeEach()
  gamobileTransaction("E1E20904-FF3B-4659-A1F8-C93C6F393FFC", "GoogleAnalytics", "1.99", "0.99", "0.09")
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&tr=1.99&av=1.0.2&ts=0.99&tt=0.09&ti=E1E20904-FF3B-4659-A1F8-C93C6F393FFC&aid=dev&ta=GoogleAnalytics&cid=test_client_id&aiid=1234X&t=transaction&an=roku-gamp&tid=test-tracking-id-1")
End Function

Function TestCase__GoogleAnalytics_exception() As String
  m.BeforeEach()
  gamobileException("Use of uninitialized variable. (runtime error &he9) in pkg:/source/googleAnalytics.brs(213)")
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString,  "v=1&z=1&exd=Use%20of%20uninitialized%20variable.%20%28runtime%20error%20%26he9%29%20in%20pkg%3A%2Fsource%2FgoogleAnalytics.brs%28213%29&av=1.0.2&exf=0&aid=dev&cid=test_client_id&aiid=1234X&t=exception&an=roku-gamp&tid=test-tracking-id-1")
End Function


Function TestCase__GoogleAnalytics_customHitParams() As String
  m.BeforeEach()
  gamobileSendHit({ cd1: "7.5.1"})  ' e.g. Firmware version defined as custom dimension
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&av=1.0.2&aid=dev&cid=test_client_id&aiid=1234X&cd1=7.5.1&an=roku-gamp&tid=test-tracking-id-1")
End Function

Function TestCase__GoogleAnalytics_customHitParamsOverrideSessionParams() As String
  m.BeforeEach()
  gamobileSendHit({ cid: "client_id_override"})  ' e.g. Firmware version defined as custom dimension
  hitString = GoogleAnalyticsTesSuite__HandleMockGAServerEvent(m.mockGA)
  return m.AssertEqual(hitString, "v=1&z=1&av=1.0.2&aid=dev&cid=client_id_override&aiid=1234X&an=roku-gamp&tid=test-tracking-id-1")
End Function


'###########
' HELPERS
'###########

Function GoogleAnalyticsTestSuite__CreateMockGAServer(port As Integer)
  messagePort = CreateObject("roMessagePort")
  socket = CreateObject("roStreamSocket")
  socket.SetMessagePort(messagePort)
  address = CreateObject("roSocketAddress")
  address.SetPort(port)
  socket.SetAddress(address)
  socket.NotifyReadable(true)
  socket.Listen(1)
  return socket
End Function

' Respond with an HTTP 200 OK for any hit. Return a stringified version of request
Function GoogleAnalyticsTesSuite__HandleMockGAServerEvent(server As Object) As String
  message = wait(1000, server.GetMessagePort())
  buffer = CreateObject("roByteArray")
  buffer[4096] = 0  ' force size of 4096 bytes
  hitString = ""
  if type(message) = "roSocketEvent" then
    ' Send an HTTP 200 response
    connection = server.accept()
    sleep(100)  ' sleep just long enough to be sure that entire request has arrived
    bytesReceived = connection.receive(buffer, 0, 4096)
    connection.send("HTTP/1.1 200 OK" + Chr(13) + Chr(10) + Chr(13) + Chr(10), 0, 19)
    connection.close()
    requestString = buffer.ToAsciiString()
    postBodyRegex = CreateObject("roRegex", "\r\n\r\n(.*)", "")
    matches = postBodyRegex.Match(requestString)
    if matches.Count() >= 2 then
      hitString = matches[1]
    end if
  end if
  return hitString
End Function

