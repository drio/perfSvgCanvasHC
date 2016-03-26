do ->
  log = (msg, clean=false) ->
    sel = d3.select("#console")
    if clean
      sel.html("")
    html = sel.html()
    sel.html(html + msg + "\n")

  clean = ->
    node = document.getElementById("vis")
    node.innerHTML = ''

  doWork = (nSeries=2, size=100, engine="svg") ->
    clean()
    data = drd.genData(nSeries, size)
    #canvasLC(data)
    #svgLC(data)
    #_.each(drd.genData(10), (e) -> log e[1])
    t0 = performance.now()
    drd.dual(data, engine)
    t1 = performance.now();
    console.log engine, nSeries, size,  t1 - t0
    +(t1 - t0).toFixed(2)
    #_.each(drd.genData(10), (e) -> log e[1])

  renderLoop = ->
    #fps()
    d3.timer -> doWork()

  benchmark = ->
    ns      = [1, 2, 5, 10, 20, 50]
    sizes   = [10, 50, 100]
    engines = [ "svg", "canvas", "hc" ]

    tData = []
    _.each(engines, (e, idx) ->
      tData.push
        name: e
        data: []
      _.each(sizes, (s) ->
        _.each(ns, (num) ->
          time = doWork(num, s, e)
          nDataPoints = s * num
          tData[idx].data.push([nDataPoints, time])
        )
      )
    )

    tData
    ###
    window.onload = ->
      setTimeout ->
        t = performance.timing
        console.log e, ": ", t.loadEventEnd - t.responseEnd
      , 0
    ###

  #renderLoop()
  d3.select("#vis")
    .style("height", drd.height + "px")
    .style("width", drd.width + "px")
  tData = benchmark()

  console.log(tData)
  d3.select("#vis")
    .style("height", "300px")
    .style("width", "1000px")
  drd.plotResults(tData, "vis")
