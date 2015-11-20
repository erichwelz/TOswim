'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', []);

TOswimApp.controller('PoolListCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('../scraper/pools_data.json').success(function(data) {
    $scope.pools = data;
    });

  $scope.orderProp = 'address'; //sets default for orderProp scope
}]);
