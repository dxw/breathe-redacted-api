require "byebug"
require "dotenv"
Dotenv.load

require_relative "./lib/breathe_client"

require "sinatra"
require "sinatra/json"

before do
  error 401, "API key invalid" unless valid_key?(request.env["HTTP_AUTHORIZATION"])
end

get "/employees" do
  json BreatheClient.employees
end

get "/absences" do
  json BreatheClient.absences(employee_id: params[:employee_id], after: params[:after])
end

get "/sicknesses" do
  json BreatheClient.sicknesses(employee_id: params[:employee_id], after: params[:after])
end

get "/trainings" do
  json BreatheClient.trainings(employee_id: params[:employee_id], after: params[:after])
end

def valid_key?(key)
  key.split[1] === ENV.fetch("MIDDLEMAN_API_KEY")
end
