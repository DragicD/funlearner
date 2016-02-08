// save the canvas for dimensions, and its 2d context for drawing to it
var canvas, canvasContext;

var p1 = new carClass();
//// removed p2 declaration here

window.onload = function() {
  canvas = document.getElementById('gameCanvas');
  canvasContext = canvas.getContext('2d');
  
  loadImages();
}

function loadingDoneSoStartGame() {
  // these next few lines set up our game logic and render to happen 30 times per second
  var framesPerSecond = 30;
  setInterval(function() {
      moveEverything();
      drawEverything();
    }, 1000/framesPerSecond);
  
  //// removed p2 usage here
  p1.carInit(carPic, "Blue Car");
  initInput();  
}

function moveEverything() {
  p1.carMove();
  //// removed p2 usage here
}

function drawEverything() {
  drawTracks();
  
  p1.carDraw();
  //// removed p2 usage here
}