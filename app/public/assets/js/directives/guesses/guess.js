angular
  .module('hangman')
  .directive('guess', [function() {
    return {
      templateUrl: "views/directives/guesses/guess.html",
      link: function(scope, element, attr) {
        var submitButton = element.find("#submit-guess"),
            guessInput   = element.find("#guess"),
            submitClicks = Rx.Observable.fromEvent(submitButton, "click");

        submitClicks
          .map(function() {
            var guess = guessInput.val();
            return toSocketRequest("POST", "/guesses/:room_name", {guess: guess, roomName: attr.roomName});
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  }]);
