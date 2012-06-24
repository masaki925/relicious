# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "rexml/document" 

if ENV["RAILS_ENV"] != "test"
  # Area
  ["Tokyo", "Kyoto", "Kanagawa", "Nagoya", "Fukuoka", "Hokkaido"].each do |pref|
    Area.create({name: pref})
  end

  # Language
  file = File.new "#{Rails.root}/doc/FacebookLocales.xml"
  doc = REXML::Document.new file

  doc.elements["locales"].elements.each do |e|
    name = e.elements["englishName"].text
    code = e.elements["codes/code/standard/representation"].text
    Language.create({name: name, code: code})
  end
end

