//// this file is new as of this step, so all lines are new or brought in from the html file
var audioFormat;

function setFormat() {
  var audio = new Audio();
  if (audio.canPlayType("audio/mp3")) {
      audioFormat = ".mp3";
  } else {
      audioFormat = ".ogg";
  }
}

function SoundOverlapsClass() {
  this.load = function(filenameWithPath) {
    setFormat(); // calling this to ensure that audioFormat is set before needed
    
    this.altSoundTurn = false;
    this.mainSound = new Audio(filenameWithPath+audioFormat);
    this.altSound = new Audio(filenameWithPath+audioFormat);
  }

  this.play = function() {
    if(this.altSoundTurn) {
      this.altSound.currentTime = 0;
      this.altSound.play();
    } else {
      this.mainSound.currentTime = 0;
      this.mainSound.play();
    }
    
    this.altSoundTurn = !this.altSoundTurn; // toggle between true and false
  }

}