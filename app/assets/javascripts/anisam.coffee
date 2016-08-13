#=require emoengine

class AniSam

  _face =
    level: 0.4
    width: 0.18

  _mouth =
    level: 0.5
    length: 0.05
    twist: 0.2
    openness: 0.3

  _eye =
    level: 0.33
    pupil_size: 0.011
    size: 0.035
    offset: 0.07

  _brow =
    level: 0.265
    stroke: 2

  _body =
    level: 0.6
    neck_offset: 0.07
    neck_length: 0.1
    waist: 0.25

  constructor: (container) ->

    @emo_engine = new EmoEngine()
    @emotion = @emo_engine.setupPAD(0,0,0)
    console.log @emotion
    @setup(container)

  setup: (container) ->
    @setup_canvas(container)
    @render()

  init_vars: ->
    canvas_height = @canvas.getHeight()

  setup_canvas: (container) ->
    id = 'anisam-canvas'
    @element = @element_view(container, id)
    @create_sliders(container)
    @canvas = new fabric.StaticCanvas id
    @resize_canvas(container)

  render: ->
    @setup_features()
    @draw_features()

  setup_features: ->

    centre = @canvas.getCenter().left

    face = new Face({
      x: centre,
      y: @ny _face.level + @emotion.HEAD_DIP
      width: @nx _face.width
      height: @ny _face.height
    })

    browL = new Brow({
      x: centre - @nx _eye.offset
      y:      @ny _brow.level + @emotion.HEAD_DIP
      slope:  @ny -@emotion.BROW_SLOPE
      length: @nx @emotion.BROW_LENGTH
      raise:  @ny @emotion.BROW_RAISE
    })

    browR = new Brow({
      x: centre + @nx _eye.offset
      y:      @ny _brow.level + @emotion.HEAD_DIP
      slope:  @ny @emotion.BROW_SLOPE
      length: @nx @emotion.BROW_LENGTH
      raise:  @ny @emotion.BROW_RAISE
    })

    eyeL = new Eye({
      x: centre - @nx _eye.offset
      y:          @ny _eye.level + @emotion.HEAD_DIP
      size:       @nx _eye.size
      openness:   @emotion.EYE_SIZE
      pupil_size: @nx _eye.pupil_size
      lid_droop:  @emotion.EYELID_DROOP
    })

    eyeR = new Eye({
      x: centre + @nx _eye.offset
      y:          @ny _eye.level + @emotion.HEAD_DIP
      size:       @nx _eye.size
      openness:   @emotion.EYE_SIZE
      pupil_size: @nx _eye.pupil_size
      lid_droop:  @emotion.EYELID_DROOP
    })

    body = new Body({
      x: centre
      y: @ny _body.level
      neck_length: @ny _body.neck_length
      neck_offset: @nx _body.neck_offset
      shoulder_width: @nx @emotion.SHOULDER_WIDTH
      shoulder_dip: @ny @emotion.SHOULDER_DIP
      waist_x: @nx(_body.waist) + @nx(@emotion.WAIST_OFFSET)
      waist_y: @canvas.getHeight()
    })

    mouth = new Mouth({
      x: centre
      y: @ny _mouth.level + @emotion.HEAD_DIP
      curve:    @ny @emotion.MOUTH_CURVE
      openness: @ny @emotion.MOUTH_OPENNESS
      offset:   @ny @emotion.MOUTH_OFFSET
      length:   @nx @emotion.MOUTH_LENGTH
    })

    @features = [body, face, eyeL, eyeR, mouth, browL, browR]

  draw_features: ->
    @canvas.clear()
    for feature in @features
      @canvas.add(feature.shape)

  resize_canvas: (container) ->
    @canvas.setWidth($(container).width())
    @canvas.setHeight(@canvas.getWidth()*0.8)


  element_view: (container, id) ->
    $("<canvas>").appendTo(container).attr({
      "id": id,
    })

  create_sliders: (container) ->
    @create_slider("pleasure")
    @create_slider("arousal")
    @create_slider("dominance")


  create_slider: (id) ->
    slider_element = document.getElementById("#{id}-slider")
    slider = noUiSlider.create slider_element, {
      start: 0
      range:
        'min': -1
        'max': 1
    }

    slider.on "slide", =>
      @slider_slide id, slider.get()

  slider_slide: (id, value)->
    @emotion = @emo_engine.setPAD(id, value)
    @render()

  ny: (y) ->
    y = y * @canvas.getHeight()

  nx: (x) ->
    x = x * @canvas.getWidth()

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
      fill: '#d8d8d8'
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

    path_string = new BezierCurve(cornerL, cornerR, lower_curve).toSVG()
    path_string += new BezierCurve(cornerL, cornerR, @curve).toSVG()

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


window.AniSam = AniSam
