require "uk_postcode"

describe UKPostcode do
  describe "parse" do
    it "returns a Giro postcode" do
      subject = described_class.parse("GIR 0AA")
      expect(subject).to be_instance_of(UKPostcode::GiroPostcode)
      expect(subject.to_s).to eq("GIR 0AA")
    end

    it "returns a geographic postcode" do
      subject = described_class.parse("EH8 8DX")
      expect(subject).to be_instance_of(UKPostcode::GeographicPostcode)
      expect(subject.to_s).to eq("EH8 8DX")
    end

    it "returns invalid instance for a blank postcode" do
      subject = described_class.parse("")
      expect(subject).to be_instance_of(UKPostcode::InvalidPostcode)
      expect(subject.to_s).to eq("")
    end

    it "returns invalid instance for an invalid postcode" do
      subject = described_class.parse("ABC DEF")
      expect(subject).to be_instance_of(UKPostcode::InvalidPostcode)
      expect(subject.to_s).to eq("ABC DEF")
    end
  end
end
