# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if ENV["RAILS_ENV"] != "test"
  ["Tokyo", "Kyoto", "Kanagawa", "Nagoya", "Fukuoka", "Hokkaido"].each do |pref|
    Area.create({name: pref})
  end
end

