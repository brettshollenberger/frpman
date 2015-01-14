angular
  .module('hangman')
  .directive('start', [function() {
    return {
      templateUrl: "views/directives/rooms/start.html",
      link: function(scope, element, attr) {

        Rx
          .Observable
          .fromEvent(element, "click")
          .map(function() {
            return toSocketRequest("PUT", "/rooms/:room_name", {
              room_name: attr.roomName,
              started: true
            })
          })
          .subscribe();
      }
    }
  }]);
