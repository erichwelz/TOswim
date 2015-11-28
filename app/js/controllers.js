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
  default_date_filter[dateMaker()] = true;
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
    // returns string of today's date or array of number of days in format "Fri Nov 27"
    var date = new Date();
    var regex = /^\w{3}\s\w{3}\s\d{1,2}/;

    if (days === 1 || days === undefined ) {
      return date.toString().match( regex ).toString();
    } else {
      var dates = [];
      // set day 1
      dates.push(date.toString().match( regex ).toString());
      for (var day = 2; day <= days; day++ ) {
        date.setDate(date.getDate() + 1);
        dates.push(date.toString().match( regex ).toString());
      }
      return dates;
    }
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
