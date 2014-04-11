require_relative "./test_helper"
require "uk_postcode"

describe UKPostcode do

  VALID_SAMPLES  = [
    %w[A   9 9 AA], %w[A  99 9 AA], %w[AA  9 9 AA], %w[AA 99 9 AA], %w[A  9A 9 AA],
    %w[AA 9A 9 AA], %w[SW 1A 0 AA], %w[SW 1A 0 PW], %w[SW 1A 1 AA], %w[SW 1A 2 HQ],
    %w[W  1A 1 AA], %w[W  1A 1 AB], %w[N  81 1 ER], %w[EH 99 1 SP], %w[CV  1 1 FL],
    %w[EX  1 1 AE], %w[TQ  1 1 AG]
  ]

  { "full samples with spaces"    => lambda{ |(a,b,c,d)| [[a, b, " ", c, d].join, [a, b, c, d]] },
    "full samples without spaces" => lambda{ |(a,b,c,d)| [[a, b, c, d].join, [a, b, c, d]] },
  }.each do |desc, mapping|
    describe desc do
      let(:samples) {
        VALID_SAMPLES.map(&mapping)
      }

      it "should all be valid" do
        samples.each do |sample, _|
          UKPostcode.new(sample).must_be :valid?
        end
      end

      it "should all be full" do
        samples.each do |sample, _|
          UKPostcode.new(sample).must_be :full?
        end
      end

      it "should extract outcodes" do
        samples.each do |sample, parts|
          UKPostcode.new(sample).outcode.must_equal parts[0] + parts[1]
        end
      end

      it "should extract incodes" do
        samples.each do |sample, parts|
          UKPostcode.new(sample).incode.must_equal parts[2] + parts[3]
        end
      end

      it "should extract area" do
        samples.each do |sample, parts|
          UKPostcode.new(sample).area.must_equal parts[0]
        end
      end

      it "should extract district" do
        samples.each do |sample, parts|
          UKPostcode.new(sample).district.must_equal parts[1]
        end
      end

      it "should extract sector" do
        samples.each do |sample, parts|
          UKPostcode.new(sample).sector.must_equal parts[2]
        end
      end

      it "should extract unit" do
        samples.each do |sample, parts|
          UKPostcode.new(sample).unit.must_equal parts[3]
        end
      end

      it "should be the same when normalised" do
        samples.each do |sample, parts|
          expected = [parts[0], parts[1], " ", parts[2], parts[3]].join
          UKPostcode.new(sample).norm.must_equal expected
        end
      end
    end
  end

  describe "outcode samples" do
    let(:samples) {
      VALID_SAMPLES.map{ |a,b,c,d| [a, b].join }
    }

    it "should all be valid" do
      samples.each do |sample|
        UKPostcode.new(sample).must_be :valid?
      end
    end

    it "should not be full" do
      samples.each do |sample|
        UKPostcode.new(sample).wont_be :full?
      end
    end

    it "should keep outcode unchanged" do
      samples.each do |sample|
        UKPostcode.new(sample).outcode.must_equal sample
      end
    end

    it "should have nil incode" do
      samples.each do |sample|
        UKPostcode.new(sample).incode.must_be_nil
      end
    end

    it "should be the same when normalised" do
      samples.each do |sample|
        UKPostcode.new(sample).norm.must_equal sample
      end
    end
  end

  describe "when the postcode is supplied in lower case" do
    let(:postcode) {
      UKPostcode.new("w1a 1aa")
    }

    it "should extract outcode in upper case" do
      postcode.outcode.must_equal "W1A"
    end

    it "should extract incode in upper case" do
      postcode.incode.must_equal "1AA"
    end

    it "should be valid" do
      postcode.must_be :valid?
    end
  end

  { "when the postcode is blank" => "",
    "when the incode is truncated" => "W1A 1A",
    "when the outcode is truncated" => "W",
    "when the postcode is invalid" => "ABC DEFG"
  }.each do |desc, sample|
    describe desc do
      let(:postcode) {
        UKPostcode.new(sample)
      }

      it "should not be valid" do
        refute postcode.valid?
      end

      it "should not be full" do
        refute postcode.full?
      end

      it "should return an empty string when normalised" do
        postcode.norm.must_equal ""
      end

      it "should return nil for outcode" do
        postcode.outcode.must_be_nil
      end

      it "should return nil for incode" do
        postcode.incode.must_be_nil
      end
    end
  end

  describe "when used as a string" do
    it "should normalise spacing when no spacing has been used in the input" do
      UKPostcode.new("W1A1AA").norm.must_equal "W1A 1AA"
    end

    it "should normalise spacing when too much spacing has been used in the input" do
      UKPostcode.new("W1A  1AA").norm.must_equal "W1A 1AA"
    end

    it "should convert case" do
      UKPostcode.new("w1a 1aa").norm.must_equal "W1A 1AA"
    end

    it "should ignore a missing incode" do
      UKPostcode.new("W1A").norm.must_equal "W1A"
    end

    it "should trim whitespace from start and end of the string" do
      UKPostcode.new(" W1A 1AA ").norm.must_equal "W1A 1AA"
    end
  end

  it "should return original input for to_s" do
    ["W1A1AA", "w1a 1aa", "W1A"].each do |s|
      UKPostcode.new(s).to_s.must_equal s
    end
  end

  it "should return original input for to_str" do
    ["W1A1AA", "w1a 1aa", "W1A"].each do |s|
      UKPostcode.new(s).to_str.must_equal s
    end
  end

  describe "when letters are used instead of digits" do
    describe "in a full postcode" do
      let(:postcode) {
        UKPostcode.new("SWIA OPW")
      }

      it "should be valid" do
        postcode.must_be :valid?
      end

      it "should be full" do
        postcode.must_be :full?
      end

      it "should normalise to digits" do
        postcode.norm.must_equal "SW1A 0PW"
      end
    end
  end

  describe "when digits are used instead of letters" do
    describe "in a full postcode" do
      let(:postcode) {
        UKPostcode.new("0X1 0AB")
      }

      it "should be valid" do
        postcode.must_be :valid?
      end

      it "should be full" do
        postcode.must_be :full?
      end

      it "should normalise to letters" do
        postcode.norm.must_equal "OX1 0AB"
      end
    end
  end

  describe "single-letter area code" do
    %w[B E G L M N S W].each do |area|
      describe area do
        it "should not convert 1 to I in two-digit outcode" do
          outcode = area + "11"
          postcode = UKPostcode.new(outcode)
          postcode.area.must_equal area
          postcode.outcode.must_equal outcode
        end

        it "should not convert 1 to I in full postcode with space" do
          outcode = area + "13"
          postcode = UKPostcode.new(outcode + " 1AA")
          postcode.area.must_equal area
          postcode.outcode.must_equal outcode
        end

        it "should not convert 1 to I in full postcode without space" do
          outcode = area + "13"
          postcode = UKPostcode.new(outcode + "2AA")
          postcode.area.must_equal area
          postcode.outcode.must_equal outcode
        end
      end
    end
  end

  describe "GIR 0AA" do
    let(:norm) {
      "GIR 0AA"
    }

    it "should stay as is if already normalised" do
      UKPostcode.new(norm).norm.must_equal norm
    end

    it "should be normalised" do
      UKPostcode.new("G1ROAA").norm.must_equal norm
    end
  end
end
