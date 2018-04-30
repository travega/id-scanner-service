require "sinatra"
require 'sinatra/activerecord'
require 'json'
require './models/stock'

set :database_file, "./config/database.yml"

class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    post '/api/user/scan' do
        content_type :json

        begin
            params = JSON.parse(request.env["rack.input"].read)
        rescue
            return {error: "Error parsing JSON."}.to_json
        end

        puts params["name"]
        puts Stock.first.dc_stock_target__c

        { message: "Awesome Sauce!" }.to_json
    end
end