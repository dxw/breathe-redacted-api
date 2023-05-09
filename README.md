# BreatheHR Redacted API

At dxw we use BreatheHR as our HR system. We want to be able to access its API
in order to get information about holidays, sickness, training etc. and put them
into other systems.

The BreatheHR API does not allow you to limit the access of particular API keys.
That means that anyone with an API key could access sensitive personal
information.

This project exists as a middleman between projects that want to consume
information about staff absences without being able to access other personal
information. Rather than making a request to the BreatheHR API, an app makes a
request to this redacted API instead.

This project is deployed and run on Heroku. Due to the sensitive nature of the
data, only a handful of people have access to it.

## API

### Authorization

Pass an API key for this app (not one for BreatheHR) via the `X-Api-Key` header

### Endpoints

The API has four endpoints:

#### `/employees`

Returns a JSON array of the emails and IDs of all employees.

#### `/absences`, `/sicknesses`, `/employee_training_courses`

Each return a JSON array of all absences/sicknesses/trainings. Use the filter
parameter `employee_id` to limit to a particular employee, and `after` with a
YYYY-MM-DD date to limit the age of items

```
/absences?employee_id=123&after=2023-04-06
```

## Running locally

1. Install the dependencies via Bundler:

   ```
   $ bundle install
   ```

2. Set up your environment variables by copying `.env.example` to `.env` and
   fill in the blanks.

3. Start the server

   ```
   ruby api.rb
   ```

## Developing

Running the tests:

```
$ bundle exec rspec lib
```
