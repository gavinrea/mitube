var _run, makeVideoPlayer
// $ is an identifier shortcut for JQuery function
// will select or create elements
$(function() {
  // initially not loaded
  window.ytPlayerLoaded = false;
  // set the videoplayer equal to funciton's output (pass in video)
  makeVideoPlayer = function(video) {
    var player_wrapper;
    // if not loaded
    if (!window.ytPlayerLoaded) {
      // # will select given element w/ id attribute
      player_wrapper = $('#player-wrapper');
      // will add Loading player... text while not loading
      player_wrapper.append('<div id="ytPlayer"><p>Loading player...</p></div>');
      // create a new youtube player
      window.ytplayer = new YT.Player('ytPlayer', {
        width: '100%',
        height: player_wrapper.width() / 1.777777777,
        videoId: video,
        playerVars: {
          wmode: 'opaque',
          autoplay: 0,
          // not sure what this is
          modestbranding: 1 
        },
        events: {
          // will tell us if the player is loaded
          'onReady': function() {
            return window.ytPlayerLoaded = true;
          },
          // will give us an alert if there is an error
          'onError': function(errorCode) {
            return alert("We are sorry, but the following error occured: " + errorCode);
          }
        }
      });
    } else {
      // now load the actual video
      window.ytplayer.loadVideoById(video);
      // and pause it, b/c no one likes vids playing automatically
      window.ytplayer.pauseVideo();
    }
  };
});

// method for google object 
_run = function() {
  // looks for the first element with preview class and clicks
  $('.preview').first().click();
};
// call above method, not sure why?
google.setOnLoadCallback(_run);

// add click event listener to start player (seems to return uid)
$('.preview').click(function() {
  return makeVideoPlayer($(this).data('uid'));
});

// resize the window as needed
 $(window).bindWithDelay('resize', function() {
  var player;
  // select element with id ytPlayer
  player = $('#ytPlayer');
  // if the size is greater than zero, scale proportionally
  if (player.size() > 0) {
    player.height(player.width() / 1.777777777);
  }
});

