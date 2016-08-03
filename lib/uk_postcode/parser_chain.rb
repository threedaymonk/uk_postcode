module UKPostcode
  class ParserChain
    def initialize(*parsers)
      @parsers = parsers
    end

    def parse(str)
      postcode = str.to_s
      @parsers.each do |klass|
        parsed = klass.parse(postcode)
        return parsed if parsed
      end
      nil
    end
  end
end
