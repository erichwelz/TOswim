'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', []);

TOswimApp.controller('PoolListCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('../scraper/bin/pools_data.json').success(function(data) {
    $scope.pools = data;
    });

  $scope.filter = {};

  $scope.getTimes = function () {
    return ($scope.pools || []).map(function (pool) {
      return pool.times;
    }).filter(function ( pool, idx, arr) {
      return arr.indexOf(pool) == idx;
    });
  };

  $scope.filterByTime = function ( pool) {
    return $scope.filter[pool.times] || noFilter($scope.filter);
  };


  function noFilter(filterObj) {
    for (var key in filterObj) {
        if (filterObj[key]) {
            return false;
        }
    }
    return true;
  }

  $scope.orderProp = 'address'; //sets default for orderProp scope
}]);
