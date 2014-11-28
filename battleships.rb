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
	for row in 0..(array.length - 1)
		if row == 0
			puts "  0 1 2 3 4 5 6 7 8 9".colorize(:red)
		end
		
		for column in 0..(array[row].length - 1)
			if column == 0
				print row.to_s.colorize(:red) + " "
			end
			print array[row][column] + " "
		end
		puts ""
	end
end

def main()
	puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	battleGrid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, "w") }
	
	draw_map(battleGrid)
		
end

main
