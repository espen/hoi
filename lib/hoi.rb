require 'httparty'
require 'json'
require 'cgi'

class Hoi
  VERSION = '0.0.2'

  include HTTParty
  format :plain
  default_timeout 30
  @throws_exceptions = false

  base_uri "https://secure.hoiio.com/open/"

  attr_accessor :app_id, :access_token, :timeout, :throws_exceptions, :test_mode

  @@app_id = nil
  @@access_token = nil
  @@test_mode = false

  def initialize(app_id = nil, access_token = nil, extra_params = {})
    @@app_id = app_id || ENV['HOIIO_APP_ID'] || @@app_id
    @@access_token = access_token || ENV['HOIIO_ACCESS_TOKEN'] || @@access_token
  end

  def app_id
    @@app_id
  end

  def app_id=(value)
    @@app_id = value
  end

  def access_token
    @@access_token
  end

  def access_token=(value)
    @@access_token = value
  end

  def test_mode
    @@test_mode
  end

  def test_mode=(value)
    @@test_mode = value
  end

  protected

    class << self
      attr_accessor :app_id, :access_token, :test_mode

      def app_id=(value)
        @@app_id = value
      end

      def app_id
        @@app_id
      end

      def access_token=(value)
        @@access_token = value
      end

      def access_token
        @@access_token
      end

      def test_mode=(value)
        @@test_mode = value
      end

      def test_mode
        @@test_mode
      end

    end

  def execute_post(url, params)
    self.class.post(url, params) unless @@test_mode
  end

  private

  def default_params(params)
    {:app_id => @@app_id, :access_token => self.access_token}.merge(params)
  end

  def handle_response(response)
    return {:status => 'success_ok'}.to_json if @@test_mode
    response_body = JSON.parse('['+response.body+']').first
    if @throws_exceptions && response_body.is_a?(Hash) && response_body["status"] != "success_ok"
      raise "Error from Hoiio API: #{response_body["status"]}"
    end
    response_body
  end

end


class Hoi::SMS < Hoi
  def send(params)
    handle_response( self.execute_post('/sms/send', {:body => default_params(params) }) )
  end

  def get_rate(params)
    handle_response( self.execute_post('/sms/get_rate', {:body => default_params(params) }) )
  end
end