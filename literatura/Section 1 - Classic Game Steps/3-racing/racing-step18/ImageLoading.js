var trackPicRoad=document.createElement("img"); ////
var trackPicWall=document.createElement("img"); ////
var carPic=document.createElement("img"); //// from Car.js

//// removed carPicLoaded
var picsToLoad = 3; //// more general than separate true/false values

function countLoadedImageAndLaunchIfReady() { ////
  picsToLoad--; ////
  if(picsToLoad == 0) { // last image loaded? ////
    loadingDoneSoStartGame(); ////
  } ////
} ////

function loadImages() { ////
   //// moved from Main.js window.onload
  carPic.onload=countLoadedImageAndLaunchIfReady; ////
  carPic.src="player1.png"; ////
  
  trackPicRoad.onload=countLoadedImageAndLaunchIfReady; ////
  trackPicRoad.src="track_road.png"; ////
  
  trackPicWall.onload=countLoadedImageAndLaunchIfReady; ////
  trackPicWall.src="track_wall.png"; ////
} ////