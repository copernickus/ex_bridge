Code.require_file "../test_helper", __FILE__

object Misultin::ServerTest
  proto ExUnit::Case
  proto ServerCase

  def port
    3002
  end
end