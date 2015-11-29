'use strict';

TOswimApp.filter('limitdaysTo', [function(){
    return function(obj, limit){
        // day offset for number of days since Sunday (set programatically based on JSON data date compared to today?)
        var dayOffset = 6;
        var keys = Object.keys(obj);
        if(keys.length < 1){
            return [];
        }

        var ret = new Object,
        count = 0;
        angular.forEach(keys, function(key, arrayIndex){
           if( count >= limit + dayOffset ){
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
