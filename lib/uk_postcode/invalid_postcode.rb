require "uk_postcode/abstract_postcode"

module UKPostcode

  # An InvalidPostcode is returned by UKPostcode.parse when it is unable to
  # parse the supplied postcode. As it returns the input verbatim via #to_s,
  # it's possible to do UKPostcode.parse(s).to_s and get either a normalised
  # postcode (if possible) or the original user input.
  #
  # The sub-fields of the postcode (outcode, area, etc.) are all nil.
  #
  class InvalidPostcode < AbstractPostcode
    def self.parse(str)
      new(str)
    end

    def initialize(input)
      @input = input
    end

    # Returns the literal string supplied at initialisation. This may be
    # helpful when returning erroneous input to the user.
    #
    def to_s
      @input
    end

    def full?
      false
    end

    def valid?
      false
    end

  end
end
