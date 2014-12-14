require_relative "./test_helper"
require "uk_postcode/giro_postcode"

describe UKPostcode::GiroPostcode do
  described_class = UKPostcode::GiroPostcode

  let(:subject) { described_class.instance }

  describe "parse" do
    it "should parse the canonical form" do
      pc = described_class.parse("GIR 0AA")
      pc.must_be_instance_of described_class
    end

    it "should parse transcribed 0/O and 1/I" do
      pc = described_class.parse("G1R OAA")
      pc.must_be_instance_of described_class
    end

    it "should handle extra spaces" do
      pc = described_class.parse("  GIR   0AA   ")
      pc.must_be_instance_of described_class
    end

    it "should handle no spaces" do
      pc = described_class.parse("GIR0AA")
      pc.must_be_instance_of described_class
    end

    it "should be case-insensitive" do
      pc = described_class.parse("gir 0aa")
      pc.must_be_instance_of described_class
    end

    it "should return nil if unable to parse" do
      pc = described_class.parse("Can't parse this")
      pc.must_be_nil
    end
  end

  describe "area" do
    it "should be nil" do
      subject.area.must_be_nil
    end
  end

  describe "district" do
    it "should be nil" do
      subject.district.must_be_nil
    end
  end

  describe "sector" do
    it "should be nil" do
      subject.sector.must_be_nil
    end
  end

  describe "unit" do
    it "should be nil" do
      subject.unit.must_be_nil
    end
  end

  describe "outcode" do
    it "should be GIR" do
      subject.outcode.must_equal("GIR")
    end
  end

  describe "incode" do
    it "should be 0AA" do
      subject.incode.must_equal("0AA")
    end
  end

  describe "to_s" do
    it "should be the canonical form" do
      subject.to_s.must_equal "GIR 0AA"
    end
  end

  describe "full?" do
    it "should be true" do
      subject.must_be :full?
    end
  end

  describe "valid?" do
    it "should be true" do
      subject.must_be :valid?
    end
  end

  describe "country" do
    it "should be England" do
      subject.country.must_equal :england
    end
  end
end
