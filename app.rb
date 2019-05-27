require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'dotenv'
require 'rest-client'
Dotenv.load
FB_ENDPOINT = "https://graph.facebook.com/v3.3/me/messages?access_token=" + ENV["FACEBOOK_ACCESS_TOKEN_KEY"]
GNAVI_KEYID = ENV['GNAVI_KEY']
GNAVI_CATEGORY_LARGE_SEARCH_API = "https://api.gnavi.co.jp/master/CategoryLargeSearchAPI/v3/"


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
  message = hash["entry"][0]["messaging"][0] #entryの0個目のmessagingの0個目
  sender = message["sender"]["id"] #上記で取得したmessage変数の中のsenderのid
  
  if message["message"]["text"] == "レストラン検索"
  else
    text = "カテゴリーと位置情報からレストランを検索します。レストランを検索したい場合は、「レストラン検索」と話しかけてね！"
    content = {
      recipient: {id: sender},
      message: {text: text}
    }
    request_body = content.to_json

    #オウム返しの返信をPOSTする（返す）
    RestClient.post FB_ENDPOINT, request_body, content_type: :json, accept: :json
  end
  status 201
  body ''
end