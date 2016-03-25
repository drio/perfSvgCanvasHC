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
    drd.dual(data, engine)
    #_.each(drd.genData(10), (e) -> log e[1])

  renderLoop = ->
    #fps()
    d3.timer -> doWork()

  loadTimes = ->
    doWork(20, 100, "svg")
    window.onload = ->
      setTimeout ->
        t = performance.timing
        console.log t.loadEventEnd - t.responseEnd
      , 0
      #console.log(t. - t.domLoading)

  #renderLoop()
  loadTimes()
