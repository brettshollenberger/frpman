angular
  .module('hangman')
  .directive('addPlayer', function() {
    return {
      templateUrl: "views/directives/sessions/add-player.html",
      link: function(scope, element, attr) {
        var playerName   = element.find("#player-name"),
            submitButton = element.find("#create-session"),
            submitClicks = submitButton.toObservable("click"),
            enterKeypresses = $(window).toObservable("keydown").filter(function(e) {
              var code = e.keyCode || e.which;
              return code == 13;
            }),
            submissions  = Rx.Observable.merge(submitClicks, enterKeypresses).map(function() {
              return playerName.val();
            });

          playerName.focus();

          submissions
            .take(1)
            .subscribe(function(name) {
              angular.socket.player = name;
            });

          submissions
            .take(1)
            .map(function(name) {
              return toSocketRequest("POST", "/sessions", { room: scope.roomName, name: name });
            })
            .subscribe(function(request) {
              angular.socket.send(request);
            });
      }
    }
  });
