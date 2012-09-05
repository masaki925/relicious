# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("article.tabs section > h3").click ->
    $("article.tabs section").removeClass "current"
    $(this).closest("section").addClass "current"

