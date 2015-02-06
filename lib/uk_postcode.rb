module UKPostcode
  DEFAULT_PARSER_CHAIN = ParserChain.new(
    GiroPostcode, GeographicPostcode, InvalidPostcode
  )

  # Attempt to parse the string str as a postcode. Returns an object
  # representing the postcode, or an InvalidPostcode if the string cannot be
  # parsed.
  #
  def parse(str)
    DEFAULT_PARSER_CHAIN.parse(str)
  end

  module_function :parse
end
