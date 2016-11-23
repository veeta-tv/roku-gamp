Function TestSuite__GoogleAnalytics()
  print "Running TestSuite__GoogleAnalytics()"
  this = BaseTestSuite()
  this.Name = "GoogleAnalyticsTestSuite"
  this.addTest("initializeSingleTIDString",TestCase__GoogleAnalytics_initializeSingleTIDString).
  this.addTest("initializeSingleTIDroString",TestCase__GoogleAnalytics_initializeSingleTIDroString).
  this.addTest("initializeMultipleTID",TestCase__GoogleAnalytics_initializeMultipleTID).
  return this
End Function

Function TestCase__GoogleAnalytics_initializeSingleTIDString() as String 
  print "Running TestSuite__GoogleAnalytics_initializeSingleTIDString()"
  gawrapper  = {
    init: initGAMobile
  }
  gawrapper.init("test-tracking-id", "test-client-id")
  result = m.AssertNotInvalid(gawrapper.gamobile)
  result = result + m.AssertEqual(type(gawrapper.gamobile.tracking_ids), "roArray")
  result = result + m.AssertArrayContainsOnly(gawrapper.gamobile.tracking_ids, "String")
  return result
End Function

Function TestCase__GoogleAnalytics_initializeSingleTIDroString() as String 
  print "Running TestSuite__GoogleAnalytics_initializeSingleTIDroString()"
  gawrapper  = {
    init: initGAMobile
  }
  trackingId = CreateObject("roString")
  trackingId.SetString("test-tracking-id")
  gawrapper.init(trackingId, "test-client-id")
  result = m.AssertNotInvalid(gawrapper.gamobile)
  result = result + m.AssertEqual(type(gawrapper.gamobile.tracking_ids), "roArray")
  return result
End Function

Function TestCase__GoogleAnalytics_initializeMultipleTID() as String 
  print "Running TestSuite__GoogleAnalytics_initializeMultipleTID()"
  gawrapper  = {
    init: initGAMobile
  }
  gawrapper.init(["test-tracking-id-1", "test-tracking-id-2"], "test-client-id")
  result = m.AssertNotInvalid(gawrapper.gamobile)
  result = result + m.AssertEqual(type(gawrapper.gamobile.tracking_ids), "roArray")
  return result
End Function
