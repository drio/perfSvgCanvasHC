drd.canvasLC = (data) ->

  margin = {top: 20, right: 20, bottom: 30, left: 50}
  width  = 1300 - margin.left - margin.right
  height = 300 - margin.top - margin.bottom

  base = d3.select("body")

  chart = base.append("canvas")
    .attr("width", width)
    .attr("height", height)
    .style("padding-left", 39 + "px")

  context = chart.node().getContext("2d")

  scaleX = d3.time.scale()
            .domain([new Date(data[0][0]), new Date(data[data.length - 1][0])])
            .range([0, width])

  scaleY = d3.scale.linear()
            .domain(d3.extent(data, (d) -> d[1]))
            .range([height, 0])

  xAxis = d3.svg.axis()
      .scale(scaleX)
      .orient("bottom")
      .tickFormat(d3.time.format('%H:%M'))
      .tickSize(0)
      .tickPadding(8)

  yAxis = d3.svg.axis()
      .scale(scaleY)
      .orient("left")

  # Axes (SVG)
  svg = d3.select("body").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end");


  # Bind Data
  detachedContainer = document.createElement("custom")
  dataContainer     = d3.select(detachedContainer)

  dataBinding = dataContainer.selectAll("custom.line")
    .data(data, (d) -> d )

  dataBinding.enter()
    .append("custom")
    .classed("line", true)
    .attr("x", (d) -> d[0])
    .attr("y", (d) -> d[1])

  # DOM -> canvas
  #
  # clear canvas
  context.fillStyle = "#fff"
  context.rect(0, 0, chart.attr("width"), chart.attr("height"))
  context.fill()

  elements = dataContainer.selectAll("custom.line")

  moves = []
  elements.each((d) ->
    node = d3.select(this)
    x = new Date(node.attr("x"))
    y = +node.attr("y")
    moves.push [x, y]
  )

  _.each(moves, (d, idx) ->
    if (idx+1 < moves.length)
      next = moves[idx+1]
      context.beginPath()
      context.moveTo scaleX(d[0]), scaleY(d[1])
      context.lineTo scaleX(next[0]), scaleY(next[1])
      context.strokeStyle = 'red'
      context.stroke();
  )
