require 'test/unit'
require 'alphabetic_regex/alphabetic_regex.rb'

class TestAlphabeticRegex < Test::Unit::TestCase

  def regex_test(regex_expression, string, should_match)

  end

  def test_get_full_alpha_range
    alphareg = AlphabeticRegex.new

    assert_equal('A-Za-z', alphareg.get_full_alpha_range)
  end

  def test_get_upcase
    alphareg = AlphabeticRegex.new

    assert_equal([true, 'A'], alphareg.get_upcase('A'))
    assert_equal([false, 'A'], alphareg.get_upcase('a'))
    assert_equal([false, 'Z'], alphareg.get_upcase('z'))
    assert_equal([false, '!'], alphareg.get_upcase('!'))
    assert_equal([false, ' '], alphareg.get_upcase(' '))
  end

  def test_get_alpha_range_before
    alphareg = AlphabeticRegex.new

    assert_equal('A-Za-z', alphareg.get_alpha_range_before('_'))
    assert_equal('', alphareg.get_alpha_range_before('-'))
    assert_equal('', alphareg.get_alpha_range_before(' '))
    assert_equal('', alphareg.get_alpha_range_before('A'))
    assert_equal('', alphareg.get_alpha_range_before('a'))
    assert_equal('A-Ya-y', alphareg.get_alpha_range_before('Z'))
    assert_equal('A-La-l', alphareg.get_alpha_range_before('M'))
    assert_equal('Aa', alphareg.get_alpha_range_before('B'))
  end

  def test_get_alpha_range_after
    alphareg = AlphabeticRegex.new

    assert_equal('A-Za-z', alphareg.get_alpha_range_after('-'))
    assert_equal('A-Za-z', alphareg.get_alpha_range_after(' '))
    assert_equal('', alphareg.get_alpha_range_after('_'))
    assert_equal('', alphareg.get_alpha_range_after('Z'))
    assert_equal('', alphareg.get_alpha_range_after('z'))
    assert_equal('B-Zb-z', alphareg.get_alpha_range_after('A'))
    assert_equal('N-Zn-z', alphareg.get_alpha_range_after('M'))
    assert_equal('Zz', alphareg.get_alpha_range_after('Y'))
  end

  def test_get_prev_character
    alphareg = AlphabeticRegex.new

    assert_equal('9', alphareg.get_prev_character('A'))
    assert_equal('9', alphareg.get_prev_character('a'))
    assert_equal('A', alphareg.get_prev_character('B'))
    assert_equal('a', alphareg.get_prev_character('b'))
    assert_equal(' ', alphareg.get_prev_character(' '))
    assert_equal('z', alphareg.get_prev_character('_'))
    assert_equal('.', alphareg.get_prev_character('0'))
  end

  def test_get_next_character
    alphareg = AlphabeticRegex.new

    assert_equal('a', alphareg.get_next_character('9'))
    assert_equal('b', alphareg.get_next_character('a'))
    assert_equal('_', alphareg.get_next_character('Z'))
    assert_equal('_', alphareg.get_next_character('_'))
    assert_equal('-', alphareg.get_next_character(' '))
    assert_equal('1', alphareg.get_next_character('0'))
  end

  def test_get_prev_alpha_character
    alphareg = AlphabeticRegex.new

    assert_equal('A', alphareg.get_prev_alpha_character('A'))
    assert_equal('9', alphareg.get_prev_alpha_character('9'))
    assert_equal('_', alphareg.get_prev_alpha_character('_'))
    assert_equal('A', alphareg.get_prev_alpha_character('B'))
    assert_equal('a', alphareg.get_prev_alpha_character('b'))
    assert_equal('Y', alphareg.get_prev_alpha_character('Z'))
    assert_equal(' ', alphareg.get_prev_alpha_character(' '))
    assert_equal('0', alphareg.get_prev_alpha_character('0'))
  end

  def test_get_next_alpha_character
    alphareg = AlphabeticRegex.new

    assert_equal('B', alphareg.get_next_alpha_character('A'))
    assert_equal('9', alphareg.get_next_alpha_character('9'))
    assert_equal('_', alphareg.get_next_alpha_character('_'))
    assert_equal('C', alphareg.get_next_alpha_character('B'))
    assert_equal('c', alphareg.get_next_alpha_character('b'))
    assert_equal('Z', alphareg.get_next_alpha_character('Z'))
    assert_equal(' ', alphareg.get_next_alpha_character(' '))
    assert_equal('0', alphareg.get_next_alpha_character('0'))
  end

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
