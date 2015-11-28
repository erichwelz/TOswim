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
  default_date_filter[dateMaker().toString()] = true;
  $scope.filter = default_date_filter; //sets default scope to 'today'

  $scope.getDates = function() {
    return dateMaker(7) ;
  };

  $scope.filterByTime = function ( pool) {
    // return all pools matching checked date, default to all dates
    // return Object.keys(pool.times).indexOf("Fri Nov 27") > -1;

    var dates = _.forEach($scope.filter, function(value, key) {
      // when dates are unchecked, the date remained with a propery of false
      if (value === false) {
        delete $scope.filter[key];
      }
    });
    var dates_str = Object.keys(dates).toString();

    // only allows selection of a single date at one time
    return Object.keys(pool.times).indexOf(dates_str) > -1 || noFilter($scope.filter);
    // return $scope.filter[pool.times] || noFilter($scope.filter);
  };

  $scope.orderProp = 'address'; //sets default for orderProp scope

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

  function noFilter(filterObj) {
    for (var key in filterObj) {
        if (filterObj[key]) {
            return false;
        }
    }
    return true;
  }
}]);
