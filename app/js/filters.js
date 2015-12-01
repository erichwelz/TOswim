'use strict';

TOswimApp.filter('limitdaysTo', [function(){
  return function(obj, limit){
    // day offset for number of days since Sunday (set programatically based on JSON data date compared to today?)
    var dayOffset = 6,
    keys = Object.keys(obj);

    if ( keys.length < 1 ) {
      return [];
    }

    var ret = {},
    count = 0;

    angular.forEach(keys, function(key, arrayIndex) {
      if ( count >= limit + dayOffset ) {
        return false;
      }
      if ( count >= dayOffset ) {
        ret[key] = obj[key];
      }
      count++;
    });
    return ret;
  };
}]);

TOswimApp.filter('poolType', function () {
  return function(input, filter) {
    var result;

    if(canFilter(filter)) {
      result = [];
      angular.forEach(input, function(pool) {
        if(filter[pool.free_swim])
          result.push(pool);
      });

    } else
      result = input;

    return result;
  };

  function canFilter(filter) {
    var hasFilter = false;
    angular.forEach(filter, function(isFiltered) {
      hasFilter = hasFilter || isFiltered;
    });
    return hasFilter;
  }
});
