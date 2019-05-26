require 'sinatra'
require 'sinatra/reloader'

get '/' do
  "hello worsss"
end

get '/callback' do
  if params["hub.verify_token"] != "hogehoge"
    return "Error, wrong validation token"
  end
  params["hub.challenge"]
end

