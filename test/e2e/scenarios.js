'use strict';

describe('TOSwim App', function() {

  describe('Pool list view', function() {

    beforeEach(function() {
      browser.get('app/index.html');
    });

    it('should filter the pool list as a user types into the search box', function() {

    var poolList = element.all(by.repeater('pool in pools'));
    var query = element(by.model('query'));

    expect(poolList.count()).toBe(3);

    query.sendKeys('nexus');
    expect(poolList.count()).toBe(1);

    query.clear();

    query.sendKeys('motorola');
    expect(poolList.count()).toBe(2);
    });
  });
});
