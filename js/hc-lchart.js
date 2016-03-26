(function() {

  function toHCFormat(series) {
    return _.map(series, function(s) {
      return {data: s};
    });
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
    console.log(toHCFormat(series));
    new Highcharts.Chart(cfg);
  }

  drd.hcEngine = engine;
}).call(this);
