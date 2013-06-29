json.array!(@projects) do |project|
  json.extract! project, :title, :logic_code, :display_code
  json.url project_url(project, format: :json)
end
