# uk_postcode

UK postcode parsing and validation for Ruby for writing friendly software.

Features:

* Handles errors with `I`/`1` and `O`/`0`.
* Does not require postcodes to contain spaces.
* Normalises postcodes (e.g. `wiaiaa` to `W1A 1AA`).
* Parses full postcodes or outcodes (`W1A`)
* Allows extraction of fields within postcode.
* Validated against 2.5 million postcodes in England, Wales, Scotland, Northern
  Ireland, the Channel Islands, and the Isle of Man.
* Finds the country corresponding to a postcode, where possible.

## Usage

```ruby
require "uk_postcode"
```

Parse and extract sections of a full postcode:

```ruby
pc = UKPostcode.parse("W1A 2AB")
pc.valid?   # => true
pc.full?    # => true
pc.outcode  # => "W1A"
pc.incode   # => "2AB"
pc.area     # => "W"
pc.district # => "1A"
pc.sector   # => "2"
pc.unit     # => "AB"
```

Or of a partial postcode:

```ruby
pc = UKPostcode.parse("W1A")
pc.valid?   # => true
pc.full?    # => false
pc.outcode  # => "W1A"
pc.incode   # => nil
pc.area     # => "W"
pc.district # => "1A"
pc.sector   # => nil
pc.unit     # => nil
```

Postcodes are converted to a normal or canonical form:

```ruby
pc = UKPostcode.parse("w1a1aa")
pc.valid?   # => true
pc.area     # => "W"
pc.district # => "1A"
pc.sector   # => "1"
pc.unit     # => "AA
pc.to_s     # => "W1A 1AA"
```

And mistakes with I/1 and O/0 are corrected:

```ruby
pc = UKPostcode.parse("WIA OAA")
pc.valid?   # => true
pc.area     # => "W"
pc.district # => "1A"
pc.sector   # => "0"
pc.unit     # => "AA
pc.to_s     # => "W1A 0AA"
```

Find the country of a full or partial postcode (if possible: some outcodes span
countries):

```ruby
UKPostcode.parse("W1A 1AA").country # => :england
UKPostcode.parse("BT4").country # => :northern_ireland
UKPostcode.parse("CA6").country # => :unknown
UKPostcode.parse("CA6 5HS").country # => :scotland
UKPostcode.parse("CA6 5HT").country # => :england
```

The country returned for a postcode is derived from the [ONS Postcode
Directory][onspd] and might not always be correct in a border region:

> Users should note that postcodes that straddle two geographic areas will be
> assigned to the area where the mean grid reference of all the addresses
> within the postcode falls.

Invalid postcodes:

```ruby
pc = UKPostcode.parse("Not Valid")
pc.valid?  # => false
pc.full?   # => false
pc.area    # => nil
pc.to_s    # => "Not valid"
pc.country # => :unknown
```

## Tips for Rails

You can normalise postcodes on assignment by overriding a setter method (this
assumes that you have a `postcode` field on the model):

```ruby
def postcode=(str)
  super UKPostcode.parse(str).to_s
end
```

Invalid postcodes are parsed to instances of `InvalidPostcode`, whose `#to_s`
method gives the original input, so an invalid postcode will be presented back
to the user as originally entered.

To validate, use something like this:

```ruby
class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    ukpc = UKPostcode.parse(value)
    unless ukpc.valid? && ukpc.full?
      record.errors[attribute] << "not recognised as a UK postcode"
    end
  end
end

class Address
  validates :postcode, presence: true, postcode: true
end
```

## For users of version 1.x

The interface has changed significantly, so code that worked with version 1.x
will not work with version 2.x without changes.

Specifically:

* Use `UKPostcode.parse(str)` where you previously used `UKPostcode.new(str)`.
* `parse` will return either a `GeographicPostcode`, a `GiroPostcode`, or an
  `InvalidPostcode`.
* You may prefer to use `GeographicPostcode.parse` directly if you wish to
  exclude `GIR 0AA` and invalid postcodes.

## As a gem

In your `Gemfile`:

```ruby
gem "uk_postcode", "~> 2.0.0.alpha"
```

## Testing

To run the test suite:

```sh
$ make
```

The full list of UK postcodes is not included in the repository due to its
size, but will be fetched automatically from [mySociety][mys].

If you are running an automatic build process, please find a way to cache these
files and run the tests via Rake instead:

```
$ rake
```

## Licensing

You may use this library according to the terms of the MIT License; see
COPYING.txt for details.

The regular expressions in `lookup.rb` are derived from the ONS Postcode
Directory according to the terms of the [Open Government
Licence][onspd-lic].

> Under the terms of the Open Government Licence (OGL) […] anyone wishing to
> use or re-use ONS material, whether commercially or privately, may do so
> freely without a specific application for a licence, subject to the
> conditions of the OGL and the Framework. Users reproducing ONS content must
> include a source accreditation to ONS.

In order to avoid the restrictive commercial terms of the Northern Ireland
data in the ONSPD, this is not used to generate the regular expressions.
Fortunately, Northern Ireland postcodes are very simple: they all start with
`BT`!

[mys]: http://parlvid.mysociety.org/os/
[onspd]: http://www.ons.gov.uk/ons/guide-method/geography/products/postcode-directories/-nspp-/index.html
[onspd-lic]: http://www.ons.gov.uk/ons/guide-method/geography/beginner-s-guide/licences/index.html
