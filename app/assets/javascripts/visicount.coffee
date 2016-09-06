class VisiCount


  _items = [
    name: "Person"
    plural: "People"
    icon: "\uf007"
    count: 0
    rail: 0
  ,
    name: "Aircraft"
    plural: "Aircraft"
    icon: "\uf072"
    count: 0
    rail: 0
  ,
    name: "Hat"
    plural: "Hats"
    icon: "\uf2ae"
    count: 0
    rail: 0
  ]

  constructor: (container)->
    @setup_canvas container
    @setup_sliders container
    @setup_rails()
    @setup_icons()
    @render()

  setup_canvas: (container) ->
    id = "visicount-canvas"
    @inkan = new Inkan container
    @gutter = @inkan.width * 0.25
    @count_space = @inkan.width * 0.75

  setup_rails: ->
    division = @inkan.height / 6
    for item, index in _items
      item.rail = division * ( 1 + (2 * index) )

  setup_icons: ->
    for item in _items
      item.text = @inkan.Text item.plural.toUpperCase(), 0, item.rail, {font:"20px Arial"}

  render: ->
    @inkan.tick =>
      @render()
    @draw_icons()

  draw_icons: ->
    @inkan.clear()
    for item, index in _items
      counter = @inkan.Text "#{item.count}", @gutter - 10, item.rail, {font: "20px Arial" }
      if item.count > 0
        @add_icon_count(number, item) for number in [1..item.count]
      @inkan.add item.text
      @inkan.add counter

    @inkan.draw()

  add_icon_count: (number, item) ->
    max = 10+1
    shape = @inkan.Text item.icon, 0, item.rail, {font: "40px FontAwesome"}
    shape.top = item.rail + 5
    shape.left = @gutter + ( @count_space / max ) * number
    @inkan.add shape

  set_count: (id, value) ->
    for item in _items
      if id.toLowerCase() is item.name.toLowerCase()
        item.count = ~~value
        console.log item

  element_view: (container, id) ->
    $("<canvas>").appendTo(container).attr({
      "id": id,
    })

  resize_canvas: (container) ->
    @canvas.setWidth $(container).width()
    @canvas.setHeight (@canvas.getWidth() * 0.7)

  setup_sliders: ->
    window.sliders = {}
    window.sliders.pleasure =   @create_slider("person")
    window.sliders.dominance =  @create_slider("aircraft")
    window.sliders.dominance =  @create_slider("hat")

  create_slider: (id) ->
    slider_element = document.getElementById "#{id}-slider"
    slider = noUiSlider.create slider_element, {
      step: 1
      start: 0
      range: 'min': 0, 'max': 10
      behaviour: 'hover'
    }
    slider.on "slide", =>
      @slider_slide id, slider.get()
    slider

  slider_slide: (id, value)->
    @set_count(id, value)

  ny: (y) ->
    y = y * @canvas.getHeight()

  nx: (x) ->
    x = x * @canvas.getWidth()

window.VisiCount = VisiCount
