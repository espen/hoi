require 'helper'
require 'cgi'

class TestHoi < Test::Unit::TestCase

  context "attributes" do

    setup do
      @app_id = "singapore"
      @access_token = "spg"
    end

    should "have no API by default" do
      @hoi = Hoi.new
      assert_equal(nil, @hoi.app_id)
      assert_equal(nil, @hoi.access_token)
    end

    should "set an credentials in constructor" do
      @hoi = Hoi.new(@app_id, @access_token)
      assert_equal(@app_id, @hoi.app_id)
      assert_equal(@access_token, @hoi.access_token)
    end

    should "set an APP id from the ENV variables" do
      ENV['HOIIO_APP_ID'] = @app_id
      ENV['HOIIO_ACCESS_TOKEN'] = @access_token
      @hoi = Hoi.new
      assert_equal(@app_id, @hoi.app_id)
      assert_equal(@access_token, @hoi.access_token)
      ENV.delete('HOIIO_APP_ID')
      ENV.delete('HOIIO_ACCESS_TOKEN')
    end

    should "set an API id via setter" do
      @hoi = Hoi.new
      @hoi.app_id = @app_id
      @hoi.access_token = @access_token
      assert_equal(@app_id, @hoi.app_id)
      assert_equal(@access_token, @hoi.access_token)
    end

    should "set timeout and get" do
      @hoi = Hoi.new
      timeout = 30
      @hoi.timeout = timeout
      assert_equal(timeout, @hoi.timeout)
    end
  end

  context "Hoi instances" do
    setup do
      @app_id = "mylittleid"
      @access_token = "yodawg"
      @hoi = Hoi::SMS.new(@app_id, @access_token)
      @msg = "hello"
      @dest = "123"
      @url = "https://secure.hoiio.com/open/sms/send/"
      @body = {"app_id" => @app_id, "access_token" => @access_token}
    end

    should "throw exception if configured to and the API replies with a JSON hash not containing 'success_ok'" do
      Hoi::SMS.stubs(:post).returns(Struct.new(:body).new({'status' => 'error_X_param_missing'}.to_json))
      @hoi.throws_exceptions = true
      assert_raise RuntimeError do
        @hoi.send(:msg => @msg, :dest => @dest)
      end
    end
  end

  context "SMS API" do
    setup do
      @app_id = "mylittleid"
      @access_token = "yodawg"
      @hoi = Hoi::SMS.new(@key)
      @url = "https://secure.hoiio.com/open/sms/send/"
      @msg = "hello"
      @dest = "123"
      @body = {:app_id => @app_id, :access_token => @access_token}
    end


    should "send sms" do
      Hoi.stubs(:post).returns(Struct.new(:body).new({'status' => 'success_ok'}.to_json))
      assert @hoi.send(:msg => @msg, :dest => @dest)
    end

  end

end