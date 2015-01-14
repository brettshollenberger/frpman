angular
  .module('hangman')
  .directive('word', [function() {
    return {
      templateUrl: "views/directives/words/word.html",
      link: function(scope, element, attr) {
        Rx
          .Observable
          .just("once")
          .map(function() {
            return toSocketRequest("GET", "/words/:room_name", {room_name: attr.roomName});
          })
          .subscribe(function(request) {
            angular.socket.send(request);
          });

        angular.socket.responses.filter(function(response) {
          return response.headers.method == "get" &&
                 response.headers.url == "/words/:room_name" &&
                 response.body.room_name == attr.roomName;
        }).map(function(response) {
          return response.body.word;
        }).subscribe(function(word) {
          scope.word = word;
          scope.$apply();
        });
      }
    }
  }]);
