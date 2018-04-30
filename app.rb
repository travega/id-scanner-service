require "sinatra"
require 'sinatra/activerecord'
require 'json'
require './models/identified_person'

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

        IdentifiedPerson.all.each do |identified_person|
            puts identified_person.name
        end

        { message: "Awesome Sauce!" }.to_json
    end
end