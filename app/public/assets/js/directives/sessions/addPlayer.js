angular
  .module('hangman')
  .directive('addPlayer', function() {
    return {
      templateUrl: "views/directives/sessions/add-player.html",
      link: function(scope, element, attr) {
        var playerName   = element.find("#player-name"),
            submitButton = element.find("#create-session"),
            submitClicks = submitButton.toObservable("click");

        submitClicks
          .map(function() {
            return playerName.val();
          })
          .map(function(name) {
            return toSocketRequest("POST", "/sessions", { room: scope.roomName, name: name });
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  });
