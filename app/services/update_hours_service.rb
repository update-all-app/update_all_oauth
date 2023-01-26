class UpdateHoursService
  attr_reader :location

  def initialize(location)
    @location = location
  end

  # iterate over all location provider oauth tokens
  # for each one constantize the name to get the appropriate ApiService
  # make a new instance of the service and pass the pot
  # call update hours on each instance
  # return an array of hashes containing data about the api response status
  def call
    responses = {}
    location.location_services.each do |location_service|
      pot = location_service.provider_oauth_token
      service_class = "#{pot.provider}_api_service".camelize.constantize
      responses[pot.provider] = service_class.new(pot).update_hours(location_service.page_id)
    end
    responses
  end


end