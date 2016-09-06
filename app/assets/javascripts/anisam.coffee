#=require emoengine
#=require features

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
    level: 0.255
    stroke: 2

  _body =
    level: 0.61
    neck_offset: 0.07
    neck_length: 0.1
    waist: 0.25

  _heart =
    level: 0.85
    size: 1

  _info_text =
    pleasure:
      text: "This slider controls the amount of pleasure in the emotion - from unpleasant to very pleasant."
      icon: "smile-o fa-2x"
    dominance:
      text: "This slider controls the felt amount of control and dominance in the emotion - from feeling submissive and not in control to feeling powerful and in-control."
      icon: "user fa-2x"
    arousal:
      icon: "heartbeat fa-2x"
      text: "This slider controls amount of felt activity in the emotion - from calm and sedate to active and alert."

  constructor: (container) ->

    @setup(container)

  setup: (container) ->
    @setup_canvas(container)
    @setup_animation_framerate()
    @last_time = 0
    @heart_size = 1
    @begin = 1
    @change = 2
    @time = 0

  init_vars: ->
    canvas_height = @canvas.getHeight()

  setup_canvas: (container) ->
    id = 'anisam-canvas'
    @element = @element_view(container, id)
    @create_sliders(container)
    @canvas = new fabric.StaticCanvas id
    @resize_canvas(container)

  start: ->
    @setup_animation_framerate()
    @emo_engine = new EmoEngine()
    @emotion = @emo_engine.setupPAD(0,0,0)
    @heart_size = 0.1
    @begin = 0.1
    @change = 100
    @last_time = 0
    @time = 0
    @render()

  render: () ->
    window.requestAnimationFrame(=>
      @render()
    )
    time = new Date().getTime()
    delta = time - @last_time
    @last_time = time
    @setup_features(delta)
    @draw_features()

  setup_features: (delta) ->

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
      length: @nx  @emotion.BROW_LENGTH
      raise:  @ny  @emotion.BROW_RAISE
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
      size:       @nx _eye.size * @emotion.EYE_SIZE
      openness:   @emotion.EYE_SIZE
      pupil_size: @nx _eye.pupil_size
      lid_droop:  @emotion.EYELID_DROOP
    })

    eyeR = new Eye({
      x: centre + @nx _eye.offset
      y:          @ny _eye.level + @emotion.HEAD_DIP
      size:       @nx _eye.size * @emotion.EYE_SIZE
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

    @heart_size_direction()
    @time = @time + delta
    @heart_size = @heart_animate(@time, @begin, @change, @emotion.HEART_PULSE)
    @heart_size = @cap @heart_size, ( _heart.size + @emotion.HEART_RANGE), ( _heart.size - @emotion.HEART_RANGE)
    heart = new Heart({
      x: centre
      y: @ny @emotion.HEART_DIP
      width1:  @nx 0.05 * @heart_size
      height1: @ny 0.05 * @heart_size
      width2:  @nx 0.05 * @heart_size
      height2: @ny 0.07 * @heart_size
      point:   @ny 0.10 * @heart_size
    })

    @features = [body, face, eyeL, eyeR, mouth, browL, browR, heart]

  heart_size_direction: () ->
    if @heart_size >= (_heart.size + @emotion.HEART_RANGE)
      @begin = @heart_size
      @change = (_heart.size - @emotion.HEART_RANGE) - @heart_size
      @time = 0
    else if @heart_size <= (_heart.size - @emotion.HEART_RANGE)
      @begin = @heart_size
      @change = (_heart.size + @emotion.HEART_RANGE) - @heart_size
      @time = 0

  heart_animate: (time, begin, change, duration) ->
    return change * time / duration + begin

  cap: (value, max, min) ->
    if value < min
      value = min
    else if value > max
      value = max
    value

  draw_features: ->
    @canvas.clear()
    for feature in @features
      @canvas.add(feature.shape)

  resize_canvas: (container) ->
    @canvas.setWidth($(container).width())
    @canvas.setHeight(@canvas.getWidth()*0.7)

  element_view: (container, id) ->
    $("<canvas>").appendTo(container).attr({
      "id": id,
    })

  create_sliders: (container) ->
    sliders = {}
    sliders.pleasure = @create_slider("pleasure")
    sliders.arousal = @create_slider("arousal")
    sliders.dominance = @create_slider("dominance")
    window.sliders = sliders


  create_slider: (id) ->
    slider_element = document.getElementById("#{id}-slider")
    slider = noUiSlider.create slider_element, {
      start: 0
      range: 'min': -1, 'max': 1
      behaviour: 'hover'
    }
    slider.on "slide", =>
      @slider_slide id, slider.get()
    slider.on "hover", (value) =>
      $("#tutorial_slider_info").show()
      $("#tutorial_slider_info").html(@slider_info_view(_info_text[id].icon, _info_text[id].text));
    $("#tutorial_slider_info").hide()
    slider

  slider_slide: (id, value) ->
    @emotion = @emo_engine.setPAD(id, value)

  slider_hover: (type) ->

  slider_info_view: (icon, text) ->
    "<i class='tutorial_info_icon fa fa-#{icon}'></i> #{text}"

  ny: (y) ->
    y = y * @canvas.getHeight()

  nx: (x) ->
    x = x * @canvas.getWidth()

  setup_animation_framerate: ->
    unless window.requestAnimationFrame
      window.requestAnimationFrame = window.webkitRequestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.oRequestAnimationFrame or
      window.msRequestAnimationFrame or
      (callback, element) -> window.setTimeout callback, 1000/60

window.AniSam = AniSam
