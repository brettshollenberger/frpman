angular
  .module('hangman')
  .directive('listRooms', function() {
    return {
      link: function(scope, element, attr) {
        element
          .toObservable("click")
          .startWith("starting click")
          .map(function() {
            return toSocketRequest("GET", "/rooms", {});
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  });
