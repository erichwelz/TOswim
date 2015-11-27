'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', []);

TOswimApp.controller('PoolListCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('../scraper/bin/pools_data.json').success(function(data) {
    $scope.pools = data;
    });

  $scope.filter = {};

  $scope.getTimes = function() {
    return ["Fri Nov 27","Tue Jan 05"] ;
  };
  // // likely unecessary, ultimately it would allow for understanding the available dates
  // $scope.getTimes = function () {
  //   return ($scope.pools || []).map(function (pool) {
  //     return Object.keys(pool.times);
  //   }).filter(function ( pool, idx, arr) {
  //     return arr.indexOf(pool) == idx;
  //   });
  // };

  $scope.filterByTime = function ( pool) {
    // return all pools matching checked date, default to all dates
    debugger;
    // return Object.keys(pool.times).indexOf("Fri Nov 27") > -1;
    return Object.keys(pool.times).indexOf(Object.keys($scope.filter).toString()) > -1 || noFilter($scope.filter);
    // return $scope.filter[pool.times] || noFilter($scope.filter);
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
