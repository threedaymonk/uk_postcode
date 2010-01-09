$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require "test/unit"
require "shoulda"
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
          sample = line.chomp.sub(/\s+/, "")
          postcode = UKPostcode.new(sample)
          assert postcode.valid?, "'#{sample}' should be valid"
        end
      end
    end
  end
end
