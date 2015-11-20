'use strict';

describe('TOSwim App', function() {

  describe('Pool list view', function() {

    beforeEach(function() {
      browser.get('app/index.html');
    });

    var poolList = element.all(by.repeater('pool in pools'));
    var query = element(by.model('query'));

    it('should filter the pool list as a user types into the search box', function() {

    expect(poolList.count()).toBe(122);

    query.sendKeys('regent');
    expect(poolList.count()).toBe(1);

    query.clear();

    query.sendKeys('east');
    expect(poolList.count()).toBe(2);
    });

    it('should display the current filter value in the title bar', function() {
      query.clear();
      expect(browser.getTitle()).toMatch(/TO Swim:\s*$/);

      query.sendKeys('regent');
      expect(browser.getTitle()).toMatch(/TO Swim: regent$/);
    });

    it('should be possible to control pool order via the drop down select box', function() {

      var poolNameColumn = element.all(by.repeater('pool in pools').column('pool.name'));
      var query = element(by.model('query'));

      function getNames() {
        return poolNameColumn.map(function(elm) {
          return elm.getText();
        });
      }

      query.sendKeys('fair'); //narrowing dataset to make test assertions shorter

      expect(getNames()).toEqual([
        "Fairhaven Park Outdoor Pool",
        "Fairmount Park Community Centre",
        "Fairbank Memorial Park"
      ]);

      element(by.model('orderProp')).element(by.css('option[value="name"]')).click();

      expect(getNames()).toEqual([
        "Fairbank Memorial Park",
        "Fairhaven Park Outdoor Pool",
        "Fairmount Park Community Centre"
      ]);
    });
  });
});
