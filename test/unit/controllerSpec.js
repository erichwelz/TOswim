'use strict';

describe('TOSwim controllers', function() {

  describe ('PoolListCtrl', function() {
    var scope, ctrl;

    beforeEach(module('TOswimApp'));

    beforeEach(inject(function($controller) {
      scope = {};
      ctrl = $controller('PoolListCtrl', {$scope:scope});
    }));

    it('should create "pools" model with 3 pools', function() {
        expect(scope.pools.length).toBe(3);
    });

    it('should set the default value of orderProp model', function() {
      expect(scope.orderProp).toBe('age');
    });
  });
});
