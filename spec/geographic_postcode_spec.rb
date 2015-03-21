require "uk_postcode/geographic_postcode"

describe UKPostcode::GeographicPostcode do
  describe ".parse" do
    it "parses a full postcode" do
      pc = described_class.parse("W1A 1AA")
      expect(pc).to be_instance_of(described_class)
      expect(pc.area).to eq("W")
      expect(pc.district).to eq("1A")
      expect(pc.sector).to eq("1")
      expect(pc.unit).to eq("AA")
    end

    it "parses a postcode with no unit" do
      pc = described_class.parse("W1A 1")
      expect(pc).to be_instance_of(described_class)
      expect(pc.area).to eq("W")
      expect(pc.district).to eq("1A")
      expect(pc.sector).to eq("1")
      expect(pc.unit).to be_nil
    end

    it "parses an outcode" do
      pc = described_class.parse("W1A")
      expect(pc).to be_instance_of(described_class)
      expect(pc.area).to eq("W")
      expect(pc.district).to eq("1A")
      expect(pc.sector).to be_nil
      expect(pc.unit).to be_nil
    end

    it "parses an area" do
      pc = described_class.parse("W")
      expect(pc).to be_instance_of(described_class)
      expect(pc.area).to eq("W")
      expect(pc.district).to be_nil
      expect(pc.sector).to be_nil
      expect(pc.unit).to be_nil
    end

    it "handles extra spaces" do
      pc = described_class.parse("  W1A   1AA  ")
      expect(pc).to be_instance_of(described_class)
      expect(pc.to_s).to eq("W1A 1AA")
    end

    it "handles no spaces" do
      pc = described_class.parse("W1A1AA")
      expect(pc).to be_instance_of(described_class)
      expect(pc.to_s).to eq("W1A 1AA")
    end

    it "is case-insensitive" do
      pc = described_class.parse("w1a 1aa")
      expect(pc).to be_instance_of(described_class)
      expect(pc.to_s).to eq("W1A 1AA")
    end

    it "returns nil if unable to parse" do
      pc = described_class.parse("Can't parse this")
      expect(pc).to be_nil
    end

    context "with single-letter area" do
      it "extracts area without trailing I from outcode" do
        pc = described_class.parse("B11")
        expect(pc.area).to eq("B")
        expect(pc.district).to eq("11")
      end

      it "extracts area without trailing I from full postcode with space" do
        pc = described_class.parse("E17 1AA")
        expect(pc.area).to eq("E")
        expect(pc.district).to eq("17")
      end

      it "extracts area without trailing I from full postcode without space" do
        pc = described_class.parse("E171AA")
        expect(pc.area).to eq("E")
        expect(pc.district).to eq("17")
      end
    end

    context "with trailing O in area" do
      it "extracts area with trailing O from outcode" do
        pc = described_class.parse("CO1")
        expect(pc.area).to eq("CO")
        expect(pc.district).to eq("1")
      end

      it "extracts area with trailing O from full postcode with space" do
        pc = described_class.parse("CO1 1BT")
        expect(pc.area).to eq("CO")
        expect(pc.district).to eq("1")
      end

      it "extracts area with trailing O from full postcode without space" do
        pc = described_class.parse("CO11BT")
        expect(pc.area).to eq("CO")
        expect(pc.district).to eq("1")
      end
    end

    context "with tricky postcodes" do
      it "parses B11 1LL" do
        pc = described_class.parse("B111LL")
        expect(pc.area).to eq("B")
        expect(pc.district).to eq("11")
        expect(pc.sector).to eq("1")
        expect(pc.unit).to eq("LL")
      end

      it "parses BII ILL" do
        pc = described_class.parse("BIIILL")
        expect(pc.area).to eq("B")
        expect(pc.district).to eq("11")
        expect(pc.sector).to eq("1")
        expect(pc.unit).to eq("LL")
      end

      it "parses BB11 1DJ" do
        pc = described_class.parse("BB111DJ")
        expect(pc.area).to eq("BB")
        expect(pc.district).to eq("11")
        expect(pc.sector).to eq("1")
        expect(pc.unit).to eq("DJ")
      end

      it "parses BBII IDJ" do
        pc = described_class.parse("BBIIIDJ")
        expect(pc.area).to eq("BB")
        expect(pc.district).to eq("11")
        expect(pc.sector).to eq("1")
        expect(pc.unit).to eq("DJ")
      end

      it "parses B10 0JP" do
        pc = described_class.parse("B100JP")
        expect(pc.area).to eq("B")
        expect(pc.district).to eq("10")
        expect(pc.sector).to eq("0")
        expect(pc.unit).to eq("JP")
      end

      it "parses BIO OJP" do
        pc = described_class.parse("BIOOJP")
        expect(pc.area).to eq("B")
        expect(pc.district).to eq("10")
        expect(pc.sector).to eq("0")
        expect(pc.unit).to eq("JP")
      end
    end
  end

  describe "#area" do
    it "is capitalised" do
      expect(described_class.new("w", "1a", "1", "aa").area).to eq("W")
    end

    it "corrects 0 to O" do
      expect(described_class.new("0X", "1", "0", "AB").area).to eq("OX")
    end

    it "corrects 1 to I" do
      expect(described_class.new("1G", "1", "1", "AA").area).to eq("IG")
    end
  end

  describe "#district" do
    it "is capitalised" do
      expect(described_class.new("w", "1a", "1", "aa").district).to eq("1A")
    end

    it "corrects O to 0" do
      expect(described_class.new("B", "2O", "2", "XB").district).to eq("20")
    end

    it "corrects I to 1" do
      expect(described_class.new("B", "I", "I", "DF").district).to eq("1")
    end
  end

  describe "#sector" do
    it "corrects O to 0" do
      expect(described_class.new("AB", "1", "O", "DN").sector).to eq("0")
    end

    it "corrects I to 1" do
      expect(described_class.new("W", "1A", "I", "AA").sector).to eq("1")
    end
  end

  describe "#unit" do
    it "is capitalised" do
      expect(described_class.new("w", "1a", "1", "aa").unit).to eq("AA")
    end

    # Note: neither I nor O appear in units
  end

  describe "#outcode" do
    it "is generated from area and district" do
      expect(described_class.new("W", "1A").outcode).to eq("W1A")
    end

    it "is nil if missing district" do
      expect(described_class.new("W").outcode).to be_nil
    end
  end

  describe "#incode" do
    it "is generated from sector and unit" do
      expect(described_class.new("W", "1A", "1", "AA").incode).to eq("1AA")
    end

    it "is nil if missing sector" do
      expect(described_class.new("W", "1A").incode).to be_nil
    end

    it "is nil if missing unit" do
      expect(described_class.new("W", "1A", "1").incode).to be_nil
    end
  end

  describe "#to_s" do
    it "generates a full postcode" do
      expect(described_class.new("W", "1A", "1", "AA").to_s).to eq("W1A 1AA")
    end

    it "generates an outcode" do
      expect(described_class.new("W", "1A").to_s).to eq("W1A")
    end

    it "generates a postcode with no unit" do
      expect(described_class.new("W", "1A", "1").to_s).to eq("W1A 1")
    end

    it "generates an area alone" do
      expect(described_class.new("W").to_s).to eq("W")
    end
  end

  describe "#full?" do
    it "is true if outcode and incode are given" do
      expect(described_class.new("W", "1A", "1", "AA")).to be_full
    end

    it "is not true if something is missing" do
      expect(described_class.new("W", "1A", "1")).not_to be_full
    end
  end

  describe "#valid?" do
    it "is true" do
      expect(described_class.new("W", "1A", "1", "AA")).to be_valid
    end
  end

  describe "#country" do
    it "looks up the country of a full postcode" do
      expect(described_class.new("EH", "8", "8", "DX").country).to eq(:scotland)
    end

    it "looks up the country of a partial postcode" do
      expect(described_class.new("W", "1A").country).to eq(:england)
    end
  end
end
