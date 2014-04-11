require_relative "./test_helper"
require "uk_postcode"

describe "Sample files" do
  Dir[File.expand_path("../samples/*.list", __FILE__)].each do |path|
    it "should be valid for each line in #{File.basename(path, ".list")}" do
      open(path).each_line do |line|
        next if line =~ /^#|^$/
        outcode = line[0,4].strip
        incode  = line[4,4].strip
        postcode = UKPostcode.new(outcode + incode)
        postcode.must_be :valid?
        postcode.outcode.must_equal outcode
        postcode.incode.must_equal incode
      end
    end
  end
end
