require "uk_postcode/giro_postcode"

describe UKPostcode::GiroPostcode do
  let(:subject) { described_class.instance }

  describe ".parse" do
    it "parses the canonical form" do
      pc = described_class.parse("GIR 0AA")
      expect(pc).to be_instance_of(described_class)
    end

    it "parses transcribed 0/O and 1/I" do
      pc = described_class.parse("G1R OAA")
      expect(pc).to be_instance_of(described_class)
    end

    it "handles extra spaces" do
      pc = described_class.parse("  GIR   0AA   ")
      expect(pc).to be_instance_of(described_class)
    end

    it "handles no spaces" do
      pc = described_class.parse("GIR0AA")
      expect(pc).to be_instance_of(described_class)
    end

    it "is case-insensitive" do
      pc = described_class.parse("gir 0aa")
      expect(pc).to be_instance_of(described_class)
    end

    it "returns nil if unable to parse" do
      pc = described_class.parse("Can't parse this")
      expect(pc).to be_nil
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
    it "is GIR" do
      expect(subject.outcode).to eq("GIR")
    end
  end

  describe "#incode" do
    it "is 0AA" do
      expect(subject.incode).to eq("0AA")
    end
  end

  describe "#to_s" do
    it "is the canonical form" do
      expect(subject.to_s).to eq("GIR 0AA")
    end
  end

  describe "#full?" do
    it "is true" do
      expect(subject).to be_full
    end
  end

  describe "#valid?" do
    it "is true" do
      expect(subject).to be_valid
    end
  end

  describe "#full_valid?" do
    it "is true" do
      expect(subject).to be_full_valid
    end
  end

  describe "#country" do
    it "is England" do
      expect(subject.country).to eq(:england)
    end
  end
end
