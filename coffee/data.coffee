
genData = (size) ->

  start = new Date() - (60*size)
  _.map(_.range(size), (i) ->
    [ new Date(start + (60*1000*i)), _.random(1000) ]
  )

drd.genData = genData
