require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'dotenv'
Dotenv.load

get '/' do
  "hello worsss"
end

get '/callback' do
  if params["hub.verify_token"] != "hogehoge"
    return "Error, wrong validation token"
  end
  params["hub.challenge"]
end

post '/callback' do
  hash = JSON.parse(request.body.read)
  message = hash["entry"][0]["messaging"][0]
  sender = message["sender"]["id"]
  text = message["message"]["text"]
  endpoint = "https://graph.facebook.com/v3.3/me/messages?access_token=" + ENV["FACEBOOK_ACCESS_TOKEN_KEY"]
  content = {
    recipient: {id: sender},
    message: {text: text}
  }
  status 201
  body ''
end
