var playerPic=document.createElement("img");
var trackPics = [];

var picsToLoad = 0;

function countLoadedImageAndLaunchIfReady() {
  picsToLoad--;
  if(picsToLoad == 0) { // last image loaded?
    loadingDoneSoStartGame();
  }
}

function beginLoadingImage(imgVar, fileName) {
  imgVar.onload=countLoadedImageAndLaunchIfReady;
  imgVar.src="images/"+fileName;
}

function loadImageForTrackCode(trackCode, fileName) {
  trackPics[trackCode] = document.createElement("img");
  beginLoadingImage(trackPics[trackCode],fileName);
}

function loadImages() {

  var imageList = [
    {varName:playerPic, theFile:"warrior.png"}, ////
    
    {tileType:TRACK_ROAD, theFile:"world_ground.png"}, ////
    {tileType:TRACK_WALL, theFile:"world_wall.png"}, ////
    {tileType:TRACK_GOAL, theFile:"world_goal.png"}, ////
    {tileType:TRACK_TREE, theFile:"world_key.png"}, ////
    {tileType:TRACK_FLAG, theFile:"world_door.png"} ////
    ];
  
  picsToLoad = imageList.length;
  
  for(var i=0;i<imageList.length;i++) {
    if(imageList[i].tileType != undefined) {
      loadImageForTrackCode(imageList[i].tileType, imageList[i].theFile);
    } else {
      beginLoadingImage(imageList[i].varName, imageList[i].theFile);
    } // end of else
  } // end of for imageList

} // end of function loadImages
