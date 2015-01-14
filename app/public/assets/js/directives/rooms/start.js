angular
  .module('hangman')
  .directive('start', [function() {
    return {
      templateUrl: "views/directives/rooms/start.html",
      link: function(scope, element, attr) {
        Rx
          .Observable
          .fromEvent(element, "click")
          .take(1)
          .map(function() {
            return toSocketRequest("PUT", "/rooms/:name", {
              name: attr.roomName,
              game: {
                started: true
              }
            })
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  }]);
