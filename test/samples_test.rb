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
        assert postcode.valid?, "'#{outcode} #{incode}' should be valid"
        assert_equal outcode, postcode.outcode, "incorrect outcode for '#{outcode} #{incode}'"
        assert_equal incode,  postcode.incode,  "incorrect incode for '#{outcode} #{incode}'"
      end
    end
  end
end
