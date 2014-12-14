require "uk_postcode/version"
require "uk_postcode/geographic_postcode"
require "uk_postcode/giro_postcode"
require "uk_postcode/invalid_postcode"

module UKPostcode
  module_function

  # Attempt to parse the string str as a postcode. Returns an object
  # representing the postcode, or an InvalidPostcode if the string cannot be
  # parsed.
  #
  def parse(str)
    [GiroPostcode, GeographicPostcode, InvalidPostcode].each do |klass|
      pc = klass.parse(str)
      return pc if pc
    end
  end
end
