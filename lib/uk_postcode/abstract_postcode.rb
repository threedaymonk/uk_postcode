module UKPostcode
  class AbstractPostcode
    NotImplemented = Class.new(StandardError)

    def self.parse(_str)
      raise NotImplemented
    end

    def initialize(*)
      raise NotImplemented
    end

    def area;     nil; end
    def district; nil; end
    def sector;   nil; end
    def unit;     nil; end
    def incode;   nil; end
    def outcode;  nil; end

    def to_s
      raise NotImplemented
    end

    def full?
      raise NotImplemented
    end

    def valid?
      raise NotImplemented
    end

    def full_valid?
      full? && valid?
    end

    def country
      :unknown
    end
  end
end
