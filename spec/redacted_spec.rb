require_relative "../lib/redacted_breathe_client"
describe "client" do
  let(:mockclient) { double }
  before do
    allow(RedactedBreatheClient).to receive(:client).and_return(mockclient)
  end

  describe "employees" do
    it "has the right shape and redacts secrets" do
      allow(mockclient).to receive_message_chain(:employees, :list, :response, :data).and_return({employees: [{id: 3, email: 6, secret: "kittens!"}], bad: "no"})
      expect(RedactedBreatheClient.employees).to eq({employees: [{id: 3, email: 6}]})
    end
  end

  describe "absenses" do
    it "has the right shape" do
      allow(mockclient).to receive_message_chain(:absences, :list, :response, :data).and_return({absences: [{id: 3, start_date: "2015-07-10 00:00:00 +0100", secret: "kittens!"}], bad: "no"})
      expect(RedactedBreatheClient.absences(employee_id: 9, after: "2022-02-22")).to eq({absences: [{id: 3, start_date: "2015-07-10 00:00:00 +0100"}]})
    end
  end

  describe "sicknesses" do
    it "has the right shape" do
      allow(mockclient).to receive_message_chain(:sicknesses, :list, :response, :data).and_return({sicknesses: [{id: 3, start_date: "2015-07-10 00:00:00 +0100", secret: "kittens!"}], bad: "no"})
      expect(RedactedBreatheClient.sicknesses(employee_id: 9, after: "2022-02-22")).to eq({sicknesses: [{id: 3, start_date: "2015-07-10 00:00:00 +0100"}]})
    end
  end

  describe "employee_training_courses" do
    it "has the right shape" do
      allow(mockclient).to receive_message_chain(:employee_training_courses, :list, :response, :data).and_return({employee_training_courses: [{id: 3, start_on: "2015-07-10 00:00:00 +0100", secret: "kittens!"}], bad: "no"})
      expect(RedactedBreatheClient.employee_training_courses(employee_id: 9, after: "2022-02-22")).to eq({employee_training_courses: [{id: 3, start_on: "2015-07-10 00:00:00 +0100"}]})
    end
  end
end
