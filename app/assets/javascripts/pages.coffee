# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#=require anisam
#=require visicount
#=require classify


$(document).on "turbolinks:load", ->
  ready()

ready = ->
  action = $("body").attr("data-action")
  controller = $("body").attr("data-controller")

  console.log controller, action

  switch controller
    when "pages" then pages_ready action
    when "surveys" then survey_ready()

pages_ready = (action) ->
  switch action
    when "classify" then classify_ready()
    when "visual_counter" then visual_counter_ready()

classify_ready = ->
  if gl?
    if gl["task_type"] is "2"
      window.anisam = new AniSam('#anisam-panel')
      window.anisam.start()
    classify = new Classify(gl)
    classify.start()

survey_ready = ->
  survey = new Survey()

visual_counter_ready = ->
  visicount  = new VisiCount "visicount-panel"
