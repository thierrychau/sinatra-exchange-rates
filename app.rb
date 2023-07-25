require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

exchangerate_url = "https://api.exchangerate.host/symbols"
raw_exchangerate = HTTP.get(exchangerate_url)
parsed_exchangerate = JSON.parse(raw_exchangerate)

symbols_hash = parsed_exchangerate.fetch("symbols")

list_currency = []

symbols_hash.each do |currency_symbol, currency_hash|
  list_currency.push(currency_symbol)
end

get("/") do
  @list_currency = list_currency
  
  erb(:currency_pairs)
end

get("/:user_currency") do
  @list_currency = list_currency

  erb(:flexible_from)
end
