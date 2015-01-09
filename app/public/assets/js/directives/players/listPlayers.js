angular
  .module('hangman')
  .directive('listPlayers', function() {
    return {
      link: function(scope, element, attr) {

        Rx
          .Observable
          .just("once")
          .map(function() {
            return toSocketRequest("GET", "/rooms/:name", { name: attr.room });
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  });
