Function TestSuite__GoogleAnalytics()
  this = BaseTestSuite()

  this.Name = "GoogleAnalyticsTestSuite"

  this.SetUp = GoogleAnalyticsTestSuite__SetUp

  this.addTest("initializeSingleTIDString", TestCase__GoogleAnalytics_initializeSingleTIDString)
  this.addTest("initializeSingleTIDroString", TestCase__GoogleAnalytics_initializeSingleTIDroString)
  this.addTest("initializeMultipleTID", TestCase__GoogleAnalytics_initializeMultipleTID)
  this.addTest("sendHit", TestCase__GoogleAnalytics_sendHit)
  return this
End Function

Function GoogleAnalyticsTestSuite__SetUp()
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

Function TestCase__GoogleAnalytics_sendHit() As String
  port = 21456  ' arbitrary
  mockGA = GoogleAnalyticsTestSuite__CreateMockGAServer(port)
  initGAMobile("test-tracking-id-1", "test-client-id")
  GetGlobalAA().gamobile.url = "http://127.0.0.1:" + stri(port) + "/"
  enableGAMobile(true)
  gamobileSendHit("")

  message = wait(1000, mockGA.GetMessagePort())
  if type(message) = "roSocketEvent" then
    ' Send an HTTP 200 response
    connection = tcpListen.accept()
    buffer = CreateObject("roByteArray")
    buffer[1024] = 0
    bytesReceived = connection.receive(buffer, 0, 1024)
    connection.send("HTTP/1.1 200 OK" + Chr(13) + Chr(10) + Chr(13) + Chr(10), 0, 19)
    connection.close()
  end if
  response = m.AssertNotEmpty(GetGlobalAA().gamobile.asyncReqById)
  gamobileCleanupAsyncReq()
  response = response + m.AssertEmpty(GetGlobalAA().gamobile.asyncReqById)
  return response
End Function

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

Function GoogleAnalyticsTesSuite__HandleMockGAServerEvent(event As Object)
End Function
