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
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(function() {
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });
})

if (location.pathname.match('stories/')) {
  var ws = new WebSocket('ws://' + location.host + location.pathname + '/chat')
  ws.onmessage = function(event) { 
    var messages = JSON.parse(sessionStorage.getItem(location.pathname) || "[]")
    messages.push(event.data)
    sessionStorage.setItem(location.pathname, JSON.stringify(messages))

    $('.chat-window ul').append($('<li>').text(event.data))
  }

  $(function() {
    var messages = JSON.parse(sessionStorage.getItem(location.pathname) || "[]")
    messages.forEach(function(message) {
      $('.chat-window ul').append($('<li>').text(message))
    })


    $('.chat-window button').click(function() {
      var input = $(this).siblings('input')
      ws.send(input.val())
      input.val(null)
    })
  })
}
