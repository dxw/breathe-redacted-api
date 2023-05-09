require "breathe"

class RateLimited < StandardError
  def initialize(msg = "Redacted Breathe Client is rate limited")
    super
  end
end

class RedactedBreatheClient
  class << self
    def client
      Breathe::Client.new(api_key: ENV.fetch("BREATHE_API_KEY"), auto_paginate: true)
    end

    def employees
      {employees:
        client
          .employees
          .list
          .response
          .data[:employees]
          .map { |employee|
          employee.to_hash.slice( # This is very important for concealing private information
            :id,
            :email
          )
        }}
    rescue => error
      raise unless rate_limited?(error)
      raise RateLimited
    end

    def absences(employee_id:, after:)
      {absences:
        client
          .absences
          .list(
            employee_id: employee_id,
            start_date: after,
            exclude_cancelled_absences: true
          )
          .response
          .data[:absences]
          .map { |absence|
          absence.to_hash.slice( # This is very important for concealing private information
            :id,
            :start_date,
            :half_start,
            :half_start_am_pm,
            :end_date,
            :half_end,
            :half_end_am_pm,
            :cancelled
          )
        }}
    rescue => error
      raise unless rate_limited?(error)
      raise RateLimited
    end

    def sicknesses(employee_id:, after:)
      {sicknesses:
        client
          .sicknesses
          .list(
            employee_id: employee_id,
            start_date: after,
            exclude_cancelled_sicknesses: true
          )
          .response
          .data[:sicknesses]
          .map { |sickness|
          sickness.to_hash.slice(
            :id,
            :start_date,
            :half_start,
            :half_start_am_pm,
            :end_date,
            :half_end,
            :half_end_am_pm,
            :status
          )
        }}
    rescue => error
      raise unless rate_limited?(error)
      raise RateLimited
    end

    def employee_training_courses(employee_id:, after:)
      {employee_training_courses:
        client
          .employee_training_courses
          .list(
            employee_id: employee_id,
            start_date: after,
            exclude_cancelled_employee_training_courses: true
          )
          .response
          .data[:employee_training_courses]
          .map { |training|
          training.to_hash.slice(
            :id,
            :start_on,
            :end_on,
            :half_day,
            :half_day_am_pm,
            :hours,
            :status
          )
        }}
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
