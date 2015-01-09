angular
  .module('hangman')
  .controller('SessionsNewCtrl', ['$scope', '$route', '$location', function($scope, $route, $location) {

    $scope.roomName = $route.current.params.roomName;

    // When session is created, re-route to rooms#show
    angular
      .socket
      .responses
      .filter(function(response) {
        return response.headers.method == "post" && response.headers.url == "/sessions";
      })
      .map(function(response) {
        return response.body.session;
      })
      .subscribe(function(session) {
        $location.path("/rooms/" + session.room);
        $scope.$apply();
      });
  }]);
