(function() {

  function toHCFormat(series) {
    return _.map(series, function(s) {
      return {data: s};
    });
  }

  function plotResults(data, container) {
    cfg = {
      chart: {
        animation: false,
        renderTo: container,
        type: 'scatter'
      },
      title: {text: "svg vs canvas vs HC (init time)"},
      legend:  {enabled: true },
      credits: {enabled: false },
      tooltip: {enabled: true},
      xAxis: {
        title: {
          text: 'Number of Data points'
        }
      },
      yAxis: {
        title: {
          text: 'scripting time in ms'
        }
      },

      series: data
    }
    new Highcharts.Chart(cfg);
  }

  function engine(series, container) { // Array of timeseries
    cfg = {
      chart: {
        animation: false,
        renderTo: container
      },
      title: {text: null},
      legend:  {enabled: false },
      credits: {enabled: false },
      tooltip: {enabled: false},
      series: toHCFormat(series)
    }
    new Highcharts.Chart(cfg);
  }

  drd.hcEngine = engine;
  drd.plotResults  = plotResults;
}).call(this);
