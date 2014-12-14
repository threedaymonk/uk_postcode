require_relative "./test_helper"
require "uk_postcode/geographic_postcode"

describe UKPostcode::GeographicPostcode do
  described_class = UKPostcode::GeographicPostcode

  describe "parse" do
    it "should parse a full postcode" do
      pc = described_class.parse("W1A 1AA")
      pc.must_be_instance_of described_class
      pc.area.must_equal "W"
      pc.district.must_equal "1A"
      pc.sector.must_equal "1"
      pc.unit.must_equal "AA"
    end

    it "should parse a postcode with no unit" do
      pc = described_class.parse("W1A 1")
      pc.must_be_instance_of described_class
      pc.area.must_equal "W"
      pc.district.must_equal "1A"
      pc.sector.must_equal "1"
      pc.unit.must_be_nil
    end

    it "should parse an outcode" do
      pc = described_class.parse("W1A")
      pc.must_be_instance_of described_class
      pc.area.must_equal "W"
      pc.district.must_equal "1A"
      pc.sector.must_be_nil
      pc.unit.must_be_nil
    end

    it "should parse an area" do
      pc = described_class.parse("W")
      pc.must_be_instance_of described_class
      pc.area.must_equal "W"
      pc.district.must_be_nil
      pc.sector.must_be_nil
      pc.unit.must_be_nil
    end

    it "should handle extra spaces" do
      pc = described_class.parse("  W1A   1AA  ")
      pc.must_be_instance_of described_class
      pc.to_s.must_equal "W1A 1AA"
    end

    it "should handle no spaces" do
      pc = described_class.parse("W1A1AA")
      pc.must_be_instance_of described_class
      pc.to_s.must_equal "W1A 1AA"
    end

    it "should be case-insensitive" do
      pc = described_class.parse("w1a 1aa")
      pc.must_be_instance_of described_class
      pc.to_s.must_equal "W1A 1AA"
    end

    it "should return nil if unable to parse" do
      pc = described_class.parse("Can't parse this")
      pc.must_be_nil
    end

    describe "single-letter area" do
      it "should extract area without trailing I from outcode" do
        pc = described_class.parse("B11")
        pc.area.must_equal "B"
        pc.district.must_equal "11"
      end

      it "should extract area without trailing I from full postcode with space" do
        pc = described_class.parse("E17 1AA")
        pc.area.must_equal "E"
        pc.district.must_equal "17"
      end

      it "should extract area without trailing I from full postcode without space" do
        pc = described_class.parse("E171AA")
        pc.area.must_equal "E"
        pc.district.must_equal "17"
      end
    end

    describe "trailing O in area" do
      it "should extract area with trailing O from outcode" do
        pc = described_class.parse("CO1")
        pc.area.must_equal "CO"
        pc.district.must_equal "1"
      end

      it "should extract area with trailing O from full postcode with space" do
        pc = described_class.parse("CO1 1BT")
        pc.area.must_equal "CO"
        pc.district.must_equal "1"
      end

      it "should extract area with trailing O from full postcode without space" do
        pc = described_class.parse("CO11BT")
        pc.area.must_equal "CO"
        pc.district.must_equal "1"
      end
    end

    describe "tricky postcodes" do
      it "should parse B11 1LL" do
        pc = described_class.parse("B111LL")
        pc.area.must_equal "B"
        pc.district.must_equal "11"
        pc.sector.must_equal "1"
        pc.unit.must_equal "LL"
      end

      it "should parse BII ILL" do
        pc = described_class.parse("BIIILL")
        pc.area.must_equal "B"
        pc.district.must_equal "11"
        pc.sector.must_equal "1"
        pc.unit.must_equal "LL"
      end

      it "should parse BB11 1DJ" do
        pc = described_class.parse("BB111DJ")
        pc.area.must_equal "BB"
        pc.district.must_equal "11"
        pc.sector.must_equal "1"
        pc.unit.must_equal "DJ"
      end

      it "should parse BBII IDJ" do
        pc = described_class.parse("BBIIIDJ")
        pc.area.must_equal "BB"
        pc.district.must_equal "11"
        pc.sector.must_equal "1"
        pc.unit.must_equal "DJ"
      end

      it "should parse B10 0JP" do
        pc = described_class.parse("B100JP")
        pc.area.must_equal "B"
        pc.district.must_equal "10"
        pc.sector.must_equal "0"
        pc.unit.must_equal "JP"
      end

      it "should parse BIO OJP" do
        pc = described_class.parse("BIOOJP")
        pc.area.must_equal "B"
        pc.district.must_equal "10"
        pc.sector.must_equal "0"
        pc.unit.must_equal "JP"
      end
    end
  end

  describe "area" do
    it "should be capitalised" do
      described_class.new("w", "1a", "1", "aa").area.must_equal "W"
    end

    it "should correct 0 to O" do
      described_class.new("0X", "1", "0", "AB").area.must_equal "OX"
    end

    it "should correct 1 to I" do
      described_class.new("1G", "1", "1", "AA").area.must_equal "IG"
    end
  end

  describe "district" do
    it "should be capitalised" do
      described_class.new("w", "1a", "1", "aa").district.must_equal "1A"
    end

    it "should correct O to 0" do
      described_class.new("B", "2O", "2", "XB").district.must_equal "20"
    end

    it "should correct I to 1" do
      described_class.new("B", "I", "I", "DF").district.must_equal "1"
    end
  end

  describe "sector" do
    it "should correct O to 0" do
      described_class.new("AB", "1", "O", "DN").sector.must_equal "0"
    end

    it "should correct I to 1" do
      described_class.new("W", "1A", "I", "AA").sector.must_equal "1"
    end
  end

  describe "unit" do
    it "should be capitalised" do
      described_class.new("w", "1a", "1", "aa").unit.must_equal "AA"
    end

    # Note: neither I nor O appear in units
  end

  describe "outcode" do
    it "should be generated from area and district" do
      described_class.new("W", "1A").outcode.must_equal "W1A"
    end

    it "should be nil if missing district" do
      described_class.new("W").outcode.must_be_nil
    end
  end

  describe "incode" do
    it "should be generated from sector and unit" do
      described_class.new("W", "1A", "1", "AA").incode.must_equal "1AA"
    end

    it "should be nil if missing sector" do
      described_class.new("W", "1A").incode.must_be_nil
    end

    it "should be nil if missing unit" do
      described_class.new("W", "1A", "1").incode.must_be_nil
    end
  end

  describe "to_s" do
    it "should generate a full postcode" do
      described_class.new("W", "1A", "1", "AA").to_s.must_equal "W1A 1AA"
    end

    it "should generate an outcode" do
      described_class.new("W", "1A").to_s.must_equal "W1A"
    end

    it "should generate a postcode with no unit" do
      described_class.new("W", "1A", "1").to_s.must_equal "W1A 1"
    end

    it "should generate an area alone" do
      described_class.new("W").to_s.must_equal "W"
    end
  end

  describe "full?" do
    it "should be true if outcode and incode are given" do
      described_class.new("W", "1A", "1", "AA").must_be :full?
    end

    it "should not be true if something is missing" do
      described_class.new("W", "1A", "1").wont_be :full?
    end
  end

  describe "valid?" do
    it "should be true" do
      described_class.new("W", "1A", "1", "AA").must_be :valid?
    end
  end

  describe "country" do
    it "should look up the country of a full postcode" do
      described_class.new("EH", "8", "8", "DX").country.must_equal :scotland
    end

    it "should look up the country of a partial postcode" do
      described_class.new("W", "1A").country.must_equal :england
    end
  end
end
