$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require "test/unit"
require "shoulda/context"
require "uk_postcode"

class UKPostcodeTest < Test::Unit::TestCase

  Dir[File.join(File.dirname(__FILE__), "samples", "*.list")].each do |path|
    context "in sample file #{File.basename(path, ".list")}" do
      setup do
        @file = open(path)
      end

      teardown do
        @file.close
      end

      should "be valid for each line in sample file" do
        @file.each_line do |line|
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
end
