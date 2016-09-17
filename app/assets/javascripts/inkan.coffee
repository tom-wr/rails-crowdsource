class Inkan

  constructor: (container)->
    @setup_animation_framerate()
    @canvas = @setup_canvas(container)
    @ctx = @canvas.getContext("2d")
    @resize_canvas()
    @setup_variables()

  setup_canvas: (container) ->
    canvas = document.createElement("canvas")
    canvas.id = "inkan-canvas"
    @container_element = document.getElementById(container)
    @container_element.appendChild(canvas)

  setup_variables: ->
    @render_array = []
    @width = @ctx.canvas.width
    @height = @ctx.canvas.height
    @centre =
      x: @width / 2
      y: @height / 2

  resize_canvas: () ->
    @ctx.canvas.width = @container_element.offsetWidth
    @ctx.canvas.height  = @ctx.canvas.width * 0.7

  setup_animation_framerate: ->
    unless window.requestAnimationFrame
      window.requestAnimationFrame = window.webkitRequestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.oRequestAnimationFrame   or
      window.msRequestAnimationFrame  or
      (callback, element) -> window.setTimeout callback, 1000/60

  add: (shape) ->
    @render_array.push shape

  draw: ->
    for shape in @render_array
      shape.draw()

  tick: (render) ->
    window.requestAnimationFrame render
    @render_array = []
    time = new Date().getTime()
    delta = time - @latch_time
    @latch_time = time
    delta

  clear: ->
    @ctx.clearRect(0, 0, @width, @height)

  Line: (points, options) ->
    new InkanLine points, options, @ctx

  Text: (text, left, top, options) ->
    new InkanText text, left, top, options, @ctx

  Circle: (left, top, radius, options) ->
    new InkanCircle left, top, radius, options, @ctx

  class InkanShape
    constructor: ->

    extend: (options) ->
      for option, value of options
        @["#{option}"] = value

  class InkanLine extends InkanShape

    constructor: (points, options, @ctx) ->
      @x_start = ~~points[0]
      @y_start = ~~points[1]
      @x_end = ~~points[2]
      @y_end = ~~points[3]

      @extend options

    draw: ->
      @ctx.save()
      @ctx.translate 0.5, 0.5
      @ctx.strokeStyle = @strokeStyle ? 'black'
      @strokeWidth = @strokeWidth ? 1
      @ctx.beginPath()
      @ctx.moveTo @x_start  ? 0,    @y_start  ? 0
      @ctx.lineTo @x_end    ? 100,  @y_end    ? 100
      @ctx.stroke()
      @ctx.restore()

  class InkanText extends InkanShape

    constructor: (@text, @left, @top, options, @ctx) ->
      @extend options

    draw: ->
      @ctx.save()
      @ctx.translate 0.5, 0.5
      @ctx.font = @font ? "12px serif"
      @ctx.textBaseline = @textBaseline ? "middle"
      @ctx.fillText @text ? "Inkan", @left ? 0, @top ? 0
      @ctx.restore()

  class InkanCircle extends InkanShape

    constructor: (@left, @top, @radius, options, @ctx) ->
      @extend options

    draw: ->
      @ctx.save()
      @ctx.arc(@left, @top, @radius, 0, Math.PI*2, false)
      @ctx.restore()

  class InkanRect extends InkanShape

    constructor: (@left, @right, @width, @height, options) ->
      @extend options

    draw: ->
      @ctx.save()
      @ctx.fillRect(@left, @right, @width, @height)
      @ctx.restore()

window.Inkan = Inkan
