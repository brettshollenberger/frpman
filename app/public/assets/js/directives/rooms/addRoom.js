angular
  .module('hangman')
  .directive('addRoom', function() {
    return {
      link: function(scope, element, attr) {
        var roomName        = element.find("#room-name"),
            submitButton    = element.find("#create-room"),
            submitClicks    = Rx.Observable.fromEvent(submitButton, "click");
            enterKeypresses = Rx.Observable.fromEvent($(window), "keydown").filter(function(e) {
              var code = e.keyCode || e.which;
              return code == 13;
            });

        Rx
          .Observable
          .merge(
            submitClicks,
            enterKeypresses
          )
          .take(1)
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
