(function() {
    var selector = "#vis";

    var x, y, xAxis, yAxis;

    var svg;

    var margin = {top: 20, right: 20, bottom: 30, left: 60},
        width = 1200 - margin.left - margin.right,
        height = 300 - margin.top - margin.bottom;

    function findMinMaxTime(aSeries) {
      var min = null,
          max = null,
          start,
          stop;

      _.each(aSeries, function(s) {
        start = s[0][0]             // start epoch
        stop  = s[s.length - 1][0]; // end epoch

        if (!min || start < min)
          min = start;

        if (!max || stop > max)
          max = stop;
      });

      return [min, max];
    }

    function findMinMaxValues(aSeries) {
      var min = null, max = null;

      _.each(aSeries, function(s) {
        _.each(s, function(point) {
          if (!min || point[1] < min)
            min = point[1];

          if (!max || point[1] > max)
            max = point[1];
        });
      });

      return [min, max];
    }

    function setAxes(data) {
      var iEpoch = 0;

      x = d3.time.scale()
                .domain(findMinMaxTime(data))
                .range([0, width]);

      y = d3.scale.linear()
                .domain(findMinMaxValues(data))
                .range([height, 0]);

      xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .tickFormat(d3.time.format('%H:%M'))
          .tickSize(0)
          .tickPadding(8);

      yAxis = d3.svg.axis()
          .scale(y)
          .orient("left");

      svg = d3.select(selector).append("svg")
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
    }

    function canvasEngine(data) {
      // create canvas
      var base = d3.select(selector);

      var chart = base.append("canvas")
                      .attr("width", width)
                      .attr("height", height)
                      .style("padding-left", margin.left + "px")
                      .style("padding-top", margin.top + "px");

      var context = chart.node().getContext("2d");

      // Bind data
      var detachedContainer = document.createElement("custom");
      var dataContainer     = d3.select(detachedContainer);

      var dataBinding = dataContainer.selectAll("custom.line")
                          .data(data, function(d) { return d;});

      // DOM -> canvas
      dataBinding.enter()
        .append("custom")
        .classed("line", true)
        .attr("x", function(d) { return d[0]; })
        .attr("y", function(d) { return d[1]; });

      context.fillStyle = "#fff";
      context.rect(0, 0, chart.attr("width"), chart.attr("height"));
      context.fill();

      var elements = dataContainer.selectAll("custom.line");

      var moves = [];
      elements.each(function (d) {
        var node = d3.select(this);
        var x = new Date(node.attr("x"));
        var y = +node.attr("y");
        return moves.push([x, y]);
      });

      _.each(moves, function (d, idx) {
        if (idx+1 < moves.length) {
          var next = moves[idx+1];
          context.beginPath();
          context.moveTo(x(d[0]), y(d[1]));
          context.lineTo(x(next[0]), y(next[1]));
          context.strokeStyle = 'red';
          context.stroke();
        }
      });
  }

  function svgEngine(series) {
      var line = d3.svg.line()
          .x(function(d) { return x(d[0]); })
          .y(function(d) { return y(d[1]); });

      _.each(series, function(s) {
        svg.append("path")
            .datum(s)
            .attr("class", "line")
            .attr("d", line);
      });
  }

  function dual(series, engine) {
    setAxes(series);

    if (engine == "canvas")
      canvasEngine(series);
    else
      svgEngine(series);
  }

  // expose methods
  drd.dual = dual
}).call(this);
