require 'sinatra'
require 'json'

before do
  @cards, @sets = %w{AllCards SetList}.collect { |filename| JSON.parse(File.read("#{filename}.json")) }
end

get '/' do
  erb :index
end