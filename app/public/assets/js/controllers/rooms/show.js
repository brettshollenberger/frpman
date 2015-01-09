angular
  .module('hangman')
  .controller('RoomsShowCtrl', ['$scope', '$route', function($scope, $route) {

    $scope.name = $route.current.params.name;

  }]);
