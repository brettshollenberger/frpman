angular
  .module('hangman')
  .directive('roomsList', function() {
    return {
      link: function(scope, element, attr) {
        angular.socket.responses.filter(function(response) {
          return response.headers.method == "get" && response.headers.url == "/rooms";
        }).map(function(response) {
          return response.body.rooms;
        }).subscribe(function(rooms) {
          element.html("");

          rooms.forEach(function(room) {
            element.append("<li room>" + room + "</li>");
          });
        });
      }
    }
  });
