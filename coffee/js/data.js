// Generated by CoffeeScript 1.10.0
(function() {
  var genData;

  genData = function(size) {
    var start;
    start = new Date() - (60 * size);
    return _.map(_.range(size), function(i) {
      return [new Date(start + (60 * 1000 * i)), _.random(1000)];
    });
  };

  drd.genData = genData;

}).call(this);
