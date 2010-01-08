uk_postcode
===========

UK postcode parsing and validation for Ruby.

Usage
-----

    require "uk_postcode"

Validate and extract sections of a full postcode:

    pc = UKPostcode.new("W1A 1AA")
    pc.valid?  #=> true
    pc.full?   #=> true
    pc.outcode #=> "W1A"
    pc.incode  #=> "1AA"

Or of a partial postcode:

    pc = UKPostcode.new("W1A")
    pc.valid?  #=> true
    pc.full?   #=> false
    pc.outcode #=> "W1A"
    pc.incode  #=> nil

Normalise postcodes:

    UKPostcode.new("w1a1aa").norm #=> "W1A 1AA"

Fix mistakes with IO/10:

    pc = UKPostcode.new("WIA OAA")
    pc.outcode #=> "W1A"
    pc.incode  #=> "0AA"

Gem?
----

    gem install uk_postcode
