$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require "test/unit"
require "shoulda"
require "uk_postcode"

class UKPostcodeTest < Test::Unit::TestCase

  VALID_SAMPLES  = [
    %w[A   9 9 AA], %w[A  99 9 AA], %w[AA  9 9 AA], %w[AA 99 9 AA], %w[A  9A 9 AA],
    %w[AA 9A 9 AA], %w[SW 1A 0 AA], %w[SW 1A 0 PW], %w[SW 1A 1 AA], %w[SW 1A 2 HQ],
    %w[W  1A 1 AA], %w[W  1A 1 AB], %w[N  81 1 ER], %w[EH 99 1 SP], %w[CV  1 1 FL],
    %w[EX  1 1 AE], %w[TQ  1 1 AG]
  ]

  { "full samples with spaces"    => lambda{ |a,b,c,d| [[a, b, " ", c, d].join, [a, b, c, d]] },
    "full samples without spaces" => lambda{ |a,b,c,d| [[a, b, c, d].join, [a, b, c, d]] },
  }.each do |desc, mapping|
    context desc do
      setup do
        @samples = VALID_SAMPLES.map(&mapping)
      end

      should "all be valid" do
        @samples.each do |sample, _|
          assert UKPostcode.new(sample).valid?, "'#{sample}' should be valid"
        end
      end

      should "all be full" do
        @samples.each do |sample, _|
          assert UKPostcode.new(sample).full?, "'#{sample}' should be full"
        end
      end

      should "extract outcodes" do
        @samples.each do |sample, parts|
          assert_equal parts[0]+parts[1], UKPostcode.new(sample).outcode
        end
      end

      should "extract incodes" do
        @samples.each do |sample, parts|
          assert_equal parts[2]+parts[3], UKPostcode.new(sample).incode
        end
      end

      should "extract area" do
        @samples.each do |sample, parts|
          assert_equal parts[0], UKPostcode.new(sample).area
        end
      end

      should "extract district" do
        @samples.each do |sample, parts|
          assert_equal parts[1], UKPostcode.new(sample).district
        end
      end

      should "extract sector" do
        @samples.each do |sample, parts|
          assert_equal parts[2], UKPostcode.new(sample).sector
        end
      end

      should "extract unit" do
        @samples.each do |sample, parts|
          assert_equal parts[3], UKPostcode.new(sample).unit
        end
      end

      should "be the same when normalised" do
        @samples.each do |sample, parts|
          expected = [parts[0], parts[1], " ", parts[2], parts[3]].join
          assert_equal expected, UKPostcode.new(sample).norm
        end
      end
    end
  end

  context "outcode samples" do
    setup do
      @samples = VALID_SAMPLES.map{ |a,b,c,d| [a, b].join }
    end

    should "all be valid" do
      @samples.each do |sample|
        assert UKPostcode.new(sample).valid?, "'#{sample}' should be valid"
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

    should "be the same when normalised" do
      @samples.each do |sample|
        assert_equal sample, UKPostcode.new(sample).norm
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

      should "return an empty string when normalised" do
        assert_equal "", @postcode.norm
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
      assert_equal "W1A 1AA", UKPostcode.new("W1A1AA").norm
    end

    should "convert case" do
      assert_equal "W1A 1AA", UKPostcode.new("w1a 1aa").norm
    end

    should "ignore a missing incode" do
      assert_equal "W1A", UKPostcode.new("W1A").norm
    end
  end

  should "return original input for to_s" do
    ["W1A1AA", "w1a 1aa", "W1A"].each do |s|
      postcode = UKPostcode.new(s)
      assert_equal s, postcode.to_s
    end
  end

  should "return original input for to_str" do
    ["W1A1AA", "w1a 1aa", "W1A"].each do |s|
      postcode = UKPostcode.new(s)
      assert_equal s, postcode.to_str
    end
  end

  context "when letters are used instead of digits" do
    context "in a full postcode" do
      setup do
        @postcode = UKPostcode.new("SWIA OPW")
      end

      should "be valid" do
        assert @postcode.valid?
      end

      should "be full" do
        assert @postcode.full?
      end

      should "normalise to digits" do
        assert_equal "SW1A 0PW", @postcode.norm
      end
    end
  end

  context "when digits are used instead of letters" do
    context "in a full postcode" do
      setup do 
        @postcode = UKPostcode.new("0X1 0AB")
      end

      should "be valid" do
        assert @postcode.valid?
      end

      should "be full" do
        assert @postcode.full?
      end

      should "normalise to letters" do
        assert_equal "OX1 0AB", @postcode.norm
      end
    end
  end
end
