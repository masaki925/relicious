require 'pp'
require "rexml/document" 

file = File.new "./doc/FacebookLocales.xml"
doc = REXML::Document.new file

class Language
  attr_accessor :name, :code
end

langs = Array.new

doc.elements["locales"].elements.each do |e|
  lang = Language.new
  lang.name = e.elements["englishName"].text
  lang.code = e.elements["codes/code/standard/representation"].text
  langs << lang
end

pp langs

