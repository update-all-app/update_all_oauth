class FacebookApiService < ApiService

  def self.get_access_token(exchange_token)
    resp = Faraday.get('https://graph.facebook.com/v10.0/oauth/access_token') do |req|
      req.params['grant_type'] = 'fb_exchange_token'
      req.params['client_id'] = ENV['FACEBOOK_CLIENT_ID']
      req.params['client_secret'] = ENV['FACEBOOK_CLIENT_SECRET']
      req.params['fb_exchange_token'] = exchange_token
    end
    # not sure if this is doing too much here and possibly hiding error cases
    # that we're not aware of at the moment
    JSON.parse(resp.body)["access_token"]
  end

  def get_pages
    res = Faraday.get("https://graph.facebook.com/me/accounts") do |req|
      req.params['access_token'] = pot.access_token
    end
    json = JSON.parse(res.body)
    json["data"]
  end

  # we have a page_id but we need to find the location
  # we'll find it by looking through the pot.location_services
  # pot.location_services.find_by(page_id: page_id).try(:location)
  # this should return the response from the API parsed from JSON.
  def update_hours(page_id, start_date=Date.today.next_week, end_date=Date.today.next_week(:sunday))
    page = pot.page_data.find{|h| h["id"] == page_id}
    raise StandardError.new("Page with id: #{page_id} not found within scope of user access: #{pot.page_data}") unless page
    page_access_token = page["page_access_token"]
    location_service = pot.location_services.find_by(page_id: page_id)
    raise StandardError.new("This page hasn't been connected with a location yet") unless location_service
    location = location_service.location
    user = pot.user
    hours_as_array = HoursSummaryService.new(user: user, location: location, start_date: start_date, end_date: end_date).call
    res = Faraday.post("https://graph.facebook.com/#{page_id}") do |req|
      req.params['access_token'] = page_access_token
      req.params["hours"] = format_hours(hours_as_array).to_json
    end
    JSON.parse(res.body)
  end

  def format_hours(hours_as_array)
    hours_as_array.group_by{|hash| hash[:weekday]}.reduce({}) do |memo, (weekday, hours_hash)|
      hours_hash.each.with_index(1) do |hour_hash, i|
        memo["#{weekday}_#{i}_open"] = hour_hash[:start_time]
        memo["#{weekday}_#{i}_close"] = hour_hash[:end_time]
      end
      memo
    end
  end
end  
=begin
@u = User.first
@pot = @u.provider_oauth_tokens.first
@fb = FacebookApiService.new(@pot)
@page_id = @pot.page_data.first["id"]
@fb.update_hours(@page_id)
curl -i -X GET  "https://graph.facebook.com/15719169145?fields=id,name,hours&access_token=EAApK8FEdjlEBACo2r8jpTTYoDjbjZAKUxKv7BjFx9MXGQuZBHqnB4DXOv3mLJvxRQ7ZBhE1qFeZBmTZAWadyPDBm6k04vJGNEWylpKagDv9N2z0iTNeZB80Q2mWo2Xax3i66Yf3qCwfl4J0RDTZCGfKk0RGlOdbdTFgTUWqnGPlEAZDZD"
curl -i -X POST "https://graph.facebook.com/113796357628695/feed?message=Hello%20world\!&access_token=EAApK8FEdjlEBANOd0b56bCk9U7R43QogyTkyG2xnOpCIHzzDNju0lZAgijLlqrzmfVITOELawmVAlKhBKD8sYGNtJwPaPEajZACSHUkwdXxoKUCmZAwhp2QXBFlXMpkb6mJayZCw9xdMGJGbeHIm8wDA9dlPBPKFGqFsNQCZCqVOJMnZC20Rx1"
curl -i -X POST "https://graph.facebook.com/113796357628695?about=helloworld&access_token=EAApK8FEdjlEBANOd0b56bCk9U7R43QogyTkyG2xnOpCIHzzDNju0lZAgijLlqrzmfVITOELawmVAlKhBKD8sYGNtJwPaPEajZACSHUkwdXxoKUCmZAwhp2QXBFlXMpkb6mJayZCw9xdMGJGbeHIm8wDA9dlPBPKFGqFsNQCZCqVOJMnZC20Rx1"

