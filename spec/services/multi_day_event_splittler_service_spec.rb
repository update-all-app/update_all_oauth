require 'rails_helper'

RSpec.describe MultiDayEventSplitterService do
  describe ".process(event)" do
    it "returns an array of events (1 per day) when given an irregular event that spans more than one day." do 
      saturday = datetime_to_utc(day_and_time_this_week("Saturday", "00:00")+1.week)
      sunday = datetime_to_utc(day_and_time_this_week("Sunday", "23:59")+1.week)
      events = MultiDayEventSplitterService.process(FactoryBot.create(:irregular_event, :for_location, status: "closed", start_time: saturday, end_time: sunday))
      expect(events.length).to eq(2)
      expect(events.first).to be_a(IrregularEvent)
      expect(events.first.start_time.hour).to eq(0)
      expect(events.last.end_time.min).to eq(59)
      expect(events.last.status).to eq("closed")
      
    end

    it "returns an array with a single event in it when given an event that spans a single day" do 
      beginning_of_saturday = datetime_to_utc(day_and_time_this_week("Saturday", "00:00")+1.week)
      end_of_saturday = datetime_to_utc(day_and_time_this_week("Saturday", "23:59")+1.week)
      event = FactoryBot.build(:irregular_event, :for_location, status: "closed", start_time: beginning_of_saturday, end_time: end_of_saturday)
      events = MultiDayEventSplitterService.process(event)
      expect(events.length).to eq(1)
      expect(events.first).to be(event)
    end

  end
end