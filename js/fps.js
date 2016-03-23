(function () {
  function computeFPS() {

    var lastCalledTime;
    var counter = 0;
    var fpsArray = [];
    var first = true;

    var update = function() {
      var fps;

      if (!lastCalledTime) {
        lastCalledTime = performance.now();
        fps = 0;
      }

      if (first) {
        first = false;
      }
      else {
        var delta = performance.now() - lastCalledTime;
        lastCalledTime = performance.now();
        fps = Math.ceil((1/delta));

        if (counter >= 60) {
          var sum = fpsArray.reduce(function(a,b) { return a + b });
          var average = Math.ceil(sum / fpsArray.length);
          console.log(average);
          counter = 0;
        } else {
          if (fps !== Infinity) fpsArray.push(fps);
          counter++;
        }
      }

      window.requestAnimationFrame(update);
    }

    window.requestAnimationFrame(update);
  }

  drd.fps = computeFPS;
}).call(this);
