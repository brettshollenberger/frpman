angular
  .module('hangman')
  .directive('notifications', [function() {
    return {
      link: function(scope, element, attr) {
        angular.socket.responses.filter(function(response) {
          return response.headers.method == "get" &&
                 response.headers.url == "/notifications/:room_name" &&
                 response.body.room.name == attr.roomName &&
                 response.body.player == angular.socket.player;
        })
        .map(function(response) {
          return response.body.notification;
        })
        .subscribe(function(notification) {
          $.growl({
            title: "<strong>" + notification.title + ":</strong> ",
            message: notification.message
          },{
            type: notification.type,
            animate: {
              enter: 'animated fadeInDown',
              exit: 'animated fadeOutUp'
            }
          });
        });
      }
    }
  }]);
