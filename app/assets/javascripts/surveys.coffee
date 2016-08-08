# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->
  # App started with globals set in classify.html.erb
  app = new Survey()
  console.log ("meow")

$(document).ready(ready)

class Survey
  constructor: (options) ->
    @stage = 0
    @events()

  events: ->
    $(".survey-section").on "click", ".survey-next-btn", (event) =>
      @advance()

  advance: ->
    @stage++
    @display_survey_stage()

  display_survey_stage: ->
    $(".survey-section").hide()
    $("#page_" + @stage).show()
