require 'test/unit'
require 'alphabetic_regex/alphabetic_regex.rb'

class TestAlphabeticRegex < Test::Unit::TestCase

  def regex_test(regex_expression, string, should_match)
    assert_equal(should_match, /#{regex_expression}/.match?(string))
  end

  def test_get_upcase
    alphareg = AlphabeticRegex.new

    assert_equal([true, 'A'], alphareg.get_upcase('A'))
    assert_equal([false, 'A'], alphareg.get_upcase('a'))
    assert_equal([false, 'Z'], alphareg.get_upcase('z'))
    assert_equal([false, '!'], alphareg.get_upcase('!'))
    assert_equal([false, ' '], alphareg.get_upcase(' '))
  end

  def test_get_regex_character_match
    alphareg = AlphabeticRegex.new

    assert_equal('Aa', alphareg.get_regex_character_match('A'))
    assert_equal('Aa', alphareg.get_regex_character_match('a'))
    assert_equal('Zz', alphareg.get_regex_character_match('Z'))
    assert_equal('Zz', alphareg.get_regex_character_match('z'))
    assert_equal('_', alphareg.get_regex_character_match('_'))
    assert_equal('0', alphareg.get_regex_character_match('0'))
  end

  def test_escape_necessary
    alphareg = AlphabeticRegex.new

    assert_equal(' \\-', alphareg.escape_necessary(' -'))
    assert_equal('abcdefg\\-\\-\\-hijklmn', alphareg.escape_necessary('abcdefg---hijklmn'))
    assert_equal('_\\-_\\-_\\-_\\-_', alphareg.escape_necessary('_-_-_-_-_'))
  end

  def test_get_string_to_match
    alphareg = AlphabeticRegex.new

    assert_equal('', alphareg.get_string_to_match('Sherlockholmes', 'S'))
    assert_equal('--', alphareg.get_string_to_match('--p-!', 'p'))
    assert_equal('In the ', alphareg.get_string_to_match('In the year 1878 I took my degree', 'y'))
  end

  def test_get_string_after_match
    alphareg = AlphabeticRegex.new

    assert_equal('', alphareg.get_string_after_match('Sherlockholmes', 's'))
    assert_equal('-!', alphareg.get_string_after_match('--p-!', 'p'))
    assert_equal('ree', alphareg.get_string_after_match('In the year 1878 I took my degree', 'g'))
  end

  def test_generate_regex
    alphareg = AlphabeticRegex.new

    regex_test(alphareg.generate_regex('Hello', 'Sherlock'), 'Hi', true)
    regex_test(alphareg.generate_regex('Ab', 'Cb'), 'Cat', true)
    regex_test(alphareg.generate_regex(nil, 'At'), 'Art', true)
    regex_test(alphareg.generate_regex(nil, 'At'), 'Azure', false)
    regex_test(alphareg.generate_regex(nil, 'At'), 'Bravo', false)
    regex_test(alphareg.generate_regex('Hello', 'Sherlock'), 'Zebra', false)
    regex_test(alphareg.generate_regex('Zebra', nil), 'Zippy', true)
    regex_test(alphareg.generate_regex('Zebra', nil), 'Zargon', false)
    regex_test(alphareg.generate_regex('Zebra', nil), 'Train', false)
  end

  def test_generate_regex_before
    alphareg = AlphabeticRegex.new

    assert_equal('[Hh]([ \-\.0-9A-Ha-h]|$)', alphareg.generate_regex_before('Hi'))
    regex_test('^' + alphareg.generate_regex_before('Hi'), 'Hi', false)
    regex_test('^' + alphareg.generate_regex_before('Hi'), 'Highlight', false)
    regex_test('^' + alphareg.generate_regex_before('Hi'), 'H', true)
  end

  def test_generate_regex_after
    alphareg = AlphabeticRegex.new

    assert_equal('[Hh]([_J-Zj-z]|[Ii])', alphareg.generate_regex_after('Hi'))
    regex_test(alphareg.generate_regex_after('Hi'), 'Hi', true)
    regex_test(alphareg.generate_regex_after('Hi'), 'Highlight', true)
    regex_test(alphareg.generate_regex_after('Hi'), 'H', false)
  end

  def test_generate_regex_between()
    alphareg = AlphabeticRegex.new

    assert_equal('[B-Cb-c]', alphareg.generate_regex_between('A', 'D'))
  end

  def test_range_before
    alphareg = AlphabeticRegex.new

    assert_equal('', alphareg.get_range_before(' '))
    assert_equal('[ \-\.0-9]', alphareg.get_range_before('A'))
    assert_equal('[ \-\.0-9]', alphareg.get_range_before('a'))
    assert_equal('[ \-\.]', alphareg.get_range_before('0'))
    assert_equal('[ \-\.0]', alphareg.get_range_before('1'))
    assert_equal('[ \-\.0-8]', alphareg.get_range_before('9'))
    assert_equal('[ \-\.0-9Aa]', alphareg.get_range_before('B'))
    assert_equal('[ \-\.0-9A-Ya-y]', alphareg.get_range_before('Z'))
    assert_equal('[ \-\.0-9A-Za-z]', alphareg.get_range_before('_'))
  end

  def test_range_after
    alphareg = AlphabeticRegex.new

    assert_equal('[_0-9A-Za-z]', alphareg.get_range_after('.'))
    assert_equal('[\-\._0-9A-Za-z]', alphareg.get_range_after(' '))
    assert_equal('[_1-9A-Za-z]', alphareg.get_range_after('0'))
    assert_equal('[_9A-Za-z]', alphareg.get_range_after('8'))
    assert_equal('[_B-Zb-z]', alphareg.get_range_after('A'))
    assert_equal('[_B-Zb-z]', alphareg.get_range_after('a'))
    assert_equal('[_]', alphareg.get_range_after('Z'))
    assert_equal('[_]', alphareg.get_range_after('z'))
    assert_equal('', alphareg.get_range_after('_'))
  end

  def test_get_special_before
    alphareg = AlphabeticRegex.new

    assert_equal('', alphareg.get_special_before(' '))
    assert_equal(' ', alphareg.get_special_before('-'))
    assert_equal(' \\-\\.', alphareg.get_special_before('0'))
    assert_equal(' \\-\\.', alphareg.get_special_before('b'))
    assert_equal(' \\-\\.', alphareg.get_special_before('_'))
  end

  def test_get_special_after
    alphareg = AlphabeticRegex.new

    assert_equal('\\-\\._', alphareg.get_special_after(' '))
    assert_equal('\\._', alphareg.get_special_after('-'))
    assert_equal('_', alphareg.get_special_after('0'))
    assert_equal('_', alphareg.get_special_after('b'))
    assert_equal('', alphareg.get_special_after('_'))
  end

  def test_get_full_alpha_range
    alphareg = AlphabeticRegex.new

    assert_equal('A-Za-z', alphareg.get_full_alpha_range)
  end

  def test_get_numeric_range_before
    alphareg = AlphabeticRegex.new

    assert_equal('0-9', alphareg.get_numeric_range_before('_'))
    assert_equal('0-9', alphareg.get_numeric_range_before('a'))
    assert_equal('', alphareg.get_numeric_range_before('-'))
    assert_equal('', alphareg.get_numeric_range_before(' '))
    assert_equal('', alphareg.get_numeric_range_before('0'))
    assert_equal('0-8', alphareg.get_numeric_range_before('9'))
    assert_equal('0', alphareg.get_numeric_range_before('1'))
  end

  def test_get_numeric_range_after
    alphareg = AlphabeticRegex.new

    assert_equal('0-9', alphareg.get_numeric_range_after('-'))
    assert_equal('', alphareg.get_numeric_range_after('_'))
    assert_equal('', alphareg.get_numeric_range_after('9'))
    assert_equal('1-9', alphareg.get_numeric_range_after('0'))
    assert_equal('9', alphareg.get_numeric_range_after('8'))
  end

  def test_get_alpha_range_before
    alphareg = AlphabeticRegex.new

    assert_equal('A-Za-z', alphareg.get_alpha_range_before('_'))
    assert_equal('', alphareg.get_alpha_range_before('-'))
    assert_equal('', alphareg.get_alpha_range_before(' '))
    assert_equal('', alphareg.get_alpha_range_before('0'))
    assert_equal('', alphareg.get_alpha_range_before('9'))
    assert_equal('', alphareg.get_alpha_range_before('A'))
    assert_equal('', alphareg.get_alpha_range_before('a'))
    assert_equal('A-Ya-y', alphareg.get_alpha_range_before('Z'))
    assert_equal('A-Ya-y', alphareg.get_alpha_range_before('z'))
    assert_equal('A-La-l', alphareg.get_alpha_range_before('M'))
    assert_equal('A-La-l', alphareg.get_alpha_range_before('m'))
    assert_equal('Aa', alphareg.get_alpha_range_before('B'))
  end

  def test_get_alpha_range_after
    alphareg = AlphabeticRegex.new

    assert_equal('A-Za-z', alphareg.get_alpha_range_after('-'))
    assert_equal('A-Za-z', alphareg.get_alpha_range_after(' '))
    assert_equal('A-Za-z', alphareg.get_alpha_range_after('9'))
    assert_equal('A-Za-z', alphareg.get_alpha_range_after('0'))
    assert_equal('', alphareg.get_alpha_range_after('_'))
    assert_equal('', alphareg.get_alpha_range_after('Z'))
    assert_equal('', alphareg.get_alpha_range_after('z'))
    assert_equal('B-Zb-z', alphareg.get_alpha_range_after('A'))
    assert_equal('B-Zb-z', alphareg.get_alpha_range_after('a'))
    assert_equal('N-Zn-z', alphareg.get_alpha_range_after('M'))
    assert_equal('N-Zn-z', alphareg.get_alpha_range_after('m'))
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
