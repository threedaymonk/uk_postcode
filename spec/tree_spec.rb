require "uk_postcode/tree"

describe UKPostcode::Tree do
  subject { described_class.new }

  it "builds a nested hash via insert" do
    subject.insert %w[a b c d e], :foo
    subject.insert %w[a b c d f], :bar
    subject.insert %w[a b g h i], :baz

    expected = {
      "a" => {
        "b" => {
          "c" => { "d" => { "e" => :foo, "f" => :bar } },
          "g" => { "h" => { "i" => :baz } }
        }
      }
    }

    expect(subject.to_h).to eq expected
  end

  it "compresses paths to identical leaves" do
    subject.insert %w[a b c d e], :foo
    subject.insert %w[a b c d f], :foo
    subject.insert %w[a b g h i], :baz

    expected = {
      "a" => {
        "b" => {
          "c" => :foo,
          "g" => :baz
        }
      }
    }

    expect(subject.compress.to_h).to eq(expected)
  end

  it "filters the tree to include only paths to specific leaf values" do
    subject.insert %w[a b c d e], :foo
    subject.insert %w[a b c d f], :bar
    subject.insert %w[a b g h i], :baz

    expected = {
      "a" => {
        "b" => {
          "c" => { "d" => { "e" => :foo } }
        }
      }
    }

    expect(subject.filter(:foo).to_h).to eq(expected)
  end

  it "generates a minimal regular expression for the tree" do
    subject.insert %w[a b c d e], :foo
    subject.insert %w[a b c d f], :foo
    subject.insert %w[a b g h i], :foo
    subject.insert %w[j k], :foo

    expected = /^(?:ab(?:cd[ef]|ghi)|jk)/

    expect(subject.regexp).to eq(expected)
  end

  it "generates a working regular expression for the tree" do
    subject.insert %w[a b c d e], :foo
    subject.insert %w[a b c d f], :foo
    subject.insert %w[a b g h i], :foo
    subject.insert %w[j k], :foo

    regexp = subject.regexp
    expect(regexp).to match('abcde')
    expect(regexp).to match('abcdf')
    expect(regexp).to match('abghi')
    expect(regexp).to match('jk')
    expect(regexp).not_to match('abcdg')
  end
end
