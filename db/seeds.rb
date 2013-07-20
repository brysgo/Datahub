# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Twitter.instance.save!

User.create(
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password'
)

Dir.foreach("#{Rails.root}/examples") do |project_dir|
  next if project_dir == '.' or project_dir == '..'
  project_dir_path = "#{Rails.root}/examples/#{project_dir}"
  Project.create(
    title: project_dir.titleize,
    logic_code: File.read("#{project_dir_path}/main.js.coffee"),
    display_code: File.read("#{project_dir_path}/index.html")
  )
end
