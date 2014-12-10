require_relative "./test_helper"
require "uk_postcode/tree"

describe UKPostcode::Tree do
  it "should build a nested hash via insert" do
    tree = UKPostcode::Tree.new
    tree.insert %w[a b c d e], :foo
    tree.insert %w[a b c d f], :bar
    tree.insert %w[a b g h i], :baz

    expected = {
      "a" => {
        "b" => {
          "c" => { "d" => { "e" => :foo, "f" => :bar } },
          "g" => { "h" => { "i" => :baz } }
        }
      }
    }

    tree.to_h.must_equal expected
  end

  it "should compress paths to identical leaves" do
    tree = UKPostcode::Tree.new
    tree.insert %w[a b c d e], :foo
    tree.insert %w[a b c d f], :foo
    tree.insert %w[a b g h i], :baz

    expected = {
      "a" => {
        "b" => {
          "c" => :foo,
          "g" => :baz
        }
      }
    }

    tree.compress.to_h.must_equal expected
  end

  it "should filter the tree to include only paths to specific leaf values" do
    tree = UKPostcode::Tree.new
    tree.insert %w[a b c d e], :foo
    tree.insert %w[a b c d f], :bar
    tree.insert %w[a b g h i], :baz

    expected = {
      "a" => {
        "b" => {
          "c" => { "d" => { "e" => :foo } }
        }
      }
    }

    tree.filter(:foo).to_h.must_equal expected
  end

  it "should generate a minimal regular expression for the tree" do
    tree = UKPostcode::Tree.new
    tree.insert %w[a b c d e], :foo
    tree.insert %w[a b c d f], :foo
    tree.insert %w[a b g h i], :foo
    tree.insert %w[j k], :foo

    expected = /^(?:ab(?:cd[ef]|ghi)|jk)/

    tree.regexp.must_equal expected
  end

  it "should generate a working regular expression for the tree" do
    tree = UKPostcode::Tree.new
    tree.insert %w[a b c d e], :foo
    tree.insert %w[a b c d f], :foo
    tree.insert %w[a b g h i], :foo
    tree.insert %w[j k], :foo

    regexp = tree.regexp
    regexp.must_be :match, 'abcde'
    regexp.must_be :match, 'abcdf'
    regexp.must_be :match, 'abghi'
    regexp.must_be :match, 'jk'
    regexp.wont_be :match, 'abcdg'
  end
end
