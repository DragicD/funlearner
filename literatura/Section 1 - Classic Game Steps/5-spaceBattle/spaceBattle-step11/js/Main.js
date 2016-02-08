// save the canvas for dimensions, and its 2d context for drawing to it
var canvas, canvasContext;

var p1 = new shipClass();
var enemy = new UFOClass(); ////

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
  
  p1.init(playerPic);
  enemy.init(UFOPic); ////
  initInput();  
}

function moveEverything() {
  p1.move();
  enemy.move();
}

function drawEverything() {
  colorRect(0, 0, canvas.width, canvas.height, 'black');
  
  p1.draw();
  enemy.draw();
}