# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "iOS client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create(name: "Android client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.create(name: "React client", redirect_uri: "", scopes: "")
end

client = Doorkeeper::Application.find_by_name("React client")
puts "Add the following to your .env file"
puts "REACT_CLIENT_UID=#{client.uid}"
puts "REACT_CLIENT_SECRET=#{client.secret}"