//// everything in this file is new for this step (but adapted from other games covered)
var paddleLeftPic=document.createElement("img");
var paddleRightPic=document.createElement("img");
var ballPic=document.createElement("img");
var backgroundPic=document.createElement("img");

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

function loadImages() {
  var imageList = [
    {varName:paddleLeftPic, theFile:"paddleLeft.png"},
    {varName:paddleRightPic, theFile:"paddleRight.png"},
    {varName:ballPic, theFile:"ball.png"},
    {varName:backgroundPic, theFile:"bg.png"}
    ];

  picsToLoad = imageList.length;

  for(var i=0;i<imageList.length;i++) {
    beginLoadingImage(imageList[i].varName, imageList[i].theFile);
  } // end of for imageList

} // end of function loadImages
