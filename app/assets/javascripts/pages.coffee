# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # App started with globals set in classify.html.erb
  if gl?
    app = new ClassifyApp(gl)
    app.start()
    console.log app

$(document).ready(ready)

class ClassifyApp

  constructor: (settings) ->
    @project = settings.project
    @current_taskflow = settings.taskflow
    @current_task = settings.task
    @data_pool = []

    @images = ["FRE_000109.jpg", "FRE_000256.jpg", "FRE_000942.jpg", "FRE_000988.jpg", "FRE_001010.jpg",]
    @image_path = "/media/images/mixed/"
    @image_name = ""
    @image_tag = $("#image")

    @events()

  start: ->
    @load_image()

  # we bind events to elements as dependencies
  events: ->
    $("#question-panel").on "click", ".answer", ->
      $(".answer").removeClass("active")
      $(this).toggleClass("active")

    $("#question-panel").on "click", "#next-button", (event) =>
      @next_click()

    $("#question-panel").on "click", "#submit-button", (event) =>
      @submit_click()

  # a random image is chosen and displayed
  load_image: ->
    @image_name = @get_random_image()
    image_source = @image_path + @image_name
    image = @image_tag.attr("src", image_source)

  # a random image is selected and removed from the master list
  get_random_image: ->
    count = @images.length
    index = Math.floor(Math.random()*count)
    image = @images.splice(index, 1)[0]

  # data is added to the data pool
  add_to_data_pool: (data) ->
    @data_pool.push(data)

  # we get data from the page and hold it in the dump
  data_dump: ->
    answer = $(".answer.active")
    question = $("#question")
    next = parseInt(answer.attr("data"), 10)

    dd =
      question: question.text()
      answer: answer.text()
      next: next

  # data is taken from the page added to the main pool and advnace to next step
  next_click: ->
    if @answer_is_selected()
      data_dump = @data_dump()
      dd = @add_to_data_pool(data_dump)
      @advance(data_dump)
    else
      @display_message("Please select an answer")

  submit_click: ->
    $.post "/responses",
      project_id: @project
      response:
        image_id: @image_name
        data: @data_pool
    .done (data) =>
      @reset_task(data)

  advance: (data_dump) ->
    @test(@data_pool)
    if data_dump.next is 0
      console.log("end task")
      @end_task()
    else
      console.log "next task"
      @get_next_task(data_dump.next)

  get_next_task: (next) ->
    $.get "/tasks/" + next, (data) =>
      @current_task = next

  end_task: ->
    @show_summary()

  show_summary: ->
    @clear_answer_list()
    @summarise_answer answer for answer in @data_pool
    @toggle_button()
    $("#question").text("Summary")

  reset_task: (data) ->
    @load_image()
    @cleanse_answers()
    @populate_answers(data)

  cleanse_answers: ->
    @data_pool = []
    @clear_answer_list()
    @toggle_button()

  populate_answers: (data) ->
    $("#question").text(data.task.title)
    $("#count").text(data.count)
    @display_answer answer for answer in data.task.data

  clear_answer_list: ->
    $("#answer-list").html("")

  summarise_answer: (answer) ->
    $("#answer-list").append @answer_summary_view answer

  display_answer: (answer) ->
    $("#answer-list").append @answer_view answer

  toggle_button: ->
    if $("#submit-button").length
      $("#submit-button").attr("id", "next-button").html("Next")
    else
      $("#next-button").attr("id", "submit-button").html("Submit")

  answer_is_selected: ->
    $(".answer.active").length

  answer_summary_view: (answer) ->
    "<li class='list-group-item list-group-item-action'>" + answer.question + " - " + answer.answer+ "</li>"

  answer_view: (answer) ->
    "<li class='answer list-group-item list-group-item-action' data=" + answer.next + ">" + answer.text + "</li>"

  notice_view: (message) ->
    "<div class='notice alert alert-info' role=alert>"+ message + "</div>"

  display_message: (message)->
    $("#answers").append(@notice_view(message))
    $(".notice").fadeOut 5000, ->
      $(".notice").remove()

  test: (message = "test") ->
    console.log(message)
