'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', []);

TOswimApp.controller('PoolListCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('../scraper/phones.json').success(function(data) {
    $scope.pools = data;
    });

  $scope.orderProp = 'age'; //sets default for orderProp scope
}]);
