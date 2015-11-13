'use strict';

describe ('PoolListCtrl', function() {

  beforeEach(module('TOswimApp'));

  it('should create "pools" model with 3 pools', inject(function($controller) {
    var scope = {},
      ctrl = $controller('PoolListCtrl', {$scope:scope});

      expect(scope.pools.length).toBe(3);
    });

});
