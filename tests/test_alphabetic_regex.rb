require 'test/unit'
require 'alphabetic_regex/alphabetic_regex.rb'

class TestAlphabeticRegex < Test::Unit::TestCase
  def test_is_uppercase
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_uppercase('A'))
    assert_true(alphareg.is_uppercase('Z'))
    assert_false(alphareg.is_uppercase('_'))
    assert_false(alphareg.is_uppercase('a'))
    assert_false(alphareg.is_uppercase('z'))
  end

  def test_is_lowercase
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_lowercase('a'))
    assert_true(alphareg.is_lowercase('z'))
    assert_false(alphareg.is_lowercase('_'))
    assert_false(alphareg.is_lowercase('A'))
    assert_false(alphareg.is_lowercase('Z'))
  end

  def test_is_alphabetic
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_alphabetic('A'))
    assert_true(alphareg.is_alphabetic('a'))
    assert_true(alphareg.is_alphabetic('Z'))
    assert_true(alphareg.is_alphabetic('z'))

    assert_false(alphareg.is_alphabetic('!'))
    assert_false(alphareg.is_alphabetic('_'))
    assert_false(alphareg.is_alphabetic('0'))
    assert_false(alphareg.is_alphabetic('9'))
  end

  def test_is_digit
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_digit('0'))
    assert_true(alphareg.is_digit('9'))

    assert_false(alphareg.is_digit('!'))
    assert_false(alphareg.is_digit('A'))
    assert_false(alphareg.is_digit('z'))
  end

  def test_is_special_character
    alphareg = AlphabeticRegex.new

    assert_true(alphareg.is_special_character(('_')))
    assert_true(alphareg.is_special_character(('-')))

    assert_false(alphareg.is_special_character(('!')))
    assert_false(alphareg.is_special_character(('a')))
    assert_false(alphareg.is_special_character(('Z')))
    assert_false(alphareg.is_special_character(('0')))
    assert_false(alphareg.is_special_character(('9')))
  end
end
