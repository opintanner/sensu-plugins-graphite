#!/usr/bin/env ruby
#
# Graphite
# ===
#
# DESCRIPTION:
#   This mutator is an extension of the OnlyCheckOutput mutator, but
#   modified for Graphite metrics. This mutator only sends event output
#   (so you don't need to use OnlyCheckOutput) and it also modifies
#   the format of the hostname in the output if present.
#
# OUTPUT:
#   Sensu event output with all dots changed to underlines in hostname and sensu. prepended.
#
#   If -r or --reverse parameter given script put hostname in reverse order
#   for better graphite tree view
#
#
# PLATFORM:
#   all
#
# DEPENDENCIES:
#   none
#
# Copyright 2013 Peter Kepes <https://github.com/kepes>
# Copyright 2015 Miika Kankare <https://github.com/opintanner>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.
require 'json'

# parse event
event = JSON.parse(STDIN.read, symbolize_names: true)

check_output = event[:check][:output]
if ARGV[0] == '-r' || ARGV[0] == '--reverse'
  check_output = check_output.gsub(event[:client][:name], event[:client][:name].split('.').reverse.join('.'))
else
  check_output = check_output.gsub(event[:client][:name], event[:client][:name].gsub('.', '_'))
end

# Prepend sensu.
puts check_output.split("\n").map{ |line| "sensu.#{line}" }
