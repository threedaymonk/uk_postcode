uk_postcode
===========

UK postcode parsing and validation for Ruby.
I've checked it against every postcode I can get my hands on: that's about 1.8
million of them.

Usage
-----

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

Gem?
----

```sh
$ gem install uk_postcode
```

Testing
-------

The full list of UK postcodes is not included in the repository due to its
size.

To test against the full UK postcode set, you need to obtain the
[Code-Point® Open data set][cpo] from Ordnance Survey, unzip it, and extract
a list of postcodes:

```sh
$ cut -c 2-8 Data/CSV/*.csv | sort -uV > test/samples/code_point_open.list
```

[cpo]: https://www.ordnancesurvey.co.uk/opendatadownload/products.html
