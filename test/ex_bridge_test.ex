Code.require File.expand_path("../test_helper", __FILE__)

object ExBridgeTest
  proto ExUnit::Case

  def toplevel_test
    ExBridge
  end
end