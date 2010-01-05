class UKPostcode
  RE_OUTCODE      = /[A-Z]{1,2}[0-9R][0-9A-Z]?/
  RE_INCODE       = /[0-9][ABD-HJLNP-UW-Z]{2}/
  RE_OUTCODE_ONLY = /\A(#{RE_OUTCODE})\Z/
  RE_FULL         = /\A(#{RE_OUTCODE}) ?(#{RE_INCODE})\Z/

  attr_reader :raw

  def initialize(raw)
    @raw = raw.upcase
  end

  def valid?
    raw.match(RE_FULL) || raw.match(RE_OUTCODE_ONLY)
  end

  def full?
    raw.match(RE_FULL)
  end

  def outcode?
    !full? && raw.match(RE_OUTCODE_ONLY)
  end

  def outcode
    raw[RE_FULL, 1] || raw[RE_OUTCODE_ONLY]
  end

  def incode
    raw[RE_FULL, 2]
  end

  def to_str
    [outcode, incode].compact.join(" ")
  end
  alias_method :to_s, :to_str
end
