$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require "test/unit"
require "shoulda"
require "uk_postcode"

class UKPostcodeTest < Test::Unit::TestCase

  VALID_SAMPLES  = [ "A9 9AA", "A99 9AA", "AA9 9AA", "AA99 9AA", "A9A 9AA", "AA9A 9AA",
                     "SW1A 0AA", "SW1A 0PW", "SW1A 1AA", "SW1A 2HQ", "W1A 1AA", "W1A 1AB",
                     "N81 1ER", "EH99 1SP" ]
  VALID_OUTCODES = VALID_SAMPLES.map{ |s| s.split(/\s/).first }
  VALID_INCODES  = VALID_SAMPLES.map{ |s| s.split(/\s/).last  }

  context "full samples with spaces" do
    setup do
      @samples  = VALID_SAMPLES
    end

    should "all be valid" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).valid?, "'#{sample}' should be valid"
      end
    end

    should "not be outcodes" do
      @samples.each do |sample|
        assert !UKPostcode.new(sample).outcode?, "'#{sample}' should not be an outcode"
      end
    end

    should "all be full" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).full?, "'#{sample}' should be full"
      end
    end

    should "extract outcodes" do
      @samples.zip(VALID_OUTCODES).each do |sample, outcode|
        assert_equal outcode, UKPostcode.new(sample).outcode
      end
    end

    should "extract incodes" do
      @samples.zip(VALID_INCODES).each do |sample, incode|
        assert_equal incode, UKPostcode.new(sample).incode
      end
    end
  end

  context "full samples without spaces" do
    setup do
      @samples  = VALID_SAMPLES.map{ |s| s.sub(/\s/, "") }
    end

    should "all be valid" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).valid?, "'#{sample}' should be valid"
      end
    end

    should "not be outcodes" do
      @samples.each do |sample|
        assert !UKPostcode.new(sample).outcode?, "'#{sample}' should not be an outcode"
      end
    end

    should "all be full" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).full?, "'#{sample}' should be full"
      end
    end

    should "extract outcodes" do
      @samples.zip(VALID_OUTCODES).each do |sample, outcode|
        assert_equal outcode, UKPostcode.new(sample).outcode
      end
    end

    should "extract incodes" do
      @samples.zip(VALID_INCODES).each do |sample, incode|
        assert_equal incode, UKPostcode.new(sample).incode
      end
    end
  end

  context "outcode samples" do
    setup do
      @samples = VALID_OUTCODES
    end

    should "all be valid" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).valid?, "'#{sample}' should be valid"
      end
    end

    should "all be outcodes" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).outcode?, "'#{sample}' should be an outcode"
      end
    end

    should "not be full" do
      @samples.each do |sample|
        assert !UKPostcode.new(sample).full?, "'#{sample}' should not be full"
      end
    end

    should "keep outcode unchanged" do
      @samples.each do |sample|
        assert_equal sample, UKPostcode.new(sample).outcode
      end
    end

    should "have nil incode" do
      @samples.each do |sample|
        assert_nil UKPostcode.new(sample).incode
      end
    end
  end

  context "when the postcode is supplied in lower case" do
    setup do
      @postcode = UKPostcode.new("w1a 1aa")
    end

    should "extract outcode in upper case" do
      assert_equal "W1A", @postcode.outcode
    end

    should "extract incode in upper case" do
      assert_equal "1AA", @postcode.incode
    end

    should "be valid" do
      assert @postcode.valid?
    end
  end

  { "when the postcode is blank" => "",
    "when the incode is truncated" => "W1A 1A",
    "when the outcode is truncated" => "W",
    "when the postcode is invalid" => "ABC DEFG"
  }.each do |desc, sample|
    context desc do
      setup do
        @postcode = UKPostcode.new(sample)
      end

      should "not be valid" do
        assert !@postcode.valid?
      end

      should "not be full" do
        assert !@postcode.full?
      end

      should "not be an outcode" do
        assert !@postcode.outcode?
      end

      should "return an empty string for to_str" do
        assert_equal "", @postcode.to_str
      end

      should "return nil for outcode" do
        assert_nil @postcode.outcode
      end

      should "return nil for incode" do
        assert_nil @postcode.incode
      end
    end
  end

  context "when used as a string" do
    should "normalise spacing" do
      assert_equal "W1A 1AA", UKPostcode.new("W1A1AA").to_str
    end

    should "convert case" do
      assert_equal "W1A 1AA", UKPostcode.new("w1a 1aa").to_str
    end

    should "ignore a missing incode" do
      assert_equal "W1A", UKPostcode.new("W1A").to_str
    end
  end

  should "have same output for to_s and to_str" do
    ["W1A1AA", "w1a 1aa", "W1A"].each do |s|
      postcode = UKPostcode.new(s)
      assert_equal s.to_str, s.to_s
    end
  end
end
