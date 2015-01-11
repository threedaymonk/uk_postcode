require "uk_postcode/abstract_postcode"

module UKPostcode

  # InvalidPostcode is a singleton null object returned by UKPostcode.parse
  # when it is unable to parse the supplied postcode.
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
  end
end
