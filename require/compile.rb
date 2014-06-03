#!/usr/bin/env ruby

require './require/lexer.rb'

def number? str
	i = 0
	while i < str.length
		if (str[i].chr > '9') or (str[i].chr < '0')
			return false
		end

		i += 1
	end

	return true
end

begin
	lex = Lexer.new ARGV[0]
	stream = lex.final
	@output = ""

	index = 0
	while index < stream.length
		if stream[index] == ":"
			@output += "{ #{stream[index + 1]}\n"
			index += 1
		elsif stream[index] == ";"
			@output += "}"
		elsif stream[index][0].chr == ":"
			@output += "N #{stream[index][1...stream[index].length]}:\n"
		elsif stream[index] == "GOTO"
			@output += "NT GOTO #{stream[index + 1]}\n"
			index += 1
		elsif stream[index] == "ZGOTO"
			@output += "NT GET_STATUS\n"
			@output += "NT ZGOTO #{stream[index + 1]}\n"
			index += 1
		elsif stream[index] == "NZGOTO"
			@output += "NT GET_STATUS\n"
			@output += "NT NZGOTO #{stream[index + 1]}\n"
			index += 1
		elsif number? stream[index]
			@output += "NT MOV AX, #{stream[index]}\n"
			@output += "NT CALL 0:CPUSHF\n"
		else
			@output += "NT FWORD #{stream[index]}\n"
		end

		index += 1
	end

	file = File.new ARGV[1], "w"
	file.puts @output
	file.close
rescue Exception => e
	abort "Syntax error or invalid file\nUSAGE: compile INPUT OUTPUT"
end
