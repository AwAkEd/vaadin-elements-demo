require 'sinatra'
require 'json'
require 'vaadin/elements'

helpers Vaadin::ViewHelpers

before do
  @cards, @sets = %w{AllCards SetList}.collect { |filename| JSON.parse(File.read("#{filename}.json")) }
end

get '/' do
  erb :index
end