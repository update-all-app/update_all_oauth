require 'rails_helper'

RSpec.describe IrregularEvent, type: :model do
  describe ".between(start_date, end_date)" do 
    it "returns the Irregular Events between the start_date and end_date" do 
      @event = FactoryBot.create(:irregular_event, :for_business)
      start_date = (@event.start_time - 1.day).to_date
      end_date = (@event.end_time + 1.day).to_date
      expect(IrregularEvent.between(start_date, end_date)).to include(@event)
    end
  end
end
