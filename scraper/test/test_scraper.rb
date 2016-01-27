require 'minitest/autorun'
require 'scraper'

class ScraperTest < Minitest::Test

  def test_simple_doubler
    assert_equal 10, Scraper.simple_equal(5)
  end
end
