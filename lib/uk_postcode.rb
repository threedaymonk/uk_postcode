class UKPostcode
  MATCH = /\A
           ( [A-PR-UWYZ][A-Z]? )           # area
           ( [0-9IO][0-9A-HJKMNPR-YIO]? )  # district
           (?:
             \s?
             ( [0-9IO] )                   # sector
             ( [ABD-HJLNPQ-Z10]{2} )       # unit
                                     )?
           \Z/x

  attr_reader :raw

  # Initialise a new UKPostcode instance from the given postcode string
  #
  def initialize(postcode_as_string)
    @raw = postcode_as_string
  end

  # Returns true if the postcode is a valid full postcode (e.g. W1A 1AA) or outcode (e.g. W1A)
  #
  def valid?
    !!outcode
  end

  # Returns true if the postcode is a valid full postcode (e.g. W1A 1AA)
  #
  def full?
    !!(outcode && incode)
  end

  # The left-hand part of the postcode, e.g. W1A 1AA -> W1A
  #
  def outcode
    area && district && [area, district].join
  end

  # The right-hand part of the postcode, e.g. W1A 1AA -> 1AA
  #
  def incode
    sector && unit && [sector, unit].join
  end

  # The first part of the outcode, e.g. W1A 2AB -> W
  #
  def area
    letters(parts[0])
  end

  # The second part of the outcode, e.g. W1A 2AB -> 1A
  #
  def district
    digits(parts[1])
  end

  # The first part of the incode, e.g. W1A 2AB -> 2
  #
  def sector
    digits(parts[2])
  end

  # The second part of the incode, e.g. W1A 2AB -> AB
  #
  def unit
    letters(parts[3])
  end

  # Render the postcode as a normalised string, i.e. in upper case and with spacing.
  # Returns an empty string if the postcode is not valid.
  #
  def norm
    [outcode, incode].compact.join(" ")
  end
  alias_method :normalise, :norm
  alias_method :normalize, :norm

  alias_method :to_s,   :raw
  alias_method :to_str, :raw

  def inspect(*args)
    "<#{self.class.to_s} #{raw}>"
  end

private
  def parts
    if @matched
      @parts
    else
      @matched = true
      matches = raw.upcase.match(MATCH) || []
      @parts = (1..4).map{ |i| matches[i] }
    end
  end

  def letters(s)
    s && s.tr("10", "IO")
  end

  def digits(s)
    s && s.tr("IO", "10")
  end
end
