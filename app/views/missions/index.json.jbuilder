# json.missions @missions do |mission|
#   json.title mission.title
# end

json.sys do
  json.type "Array"
end
json.total @missions.length
json.skip 0 # TODO: make it dynamic in the future
json.limit 100 # TODO: make it dynamic in the future
json.items @missions do |mission|
  json.sys do
    json.space do
      json.sys do
        json.type "Link"
        json.linkType "Space"
        json.id ENV['SPACE_ID']
      end
    end
    json.id "TODO: id from contentful"
    json.type "Entry"
    json.createdAt mission.created_at
    json.updatedAt mission.updated_at
    json.revision "TODO: revision from contentful"
    json.contentType do
      json.sys do
        json.type "Link"
        json.linkType "ContentType"
        json.id "mission" # or .class.name
      end
    end
    json.locale "en-US" # TODO: make it dynamic in the future
  end
  json.fields do
    json.title mission.title
    json.location do
      json.lon "TODO: lon from contentful"
      json.lat "TOOD: lat from contentful"
    end
    json.due "TODO: due from contentful"
  end
end
