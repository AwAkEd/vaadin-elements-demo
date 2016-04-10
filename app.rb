require 'sinatra'
require 'json'
require 'vaadin/elements'

helpers Vaadin::ViewHelpers

before do
  @cards, @sets = %w{AllCards SetList}.collect { |filename| JSON.parse(File.read("#{filename}.json")) }
  @types = %w{Artifact Creature Enchantment Instant Land Sorcery Planeswalker}
  @cmcs = @cards.values.collect { |v| v["cmc"] }.uniq.compact.sort.collect(&:to_s)
end

get '/' do
  erb :index
end