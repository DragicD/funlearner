const ENEMY_START_UNITS = 15;
var enemyUnits = [];
const PLAYER_START_UNITS = 20;
var playerUnits = [];

var allUnits = [];

var anyNewUnitsToClear = false;

function soonCheckUnitsToClear() {
  anyNewUnitsToClear = true;
}

function checkAndHandleVictory() { ////
  if(playerUnits.length == 0 && enemyUnits.length == 0) { ////
    document.getElementById("debugText").innerHTML = "IT'S... A... DRAW?"; ////
  } else if(playerUnits.length == 0) { ////
    document.getElementById("debugText").innerHTML = "ENEMY TEAM WON"; ////
  } else if(enemyUnits.length == 0) { ////
    document.getElementById("debugText").innerHTML = "PLAYER TEAM WON"; ////
  } ////
} ////

function addNewUnitToTeam(spawnedUnit,fightsForTeam) {
  fightsForTeam.push(spawnedUnit);
  allUnits.push(spawnedUnit);
}

function removeDeadUnitsFromList(fromArray) {
  for(var i=fromArray.length-1; i>=0; i--) {
    if(fromArray[i].isDead) {
      fromArray.splice(i,1);
    }
  }
}

function removeDeadUnits() {
  if(anyNewUnitsToClear) {
    removeDeadUnitsFromList(allUnits);
    removeDeadUnitsFromList(playerUnits);
    removeDeadUnitsFromList(enemyUnits);
    removeDeadUnitsFromList(selectedUnits);

    anyNewUnitsToClear = false;
  }
}

function populateTeam(whichTeam,howMany,isPlayerControlled) {
  for(var i=0;i<howMany;i++) {
    var spawnUnit = new unitClass();
    spawnUnit.resetAndSetPlayerTeam(isPlayerControlled);
    addNewUnitToTeam(spawnUnit, whichTeam);
  }
}

function findClosestUnitInRange(fromX,fromY,maxRange,inUnitList) {
  var nearestUnitDist = maxRange;
  var nearestUnitFound = null;
  for(var i=0;i<inUnitList.length;i++) {
    var distTo = inUnitList[i].distFrom(fromX,fromY);
    if(distTo < nearestUnitDist) {
      nearestUnitDist = distTo;
      nearestUnitFound = inUnitList[i];
    }
  }
  return nearestUnitFound;
}