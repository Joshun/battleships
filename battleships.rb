# Battleships
#
# Joshua O'Leary
# Assignment 2
# 12/2014
# University of Sheffield

require "colorize"


GRID_SIZE = 10

# Types of ships [ ship_name: [quantity, size] ]
SHIP_TYPES = [ aircraft_carrier: [1, 5], cruiser: [1, 4], destroyer: [2, 3], submarine: [1, 2] ]

def print_coloured(str, colour)
	puts str.colorize(colour)
end

def check_valid_position(xcoord, ycoord)
	if xcoord > GRID_SIZE || xcoord < 0
		return false
	elsif ycoord > GRID_SIZE || ycoord < 0
		return false
	else
		return true
	end
end

def mapsymbol_to_string(msymbol)
	case msymbol
		when :water
			return "w".colorize(:background => :light_blue)
		when :ship
			return "s".colorize(:background => :red)
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
			if array[row][column][:known]
				print mapsymbol_to_string(array[row][column][:tile]) + " "
			else
				print "* "
			end
		end
		puts
	end
end

def main()
	puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	# Create new array to store battleships
	# Each array element is a hash with a tile value (water or ship) and a known value (true or false)
	battleGrid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, {:tile=>:water, :known=>false} ) }
	
	draw_map(battleGrid, :green)
		
end

main
