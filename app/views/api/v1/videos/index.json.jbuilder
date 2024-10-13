json.array!(videos) do |video|
  json.extract! video, :id, :title, :description, :wistia_hash, :visible, :play_count

  json.tags video.tags do |tag|
    json.id tag.id
    json.name tag.name
  end
end
