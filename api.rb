require "dotenv"
Dotenv.load

require_relative "./lib/redacted_breathe_client"

require "sinatra"
require "sinatra/json"

def valid_key?(key)
  key === ENV.fetch("MIDDLEMAN_API_KEY")
end

def ensure_key_is_set
  key = ENV.fetch("MIDDLEMAN_API_KEY")
  raise "MIDDLEMAN_API_KEY not set properly" if key.nil? || key.length < 64
end

ensure_key_is_set

# Routing

before do
  error 401, "API key invalid" unless valid_key?(request.env["HTTP_X_API_KEY"])
end

get "/employees" do
  json RedactedBreatheClient.employees
rescue RateLimited
  halt(420, "Redacted API: Rate limited")
end

get "/absences" do
  json RedactedBreatheClient.absences(employee_id: params[:employee_id], after: params[:after])
rescue RateLimited
  halt(420, "Redacted API: Rate limited")
end

get "/sicknesses" do
  json RedactedBreatheClient.sicknesses(employee_id: params[:employee_id], after: params[:after])
rescue RateLimited
  halt(420, "Redacted API: Rate limited")
end

get "/employee_training_courses" do
  json RedactedBreatheClient.trainings(employee_id: params[:employee_id], after: params[:after])
rescue RateLimited
  halt(420, "Redacted API: Rate limited")
end
