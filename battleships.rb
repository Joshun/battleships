# Battleships
#
# Joshua O'Leary
# Assignment 2
# 12/2014
# University of Sheffield

require "colorize"


GRID_SIZE = 10

def print_coloured(str, colour)
	puts str.colorize(colour)
end


def draw_map(array)
	array.each do |row|
		row.each do |column|
			print column
		end
		puts ""
	end
end

def main()
	puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	battleGrid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, 0) }
	
	draw_map(battleGrid)
		
end

main
