$(document).ready(function() {
$('#window-bottom').bind('inview', function(event, isInView, visiblePartX, visiblePartY) {
  if (isInView) {
    alert("hello")
    // if (visiblePartY == 'top') {
    //   // top part of element is visible
    // } else if (visiblePartY == 'bottom') {
    //   // bottom part of element is visible
    // } else {
    //   // whole part of element is visible
    // }
  // } else {
    // // element has gone out of viewport
  // }
}
});
});
