#!/usr/bin/env ruby
require './require/beta.rb'

begin
	if ARGV.length == 3
		puts "Chaining #{ARGV[0]} to #{ARGV[1]} with #{ARGV[2]} as last:"
		names = []
		values = []
		last = 0

		file = File.open ARGV[2] + ".asm.names", 'r'
		file.each do |line|
			puts "\t-Adding names..."
			names.push line.chomp
		end

		file = File.open ARGV[2] + ".asm.values", 'r'
		file.each do |line|
			puts "\t-Adding values..."
			values.push line.chomp.to_i
		end

		file = File.open ARGV[2] + ".asm.last", 'r'
		file.each do |line|
			puts "\t-Getting value of last"
			last = line.to_i
		end

		file.close

		Spreader.new ARGV[0], ARGV[1], "FLBL" + (last - 1).to_s, last, names, values
	else
		puts "Spreading file into assembly..."
		Spreader.new ARGV[0], ARGV[1]
	end
rescue Exception => e
	abort "USAGE: ./exec.rb <INPUT> <OUTPUT> [<PREVIOUS>]"
end
