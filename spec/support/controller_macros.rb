module ControllerMacros 
  def load_client 
    @oauth_client ||= Doorkeeper::Application.create(name: "React client")
    ENV["REACT_CLIENT_UID"] = @oauth_client.uid
    ENV["REACT_CLIENT_SECRET"] = @oauth_client.secret
  end
  def login_user(user) 
    load_client
    @user = user
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