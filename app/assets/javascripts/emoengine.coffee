class EmoEngine

  FEATURE =
    MOUTH_CURVE:    [-0.1, 0, 0.08]
    MOUTH_OPENNESS: [0, 0, 0.09]
    MOUTH_OFFSET:   [0.05, 0, -0.05]
    MOUTH_LENGTH:   [0.07, 0.05, 0.07]

    EYE_SIZE:  [0.75, 0.95, 1.05 ]
    EYELID_DROOP:  [0.4, 0, 0 ]

    BROW_LENGTH:   [ 0.03, 0.03, 0.03]
    BROW_SLOPE:    [ -0.004, 0, 0.004]
    BROW_RAISE:    [ -0.005, 0, 0.005]

    SHOULDER_DIP: [0.16, 0.13, 0.1 ]
    SHOULDER_WIDTH: [0.2, 0.25, 0.25]
    HEAD_DIP: [0.05, 0.01, 0]
    WAIST_OFFSET: [0, 0.04, 0.06]


  constructor: ->
    @emotion = {}
    @setupPAD(0,0,0)

  pleasure_ops: (valence) ->
    @update "MOUTH_CURVE",    valence
    @update "MOUTH_OFFSET",   valence
    @update "MOUTH_LENGTH",   valence

  arousal_ops: (arousal) ->
    @update "MOUTH_OPENNESS", arousal
    @update "EYE_SIZE",       arousal
    @update "BROW_RAISE",     arousal
    @update "EYELID_DROOP",   arousal

  dominance_ops: (dominance) ->
    @update "BROW_SLOPE",     dominance
    @update "BROW_LENGTH",    dominance
    @update "SHOULDER_DIP",   dominance
    @update "HEAD_DIP",       dominance
    @update "SHOULDER_WIDTH", dominance
    @update "WAIST_OFFSET",   dominance

  update: (feature_name, value) ->
    normal = @normalise FEATURE[feature_name], value
    @emotion[feature_name] = normal

  normalise: (feature, value) ->
    high  = feature[2]
    mid   = feature[1]
    low   = feature[0]

    if value > 0
      norm = (high - mid) * value + mid
    else if value < 0
      norm = (mid - low) * value + mid
    else
      norm = mid
    norm

  setupPAD: (p, a, d) ->
    @pleasure_ops(p)
    @arousal_ops(a)
    @dominance_ops(d)
    @emotion

  setPAD: (type, value) ->
    switch type
      when "pleasure"   then @pleasure_ops  value
      when "arousal"    then @arousal_ops   value
      when "dominance"  then @dominance_ops value
    @emotion

window.EmoEngine = EmoEngine