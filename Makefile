ONSPD_URL=http://parlvid.mysociety.org/os/ONSPD_MAY_2014_csv.zip
CODEPOINT_URL=http://parlvid.mysociety.org/os/codepo_gb-2014-11.zip

.PHONY: test

test: test/data/postcodes.csv lib/uk_postcode/country/lookup.rb
	rake

data/onspd.zip:
	mkdir -p data
	curl -L -o $@.tmp $(ONSPD_URL) && mv $@.tmp $@

data/codepoint.zip:
	mkdir -p data
	curl -L -o $@.tmp $(CODEPOINT_URL) && mv $@.tmp $@

data/onspd.csv: data/onspd.zip
	unzip -d data/onspd $^ && \
		cut -d, -f 1,15 data/onspd/Data/*.csv > $@

data/codepoint.csv: data/codepoint.zip
	unzip -d data/codepoint $^ && \
		cut -d, -f1,5 data/codepoint/Data/CSV/*.csv > $@

data/postcodes.csv: data/onspd.csv data/codepoint.csv
	cat $^ | grep '[A-Z]' | grep -v NPT | sort -uV > $@

test/data/postcodes.csv: data/postcodes.csv
	mkdir -p test/data
	cp $< $@

lib/uk_postcode/country/lookup.rb: data/postcodes.csv
	ruby -I./lib tools/generate_country_lookup.rb $< > $@
