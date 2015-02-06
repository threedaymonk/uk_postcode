require "uk_postcode/country_finder"
require "uk_postcode/abstract_postcode"

module UKPostcode

  # GeographicPostcode models the majority of postcodes, containing an area,
  # a district, a sector, and a unit.
  #
  # Despite the name, it also handles non-geographic postcodes that follow the
  # geographic format.
  #
  class GeographicPostcode < AbstractPostcode
    PATTERN = /
      \A ( [A-PR-UWYZ01][A-HJ-Z0]? )     # area
      (?: ( [0-9IO][0-9A-HJKMNPR-YIO]? ) # district
        (?: \s* ( [0-9IO] )              # sector
          ( [ABD-HJLNPQ-Z]{2} )? )? )?   # unit
      \Z
    /ix

    # Attempts to parse the postcode given in str, and returns an instance of
    # GeographicPostcode on success, or nil on failure.
    #
    def self.parse(str)
      matched = PATTERN.match(str.strip)
      if matched
        new(*(1..4).map { |i| matched[i] })
      else
        nil
      end
    end

    # Initialise a new GeographicPostcode instance with the given area,
    # district, sector, and unit. Only area is required.
    #
    def initialize(area, district = nil, sector = nil, unit = nil)
      @area = letters(area)
      @district = digits(district)
      @sector = digits(sector)
      @unit = letters(unit)
    end

    attr_reader :area, :district, :sector, :unit

    # The left-hand part of the postcode, e.g. W1A 1AA -> W1A
    #
    def outcode
      return nil unless district
      [area, district].join('')
    end

    # The right-hand part of the postcode, e.g. W1A 1AA -> 1AA
    #
    def incode
      return nil unless sector && unit
      [sector, unit].join('')
    end

    # Returns the canonical string representation of the postcode.
    #
    def to_s
      [area, district, " ", sector, unit].compact.join('').strip
    end

    # Returns true if the postcode is a valid full postcode (e.g. W1A 1AA)
    #
    def full?
      area && district && sector && unit && true
    end

    # Any geographic postcode is assumed to be valid
    #
    def valid?
      true
    end

    # Find the country associated with the postcode. Possible values are
    # :england, :scotland, :wales, :northern_ireland, :isle_of_man,
    # :channel_islands, or :unknown.
    #
    # Note that, due to limitations in the underlying data, the country might
    # not always be correct in border regions.
    #
    def country
      CountryFinder.country(self)
    end

  private

    def letters(str)
      return nil unless str
      str.upcase.tr("10", "IO")
    end

    def digits(str)
      return nil unless str
      str.upcase.tr("IO", "10")
    end
  end
end
