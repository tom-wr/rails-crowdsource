class VisiCount

  _items = [
    name: "Bicycle"
    plural: "Bicycles"
    icon: "\uf206"
    count: 0
    rail: 0
  ,
    name: "Ground-Vehicle"
    plural: "Ground-Vehicles"
    icon: "\uf0d1"
    count: 0
    rail: 0
  ,
    name: "Aircraft"
    plural: "Aircraft"
    icon: "\uf072"
    count: 0
    rail: 0
  ]

  constructor: (container)->
    @setup_canvas container
    @setup_items()
    @setup_sliders container
    @setup_rails()
    @setup_icons()
    @render()

  setup_canvas: (container) ->
    @inkan = new Inkan container
    @gutter = @inkan.width * 0.3
    @count_space = @inkan.width * 0.7

  setup_items: ->
    for item, index in _items
      item.count = 0;
      item.rail = 0;

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
      count_text = if item.count >= 10 then "#{item.count}+" else "#{item.count}"
      counter = @inkan.Text "#{count_text}", 0, item.rail + 30, {font: "20px Arial" }
      if item.count > 0
        @add_icon_count(number, item) for number in [1..item.count]
      @inkan.add item.text
      @inkan.add counter

    @inkan.draw()

  add_icon_count: (number, item) ->
    max = 10+1
    shape = @inkan.Text item.icon, 0, item.rail, {font: "28px FontAwesome"}
    shape.top = item.rail + 5
    shape.left = @gutter + ( @count_space / max ) * number
    @inkan.add shape

  set_count: (id, value) ->
    for item in _items
      if id.toLowerCase() is item.name.toLowerCase()
        item.count = ~~value

  element_view: (container, id) ->
    $("<canvas>").appendTo(container).attr({
      "id": id,
    })

  resize_canvas: (container) ->
    @canvas.setWidth $(container).width()
    @canvas.setHeight (@canvas.getWidth() * 0.7)

  setup_sliders: ->
    window.sliders = {}
    window.sliders.bicycles =   @create_slider("bicycle")
    window.sliders.vehicles =  @create_slider("ground-vehicle")
    window.sliders.aircraft =  @create_slider("aircraft")

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

window.VisiCount = VisiCount
