require 'uk_postcode'

describe UKPostcode do
  it 'finds the town of a full postcode' do
    expect(described_class.parse('WD17 0AA').town).to eq('Watford')
  end

  it 'finds the town of a postcode outcode' do
    expect(described_class.parse('WD17').town).to eq('Watford')
  end

  it 'finds the town of a postcode outcode that is shared between multiple towns with a full postcode' do
    expect(described_class.parse('OX18 1AA').town).to eq('Carterton')
  end

  it 'finds the town of a postcode outcode that is shared between multiple towns with an outcode and sector' do
    expect(described_class.parse('OX18 2').town).to eq('Bampton')
  end

  it 'returns :unknown_outcode for an invalid outcode' do
    expect(described_class.parse('WD77').town).to eq(:unknown_outcode)
  end

  it 'returns :multiple_possible_matches for an outcode that is shared between multiple towns' do
    expect(described_class.parse('OX18').town).to eq(:multiple_possible_matches)
  end
end
