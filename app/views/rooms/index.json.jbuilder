json.array!(@rooms) do |room|
  json.extract! room, :id, :library_id, :room_number, :size
  json.url room_url(room, format: :json)
end
