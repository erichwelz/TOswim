'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', []);

TOswimApp.controller('PoolListCtrl', function ($scope) {
  $scope.pools = [
    {'name': 'Nexus S',
     'snippet': 'Fast just got faster with Nexus S.',
     'age': 1},
    {'name': 'Motorola XOOM™ with Wi-Fi',
     'snippet': 'The Next, Next Generation tablet.',
     'age': 2},
    {'name': 'MOTOROLA XOOM™',
     'snippet': 'The Next, Next Generation tablet.',
     'age': 3}
  ];

  $scope.orderProp = 'age'; //sets default for orderProp scope
});
