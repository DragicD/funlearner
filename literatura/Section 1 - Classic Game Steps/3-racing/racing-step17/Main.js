// save the canvas for dimensions, and its 2d context for drawing to it
var canvas, canvasContext;

window.onload = function() {
  canvas = document.getElementById('gameCanvas');
  canvasContext = canvas.getContext('2d');
  
  // these next few lines set up our game logic and render to happen 30 times per second
  var framesPerSecond = 30;
  setInterval(function() {
      moveEverything();
      drawEverything();
    }, 1000/framesPerSecond);
  
  carInit(); ////    
  initInput(); ////
}

function moveEverything() {
  carMove();
}

function drawEverything() {
  // clear the game view by filling it with black
  colorRect(0, 0, canvas.width, canvas.height, 'black');

  drawTracks();
  
  carDraw(); // no more white circle!
}