require "breathe"

class BreatheClient
  class << self
    def client
      Breathe::Client.new(api_key: ENV.fetch("BREATHE_API_KEY"), auto_paginate: true)
    end

    def employees
      client
        .employees
        .list
        .response
        .data[:employees]
        .map { |employee| employee.to_hash.slice(:id, :email) } # This is very important for concealing private information
    rescue => error
      raise unless rate_limited?(error)

      await_rate_limit_reset

      employees
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

      await_rate_limit_reset

      absences(employee_id: employee_id, after: after)
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

      await_rate_limit_reset

      sicknesses(employee_id: employee_id, after: after)
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

      await_rate_limit_reset

      trainings(employee_id: employee_id, after: after)
    end

    SECONDS_FOR_RATE_LIMIT_RESET = 60

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

    def await_rate_limit_reset
      puts "Waiting #{SECONDS_FOR_RATE_LIMIT_RESET} seconds due to rate limiting by Breathe"
      sleep SECONDS_FOR_RATE_LIMIT_RESET
    end
  end
end
