# uk_postcode

UK postcode parsing and validation for Ruby.
I've checked it against every postcode I can get my hands on: that's about 1.8
million of them.

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

## Gem?

```sh
$ gem install uk_postcode
```

## Testing

To run the test suite:

```sh
$ rake
```

The full list of UK postcodes is not included in the repository due to its
size.
Additional sample files under `test/samples` will automatically be used.

The format of each line in a sample file must be `OOOOIII` or `OOO III` (where
`O` = outcode, `I` = incode), e.g.:

```
AB1 0AA
BT109AH
```

You can obtain lists of postcodes by processing various datasets available
from [mySociety][mys].

### Code-Point Open

This does not include postcodes for Northern Ireland, the Channel Islands,
or the Isle of Man.

```sh
$ cut -c 2-8 Data/CSV/*.csv | \
sort -uV > test/samples/large/code_point_open.list
```

### ONS Postcode Directory

This includes postcodes for the whole UK as well as the Channel Islands and the
Isle of Man.
It also includes some defunct postcodes, most notably the NPT outcode, which
must be filtered out.

```sh
$ cut -c 2-8 ONSPD_*.csv | grep '[A-Z]' | grep -v ^NPT | \
sort -uV > test/samples/large/onspd.list
```

[mys]: http://parlvid.mysociety.org/os/
