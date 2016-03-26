do ->
  log = (msg, clean=false) ->
    sel = d3.select("#console")
    if clean
      sel.html("")
    html = sel.html()
    sel.html(html + msg + "\n")

  doWork = (nSeries=2, size=100, engine="svg") ->
    # clean up
    node = document.getElementById("vis")
    node.innerHTML = ''

    data = drd.genData(nSeries, size)
    #canvasLC(data)
    #svgLC(data)
    #_.each(drd.genData(10), (e) -> log e[1])
    t0 = performance.now()
    drd.dual(data, engine)
    t1 = performance.now();
    console.log engine, nSeries, size,  t1 - t0
    #_.each(drd.genData(10), (e) -> log e[1])

  renderLoop = ->
    #fps()
    d3.timer -> doWork()

  benchmark = ->
    ns      = [1, 2, 5, 10, 20, 50]
    sizes   = [10, 100, 500]
    engines = [ "svg", "canvas", "hc" ]
    _.each(ns, (num) ->
      _.each(sizes, (s) ->
        _.each(engines, (e) -> doWork(num, s, e))
      )
    )
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
  benchmark()
