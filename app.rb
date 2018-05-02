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

        begin
            IdentifiedPerson.create!(identified_person_payload(params));
            person = Patient.create!(patient_payload(params));

            IdentifiedPerson.all.each do |identified_person|
                puts identified_person.name
            end

            { message: "'#{person.name}' record Successfully created!" }.to_json
        rescue
            return {error: "Error saving ID record."}.to_json
        end
    end

    def patient_payload(params)
        {
            name: "#{params["fname"]} #{params["lname"]}",
            legal_first_name__c: params["fname"],
            legal_last_name__c: params["lname"],
            gender__c: params["gender"],
            date_of_birth__c: params["dob"],
            id_type__c: params["travelDocType"],
            nationality__c: params["nationality"],
            document_code__c: params["docCode"]
        }
    end

    def identified_person_payload(params)
        {
            name: "#{params["fname"]} #{params["lname"]}",
            first_name__c: params["fname"],
            last_name__c: params["lname"],
            gender__c: params["gender"],
            date_of_birth__c: params["dob"],
            travel_doc_type__c: arams["travelDocType"],
            nationality__c: params["nationality"],
            document_code__c: params["docCode"],
            external_id__c: SecureRandom.hex(12)
        }
    end
end