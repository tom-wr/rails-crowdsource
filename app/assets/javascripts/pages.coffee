# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#=require anisam
#=require visicount

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
      window.anisam = new AniSam('#anisam-panel')
      window.anisam.start()
    app = new ClassifyApp(gl)
    app.start()

class ClassifyApp

  constructor: (settings) ->
    @project = settings.project
    @current_taskflow = settings.taskflow
    @current_task = settings.task
    @data_pool = []

    @images = [
      {id: "FRE_000109.jpg", caption: "P-38 Lightning pilots of the 55th Fighter Group huddle at Nuthampstead air base. Passed for publication 12 November 1943. \n \nPrinted caption attached to print: 'Taking a last look at the map before setting out on an operational flight. Reading anti-clockwise from the man with goggles (bottom, centre) they are: Lt. M.E. Blanchard, of 284 Seaside Ave. Santa Cruz, Avenue, Calif; Lt. H.E. Larsen, of 718 E. 5th St. Anaconda, Montana; Lt. R.W. Brown, of 1205 West 8th St. Erie, Penn.; Lt. R.H. Jensen, of Racine, Wisc.; Lt. W.C. Florentine, of Washington, Minn.; Lt. W.W. Shank, of 413 S. Main St., Harrisonburg, Va,; Lt. K.H. Garlock, of South [Tra]nsit Road, Lockport, N.Y.; and Lt. W.M. Tibbots [Tibbetts], of Route 2, Homer, Ill"}
      {id: "FRE_000256.jpg", caption: "Pilots of the 56th Fighter Group relax with the papers or a pack of cards at a dispersal point rest room at Horsham St. Faith air base. Passed for publication 29 May 1943. Printed caption attached to print: 'A Match for the Nazi - F.W. 190 - the \"Thunderbolt\" New American High-Altitude Fighter. The latest Amerian single-seater fighter, the Republic P.47, known as the \"Thunderbolt\" has been in operation from British bases for some time. The largest and heaviest single-seater fighter - around 40,000 ft - the \"Thunderbolt\"'s top speed rated in excess of 400 m.p.h., at altitude, is derived from a Pratt and Whitney Radial engine of 2,000 h.p. fitted with Turbo-Supercharger. The armament consists of eight and a half in. calibre magine guns, these give a total rate of fire of 6,400 rounds a minute. In a series of operations they have shot down several of the German crack Fw 190s. Photograph shows - Crew at ease at dispersal point rest room. FOX MAY 1943."}
      {id: "FRE_000740.jpg", caption: "Personnel of the 92nd Bomb Group enjoy refreshments with ladies of the American Red Cross at Alconbury. Caption printed on image: 'American Red Cross Clubmobile \"somewhere in Great Britain.\" \"JUST BACK FROM THE TARGET.\" 4. Passed by US Army Censor no 21 ETO USA.'"}
      {id: "FRE_001302.jpg", caption: "A B-26 Marauder of the 387th Bomb Group explodes in mid air over Dunkirk. A veteran has written in an enclosed letter to Freeman: 'The \"A\" picture enclosed was taken over Dunkirk and the aircraft is, I believe, piloted Col Jack Caldwell of Searey Ark. We were leading the second box and I remember Captain Kunde, our navigator with a real \"nose\" for flak, screaming at them to get away from Dunkirk. You will note that this is with 8-10 tenths cloud cover and other bursts are \"on target\", Thus our subsequent are of \"Window\" or \"Chaff\".'"}
      {id: "FRE_001001.jpg", caption: "Sergeant Sam E. Frisella, of the 303rd Bomb Group, enjoys a cup of tea from an army Jeep. Image stamped on reverse: ‘Copyright Current Affairs Ltd.’ [stamp], ‘Passed for Publication 16 Dec 1942. [stamp] and ‘238731.’ [Censor no.] Printed caption on reverse: 'It is hardly a drawing room tea party, but Sergt. Sam E. Frisella, of 1006 S. Ashland Blud. Chicago, finds it quite a comfortable way to keep his feet out of the mud while drinking his tea and reading a letter from home at an American Air Corps station somewhere in England. \"If American keeps supplying, we'll keep 'em flying\", is the message he sends home.'"}
      {id: "FRE_001010.jpg", caption: "Sergeant Dominick A. Mupo, of the 303rd Bomb Group, relaxes on a haystack.\n\nImage stamped on reverse: ‘Copyright Current Affairs Ltd.’ [stamp], ‘Passed for Publication 28 Jan 1943. [stamp] and ‘245677.’ [Censor no.]\n\nPrinted caption on reverse: 'Roasting on the hay is Sgt Dominick A Mupo, of 503 West 170 Street, NYC. He is serving with the Engineers in Britain. Aged 26, Sgt ?upo was formerly with the GPO. His parents live at the above address. Sgt Mupo was educated at Junior High School 115.'"}
      {id: "FRE_001160.jpg", caption: "Personnel of the 306th Bomb Group burn missions into the ceiling of a hut. Image stamped on reverse: '314200.' [Censor no.], 'Passed for publication 30 March 1944.' [stamp] Printed caption on reverse: '8th USAAF facility visit. When the crews of a Fortress Bomber Group stationed somewhere in England go on a raid the place and date is recorded with candle smpke on the ceiling of the officers' mess. One of the pilots taking part in the raid is hoisted on the shoulders of two senior officers and with a lighted candle records the raid and date. The ceiling is now a mass of candle smoke as this group has been here since 1942. The Colonel and Major of the Squadron hoist the Lieutenant on their shoulders whilst he marks this raid with a lighted candle. Left is Col. George R. Buckey and right Maj. Richard E. Walck, and on their shoulders is 1st Lt. John Stolz, and the recording is Berlin. 29 March 1944.'"}
      {id: "FRE_001891.jpg", caption: "B-17 Flying Fortresses of the 457th Bomb Group fly in formation during a mission."}
      {id: "FRE_001935.jpg", caption: "Three little girls hold up a balloon celebrating the 100th mission of the 466th Bomb Group in front of a B-24 Liberator (serial number 42-95592) nicknamed \"Black Cat\". Handwritten caption on reverse: 'On our 100 Mission party Day- 18 Aug 1944, Attlebridge, 466th- wouldn't it be something if we could identify these girls? How could I do it?'"}
      {id: "FRE_002314.jpg", caption: "Major James Goodson, of the 4th Fighter Group on the phone in his bunk, 5 June 1944. Passed for publication 5 Jun 1944. Printed caption on reverse: 'Shot Down 30 Nazi Planes. Associated Press Photo Shows:- Associated Press Photo Shows:- Major Goodson talks about an upcoming mission over the field phone in his quarters. \"Pin-Up\" girls adorn the wall. CORT. 5-6-44-Y.' On reverse: Associated Press, SHAEF Field Press Censor and US Army General Section Press & Censorship Bureau [Stamps]."}
      {id: "FRE_003522.jpg", caption: "A bomber crew of the 91st Bomb Group at interrogation after a mission. Passed for publication 24 Mar 1943. Printed caption on reverse: 'Fortresses' Day Raid on Wilhelmshaven - The German Naval Base at Wilhelmshaven was successfully attacked in daylight March 22 by American Flying Fortresses and Liberators. This was the third heavy raid for U.S. bombers on Wilhelmshaven. Despite strong fighter opposition, the bombers battled their way to the target and dropped their loads of explosives. Three bombers were lost. Associated Press photos show: the crew of a Fortress called Wheel and Deal in front of their bomber which had prop of one engine shot away. Members of crews taking refreshment, and chatting while awaiting interrogation. Being interrogated. Ground crews loading parachute harness, and uncovering bombers prior to take-off. Fortresses taxiing to the straight runway for interval take-off. Machineguns mounted in nose of Fortress to fight off frontal attacks. Gunner manning lethal weapon in nose of Fortress. Crew of the Delta Rebel which had just completed its 21st operational flight. Scoreboard on Fortress denoting number of raids and number of Nazis shots down.' On reverse: US Army General Section Press & Censorship Bureau [Stamp]. Print No: 254774."}
      {id: "FRE_003668.jpg", caption: "Technical Sergeant Edward Fee of the 91st Bomb Group enjoys a cup of coffee surrounded by his comrades at Bassingbourn after his final mission. Printed caption on reverse of print: 'A-27150 AC - HQ 8th AAF Photo Section, 20 Dec 1943. Ovation on Return. Congratulated on the completion of his tour of \"Ops\", T/Sgt. Edward Fee (holding cup), 30, of Charlestown, Mass., is surrounded by flying mates as he awaits interrogation. T/Sgt. Fee, holder of Air Medal and slated for the DFC, is aerial engineer of Fortress \"Black Swan\", and was a longshoreman in civilian life. His final operational mission on December 22nd took him over northwest Germany. Photo shows him enjoying coffee a few minutes after landing. U.S. Air Force Photo.'"}
      {id: "FRE_004349.jpg", caption: "A B-17 Flying Fortress of the 306th Bomb Group trails smoke as it drops its bombs. Handwritten caption on reverse: '306BG, Berlin.'"}
      {id: "FRE_004794.jpg", caption: "Ground crewmen of the 379th Bomb Group gather around a stove in a tent near their B-17 Flying Fortress. Passed for publication 8 Jan 1944. Handwritten caption on reverse: '379.' Printed caption on reverse: '\"Unsung Heroes Of The Air War\". Working endless hours in all ki-[obscured] the ground crews of the big B-17 bombers get little cradit[sic] in the constant onslaught from the air on Hitler's European Fortress. Averaging 18 hours a day for many weeks at a time, they seldom get a chance to shave or wash. To be near their work they live in tents pitched near the parking area. Associated Press Photo Shows:- Grouped around the stove in their tent, with their \"charge\", a B-17 Fortress just visible through the door, are (left to right): M/Sgt. Kenneth Harrison, crew chief, of 734 Commercial St., Danville, Ill.; Pte. John E. Andress, of Greenville, Ala.; Cpl. Bruce Drynan, of 576 Hawthorne Ave., Elmhurst, Ill.; and Sgt. Frank Janish, of 421 Sycamore Street, Buffalo, N.U[sic]. IRV 263742. 8-1-44-Y.' Censor no: 299298. On reverse: Associated Press and US Army General Section Press & Censorship Bureau [Stamps]."}
      {id: "FRE_004914.jpg", caption: "Personnel gather crates of supplies dropped by a B-17 Flying Fortress of the 385th Bomb Group."}
      {id: "FRE_008474.jpg", caption: "B-24 Liberators of the 467th Bomb Group dropping their bomb-loads. Handwritten caption on reverse: '21.'"}
      {id: "FRE_008497.jpg", caption: "A flight of 486th Bomb Group B-17 Flying Fortresses drop their loads of anti-personnel bombs on the target below. Handwritten caption on reverse: '486BG, Anti-Personnel.'"}
      {id: "FRE_008775.jpg", caption: "Personnel of the 1st Fighter Group, 15th Air Force in their quarters in Corsica. Printed caption on reverse: '75644 AC_ Members of the 94th Fighter Squadron, 1st Fighter Group relax in their quarters at an airbase in Corsica. US Air Force Photo.' Handwritten caption on reverse: 'Loretta Fall 44.'"}
      {id: "FRE_009766.jpg", caption: "American air men talk to Women's Auxiliary Air Force Officers. Image stamped on reverse: 'Daily Mirror.' [stamp], 'Not to be published 24 Jun 1943.' [stamp] and '271296.' [Censor no.] Printed caption on reverse: 'A picturesque setting showing some WAAF officers, attached to the United States Air Force, chatting to American Airmen at American Bomber Command.'"}
      {id: "FRE_009904.jpg", caption: "Major Gerald W Johnson, Colonelt Hubert Zemke, Lieutenant Colonel David Schilling and Major Walker M Mahurin of the 56th Fighter Group entertain Foreign Correspondent Susie Carson, in the officers mess at Halesworth. Zemke has handwritten on the reverse: 'L to R: (1) Johnson; (2) Zemke; (3) Carson - Reporter; (4)Schilling; (5) Mahurin. An individual woman on base caused all sorts of problems. First, we had no billet to keep them. An officer had to move from his bed to provide lodge, and then again they were forever wanting to follow the CO and force their way into briefings. In this case Miss Carson was assigned to Mahurin and told to talk to the troops who did the fighting. Mahurin kept her out of my hair.'"}
    ]

    @image_path = "/media/images/mixed/"
    @image_name = ""
    @image_caption = "none"
    @image_tag = $("#classify-image")
    @caption_tag = $("#classify-caption-text")

    @events()

  start: ->
    console.log("starting app")
    @load_image()

  # we bind events to elements as dependencies
  events: ->
    $("#classify-question-panel").on "click", ".answer", ->
      $(".answer").removeClass("active")
      $(this).toggleClass("active")

    $("#classify-question-panel").on "click", "#next-button", (event) =>
      console.log "toyoy"
      @next_click()

    $("#classify-question-panel").on "click", "#submit-button", (event) =>
      @submit_click()

    $("#classify-image-panel").on "click", ".classify-caption-toggle", (event) =>
      $("#classify-caption-panel").slideToggle()

  # a random image is chosen and displayed
  load_image: ->
    random_image = @get_random_image()
    @image_name = random_image.id
    @image_caption = random_image.caption
    image_source = @image_path + @image_name
    @caption_tag.text @image_caption
    image = @image_tag.attr("src", image_source)

  # a random image is selected and removed from the master list
  get_random_image: ->
    count = @images.length
    index = Math.floor( Math.random() * count )
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
        window.sliders.dominance.get()
      ]
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
    $("#question").text("Classification Summary")

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
    delete window.anisam
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
