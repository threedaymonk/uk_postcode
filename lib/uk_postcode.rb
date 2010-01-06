class UKPostcode
  RE_OUTCODE      = /[A-Z]{1,2}[0-9R][0-9A-Z]?/
  RE_INCODE       = /[0-9][ABD-HJLNP-UW-Z]{2}/
  RE_OUTCODE_ONLY = /\A(#{RE_OUTCODE})\Z/
  RE_FULL         = /\A(#{RE_OUTCODE}) ?(#{RE_INCODE})\Z/

  attr_reader :raw

  # Initialise a new UKPostcode instance from the given postcode string
  #
  def initialize(postcode_as_string)
    @raw = postcode_as_string.upcase
  end

  # Returns true if the postcode is a valid full postcode (e.g. W1A 1AA) or outcode (e.g. W1A)
  #
  def valid?
    raw.match(RE_FULL) || raw.match(RE_OUTCODE_ONLY)
  end

  # Returns true if the postcode is a valid full postcode (e.g. W1A 1AA)
  #
  def full?
    raw.match(RE_FULL)
  end

  # Returns true if the postcode is a valid outcode (e.g. W1A)
  #
  def outcode?
    !full? && raw.match(RE_OUTCODE_ONLY)
  end

  # The left-hand part of the postcode, e.g. W1A 1AA -> W1A
  #
  def outcode
    raw[RE_FULL, 1] || raw[RE_OUTCODE_ONLY]
  end

  # The right-hand part of the postcode, e.g. W1A 1AA -> 1AA
  #
  def incode
    raw[RE_FULL, 2]
  end

  # Render the postcode as a normalised string, i.e. in upper case and with spacing.
  # Returns an empty string if the postcode is not valid.
  #
  def to_str
    [outcode, incode].compact.join(" ")
  end
  alias_method :to_s, :to_str
end
