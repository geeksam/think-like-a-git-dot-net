function nav_hotkey(e) {
  var action_for_key = function(e) {
    switch (e.keyCode) {
      case 74:  // 'j'
        if ((window.innerHeight + window.scrollY) < document.body.scrollHeight) {
          return 'down';
        }
        return '';
      case 75:  // 'k'
        if (window.scrollY > document.body.scrollTop) {
          return 'up';
        }
        return '';
      case 76:  // 'l'
      case 78:  // 'n'
        return 'next';
      case 72:  // 'h'
      case 80:  // 'p'
        return 'prev';
    }
  }

  const scrollStep = 50;
  var action = action_for_key(e);
  if (action == 'next' || action == 'prev') {
    var link = $('link[rel="'+action+'"]');
    window.location.href = link[0].href;
  } else if (action == 'up'){
    window.scrollTo(document.body.scrollLeft,
      window.scrollY - scrollStep);
  } else if (action == 'down'){
    window.scrollTo(document.body.scrollLeft,
      window.scrollY + scrollStep);
  }
}
