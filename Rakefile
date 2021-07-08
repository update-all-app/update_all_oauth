# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks


desc "test facebook"
task :fb => :environment do
  @u = User.first
  @pot = @u.provider_oauth_tokens.last
  @fb = FacebookApiService.new(@pot)
  @page_id = @pot.page_data.first["id"]
  @fb.update_hours(@page_id)
  byebug
end