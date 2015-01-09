angular
  .module('hangman')
  .controller('RoomsIndexCtrl', ['$scope', '$location', function($scope, $location) {

    // When room is created, re-route to sessions#new
    angular
      .socket
      .responses
      .filter(function(response) {
        return response.headers.method == "post" && response.headers.url == "/rooms";
      })
      .map(function(response) {
        return response.body.room;
      })
      .subscribe(function(room) {
        $location.path("/sessions/" + room.name);
        $scope.$apply();
      });
  }]);
