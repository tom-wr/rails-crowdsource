# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#=require anisam
#

if typeof Turbolinks != 'undefined'
  $(document).on("page:load ready", ->
    ready()
  )
else
  $(document).ready(ready)

ready = ->
  # App started with globals set in classify.html.erb
  if gl?
    if gl["task_type"] is "2"
      anisam = new AniSam('#anisam-panel')
      anisam.start()
    app = new ClassifyApp(gl)
    app.start()

#$(document).on("page:load ready", ready)

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
    console.log("starting app")
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
  data_dump_choice: ->
    answer = $(".answer.active")
    question = $("#question")
    next = parseInt(answer.attr("data"), 10)

    dd =
      question: question.text()
      answer: [answer.text()]
      next: next

  data_dump_anisam: ->
    question = $("#question")

    dd =
      question: question.text()
      answer: [
        window.sliders.pleasure.get()
        window.sliders.arousal.get()
        window.sliders.dominance.get()]
      next: 0

  # data is taken from the page added to the main pool and advnace to next step
  next_click: ->
    task_type = $("#question").attr("data")
    switch task_type
      when "1" then @handle_choice_answers()
      when "2" then @handle_anisam_answers()

  handle_choice_answers: ->
    if @answer_is_selected()
      data_dump = @data_dump_choice()
      dd = @add_to_data_pool(data_dump)
      @advance(data_dump.next)
    else
      @display_message("Please select an answer")

  handle_anisam_answers: ->
    data_dump = @data_dump_anisam()
    dd = @add_to_data_pool(data_dump)
    @advance(data_dump.next)
    #@submit_click()

  submit_click: ->
    $.post "/responses",
      project_id: @project
      response:
        image_id: @image_name
        data: @data_pool
    .done (data) =>
      @reset_task(data)

  advance: (next) ->
    if next is 0
      @end_task()
    else
      @get_next_task(next)

  get_next_task: (next) ->
    $.get "/tasks/" + next, (data) =>
      @current_task = next

  end_task: ->
    @show_summary()

  show_summary: ->
    @clear_answer_list()
    @clear_anisam()
    @summarise_answer answer for answer in @data_pool
    @toggle_button()
    $("#question").text("Summary")

  reset_task: (data) ->
    task_type = data.task.task_type
    @set_task_type(task_type)
    @load_image()
    @cleanse_answers()
    if task_type == 1
      @populate_answers(data)
    else if task_type == 2
      new AniSam("#anisam-panel")
    $("#count").text(data.count)

  cleanse_answers: ->
    @data_pool = []
    @clear_answer_list()
    @clear_anisam()
    @toggle_button()

  populate_answers: (data) ->
    $("#question").text(data.task.title)
    @display_answer answer for answer in data.task.data

  clear_answer_list: ->
    $("#answer-list").html("")

  clear_anisam: ->
    $("#anisam-canvas").remove()
    $("#anisam-sliders").html("")

  set_task_type: (task_type) ->
    $("#question").attr(data: task_type)

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
    "<li class='list-group-item list-group-item-action'>" + answer.question + "<p class='pull-right'>" + answer.answer+ "</p></li>"

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
