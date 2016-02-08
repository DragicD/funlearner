//// basically all files here are new or rearranged, so no //// per-line markings added
function calculateMousePos(evt) {
  var rect = canvas.getBoundingClientRect(), root = document.documentElement;

  // account for the margins, canvas position on page, scroll amount, etc.
  var mouseX = evt.clientX - rect.left - root.scrollLeft;
  var mouseY = evt.clientY - rect.top - root.scrollTop;
  return {
    x: mouseX,
    y: mouseY
  };
}

function handleMousedown(evt) {
  if(showingWinScreen) {
     paddle1Score = 0;
     paddle2Score = 0;
     showingWinScreen = false;
  }
}

function handleMousemove(evt) {
  var mousePos = calculateMousePos(evt);
  paddle1Y = mousePos.y - (PADDLE_HEIGHT/2); // minus half paddle height to center
}

function setupMouseEventHandlers() {
  canvas.addEventListener('mousedown', handleMousedown);
  canvas.addEventListener('mousemove', handleMousemove);
}