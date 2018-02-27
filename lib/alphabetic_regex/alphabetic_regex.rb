#
# AlphabeticRegex
#
# Primary class that handles transforming an alphabetic range
# into regex.
#
class AlphabeticRegex

  SPECIAL_CHARACTERS = '_- '
  INVALID_CHARACTERS=':;<=>?@[\]^`'

  def get_range_before(character)

  end

  def get_range_after(character)

  end

  def get_next_character(character)

  end

  def get_prev_character(character)

  end

  def get_ending_character
    '_'
  end

  def get_beginning_character
    '0'
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
