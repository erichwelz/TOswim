'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', []);

TOswimApp.controller('PoolListCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('swim_data/pools_data.json').success(function(data) {
    $scope.pools = data;
    });

  $scope.filter = { date: dateMaker().toString(),
                    currentLoc: { latitude: 43.7, longitude: -79 }
                  };

  $scope.getDates = function() {
    return dateMaker(7) ;
  };

  $scope.poolType = function (pool) {
    if ( $scope.filter.free_swim === true ) {
      return pool.free_swim === true;
    } else {
    return pool;
    }
  };

  $scope.filterByDate = function (pool) {
    // return all pools matching checked date, default to all dates

    var selected_date = $scope.filter.date;

    return Object.keys(pool.times).indexOf(selected_date) > -1 || noFilter($scope.filter);
  };

  function noFilter(filterObj) {
    for (var key in filterObj) {
        if (filterObj[key]) {
            return false;
        }
    }
    return true;
  }

  function dateMaker(days) {
    // returns array of dates in format of "Fri Nov 27" starting with today
    if (isNaN(days) === true) {
      days = 1;
    }

    var dates = [];
    var regex = /^\w{3}\s\w{3}\s\d{1,2}/;

    for (var day = 0; day < days; day++ ) {
      var date = new Date();
      date.setDate(date.getDate() + day);
      dates.push(date.toString().match( regex ).toString());
    }
    return dates;
  }

  $scope.distanceSort = function (pool) {
    return $scope.getDistance(pool.coordinates);
  };

  $scope.getDistance = function (poolLoc) {
    var currentLoc = $scope.filter.currentLoc;

    var p = 0.017453292519943295;    // Math.PI / 180
    var c = Math.cos;
    var a = 0.5 - c((currentLoc.latitude - poolLoc.latitude) * p)/2 +
            c(poolLoc.latitude * p) * c(currentLoc.latitude * p) *
            (1 - c((currentLoc.longitude - poolLoc.longitude) * p))/2;

    return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
  };

  navigator.geolocation.getCurrentPosition(function (pos) {
    $scope.$apply(function() {
      $scope.filter.currentLoc.latitude = pos.coords.latitude;
      $scope.filter.currentLoc.longitude = pos.coords.longitude;
    });
  });

}]);
