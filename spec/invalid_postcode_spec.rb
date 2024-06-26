require "uk_postcode/invalid_postcode"

describe UKPostcode::InvalidPostcode do
  let(:subject) { described_class.new("anything") }

  describe ".parse" do
    it "parses anything" do
      pc = described_class.parse("Any old junk")
      expect(pc).to be_instance_of(described_class)
    end
  end

  describe "#area" do
    it "is nil" do
      expect(subject.area).to be_nil
    end
  end

  describe "#district" do
    it "is nil" do
      expect(subject.district).to be_nil
    end
  end

  describe "#sector" do
    it "is nil" do
      expect(subject.sector).to be_nil
    end
  end

  describe "#unit" do
    it "is nil" do
      expect(subject.unit).to be_nil
    end
  end

  describe "#outcode" do
    it "is nil" do
      expect(subject.outcode).to be_nil
    end
  end

  describe "#incode" do
    it "is nil" do
      expect(subject.incode).to be_nil
    end
  end

  describe "#to_s" do
    it "returns the initialisation string" do
      expect(subject.to_s).to eq("anything")
    end
  end

  it { is_expected.not_to be_full }
  it { is_expected.not_to be_valid }
  it { is_expected.not_to be_full_valid }
end
