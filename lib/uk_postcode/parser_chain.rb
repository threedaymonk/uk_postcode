module UKPostcode
  class ParserChain
    def initialize(*parsers)
      @parsers = parsers
    end

    def parse(str)
      @parsers.each do |klass|
        parsed = klass.parse(str)
        return parsed if parsed
      end
      nil
    end
  end
end
