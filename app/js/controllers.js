'use strict';

// Controllers

var TOswimApp = angular.module('TOswimApp', [])
  // allow DI for use in controllers, unit tests
  .constant('_', window._)
  // use in views, ng-repeat="x in _.range(3)"
  .run(function ($rootScope) {
     $rootScope._ = window._;
  });

TOswimApp.controller('PoolListCtrl', ['$scope', '$http', function ($scope, $http) {
  $http.get('../scraper/bin/pools_data.json').success(function(data) {
    $scope.pools = data;
    });

  var default_date_filter = {};
  default_date_filter[undefined] = dateMaker().toString();
  $scope.filter = default_date_filter; //sets default scope to 'today'

  $scope.getDates = function() {
    return dateMaker(7) ;
  };

  $scope.filterByTime = function ( pool) {
    // return all pools matching checked date, default to all dates

    var selected_date = $scope.filter[undefined];

    return Object.keys(pool.times).indexOf(selected_date) > -1 || noFilter($scope.filter);
  };

  $scope.orderProp = 'name'; //sets default for orderProp scope

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

  $scope.getDistance = function distance(lat1, lon1, lat2, lon2) {
  if (isNaN(lat2) === true) {
    lat2 = 43.6792740; //my latitude
  }

  if (isNaN(lon2) === true) {
    lon2 = -79.3592080; //my longitude
  }

  var p = 0.017453292519943295;    // Math.PI / 180
  var c = Math.cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;

  return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
}

  function noFilter(filterObj) {
    for (var key in filterObj) {
        if (filterObj[key]) {
            return false;
        }
    }
    return true;
  }
}]);
