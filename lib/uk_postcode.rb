class UKPostcode
  RE_AREA         = /[A-PR-UWYZ][A-Z]?/
  RE_DISTRICT     = /[0-9IO][0-9A-HJKMNPR-YIO]?/
  RE_SECTOR       = /[0-9IO]/
  RE_UNIT         = /[ABD-HJLNPQ-Z10]{2}/
  RE_OUTCODE_ONLY = /\A (#{RE_AREA}) (#{RE_DISTRICT}) \Z/x
  RE_FULL         = /\A (#{RE_AREA}) (#{RE_DISTRICT}) \s?
                        (#{RE_SECTOR}) (#{RE_UNIT})   \Z/x

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
      uraw = raw.upcase
      m = uraw.match(RE_FULL) || uraw.match(RE_OUTCODE_ONLY) || []
      @parts = (1..4).map{ |i| m[i] }
    end
  end

  def letters(s)
    s && s.tr("10", "IO")
  end

  def digits(s)
    s && s.tr("IO", "10")
  end
end
