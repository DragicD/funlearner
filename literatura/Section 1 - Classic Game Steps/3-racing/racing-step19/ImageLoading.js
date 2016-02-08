var trackPicRoad=document.createElement("img");
var trackPicWall=document.createElement("img");
var carPic=document.createElement("img");

var picsToLoad = 0; //// one less thing to manually keep in sync

function countLoadedImageAndLaunchIfReady() {
  picsToLoad--;
  if(picsToLoad == 0) { // last image loaded?
    loadingDoneSoStartGame();
  }
}

function beginLoadingImage(imgVar, fileName) { ////
  // picsToLoad++; // led to race condition, don’t want to do it that way, after all! ////
  imgVar.onload=countLoadedImageAndLaunchIfReady; ////
  imgVar.src=fileName; ////
} ////

function loadImages() {
  var imageList = [ ////
    {varName:carPic, theFile:"player1.png"}, ////
    {varName:trackPicRoad, theFile:"track_road.png"}, ////
    {varName:trackPicWall, theFile:"track_wall.png"} ////
    ]; ////
  
  picsToLoad = imageList.length; ////

  for(var i=0;i<imageList.length;i++) { ////
    beginLoadingImage(imageList[i].varName,imageList[i].theFile); ////
  } ////
}