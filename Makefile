all:

.SECONDARY:

data/iso3166.json:
	scripts/iso3166.py

data/iso4217.json: data/iso3166.json
	scripts/iso4217.py

data/statoids.json: data/iso3166.json data/iso4217.json
	scripts/statoids.py

data/country-codes.json: data/statoids.json
	scripts/flatten.py
	cp data/statoids-flat.json data/country-codes.json

country-codes.csv: data/country-codes.json
	in2csv data/country-codes.json > data/country-codes.csv
	csvcut -c "official_name_en","official_name_fr","ISO3166-1-Alpha-2","ISO3166-1-Alpha-3","ISO3166-1-numeric","ITU","MARC","WMO","DS","Dial","FIFA","FIPS","GAUL","IOC","ISO4217-currency_alphabetic_code","ISO4217-currency_country_name","ISO4217-currency_minor_unit","ISO4217-currency_name","ISO4217-currency_numeric_code","is_independent" data/country-codes.csv > data/country-codes-reordered.csv
	mv data/country-codes-reordered.csv data/country-codes.csv
	scripts/cldr.py

clean:
	@rm data/*.json
	@rm data/country-codes.csv