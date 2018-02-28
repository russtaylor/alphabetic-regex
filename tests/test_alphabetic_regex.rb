require 'test/unit'
require 'alphabetic_regex/alphabetic_regex.rb'

class TestAlphabeticRegex < Test::Unit::TestCase

  def regex_test(regex_expression, string, should_match)

  end

  def test_get_upcase
    alphareg = AlphabeticRegex.new

    assert_equal([true, 'A'], alphareg.get_upcase('A'))
    assert_equal([false, 'A'], alphareg.get_upcase('a'))
    assert_equal([false, 'Z'], alphareg.get_upcase('z'))
    assert_equal([false, '!'], alphareg.get_upcase('!'))
    assert_equal([false, ' '], alphareg.get_upcase(' '))
  end

  def test_get_prev_character
    alphareg = AlphabeticRegex.new

    assert_equal('9'.force_encoding('ASCII'), alphareg.get_prev_character('A'))
    assert_equal('9'.force_encoding('ASCII'), alphareg.get_prev_character('a'))
    assert_equal('A'.force_encoding('ASCII'), alphareg.get_prev_character('B'))
    assert_equal('a'.force_encoding('ASCII'), alphareg.get_prev_character('b'))
    assert_equal(' '.force_encoding('ASCII'), alphareg.get_prev_character(' '))
    assert_equal('z'.force_encoding('ASCII'), alphareg.get_prev_character('_'))
    assert_equal('.'.force_encoding('ASCII'), alphareg.get_prev_character('0'))
  end

  def test_get_next_character
    alphareg = AlphabeticRegex.new

    assert_equal('a'.force_encoding('ASCII'), alphareg.get_next_character('9'))
    assert_equal('b'.force_encoding('ASCII'), alphareg.get_next_character('a'))
    assert_equal('_'.force_encoding('ASCII'), alphareg.get_next_character('Z'))
    assert_equal('_'.force_encoding('ASCII'), alphareg.get_next_character('_'))
    assert_equal('-'.force_encoding('ASCII'), alphareg.get_next_character(' '))
    assert_equal('1'.force_encoding('ASCII'), alphareg.get_next_character('0'))
  end

  def test_get_prev_alpha_character
    alphareg = AlphabeticRegex.new

    assert_equal('A'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('A'))
    assert_equal('9'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('9'))
    assert_equal('_'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('_'))
    assert_equal('A'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('B'))
    assert_equal('a'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('b'))
    assert_equal('Y'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('Z'))
    assert_equal(' '.force_encoding('ASCII'), alphareg.get_prev_alpha_character(' '))
    assert_equal('0'.force_encoding('ASCII'), alphareg.get_prev_alpha_character('0'))
  end

  def test_get_next_alpha_character
    alphareg = AlphabeticRegex.new

    assert_equal('B'.force_encoding('ASCII'), alphareg.get_next_alpha_character('A'))
    assert_equal('9'.force_encoding('ASCII'), alphareg.get_next_alpha_character('9'))
    assert_equal('_'.force_encoding('ASCII'), alphareg.get_next_alpha_character('_'))
    assert_equal('C'.force_encoding('ASCII'), alphareg.get_next_alpha_character('B'))
    assert_equal('c'.force_encoding('ASCII'), alphareg.get_next_alpha_character('b'))
    assert_equal('Z'.force_encoding('ASCII'), alphareg.get_next_alpha_character('Z'))
    assert_equal(' '.force_encoding('ASCII'), alphareg.get_next_alpha_character(' '))
    assert_equal('0'.force_encoding('ASCII'), alphareg.get_next_alpha_character('0'))
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
