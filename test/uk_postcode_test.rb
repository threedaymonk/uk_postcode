require_relative "./test_helper"
require "uk_postcode"

describe UKPostcode do
  describe "parse" do
    it "should return a Giro postcode" do
      pc = UKPostcode.parse("GIR 0AA")
      pc.must_be_instance_of UKPostcode::GiroPostcode
      pc.to_s.must_equal "GIR 0AA"
    end

    it "should return a geographic postcode" do
      pc = UKPostcode.parse("EH8 8DX")
      pc.must_be_instance_of UKPostcode::GeographicPostcode
      pc.to_s.must_equal "EH8 8DX"
    end

    it "should return invalid instance for a blank postcode" do
      pc = UKPostcode.parse("")
      pc.must_be_instance_of UKPostcode::InvalidPostcode
      pc.to_s.must_equal ""
    end

    it "should return invalid instance for an invalid postcode" do
      pc = UKPostcode.parse("ABC DEF")
      pc.must_be_instance_of UKPostcode::InvalidPostcode
      pc.to_s.must_equal "ABC DEF"
    end
  end
end
