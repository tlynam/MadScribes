// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(function() {
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });
})

if (location.pathname.match('stories/')) {
  //Round countdown and page reload for players waiting for game to start
  var seconds, element;
  function countdown() {
    element = $('#countdown');
    if (element.length)
      seconds = parseInt(element.text(), 10)

    if (seconds == 0) {
      window.location.reload();
      return;
    } else if (seconds < 0 && seconds % 4 == 0) {
      //Countdown from -1 for subscribers waiting to start game
      $.get(location.pathname + '/is_active', function(data) {
        if(data == true)
          window.location.reload();
      });
    }

    seconds--;
    element.text(seconds);
    setTimeout(countdown, 1000);
  }
  setTimeout(countdown, 1000);

  //Websocket chat
  // var ws = new WebSocket('ws://' + location.host + location.pathname + '/chat')
  // ws.onmessage = function(event) {
  //   var messages = JSON.parse(sessionStorage.getItem(location.pathname) || "[]")
  //   messages.push(event.data)
  //   sessionStorage.setItem(location.pathname, JSON.stringify(messages))

  //   var chatWindow = $('.chat-window ul')
  //   chatWindow.append($('<li>').text(event.data))
  //   chatWindow.scrollTop(chatWindow[0].scrollHeight)
  // }

  // $(function() {
  //   var messages = JSON.parse(sessionStorage.getItem(location.pathname) || "[]")
  //   messages.forEach(function(message) {
  //     var chatWindow = $('.chat-window ul')
  //     chatWindow.append($('<li>').text(message))
  //     chatWindow.scrollTop(chatWindow[0].scrollHeight)
  //   })

  //   //Submit chat via click
  //   $('.chat-window button').click(function() {
  //     var input = $(this).siblings('input')
  //       if(input.val()) {
  //         ws.send(input.val())
  //         input.val(null)
  //       }
  //   })

  //   //Submit chat via press enter
  //   $('.chat-window input').keypress(function (e) {
  //    var key = e.which;
  //    if(key == 13)  // the enter key code
  //     {
  //       $('.chat-window button').click();
  //     }
  //   })
  // })
}
