json.extract! text, :id, :title, :link, :body, :created_at, :updated_at
json.url text_url(text, format: :json)
