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

def mapsymbol_to_string(msymbol)
	case msymbol
		when :water
			return "w"
		when :ship
			return "s"
		else
			return " "
	end
end

def draw_map(array, border_colour)

	# Print top border (0-9)
	print "  "
	(0..9).each do |num|
		print num.to_s.colorize(border_colour) + " "
	end
	puts

	# Print array contents
	for row in 0..(array.length - 1)
		for column in 0..(array[row].length - 1)
			if column == 0
				print row.to_s.colorize(border_colour) + " "
			end
			# Print left border (0-9)
			print mapsymbol_to_string(array[row][column]) + " "
		end
		puts
	end
end

def main()
	puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	battleGrid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, :water) }
	
	draw_map(battleGrid, :red)
		
end

main
