json.extract! user, :id, :email, :firstname, :last_name, :created_at, :updated_at
json.url user_url(user, format: :json)
