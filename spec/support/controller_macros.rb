module ControllerMacros 
  def load_client 
    @client ||= Doorkeeper::Application.create(name: "React client")
    ENV["REACT_CLIENT_UID"] = @client.uid
    ENV["REACT_CLIENT_SECRET"] = @client.secret
  end
  def login_user(with_businesses: false) 
    load_client
    @user = with_businesses ? FactoryBot.create(:user_with_businesses) : FactoryBot.create(:user)
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