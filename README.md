# Update All Oauth

```
rails g scaffold business name 
```

```
rails db:create
```

```
rails db:migrate
```

```
bundle add devise
```


```
rails g devise:install
```

```
# config/environments/development.rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

```
rails g devise User
```

```
rails db:migrate
```

Add

```
before_action :authenticate_user!
```

to 
BusinessesController

```
bundle add doorkeeper
```

```
rails g doorkeeper:install
```

This will print out
```
There is a setup that you need to do before you can use doorkeeper.

Step 1.
Go to config/initializers/doorkeeper.rb and configure
resource_owner_authenticator block.

Step 2.
Choose the ORM:

If you want to use ActiveRecord run:

  rails generate doorkeeper:migration

And run

  rake db:migrate

Step 3.
That's it, that's all. Enjoy!

===============================================================================
```

We're going to come back to the initializer a bit later, for now run migration

```
rails generate doorkeeper:migration
```

Edit migration so it looks like this:

```rb
# frozen_string_literal: true

class CreateDoorkeeperTables < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_applications do |t|
      t.string  :name,    null: false
      t.string  :uid,     null: false
      t.string  :secret,  null: false

      # Remove `null: false` if you are planning to use grant flows
      # that doesn't require redirect URI to be used during authorization
      # like Client Credentials flow or Resource Owner Password.
      t.text    :redirect_uri
      t.string  :scopes,       null: false, default: ''
      t.boolean :confidential, null: false, default: true
      t.timestamps             null: false
    end

    add_index :oauth_applications, :uid, unique: true

    create_table :oauth_access_tokens do |t|
      t.references :resource_owner, index: true

      # Remove `null: false` if you are planning to use Password
      # Credentials Grant flow that doesn't require an application.
      t.references :application,    null: false

      t.string :token, null: false

      t.string   :refresh_token
      t.integer  :expires_in
      t.datetime :revoked_at
      t.datetime :created_at, null: false
      t.string   :scopes

      # The authorization server MAY issue a new refresh token, in which case
      # *the client MUST discard the old refresh token* and replace it with the
      # new refresh token. The authorization server MAY revoke the old
      # refresh token after issuing a new refresh token to the client.
      # @see https://tools.ietf.org/html/rfc6749#section-6
      #
      # Doorkeeper implementation: if there is a `previous_refresh_token` column,
      # refresh tokens will be revoked after a related access token is used.
      # If there is no `previous_refresh_token` column, previous tokens are
      # revoked as soon as a new access token is created.
      #
      # Comment out this line if you want refresh tokens to be instantly
      # revoked after use.
      t.string   :previous_refresh_token, null: false, default: ""
    end

    add_index :oauth_access_tokens, :token, unique: true
    add_index :oauth_access_tokens, :refresh_token, unique: true
    add_foreign_key(
      :oauth_access_tokens,
      :oauth_applications,
      column: :application_id
    )
  end
end

```

```
rails db:migrate
```

Comment out resource_owner_authenticator in config/initializers/doorkeeper.rb and add this:

```rb
 resource_owner_from_credentials do |_routes|
    User.authenticate(params[:email], params[:password])
  end
```

Add the authenticate method to User

```rb
validates :email, format: URI::MailTo::EMAIL_REGEXP
  
  # the authenticate method from devise documentation
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
```

Add password grant to doorkeeper config

```
# enable password grant
grant_flows %w[password]
```

Then add

```
allow_blank_redirect_uri true
```

Then add 

```
skip_authorization do
  true
end
```

And add

```
use_refresh_token
```

Add some routes:

```
use_doorkeeper do
  skip_controllers :authorizations, :applications, :authorized_applications
end
```

This is [where we're at in the tutorial](https://rubyyagi.com/rails-api-authentication-devise-doorkeeper/#create-your-own-oauth-application)

Make a new Oauth client in rails console

```
Doorkeeper::Application.create(name: "React client", redirect_uri: "", scopes: "")
```

Store the uid and secret so we can use later. 

```
bundle add dotenv-rails
touch .env
echo ".env" >> .gitignore
```

In .env 

```
REACT_CLIENT_ID=secret_here
REACT_CLIENT_SECRET=secret_here
```

We create a seeds file that will create
```rb
# db/seeds.rb
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "iOS client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create(name: "Android client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create(name: "React client", redirect_uri: "", scopes: "")
end
```

Create a user from the rails console:

```
User.create(email:'test@test.com', password: 'password')
```

Now we can try out an endpoint in Postman.