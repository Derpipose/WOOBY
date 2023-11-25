require 'minitest/autorun'

class TestExample < Minitest::Test
  def test_truth
    assert(true)
  end

  def test_addition
    result = 1 + 1
    assert_equal(2, result)
  end
end
