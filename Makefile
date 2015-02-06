ONSPD_URL=http://parlvid.mysociety.org/os/ONSPD_MAY_2014_csv.zip

.PHONY: test clean

test: test/data/postcodes.csv lib/uk_postcode/country_lookup.rb
	rake

data/onspd.zip:
	mkdir -p data
	curl -L -o $@.tmp $(ONSPD_URL) && mv $@.tmp $@

data/onspd.csv: data/onspd.zip
	unzip -d data/onspd $^ && \
		cut -d, -f 1,15 data/onspd/Data/*.csv > $@.tmp
		mv $@.tmp $@

data/postcodes.csv: data/onspd.csv
	grep '[A-Z]' $^ | grep -v NPT | sort -uV > $@.tmp && mv $@.tmp $@

test/data/postcodes.csv: data/postcodes.csv
	mkdir -p test/data
	cp $< $@

lib/uk_postcode/country_lookup.rb: data/postcodes.csv
	ruby -I./lib tools/generate_country_lookup.rb $< > $@.tmp && mv $@.tmp $@

clean:
	rm -rf data test/data
