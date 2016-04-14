require 'sinatra'
require 'json'
require 'vaadin/elements'

enable :sessions

helpers Vaadin::ViewHelpers

before do
  Encoding.default_external=Encoding::UTF_8
  @cards, @sets = %w{AllCards SetList}.collect { |filename| JSON.parse(File.read("#{filename}.json")) }
  @types = %w{Artifact Creature Enchantment Instant Land Sorcery Planeswalker}
  # cmcs actually need to contain some string, because of https://github.com/vaadin-miki/vaadin-elements/issues/10
  @cmcs = @cards.values.collect { |v| v['cmc'] }.uniq.compact.sort.collect { |x| "#{x}" }
end

post '/cards' do
  # from cards, select
  matching = @cards.select { |name, data| !name.include?("token card") && session[:filters].all? { |type, values| values.empty? || data[type].nil? || (data[type].is_a?(Array) && values.any? { |v| data[type].include?(v) }) || values.any? { |v| data[type].to_s == v.to_s } } }
  puts "Selecting #{params['count']} cards from #{matching.size} matching the current filters, starting at index #{params['index']}."

  content_type 'application/json', charset: 'utf-8'
  {result: matching.values[params['index'].to_i, params['count'].to_i], size: matching.size}.to_json
end

post '/update' do
  attribute = case params['id']
                when 'card-type' then
                  'types'
                when 'cmc' then
                  'cmc'
                when 'sets' then
                  'printings'
                else
                  raise "unsupported parameters #{params.inspect}"
              end
  if params["value"].empty? then
    session[:filters][attribute].clear
  elsif !session[:filters][attribute].include?(params['value'])
    session[:filters][attribute] << params['value']
  end

  puts "Current filters: #{session[:filters].inspect}."

  content_type 'application/json', charset: 'utf-8'
  {grid: {refreshItems: nil}, active: {innerHTML: session[:filters].inspect}}.to_json
end

get '/' do
  session[:filters] = {}
  %w{types cmc printings}.each { |filter| session[:filters][filter] = [] }
  erb :index
end