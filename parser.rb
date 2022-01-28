#!/usr/bin/env ruby

require 'table_print'
require File.dirname(__FILE__) + '/lib/' + 'log_parser.rb'

abort 'ERROR: Missing argument' unless ARGV[0]
parser = LogParser.new(ARGV[0])
result = parser.parse
abort parser.message  unless parser.success?

tp result
