class TokenService
  attr_reader :user, :api_url, :client_id, :client_secret
  def initialize(_options={})
    options = {
      user: _options[:user],
      api_url: _options[:api_url] || ENV["API_URL"],
      client_id: _options[:client_id] || ENV["REACT_CLIENT_UID"],
      client_secret: _options[:client_secret] || ENV["REACT_CLIENT_SECRET"], 
      scope: _options[:scopes] || ""
    }
    @user = options[:user]
    @api_url = options[:api_url]
    @client_id = options[:client_id]
    @client_secret = options[:client_secret]
    @scopes = options[:scopes]
  end

  
  def get_token
    token = Doorkeeper::AccessToken.create(
      resource_owner_id: user.id,
      application_id: client.id,
      refresh_token: generate_refresh_token,
      expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
      scopes: ''
    )
    token.serializable_hash
  end
  
  def client 
    Doorkeeper::Application.find_by(uid: client_id)
  end

  private 
  

  def generate_refresh_token
    loop do
      # generate a random token string and return it, 
      # unless there is already another token with the same string
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end 
end