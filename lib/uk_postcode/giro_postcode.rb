require "singleton"
require "uk_postcode/abstract_postcode"

module UKPostcode

  # GiroPostcode models the single, peculiar GIR 0AA postcode originally used
  # by Girobank.
  #
  # area, district, sector, and unit all return nil, because this postcode
  # does not meaningfully possess these distinctions.
  #
  class GiroPostcode < AbstractPostcode
    include Singleton

    PATTERN = /\A G[I1]R \s* [0O]AA \z/ix

    # Returns an instance of GiroPostcode if str represents GIR 0AA, and nil
    # otherwise.
    #
    def self.parse(str)
      PATTERN.match(str.strip) ? instance : nil
    end

    def initialize
    end

    # The left-hand part of the postcode, always "GIR".
    #
    def outcode
      "GIR"
    end

    # The right-hand part of the postcode, always "0AA".
    #
    def incode
      "0AA"
    end

    # The canonical string representation of the postcode, i.e.  "GIR 0AA".
    #
    def to_s
      "GIR 0AA"
    end

    # GIR 0AA is always valid.
    #
    def valid?
      true
    end

    # GIR 0AA is always full.
    #
    def full?
      true
    end

    # GIR 0AA is in England. (In Bootle, in fact.)
    #
    def country
      :england
    end
  end
end
