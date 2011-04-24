Code.require_file "../test_helper", __FILE__

object ExBridgeTest
  proto ExUnit::Case

  def no_support_test
    self.assert_error { 'nobridge, "No request bridge for 'webrick" }, -> ExBridge.request('webrick, [])
  end
end