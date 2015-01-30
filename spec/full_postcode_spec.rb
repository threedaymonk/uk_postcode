require "csv"
require "uk_postcode"

describe "Full set of postcodes" do
  CSV_PATH = File.expand_path("../data/postcodes.csv", __FILE__)

  COUNTRIES = {
    'E92000001' => :england,
    'N92000002' => :northern_ireland,
    'S92000003' => :scotland,
    'W92000004' => :wales,
    'L93000001' => :channel_islands,
    'M83000003' => :isle_of_man
  }

  it "parses and finds the country of every extant postcode" do
    skip "Skipping because SKIP_FULL_TEST was set" if ENV['SKIP_FULL_TEST']
    skip "Skipping because #{CSV_PATH} does not exist" unless File.exist?(CSV_PATH)

    CSV.foreach(CSV_PATH, headers: [:postcode, :country]) do |row|
      outcode = row[:postcode][0, 4].strip
      incode  = row[:postcode][4, 3].strip
      country = COUNTRIES.fetch(row[:country])

      postcode = UKPostcode.parse(outcode + incode)

      expect(postcode).not_to be_nil
      expect(postcode.outcode).to eq(outcode)
      expect(postcode.incode).to eq(incode)
      expect(postcode.country).to eq(country)
    end
  end
end
