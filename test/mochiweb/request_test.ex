Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case
  proto RequestCase

  def port
    3001
  end
end