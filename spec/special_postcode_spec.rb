require "uk_postcode"

describe UKPostcode do
  # Special postcodes listed in http://en.wikipedia.org/wiki/UK_postcode
  special = %w[
    SW1A 0AA
    SW1A 1AA
    SW1A 2AA
    BS98 1TL
    BX1  1LT
    BX5  5AT
    CF99 1NA
    DH99 1NS
    E16  1XL
    E98  1NW
    E98  1SN
    E98  1ST
    E98  1TT
    EC4Y 0HQ
    EH99 1SP
    EN8  9SL
    G58  1SB
    GIR  0AA
    L30  4GB
    LS98 1FD
    M2   5BE
    N81  1ER
    S2   4SU
    S6   1SW
    SE1  8UJ
    SE9  2UG
    SN38 1NW
    SW1A 0PW
    SW1A 2HQ
    SW1W 0DT
    TS1  3BA
    W1A  1AA
    W1F  9DJ
  ]

  special.each_slice(2) do |outcode, incode|
    it "handles special postcode #{outcode} #{incode}" do
      postcode = described_class.parse(outcode + incode)
      expect(postcode).not_to be_nil
      expect(postcode.outcode).to eq(outcode)
      expect(postcode.incode).to eq(incode)
    end
  end
end
