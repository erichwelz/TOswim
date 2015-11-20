'use strict';

describe('TOSwim controllers', function() {

  describe ('PoolListCtrl', function() {
    var scope, ctrl, $httpBackend;

    // Load our app module before each test
    beforeEach(module('TOswimApp'));

    // The injector ignores leading and trailing underscores here (i.e. _$httpBackend_)
    // This allows us to inject a srice but then attach it to a variable
    // with the same names as the service in order to avoid a name conflict.
    beforeEach(inject(function(_$httpBackend_, $rootScope, $controller) {
      $httpBackend = _$httpBackend_;
      $httpBackend.expectGET('../scraper/phones.json').
        respond([{name: 'Nexus S'}, {name: 'Motorola DROID'}]);

      scope = $rootScope.$new();
      ctrl = $controller('PoolListCtrl', {$scope:scope});
    }));



    it('should create "pools" model with 2 pools fetched from xhr', function() {
      expect(scope.pools).toBeUndefined();
      $httpBackend.flush();

      expect(scope.pools).toEqual([{name: 'Nexus S'},
                                   {name: 'Motorola DROID'}]);
    });


    it('should set the default value of orderProp model', function() {
      expect(scope.orderProp).toBe('age');
    });
  });
});
