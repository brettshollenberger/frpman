angular
  .module('hangman')
  .directive('addRoom', function() {
    return {
      link: function(scope, element, attr) {
        var roomName     = element.find("#room-name"),
            submitButton = element.find("#create-room"),
            submitClicks = submitButton.toObservable("click");

        submitClicks
          .map(function() {
            return roomName.val();
          })
          .map(function(name) {
            return toSocketRequest("POST", "/rooms", { name: name });
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  });
