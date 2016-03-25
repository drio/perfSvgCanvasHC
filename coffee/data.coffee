
genData = (nSeries, size) ->

  start = new Date() - (60*size)
  series = []

  _.times(nSeries, ->
    singleSerie = []
    _.map(_.range(size), (i) ->
      singleSerie.push [ new Date(start + (60*1000*i)), _.random(1000) ]
    )
    series.push singleSerie
  )

  series

drd.genData = genData
