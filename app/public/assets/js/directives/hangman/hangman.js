angular
  .module('hangman')
  .directive('hangman', [function() {
    return {
      templateUrl: "views/directives/hangman/hangman.html",
      link: function(scope, element, attr) {
        scope.hangman_src = "assets/img/none.png";

        angular
          .socket
          .responses
          .filter(function(response) {
            return response.headers.method == "get" &&
                   response.headers.url == "/hangman/:room_name";
          })
          .map(function(response) {
            return response.body.hangman;
          })
          .subscribe(function(hangman) {
            if (hangman.length > 0) {
              scope.hangman_src = "assets/img/" + hangman.join("-") + ".png";
              scope.$apply();
            }
          });
      }
    }
  }]);
