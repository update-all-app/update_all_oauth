class ApiService
  attr_reader :pot

  # def self.get_access_token
  #   raise NotImplementedError.new("Make sure to define self.get_access_token within the #{self.name} class"
  # end

  def initialize(provider_oauth_token)
    @pot = provider_oauth_token
    # @page_access_token = get_page_access_token
  end
end