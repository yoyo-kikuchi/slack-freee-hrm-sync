.PHONY: run

run:
	# export RAILS_ENV=production
	bin/rails server

run_dev:
	# export RAILS_ENV=development
	bin/rails server -b 0.0.0.0
