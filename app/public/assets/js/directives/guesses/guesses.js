angular
  .module('hangman')
  .directive('guesses', [function() {
    return {
      templateUrl: "views/directives/guesses/guesses.html",
      link: function(scope, element, attr) {
        angular.socket.responses.filter(function(response) {
          return response.headers.method == "get" && response.headers.url == "/guesses/:room_name" && response.body.room.name == attr.roomName;
        })
        .map(function(response) {
          return response.body.guesses;
        })
        .subscribe(function(guesses) {
          element.html("");

          guesses.forEach(function(guess) {
            element.append("<li>" + guess + "</li>");
          });
        });
      }
    }
  }]);
