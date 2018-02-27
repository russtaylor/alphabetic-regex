#
# AlphabeticRegex
#
# Primary class that handles transforming an alphabetic range
# into regex.
#
class AlphabeticRegex

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

  def is_uppercase(character)
    character == character.upcase
  end

  def is_lowercase(character)
    character == character.downcase
  end

  def is_invalid_charater(character)
    INVALID_CHARACTERS.include?(character)
  end
end
