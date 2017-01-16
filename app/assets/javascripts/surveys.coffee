# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Survey
  constructor: (options) ->
    @stage = 0
    @events()
    @stage_count = $(".survey-page").size()

  events: ->
    $(".survey-section").on "click", ".survey-next-btn", (event) =>
      @advance()

  advance: ->
    @unhighlight()
    if @check_form()
      @stage++
      @display_survey_stage()
      @update_progress_bar()
      window.scrollTo 0, 0

  display_survey_stage: ->
    $(".survey-section").hide()
    $("#page_" + @stage).show()

  update_progress_bar: ->
    $(".progress-count").text(@stage)
    $("#survey-progress").width( (@stage/@stage_count) * 100 + "%")

  check_form: ->
    table_errors = @check_tables()
    @highlight row for row in table_errors
    if table_errors.length
      false
    else
      true

  check_tables: ->
    errors = []
    tbody = $("#page_#{@stage}").find("tbody").children("tr").each ->
      checked = false
      $(this).find(".form-check-input").each ->
        if $(this).is(":checked")
          checked = true
      if !checked
        errors.push this
    errors

  highlight: (element) ->
    $(element).addClass("survey-table-error")

  unhighlight: ->
    $(".survey-table-error").removeClass("survey-table-error")

  pointer_helper: ->
   # $('#elm').hover(
   #    function(){ $(this).addClass('hover') },
   #    function(){ $(this).removeClass('hover') }
   #)

window.Survey = Survey
