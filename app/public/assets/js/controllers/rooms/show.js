angular
  .module('hangman')
  .controller('RoomsShowCtrl', ['$scope', '$route', function($scope, $route) {

    $scope.name    = $route.current.params.name;
    $scope.started = false;

    angular
      .socket
      .responses
      .filter(function(response) {
        return response.headers.method == "put" && response.headers.url == "/rooms/:name";
      })
      .take(1)
      .map(function(response) {
        return response.body.game;
      })
      .subscribe(function(game) {
        if (game.started) {
          $scope.started = true;
          $scope.$apply();
        }
      });

  }]);
