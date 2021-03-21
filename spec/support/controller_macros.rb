module ControllerMacros 
  def load_client 
    @oauth_client ||= Doorkeeper::Application.create(name: "React client")
    ENV["REACT_CLIENT_UID"] = @oauth_client.uid
    ENV["REACT_CLIENT_SECRET"] = @oauth_client.secret
  end
  def login_user(with_businesses: false, with_locations: false, with_services: false) 
    load_client
    if with_businesses && with_locations
      @user = FactoryBot.create(:user_with_businesses_and_locations)
    elsif with_businesses 
      @user = FactoryBot.create(:user_with_businesses)
    else
      @user = FactoryBot.create(:user)
    end
    if with_services
      @user.provider_oauth_tokens.create(
        provider: ["Facebook"].sample, 
        provider_uid: rand(9959300543630775...10159300543630775),
        label: 'Page1, Page2'
      )
    end

    token = TokenService.new(user: @user).get_token
    @access_token = token["token"]
    @refresh_token = token["refresh_token"]
  end

  def headers 
    {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer #{@access_token}"
    }
  end
end