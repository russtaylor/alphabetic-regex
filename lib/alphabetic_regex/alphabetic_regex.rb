#
# AlphabeticRegex
#
# Primary class that handles transforming an alphabetic range
# into regex.
#
class AlphabeticRegex

  SPECIAL_CHARACTERS = ' -._'
  SPECIAL_BEFORE_ALPHANUMERIC = ' -.'
  NEEDS_ESCAPE = '-.'
  SPECIAL_AFTER_ALPHANUMERIC = '_'
  # Since we are (for now) dealing with filenames, we're disallowing most special characters.
  INVALID_CHARACTERS = ':;<=>?@[]\\^`/!"\'$#^%&()*+,|'
  FIRST_CHARACTER = ' '
  LAST_CHARACTER = '_'
  FIRST_ALPHA_CHARACTER = 'A'
  LAST_ALPHA_CHARACTER = 'Z'
  FIRST_NUMERIC_CHARACTER = '0'
  LAST_NUMERIC_CHARACTER = '9'
  FULL_REGEX_MATCH='[ \\-\\._0-9A-Za-z]*'

  def original_case(upcase, character)
    upcase ? character : character.downcase
  end

  def get_upcase(character)
    upcase = is_uppercase(character)
    upcase_char = character.upcase
    return upcase, upcase_char.force_encoding('ASCII')
  end

  def needs_escape(character)
    NEEDS_ESCAPE.include?(character)
  end

  def get_regex_character_match(character)
    if (is_digit(character) || is_special_character(character))
      "#{character}"
    else
      "#{character.upcase}#{character.downcase}"
    end
  end

  def escape_necessary(input)
    escaped = Array.new
    input.each_char do |character|
      if (needs_escape(character))
        escaped.push('\\')
      end
      escaped.push(character)
    end
    escaped.join('')
  end

  def get_string_to_match(input_string, character)
    escaped_char = escape_necessary(character)
    input_string.partition(/#{escaped_char}/).first
  end

  def get_string_after_match(input_string, character)
    escaped_char = escape_necessary(character)
    input_string.partition(/#{escaped_char}/).last
  end

  def generate_regex(from_string, to_string)
    full_regex = ''
    if (from_string)
      full_regex += ('^(' + generate_regex_after(from_string) + ")#{FULL_REGEX_MATCH}$")
    end
    if (from_string && to_string)
      between_regex = generate_regex_between(from_string, to_string)
    end
    if (between_regex)
      full_regex += ('|^(' + between_regex + ")#{FULL_REGEX_MATCH}$")
    end
    if (to_string)
      unless(full_regex.empty?)
        full_regex += '|'
      end
      full_regex += ('^(' + generate_regex_before(to_string) + ")#{FULL_REGEX_MATCH}$")
    end
    full_regex
  end

  # Does _not_ include any _exact_ results matching `end_string`
  def generate_regex_before(end_string)
    first_char_match = get_regex_character_match(end_string[0])
    if (end_string.length > 1)
      range_before_next = get_range_before(end_string[1])
      recursive_range = generate_regex_before(end_string[1..-1])
      final_condition = ''
      if (recursive_range)
        final_condition = "|#{recursive_range}"
      end
      "[#{first_char_match}](#{range_before_next}#{final_condition}|$)"
    end
  end

  # Includes any _exact_ results matching `start_string`
  def generate_regex_after(start_string)
    first_char_match = get_regex_character_match(start_string[0])
    if (start_string.length > 1)
      range_after_next = get_range_after(start_string[1])
      unless (range_after_next.empty?)
        range_after_next += '|'
      end
      recursive_range = generate_regex_after(start_string[1..-1])
      "[#{first_char_match}](#{range_after_next}#{recursive_range})"
    else
      "[#{first_char_match}]"
    end
  end

  def generate_regex_between(start_string, end_string)
    start_char = start_string[0]
    start_range_char = get_next_alpha_character(start_char)
    end_char = end_string[0]
    end_range_char = get_prev_alpha_character(end_char)
    if (start_range_char == end_range_char)
      return "[#{start_range_char.upcase}#{start_range_char.downcase}]"
    end
    if (start_range_char < end_range_char)
      return "[#{start_range_char.upcase}-#{end_range_char.upcase}#{start_range_char.downcase}-#{end_range_char.downcase}]"
    end
    return nil
  end

  def get_range_before(character)
    if (character == FIRST_CHARACTER)
      return ''
    end
    special_range = get_special_before(character)
    numeric_range = get_numeric_range_before(character)
    alphabetic_range = get_alpha_range_before(character)
    "[#{special_range}#{numeric_range}#{alphabetic_range}]"
  end

  def get_range_after(character)
    if (character == LAST_CHARACTER)
      return ''
    end
    special_range = get_special_after(character)
    numeric_range = get_numeric_range_after(character)
    alphabetic_range = get_alpha_range_after(character)
    "[#{special_range}#{numeric_range}#{alphabetic_range}]"
  end

  def get_special_before(character)
    unless (SPECIAL_BEFORE_ALPHANUMERIC.include?(character))
      return escape_necessary(SPECIAL_BEFORE_ALPHANUMERIC)
    end
    match_before = get_string_to_match(SPECIAL_BEFORE_ALPHANUMERIC, character)
    escape_necessary(match_before)
  end

  def get_special_after(character)
    unless (SPECIAL_AFTER_ALPHANUMERIC.include?(character) ||
          SPECIAL_BEFORE_ALPHANUMERIC.include?(character))
      return escape_necessary(SPECIAL_AFTER_ALPHANUMERIC)
    end
    if (SPECIAL_BEFORE_ALPHANUMERIC.include?(character))
      after_match = get_string_after_match(SPECIAL_BEFORE_ALPHANUMERIC, character)
      return escape_necessary(after_match + SPECIAL_AFTER_ALPHANUMERIC)
    end
    after_match = get_string_after_match(SPECIAL_AFTER_ALPHANUMERIC, character)
    escape_necessary(after_match)
  end

  def get_full_numeric_range
    "0-9"
  end

  def get_full_alpha_range
    "#{FIRST_ALPHA_CHARACTER}-#{LAST_ALPHA_CHARACTER}#{FIRST_ALPHA_CHARACTER.downcase}-#{LAST_ALPHA_CHARACTER.downcase}"
  end

  def get_numeric_range_before(character)
    if (SPECIAL_AFTER_ALPHANUMERIC.include?(character) || is_alphabetic(character))
      return get_full_numeric_range
    end
    if (FIRST_NUMERIC_CHARACTER == character || SPECIAL_BEFORE_ALPHANUMERIC.include?(character))
      return ''
    end
    stop_digit = (character.to_i - 1).to_s
    if (stop_digit == FIRST_NUMERIC_CHARACTER)
      return '0'
    end
    "#{FIRST_NUMERIC_CHARACTER}-#{stop_digit}"
  end

  def get_numeric_range_after(character)
    if (SPECIAL_BEFORE_ALPHANUMERIC.include?(character))
      return get_full_numeric_range
    end
    if (LAST_NUMERIC_CHARACTER == character ||
        SPECIAL_AFTER_ALPHANUMERIC.include?(character) ||
        is_alphabetic(character))
      return ''
    end
    stop_digit = (character.to_i + 1).to_s
    if (stop_digit == LAST_NUMERIC_CHARACTER)
      return '9'
    end
    "#{stop_digit}-#{LAST_NUMERIC_CHARACTER}"
  end

  def get_alpha_range_before(character)
    if (SPECIAL_AFTER_ALPHANUMERIC.include?(character))
      return get_full_alpha_range
    end
    upcase, upcase_char = get_upcase(character)
    if (get_prev_character(upcase_char) == FIRST_ALPHA_CHARACTER)
      return "#{FIRST_ALPHA_CHARACTER}#{FIRST_ALPHA_CHARACTER.downcase}"
    end
    if (upcase_char == FIRST_ALPHA_CHARACTER ||
        is_digit(upcase_char) ||
        SPECIAL_BEFORE_ALPHANUMERIC.include?(character))
      return ''
    end
    stop_character = get_prev_character(character)
    "#{FIRST_ALPHA_CHARACTER}-#{stop_character.upcase}#{FIRST_ALPHA_CHARACTER.downcase}-#{stop_character.downcase}"
  end

  def get_alpha_range_after(character)
    if (SPECIAL_BEFORE_ALPHANUMERIC.include?(character) || is_digit(character))
      return get_full_alpha_range
    end
    upcase, upcase_char = get_upcase(character)
    if (get_next_character(upcase_char) == LAST_ALPHA_CHARACTER)
      return "#{LAST_ALPHA_CHARACTER}#{LAST_ALPHA_CHARACTER.downcase}"
    end
    if (upcase_char == LAST_ALPHA_CHARACTER ||
        SPECIAL_AFTER_ALPHANUMERIC.include?(character))
      return ''
    end
    start_character = get_next_character(character)
    "#{start_character.upcase}-#{LAST_ALPHA_CHARACTER}#{start_character.downcase}-#{LAST_ALPHA_CHARACTER.downcase}"
  end

  def get_prev_character(character)
    if (character == FIRST_CHARACTER)
      return character
    end
    upcase, upcase_char = get_upcase(character)
    loop do
      upcase_char = (upcase_char.ord - 1).chr
      break unless is_invalid_charater(upcase_char)
    end
    original_case(upcase, upcase_char)
  end

  def get_prev_alpha_character(character)
    unless (is_alphabetic(character))
      return character
    end
    upcase, upcase_char = get_upcase(character)
    if (upcase_char == FIRST_ALPHA_CHARACTER)
      return original_case(upcase, upcase_char)
    end
    original_case(upcase, get_prev_character(upcase_char))
  end

  def get_next_character(character)
    if (character == LAST_CHARACTER)
      return character
    end
    upcase, upcase_char = get_upcase(character)
    loop do
      upcase_char = (upcase_char.ord + 1).chr
      break unless is_invalid_charater(upcase_char)
    end
    original_case(upcase, upcase_char)
  end

  def get_next_alpha_character(character)
    unless (is_alphabetic(character))
      return character
    end
    upcase, upcase_char = get_upcase(character)
    if (upcase_char == LAST_ALPHA_CHARACTER)
      return original_case(upcase, upcase_char)
    end
    original_case(upcase, get_next_character(upcase_char))
  end

  def is_alphabetic(character)
    /[[:alpha:]]/.match?(character)
  end

  def is_digit(character)
    /[[:digit:]]/.match?(character)
  end

  def is_special_character(character)
    SPECIAL_CHARACTERS.include?(character)
  end

  def is_uppercase(character)
    /[[:upper:]]/.match?(character)
  end

  def is_lowercase(character)
    /[[:lower:]]/.match?(character)
  end

  def is_invalid_charater(character)
    INVALID_CHARACTERS.include?(character)
  end
end
