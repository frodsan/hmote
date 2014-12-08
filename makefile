.PHONY: test

gem:
	gem build hmote.gemspec

test:
	cutest test/*.rb
