'use strict';

describe('TOSwim App', function() {

  describe('Pool list view', function() {

    beforeEach(function() {
      browser.get('app/index.html');
    });

    var poolList = element.all(by.repeater('pool in pools'));
    var query = element(by.model('query'));

    it('should filter the pool list as a user types into the search box', function() {

    expect(poolList.count()).toBe(3);

    query.sendKeys('nexus');
    expect(poolList.count()).toBe(1);

    query.clear();

    query.sendKeys('motorola');
    expect(poolList.count()).toBe(2);
    });

    it('should display the current filter value in the title bar', function() {
      query.clear();
      expect(browser.getTitle()).toMatch(/TO Swim:\s*$/);

      query.sendKeys('nexus');
      expect(browser.getTitle()).toMatch(/TO Swim: nexus$/);
    });
  });
});
