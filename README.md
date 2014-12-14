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

## Usage

```ruby
require "uk_postcode"
```

Validate and extract sections of a full postcode:

```ruby
pc = UKPostcode.new("W1A 2AB")
pc.valid?   #=> true
pc.full?    #=> true
pc.outcode  #=> "W1A"
pc.incode   #=> "2AB"
pc.area     #=> "W"
pc.district #=> "1A"
pc.sector   #=> "2"
pc.unit     #=> "AB"
```

Or of a partial postcode:

```ruby
pc = UKPostcode.new("W1A")
pc.valid?   #=> true
pc.full?    #=> false
pc.outcode  #=> "W1A"
pc.incode   #=> nil
pc.area     #=> "W"
pc.district #=> "1A"
pc.sector   #=> nil
pc.unit     #=> nil
```

Normalise postcodes with `normalize` (or just `norm`):

```ruby
UKPostcode.new("w1a1aa").normalize #=> "W1A 1AA"
```

Fix mistakes with IO/10:

```ruby
pc = UKPostcode.new("WIA OAA")
pc.outcode #=> "W1A"
pc.incode  #=> "0AA"
```

Find the country of a postcode or outcode (if possible: some outcodes span
countries):

```ruby
UKPostcode.new("W1A 1AA").country #=> :england
UKPostcode.new("BT4").country #=> :northern_ireland
UKPostcode.new("CA6").country #=> :unknown
UKPostcode.new("CA6 5HS").country #=> :scotland
UKPostcode.new("CA6 5HT").country #=> :england
```

The country returned for a postcode is derived from the [ONS Postcode
Directory][onspd] and might not always be correct in a border region:

> Users should note that postcodes that straddle two geographic areas will be
> assigned to the area where the mean grid reference of all the addresses
> within the postcode falls.

## As a gem

```sh
$ gem install uk_postcode
```

or in your `Gemfile`:

```ruby
gem "uk_postcode"
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
