class ContactsController < ApplicationController
  require 'linkedin'
  def index
    client = LinkedIn::Client.new("u2qwtchjry2s", "EckOuDsWcWAeBJdm")
    request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/contacts/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to client.request_token.authorize_url
  end

  def callback
    client = LinkedIn::Client.new("u2qwtchjry2s", "EckOuDsWcWAeBJdm")
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = client.profile
    @connections = client.connections
  end
end
