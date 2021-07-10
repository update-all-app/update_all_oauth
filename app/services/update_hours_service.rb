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
    location.provider_oauth_tokens.each do |pot|
      service_class = "#{pot.provider}_api_service".camelize.constantize
      responses[pot.provider] = service_class.new(pot).update_hours
    end
    responses
  end


end