require 'uk_postcode/country/lookup'

class UKPostcode
  class Country
    def initialize(postcode)
      @postcode = postcode
    end

    def country
      normalized = [@postcode.outcode, @postcode.incode].compact.join
      LOOKUP.each do |name, regexp|
        return name if normalized.match(regexp)
      end
      :unknown
    end
  end
end
