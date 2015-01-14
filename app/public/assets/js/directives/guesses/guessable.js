angular
  .module('hangman')
  .directive('guessable', [function() {
    return {
      link: function(scope, element, attr) {
        var clicks = Rx.Observable.fromEvent(element, "click");

        clicks
          .map(function() {
            return element.text().trim();
          })
          .map(function(letter) {
            return toSocketRequest("POST", "/guesses/:room_name", {
              guess: letter,
              guesser: angular.socket.player,
              roomName: attr.roomName
            });
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });
      }
    }
  }]);
