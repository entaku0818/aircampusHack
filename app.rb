require 'sinatra'
require_relative './bbt-login/bbtScoreGet.rb'
bbtScraping = BbtScraping.new()

set :show_exceptions, false


error do |e|
  status 500
  body e.message
end

get '/' do
  erb :index
end

post '/submit' do
  userid = params[:userid]
  password = params[:password]
  scores = bbtScraping.scoreGet(userid, password)

  @scores = scores["scores"]
  @gpa = scores["gpa"]
  erb :submit
end

post '/task' do
  userid = params[:userid]
  password = params[:password]
  scores = bbtScraping.taskGet(userid, password)


  erb :task
end
