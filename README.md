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

**Note**: There's a distinction between validity and existence. This library
validates the *format* of a postcode, but not whether it actually currently
refers to a location.

By analogy, `name@somedomainthatdoesnotexist.com` is a valid email address in
terms of format, but you can't successfully deliver an email to it.

## Usage

```ruby
require "uk_postcode"
```

Parse and extract sections of a full postcode:

```ruby
pc = UKPostcode.parse("W1A 2AB")
pc.valid?      # => true
pc.full?       # => true
pc.full_valid? # => true
pc.outcode     # => "W1A"
pc.incode      # => "2AB"
pc.area        # => "W"
pc.district    # => "1A"
pc.sector      # => "2"
pc.unit        # => "AB"
```

Or of a partial postcode:

```ruby
pc = UKPostcode.parse("W1A")
pc.valid?      # => true
pc.full?       # => false
pc.full_valid? # => false
pc.outcode     # => "W1A"
pc.incode      # => nil
pc.area        # => "W"
pc.district    # => "1A"
pc.sector      # => nil
pc.unit        # => nil
```

Postcodes are converted to a normal or canonical form:

```ruby
pc = UKPostcode.parse("w1a1aa")
pc.valid?      # => true
pc.area        # => "W"
pc.district    # => "1A"
pc.sector      # => "1"
pc.unit        # => "AA
pc.to_s        # => "W1A 1AA"
```

And mistakes with I/1 and O/0 are corrected:

```ruby
pc = UKPostcode.parse("WIA OAA")
pc.valid?      # => true
pc.area        # => "W"
pc.district    # => "1A"
pc.sector      # => "0"
pc.unit        # => "AA
pc.to_s        # => "W1A 0AA"
```

Invalid postcodes:

```ruby
pc = UKPostcode.parse("Not Valid")
pc.valid?      # => false
pc.full?       # => false
pc.full_valid? # => false
pc.area        # => nil
pc.to_s        # => "Not valid"
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
    unless ukpc.full_valid?
      record.errors.add(attribute, "not recognised as a UK postcode")
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
gem "uk_postcode", "~> 2.1.0"
```

## Testing

To run the test suite:

```sh
$ rake
```

The full list of UK postcodes is not included in the repository due to its
size, but will be fetched automatically from [mySociety][mys].

If you are running an automatic build process, please find a way to cache these
files between runs.

## Occasionally asked questions

### Does it support Father Christmas's postcode?

No. The old postcode was SAN TA1; the current one is [XM4 5HQ][santa].
(XMAS HQ, geddit?)
For most people, these probably aren't useful, as they don't correspond to
actual locations, and are only used by Royal Mail internally.

See "Adding additional formats" if you'd like to support this.

### Does it support BFPO?

No. They're not really postcodes, though they serve a similar purpose.
Some of them are abroad; some of them are on boats that move around; some of
them are ephemeral and exist only for particular operations.
This library has been designed with the assumption that most people won't want
to handle BFPO codes, and that those that do can do so explicitly.

See "Adding additional formats" if you'd like to support them.

The new [BF1 format][bfpo] postcodes *can* be parsed, although their location
is always unknown.

## Adding additional formats

Parsing is implemented via the `ParserChain` class, which attempts to parse
the supplied text via each parser in turn.
The `UKPostcode.parse` method is effectively a thin wrapper that does this:

```ruby
ParserChain.new(GiroPostcode, GeographicPostcode, InvalidPostcode)
  .parse(str)
```

Each class passed to `ParserChain.new` must implement a class method
`parse(str)` and return either a postcode object (see `AbstractPostcode`) or
nil.
The first non-nil object is returned.

`InvalidPostcode` is at the end of the chain to ensure that a postcode object
is always returned.

To add an additional class, subclass `AbstractPostcode`, implement the abstract
methods, and instantiate your own `ParserChain`.

## Licensing

You may use this library according to the terms of the MIT License; see
COPYING.txt for details.

[bfpo]: https://www.gov.uk/government/publications/british-forces-post-office-locations
[mys]: http://parlvid.mysociety.org/os/
[santa]: http://services.royalmail.com/santa-schools
