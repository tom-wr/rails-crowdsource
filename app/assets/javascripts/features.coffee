class Feature

  constructor: (options)->
    @set_defaults()
    for option, value of options
      @set_option(option, value)
    @shape = @make_shape()

  set_defaults: ->
    @x = 0
    @y = 0
    @width = 0
    @height = 0

  set_option: (option, value) ->
    this["#{option}"] = value

  make_shape: ->
    new fabric.Circle({
      fill: "#333333"
      top: @y
      left: @x
      radius: 1
    })

class Eye extends Feature

  constructor: (options) ->
    super options

  make_shape: ->
    eye = new fabric.Circle({
      originX: "center"
      originY: "center"
      stroke: "#333333"
      strokeWidth: 2
      radius: @size
      fill: undefined
    })
    eyelid = new fabric.Circle({
      originX: "center"
      originY: "center"
      startAngle: ((1.5 - @lid_droop) * Math.PI)
      endAngle:  ((1.5+ @lid_droop) * Math.PI)
      radius: @size - 1
      fill: '#d0d0d0'
      strokeWidth: 10
      strokeWidth: '#e1e1e1'
    })
    pupil = new fabric.Circle({
      originX: "center"
      originY: "center"
      fill: "#333333"
      radius: @pupil_size
    })
    new fabric.Group([eye, pupil, eyelid], {
      top: @y
      left: @x
      originX: "center"
      originY: "center"
    })

class Mouth extends Feature

  constructor: (options) ->
    super options

  make_shape: ->
    cornerL = new fabric.Point(@x - @length, @y + @offset)
    cornerR = new fabric.Point(@x + @length, @y + @offset)

    lower_curve = @curve + @openness
    upper_curve = @curve - @openness

    path_string = new BezierCurve(cornerL, cornerR, lower_curve).toSVG()
    path_string += new BezierCurve(cornerL, cornerR, upper_curve).toSVG()

    path = new fabric.Path(path_string)
    path.set({fill: undefined, stroke: "#333333", strokeWidth: 2})

class Face extends Feature

  constructor: (options) ->
    super options

  make_shape: ->
    new fabric.Ellipse({
      fill: "#ffffff"
      stroke: "#333333"
      strokeWidth: 4
      top: @y
      left: @x
      rx: @width
      ry: @width * 1.1
      originY: "center"
      originX: "center"
    })

class Brow extends Feature
  constructor: (options) ->
    super options

  make_shape: ->
    new fabric.Line(
      [ @x - @length, @y - @raise + @slope, @x + @length, @y - @raise - @slope],
      {
        stroke: "#333333"
        strokeWidth: 4
      }
    )

class Body extends Feature

  constructor: (options) ->
    super options

  make_shape: ->

    bodyR_position = new fabric.Point(@x + @neck_offset, @y)
    neck_start = new fabric.Point(@x - @neck_offset, @y)
    neck_end = new fabric.Point(@x - @neck_offset, @y + @neck_length)
    neck_path = "M #{neck_start.x} #{neck_start.y} L#{neck_end.x} #{neck_end.y}"

    shoulder_path = "L#{@x - @shoulder_width} #{@y + @shoulder_dip}"
    waist_path = "L#{@waist_x} #{@waist_y}"

    path_string = neck_path + shoulder_path + waist_path
    bodyL = new fabric.Path(path_string,{
      fill:undefined
      stroke: "#333333"
      strokeWidth: 4
    })

    bodyR = fabric.util.object.clone(bodyL)
    bodyR.set("flipX", true)
    bodyR.setLeft(bodyR_position.x)

    new fabric.Group([bodyL, bodyR])

class Heart extends Feature

  constructor: (options) ->
    super options

  make_shape: ->
    heartL_position = new fabric.Point(@x, @y)
    heartL = new fabric.Path("M #{@x} #{@y} C #{@x-@width1} #{@y-@height1} #{@x-@width2} #{@y+@height2} #{@x} #{@y+@point} C #{@x+@width2} #{@y+@height2} #{@x+@width1} #{@y-@height1} #{@x} #{@y} z")
    heartL.set({
      left: @x
      fill: undefined
      stroke: "#333333"
      strokeWidth: 2
      originY: "center"
      originX: "center"
    })

class BezierCurve
  constructor: (@start, @end, @curve) ->
    @cp1 =
      x: @start.x
      y: @start.y + @curve

    @cp2 =
      x: @end.x
      y: @end.y + @curve

  toSVG: ->
    "M#{@start.x} #{@start.y} C#{@cp1.x} #{@cp1.y} #{@cp2.x} #{@cp2.y} #{@end.x} #{@end.y}"

class QuadraticBezierCurve
  constructor: (@start, @end, @curve) ->
    @mid =
      x: (@start.x + @end.x)/2
      y: (@start.y + @end.y)/2

  toSVG: ->
    "M#{@start.x} #{@start.y} Q#{@cp.x} #{@cp.y} #{@end.x} #{@end.y}"


window.Body     = Body
window.Brow     = Brow
window.Eye      = Eye
window.Face     = Face
window.Feature  = Feature
window.Heart    = Heart
window.Mouth    = Mouth
