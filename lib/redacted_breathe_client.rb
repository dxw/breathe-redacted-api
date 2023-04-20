require "breathe"
require "byebug"

class RateLimited < StandardError
  def initialize(msg = "Redacted Breathe Client is rate limited")
    super
  end
end

class RedactedBreatheClient
  class << self
    def client
      Breathe::Client.new(api_key: ENV.fetch("BREATHE_API_KEY", "1"), auto_paginate: true)
    end

    def employees
      client
        .employees
        .list
        .response
        .data[:employees]
        .map { |employee| employee.to_hash.slice(:id, :email) } # This is very important for concealing private information
    rescue => error
      raise RateLimited if rate_limited?(error)
      client.last_response
      byebug
      "x"
    end

    def absences(employee_id:, after:)
      client
        .absences
        .list(
          employee_id: employee_id,
          start_date: after,
          exclude_cancelled_absences: true
        )
        .response
        .data[:absences]
        .map(&:to_hash)
    rescue => error
      raise unless rate_limited?(error)
      raise RateLimited
    end

    def sicknesses(employee_id:, after:)
      client
        .sicknesses
        .list(
          employee_id: employee_id,
          start_date: after,
          exclude_cancelled_sicknesses: true
        )
        .response
        .data[:sicknesses]
        .map(&:to_hash)
    rescue => error
      raise unless rate_limited?(error)
      raise RateLimited
    end

    def trainings(employee_id:, after:)
      client
        .employee_training_courses
        .list(
          employee_id: employee_id,
          start_date: after,
          exclude_cancelled_employee_training_courses: true
        )
        .response
        .data[:employee_training_courses]
        .map(&:to_hash)
    rescue => error
      raise unless rate_limited?(error)
      raise RateLimited
    end

    def rate_limited?(error)
      (
        error.instance_of?(Breathe::UnknownError) &&
        client.last_response &&
        client.last_response.data[:error][:type] == "Rate Limit Reached"
      ) || (
        error.instance_of?(TypeError) &&
        error.message == "no implicit conversion of nil into Array"
      )
    end
  end
end
