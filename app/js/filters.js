'use strict';

TOswimApp.filter('limitdaysTo', [function(){
  return function(obj, scope){

    // passing scope in to get currently selected date
    var selectedDate = scope.filter.date,
    keys = Object.keys(obj),
    dayOffset = keys.indexOf(selectedDate),
    limit = 5;

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
