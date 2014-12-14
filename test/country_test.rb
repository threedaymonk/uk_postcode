require_relative "./test_helper"
require "uk_postcode"

describe UKPostcode do
  it 'should find the country of a full postcode in England' do
    UKPostcode.new('W1A 1AA').country.must_equal :england
  end

  it 'should find the country of a full postcode in Scotland' do
    UKPostcode.new('EH8 8DX').country.must_equal :scotland
  end

  it 'should find the country of a full postcode in Wales' do
    UKPostcode.new('CF99 1NA').country.must_equal :wales
  end

  it 'should find the country of a full postcode in Northern Ireland' do
    UKPostcode.new('BT4 3XX').country.must_equal :northern_ireland
  end

  it 'should find the country of a postcode in a border region' do
    UKPostcode.new('CA6 5HS').country.must_equal :scotland
    UKPostcode.new('CA6 5HT').country.must_equal :england
  end

  it 'should find the country of an unambiguous partial postcode' do
    UKPostcode.new('BT4').country.must_equal :northern_ireland
  end

  it 'should return :unknown for an ambiguous partial postcode' do
    UKPostcode.new('DG16').country.must_equal :unknown
  end
end
