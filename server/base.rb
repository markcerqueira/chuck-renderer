require 'sinatra'
require 'json'
require './app.rb'

helpers do
  def json(*args)
    headers 'Content-Type' => 'application/json'
    hash = args.length == 1 ? args.shift : args
    if hash
      body hash.to_json
    else
      body {}.to_json
    end
  end
end
