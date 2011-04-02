Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case
  proto ServerCase

  def port
    3001
  end
end