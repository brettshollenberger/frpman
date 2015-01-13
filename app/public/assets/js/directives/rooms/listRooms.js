angular
  .module('hangman')
  .directive('listRooms', function() {
    return {
      link: function(scope, element, attr) {
        Rx
          .Observable
          .just("once")
          .map(function() {
            return toSocketRequest("GET", "/rooms", {});
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  });
