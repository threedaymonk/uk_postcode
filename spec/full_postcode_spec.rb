require "csv"
require "uk_postcode"

describe "Full set of postcodes" do
  let(:sample_percent) {
    ENV.fetch("SAMPLE_PERCENT", 1).to_i
  }

  let(:csv_path) {
    File.expand_path("data/postcodes_#{sample_percent}.csv", __dir__)
  }

  let(:countries) {
    {
      'E92000001' => :england,
      'N92000002' => :northern_ireland,
      'S92000003' => :scotland,
      'W92000004' => :wales,
      'L93000001' => :channel_islands,
      'M83000003' => :isle_of_man
    }
  }

  let(:each_postcode) {
    ->(&blk) {
      CSV.foreach(csv_path, headers: [:postcode, :country]) do |row|
        country = countries.fetch(row[:country])
        outcode = row[:postcode][0, 4].strip
        incode  = row[:postcode][4, 3].strip
        blk.call outcode, incode, country
      end
    }
  }

  it "parses and finds the country of a postcode" do
    each_postcode.call do |outcode, incode, country|
      postcode = UKPostcode.parse(outcode + incode)

      expect(postcode).not_to be_nil
      expect(postcode.outcode).to eq(outcode)
      expect(postcode.incode).to eq(incode)
      expect(postcode.country).to eq(country)
    end
  end

  it "parses postcodes with letters in place of numbers" do
    each_postcode.call do |outcode, incode, _country|
      postcode = UKPostcode.parse((outcode + incode).tr("01", "OI"))

      expect(postcode).not_to be_nil
      expect(postcode.outcode).to eq(outcode)
      expect(postcode.incode).to eq(incode)
    end
  end

  it "parses postcodes with numbers in place of letters" do
    each_postcode.call do |outcode, incode, _country|
      postcode = UKPostcode.parse((outcode + incode).tr("OI", "01"))

      expect(postcode).not_to be_nil
      expect(postcode.outcode).to eq(outcode)
      expect(postcode.incode).to eq(incode)
    end
  end
end
