require "uk_postcode"

describe UKPostcode do
  it "finds the country of a full postcode in England" do
    expect(described_class.parse("W1A 1AA").country).to eq(:england)
  end

  it "finds the country of a full postcode in Scotland" do
    expect(described_class.parse("EH8 8DX").country).to eq(:scotland)
  end

  it "finds the country of a full postcode in Wales" do
    expect(described_class.parse("CF99 1NA").country).to eq(:wales)
  end

  it "finds the country of a full postcode in Northern Ireland" do
    expect(described_class.parse("BT4 3XX").country).to eq(:northern_ireland)
  end

  it "finds the country of a postcode in a border region" do
    expect(described_class.parse("CA6 5HS").country).to eq(:scotland)
    expect(described_class.parse("CA6 5HT").country).to eq(:england)
  end

  it "finds the country of an unambiguous partial postcode" do
    expect(described_class.parse("BT4").country).to eq(:northern_ireland)
  end

  it "returns :unknown for an ambiguous partial postcode" do
    expect(described_class.parse("DG16").country).to eq(:unknown)
  end
end
