require 'httparty'
require 'json'
require 'cgi'

class Hoi
  VERSION = '0.0.1'

  include HTTParty
  format :plain
  default_timeout 30

  base_uri "https://secure.hoiio.com/open/"

  attr_accessor :app_id, :access_token, :timeout, :throws_exceptions

  def initialize(app_id = nil, access_token = nil, extra_params = {})
    @app_id = app_id || ENV['HOIIO_APP_ID'] || self.class.app_id
    @access_token = access_token || ENV['HOIIO_ACCESS_TOKEN'] || self.class.access_token
    @default_params = {:app_id => @app_id, :access_token => @access_token}.merge(extra_params)
    @throws_exceptions = false
  end

  def app_id=(value)
    @app_id = value
    @default_params = @default_params.merge({:app_id => @app_id})
  end

  def access_token=(value)
    @access_token = value
    @default_params = @default_params.merge({:access_token => @access_token})
  end

  private

  def handle_response(response)
    response_body = JSON.parse('['+response.body+']').first
    if @throws_exceptions && response_body.is_a?(Hash) && response_body["status"] != "success_ok"
      raise "Error from Hoiio API: #{response_body["status"]}"
    end

    response
  end

end


class Hoi::SMS < Hoi
  def send(params)
    params = @default_params.merge(params)
    handle_response( self.class.post('/sms/send', {:body => params }) )
  end

  def get_rate(params)
    params = @default_params.merge(params)
    handle_response( self.class.post('/sms/get_rate', {:body => params }) )
  end
end