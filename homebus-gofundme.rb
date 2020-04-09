#!/usr/bin/env ruby

require './options'
require './app'

gofundme_app_options = GoFundMeHomebusAppOptions.new

gofundme = GoFundMeHomebusApp.new gofundme_app_options.options
gofundme.setup!
gofundme.work!
#gofundme.run!
