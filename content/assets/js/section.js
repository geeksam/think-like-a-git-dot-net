function nav_hotkey(e) {
  var action_for_key = function(e) {
    switch (e.keyCode) {
      case 74:  // 'j'
      case 78:  // 'n'
        return 'next';
      case 75:  // 'k'
      case 80:  // 'p'
        return 'prev';
    }
  }
  var action = action_for_key(e);
  if (action == 'next' || action == 'prev') {
    var link = $('link[rel="'+action+'"]');
    window.location.href = link[0].href;
  }
}
