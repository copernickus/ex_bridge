Code.require File.expand_path("../test_helper", __FILE__)

object Misultin::ServerTest
  proto ExUnit::Case
  proto ServerCase

  def port
    3002
  end

  def serve_file_with_headers_test
    % Not supported
  end
end