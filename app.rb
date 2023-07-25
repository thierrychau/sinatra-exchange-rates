require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

def fetch_symbols
  exchangerate_url = "https://api.exchangerate.host/symbols"
  raw_exchangerate = HTTP.get(exchangerate_url)
  parsed_exchangerate = JSON.parse(raw_exchangerate)

  symbols_hash = parsed_exchangerate.fetch("symbols")

  list_symbols = []

  symbols_hash.each do |currency_symbol, currency_hash|
    list_symbols.push(currency_symbol)
  end

  return list_symbols
end

get("/") do
  @list_currency = fetch_symbols

  erb(:currency_pairs)
end

get("/:from_currency") do
  @list_currency = fetch_symbols

  erb(:flexible_from_currency)
end

get("/:from_currency/:to_currency") do
  currency_from_to_url = "https://api.exchangerate.host/convert?from=#{params.fetch("from_currency")}&to=#{params.fetch("to_currency")}"
  raw_currency_from_to = HTTP.get(currency_from_to_url)
  parsed_currency_from_to = JSON.parse(raw_currency_from_to)

  @rate = parsed_currency_from_to.fetch("info").fetch("rate")

  erb(:flexible_to_currency)
end
