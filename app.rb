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

        fname = params["fname"]
        lname = params["lname"]
        gender = params["gender"]
        dob = params["dob"]
        travel_doc_type = params["travelDocType"]
        nationality = params["nationality"]
        doc_code = params["docCode"]

        payload = {
            name: "#{fname} #{lname}",
            first_name__c: fname,
            last_name__c: lname,
            gender__c: gender,
            date_of_birth__c: dob,
            travel_doc_type__c: travel_doc_type,
            nationality__c: nationality,
            document_code__c: doc_code,
            external_id__c: SecureRandom.hex(12)
        }

        IdentifiedPerson.create!(payload);

        IdentifiedPerson.all.each do |identified_person|
            puts identified_person.name
        end

        { message: "Awesome Sauce!" }.to_json
    end
end