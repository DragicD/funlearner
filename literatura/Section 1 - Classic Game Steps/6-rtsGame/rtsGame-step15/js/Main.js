// save the canvas for dimensions, and its 2d context for drawing to it
var canvas, canvasContext;

const ENEMY_START_UNITS = 15;
var enemyUnits = [];
const PLAYER_START_UNITS = 20;
var playerUnits = [];

window.onload = function() {
  canvas = document.getElementById('gameCanvas');
  canvasContext = canvas.getContext('2d');
  
  // these next few lines set up our game logic and render to happen 30 times per second
  var framesPerSecond = 30;
  setInterval(function() {
      moveEverything();
      drawEverything();
    }, 1000/framesPerSecond);
    
  canvas.addEventListener('mousemove', mousemoveHandler);
  
  canvas.addEventListener('mousedown', mousedownHandler);
  
  canvas.addEventListener('mouseup', mouseupHandler);

  for(var i=0;i<PLAYER_START_UNITS;i++) {
    var spawnUnit = new unitClass();
    spawnUnit.resetAndSetPlayerTeam(true);
    playerUnits.push(spawnUnit);
  }

  for(var i=0;i<ENEMY_START_UNITS;i++) {
    var spawnUnit = new unitClass();
    spawnUnit.resetAndSetPlayerTeam(false);
    enemyUnits.push(spawnUnit);
  }
}

function moveEverything() {
  for(var i=0;i<playerUnits.length;i++) {
    playerUnits[i].move();
  }
  for(var i=0;i<enemyUnits.length;i++) {
    enemyUnits[i].move();
  }
}

function drawEverything() {
  // clear the game view by filling it with black
  colorRect(0, 0, canvas.width, canvas.height, 'black');
  
  for(var i=0;i<playerUnits.length;i++) {
    playerUnits[i].draw();
  }

  for(var i=0;i<enemyUnits.length;i++) {
    enemyUnits[i].draw();
  }
  
  for(var i=0;i<selectedUnits.length;i++) {
    selectedUnits[i].drawSelectionBox();
  }
  
  if(isMouseDragging) {
    coloredOutlineRectCornerToCorner(lassoX1,lassoY1, lassoX2,lassoY2, 'yellow');
  }
}