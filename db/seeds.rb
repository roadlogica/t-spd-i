# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
DatabaseCleaner.clean_with :truncation

user = User.new
user.email = 'blee@roadlogica.com'
user.password = '12345678'
user.password_confirmation = '12345678'
user.role = 'admin'
user.save!