So, we currently have a user access token. 
When we try to manage metadata on a page, we're getting an error that says:
A page access token is required to request this resource.
So, we need to go get a page access token using the user access token:
https://developers.facebook.com/docs/facebook-login/access-tokens/
curl -i -X GET "https://graph.facebook.com/{your-user-id}/accounts?access_token={user-access-token} 
we get the user-id from the provider oauth token (pot.provider_uid) and we get the user access token
from there as well
pot.access_token
pot.provider_uid #=> "127236136227598"
pot.access_token #=> "EAApK8FEdjlEBANOd0b56bCk9U7R43QogyTkyG2xnOpCIHzzDNju0lZAgijLlqrzmfVITOELawmVAlKhBKD8sYGNtJwPaPEajZACSHUkwdXxoKUCmZAwhp2QXBFlXMpkb6mJayZCw9xdMGJGbeHIm8wDA9dlPBPKFGqFsNQCZCqVOJMnZC20Rx1"

so, here's the CURL

curl -i -X GET "https://graph.facebook.com/127236136227598/accounts?access_token=EAApK8FEdjlEBANOd0b56bCk9U7R43QogyTkyG2xnOpCIHzzDNju0lZAgijLlqrzmfVITOELawmVAlKhBKD8sYGNtJwPaPEajZACSHUkwdXxoKUCmZAwhp2QXBFlXMpkb6mJayZCw9xdMGJGbeHIm8wDA9dlPBPKFGqFsNQCZCqVOJMnZC20Rx1"

And we get this back:

{
  "data":[
    {
      "access_token": "EAApK8FEdjlEBAMpMERrKALkIr8GsXoEQFv4R7YDwCpMTbZAzLioOJ1Aos9rYMtZByecIW0PeGlkbUWNOgKMk5TeM6tKRUH0sOr4ph9IDZCWpqXnEd4lue0jqzJ2ZCiJbTbebrYml0QaxA2EC7jhwmW09DoxIBijKZAzwWm0x3CWZB4LxlpMIN8GOBBvyhnikIZD",
      "category": "Business Consultant",
      "category_list":[
        {
          "id":"179672275401610",
          "name":"Business Consultant"
        }
      ],
      "name":"Updatingitall",
      "id":"113796357628695",
      "tasks":["ANALYZE","ADVERTISE","MESSAGING","MODERATE","CREATE_CONTENT","MANAGE"]
    }
  ],
  "paging":{
    "cursors":{
      "before": "MTEzNzk2MzU3NjI4Njk1",
      "after":"MTEzNzk2MzU3NjI4Njk1"
    }
  }
}

Now, we're going to take the access token from this response and use it to try to manage metadata on the page.
We realized we were already getting this information when the user signed up, so we persisted that 
in the page_data key within the provider_oauth_token. Page Data is an array of hashes where the keys are
id, name, and page_access_token which should be all we need to make the appropriate requests.

We're thinking if we use THIS access token instead of the user access token that we'll actually be able
to make a change so let's try a CURL with the new access token!!!

curl -i -X POST "https://graph.facebook.com/113796357628695?about=helloworld&access_token=EAApK8FEdjlEBAJofd36Uv5qzsz5WG7RZC89kINpO0E7gfXrNYAONBfox7ZBz5Glw5kMJedgscnj2bJKkPgbZBZAKL59S7p0YVFZCzXhfkJrB4SBuoONYI7SjFpo7VfSIRJsjcRrjEJZB8ciakZCRPD6b28BUHcZAtZBwVj7iBBbM8ASXUEZBCfIMFcJVcU9yyG1t8ZD"

ZB8ciakZCRPD6b28BUHcZAtZBwVj7iBBbM8ASXUEZBCfIMFcJVcU9yyG1t8ZD"
HTTP/2 200 
content-type: application/json; charset=UTF-8
vary: Origin
x-business-use-case-usage: {"113796357628695":[{"type":"pages","call_count":0,"total_cputime":0,"total_time":0,"estimated_time_to_regain_access":0}]}
x-fb-rlafr: 0
access-control-allow-origin: *
facebook-api-version: v10.0
strict-transport-security: max-age=15552000; preload
pragma: no-cache
cache-control: private, no-cache, no-store, must-revalidate
expires: Sat, 01 Jan 2000 00:00:00 GMT
x-fb-request-id: AC6YLrgfESf6_ieaj1EBDD0
x-fb-trace-id: H3mfzbb2o25
x-fb-rev: 1004078022
x-fb-debug: ZnWUin3vKCzzPippYglKJ4w898hO9Z2kqtBma/Kw65X8+z7fX7TqEgp6aPzhkRuyal6mYB8HV82JiYKWTTpMVg==
content-length: 16
date: Mon, 05 Jul 2021 22:11:23 GMT
priority: u=3,i
alt-svc: h3-29=":443"; ma=3600,h3-27=":443"; ma=3600

{"success":true}

=end