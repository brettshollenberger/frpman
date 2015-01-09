angular
  .module('hangman')
  .directive('playersList', function() {
    return {
      link: function(scope, element, attr) {
        angular.socket.responses.filter(function(response) {
          return response.headers.method == "get" && response.headers.url == "/rooms/:name" && response.body.room.name == attr.room;
        }).map(function(response) {
          return response.body.room.players;
        }).subscribe(function(players) {
          element.html("");

          players.forEach(function(player) {
            element.append("<li player>" + player + "</li>");
          });
        });
      }
    }
  });
