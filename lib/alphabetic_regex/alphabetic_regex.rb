require 'pry'

#
# AlphabeticRegex
#
# Primary class that handles transforming an alphabetic range
# into regex.
#
class AlphabeticRegex

  # Since we are (for now) dealing with filenames, we're disallowing most special characters.
  SPECIAL_CHARACTERS = '_- '
  INVALID_CHARACTERS=':;<=>?@[]\\^`/!"\'$#^%&()*+,'
  FIRST_CHARACTER = ' '
  LAST_CHARACTER = '_'
  FIRST_ALPHA_CHARACTER = 'A'.force_encoding('ASCII')
  LAST_ALPHA_CHARACTER = 'Z'.force_encoding('ASCII')

  def original_case(upcase, character)
    upcase ? character : character.downcase
  end

  def get_upcase(character)
    upcase = is_uppercase(character)
    upcase_char = character.upcase
    return upcase, upcase_char.force_encoding('ASCII')
  end

  def get_range_before(character)

  end

  def get_range_after(character)

  end

  def get_alpha_range_before(character)

  end

  def get_alpha_range_after(character)

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
