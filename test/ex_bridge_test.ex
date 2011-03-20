Code.require File.expand_path("../test_helper", __FILE__)

object ExBridgeTest
  proto ExUnit::Case

  def no_support_test
    self.assert_error { 'nobridge, "No bridge for 'webrick" }, -> ExBridge.request('webrick, [])
  end
end