require 'httparty'
require 'json'
require 'cgi'

class Hoi
  VERSION = '0.0.1'

  include HTTParty
  format :plain
  default_timeout 30
  @throws_exceptions = false

  base_uri "https://secure.hoiio.com/open/"

  attr_accessor :app_id, :access_token, :timeout, :throws_exceptions

  @@app_id = nil
  @@access_token = nil

  def initialize(app_id = nil, access_token = nil, extra_params = {})
    @@app_id = app_id || ENV['HOIIO_APP_ID'] || @@app_id
    @@access_token = access_token || ENV['HOIIO_ACCESS_TOKEN'] || @@access_token
  end

  def app_id
    @@app_id
  end

  def access_token
    @@access_token
  end

  def app_id=(value)
    @@app_id = value
  end

  def access_token=(value)
    @@access_token = value
  end


  protected

    class << self
      attr_accessor :app_id, :access_token

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

    end

  private

  def default_params(params)
    {:app_id => @@app_id, :access_token => self.access_token}.merge(params)
  end

  def handle_response(response)
    response_body = JSON.parse('['+response.body+']').first
    if @throws_exceptions && response_body.is_a?(Hash) && response_body["status"] != "success_ok"
      raise "Error from Hoiio API: #{response_body["status"]}"
    end
    response_body
  end

end


class Hoi::SMS < Hoi
  def send(params)
    handle_response( self.class.post('/sms/send', {:body => default_params(params) }) )
  end

  def get_rate(params)
    handle_response( self.class.post('/sms/get_rate', {:body => default_params(params) }) )
  end
end