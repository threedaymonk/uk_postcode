require_relative "./test_helper"
require "uk_postcode/invalid_postcode"

describe UKPostcode::InvalidPostcode do
  described_class = UKPostcode::InvalidPostcode

  let(:subject) { described_class.new("anything") }

  describe "parse" do
    it "should parse anything" do
      pc = described_class.parse("Any old junk")
      pc.must_be_instance_of described_class
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
    it "should be nil" do
      subject.outcode.must_be_nil
    end
  end

  describe "incode" do
    it "should be nil" do
      subject.incode.must_be_nil
    end
  end

  describe "to_s" do
    it "should return the initialisation string" do
      subject.to_s.must_equal "anything"
    end
  end

  describe "full?" do
    it "should be false" do
      subject.wont_be :full?
    end
  end

  describe "valid?" do
    it "should be false" do
      subject.wont_be :valid?
    end
  end

  describe "country" do
    it "should be unknown" do
      subject.country.must_equal :unknown
    end
  end
end
