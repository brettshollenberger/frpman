angular
  .module('hangman')
  .directive('room', ['$location', function($location) {
    return {
      link: function(scope, element, attr) {

        // When a player wants to join a room, navigate to sessions#new
        element
          .toObservable("click")
          .map(function() {
            return element.text();
          })
          .subscribe(function(room) {
            $location.path("/sessions/" + room);
            scope.$apply();
          });
      }
    }
  }]);
