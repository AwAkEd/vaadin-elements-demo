require 'sinatra'

get '/' do
  @hello = 'My name is Sinatra and welcome to web apps.'
  erb :index
end