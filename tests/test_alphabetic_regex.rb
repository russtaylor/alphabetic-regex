require 'test/unit'
require 'alphabetic_regex/alphabetic_regex.rb'

class TestAlphabeticRegex < Test::Unit::TestCase
  def test_is_uppercase
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_uppercase('A'))
    assert_true(alphareg.is_uppercase('Z'))
    assert_true(alphareg.is_uppercase('_'))
    assert_false(alphareg.is_uppercase('a'))
    assert_false(alphareg.is_uppercase('z'))
  end

  def test_is_lowercase
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_lowercase('a'))
    assert_true(alphareg.is_lowercase('z'))
    assert_true(alphareg.is_lowercase('_'))
    assert_false(alphareg.is_lowercase('A'))
    assert_false(alphareg.is_lowercase('Z'))
  end
end
