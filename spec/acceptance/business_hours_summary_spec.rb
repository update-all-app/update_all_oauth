require 'acceptance_helper'

resource "Business Hours Summary" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"
  before(:all) do 
    login_user(FactoryBot.create(:user, :with_business_hours, schedulable: "locations"))
  end

  # parameter :one_level_arr, with_example: true
  # parameter :two_level_arr, with_example: true

  # let(:one_level_arr) { ['value1', 'value2'] }
  # let(:two_level_arr) { [[5.1, 3.0], [1.0, 4.5]] }

  get "/api/v1/locations/:id/hours_summary" do 
    with_options with_example: true do
      parameter :start_date, "in YYYY-MM-DD format", required: true
      parameter :end_date, "in YYYY-MM-DD format", required: true
    end
    
    let(:id) { @user.locations.first.id }
    # @user.locations.
    
    let (:start_date) { DateTime.now.beginning_of_week.to_date - 1.day }
    let (:end_date) { DateTime.now.end_of_week.to_date - 1.day }
    
    response_field :days_after_start, "Integer representing the number of days between the start date and the day to which the attached hours belong."
    response_field :start_time, "String in %Y-%m-%d %H:%M format representing the opening time"
    response_field :end_time, "String in %Y-%m-%d %H:%M format representing the closing time"
     
    example "returns a summary of business hours for a location" do 
      header "Authorization", "Bearer #{@access_token}"
      @user.irregular_events.create(status: 
        "open", schedulable: @user.locations.first, start_time: (DateTime.now.end_of_week.to_date - 1.day + 8.hours), end_time: (DateTime.now.end_of_week.to_date - 1.day + 12.hours))
      do_request
      bd = JSON.parse(response_body)      
      saturday_hours = bd.find{|hash| hash["weekday"] == "sat"}
      expect(saturday_hours).not_to be_nil
      expect(saturday_hours["start_time"]).to eq("08:00")
      expect(saturday_hours["end_time"]).to eq("12:00")
      expect(response_status).to eq(200)
    end
    
  end
end