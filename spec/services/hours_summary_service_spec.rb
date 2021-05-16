require 'rails_helper'

RSpec.describe HoursSummaryService do
  describe "new(location, start_date, end_date)" do 
    it "initializes with a location, start_date and end_date)" do
      # create an irregular event for a location
      irregular_event = FactoryBot.create(:irregular_event, :for_location, {
        start_time: day_and_time_this_week("friday", "2:00"),
        end_time: day_and_time_this_week("friday", "6:00")
      })
      # create regular events for the same user and location
      user = irregular_event.user
      location = irregular_event.schedulable
      regular_events = [1,2,3,4,5].map do |day_of_week|
        FactoryBot.create(:regular_event, :for_location, 
          day_of_week: day_of_week, 
          user: user,
          schedulable: location
        )
      end
      regular_events = user.regular_events.by_location(location).map do |re|
        RegularEventValueObject.new(
          day_of_week: re.day_of_week,
          start_time: re.start_time,
          end_time: re.end_time,
          schedulable_type: re.schedulable_type
        )
      end
      irregular_events = user.irregular_events.by_location(location).map do |ie|
        IrregularEventValueObject.new(
          status: ie.status,
          start_time: ie.start_time,
          end_time: ie.end_time,
          schedulable_type: ie.schedulable_type
        )
      end
      service = HoursSummaryService.new(
        regular_events: regular_events, 
        irregular_events: irregular_events, 
        start_date: beginning_of_week, 
        end_date: end_of_week
      )
      
      expect(service.call).to eq([
        {
          :days_after_start => 0,
          :end_time => "17:00",
          :start_time => "09:00",
          :weekday => "mon"
        },
        {
          :days_after_start => 1,
          :end_time => "17:00",
          :start_time => "09:00",
          :weekday => "tue"
        },
        {
          :days_after_start => 2,
          :end_time => "17:00",
          :start_time => "09:00",
          :weekday => "wed"
        },
        {
          :days_after_start => 3,
          :end_time => "17:00",
          :start_time => "09:00",
          :weekday => "thu"
        },
        {
          :days_after_start => 4,
          :end_time => "13:00",
          :start_time => "09:00",
          :weekday => "fri"
        },
      ])
    end
  end
end
