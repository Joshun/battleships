# Battleships
#
# Joshua O'Leary
# Assignment 2
# 12/2014
# University of Sheffield

require "colorize"

require_relative "tile"
require_relative "ship"
require_relative "board"

GRID_SIZE = 10 #Width and height of grid
MAX_SHIP_ATTEMPTS = 5 #Maximum number of times to try ship positioning before giving up

# Types of ships [ ship_name: [quantity, size] ]
SHIP_TYPES = [ aircraft_carrier: [1, 5], cruiser: [1, 4], destroyer: [2, 3], submarine: [1, 2] ]

def print_coloured(str, colour)
	puts str.colorize(colour)
end

def check_valid_position(xcoord, ycoord)
	if xcoord >= GRID_SIZE || xcoord < 0
		return false
	elsif ycoord >= GRID_SIZE || ycoord < 0
		return false
	else
		return true
	end
end

def get_input(board)
	begin
		print "Coordinates (x,y): "
		input_string = gets.chomp.delete(" ")
		coordinate_strings = input_string.split(",")

		coordinates = Array.new
		coordinates[0] = coordinate_strings[0].to_i
		coordinates[1] = coordinate_strings[1].to_i
		
		hit_already = false
		valid_coords = check_valid_position(coordinates[0], coordinates[1])
		
		if coordinate_strings[0] == nil || coordinate_strings[1] == nil || hit_already
			null_string = true
		else
			null_string = false
		end
		
		if valid_coords && ! null_string
			hit_already = board.get_square_known_status(coordinates)
		end
		
		if hit_already
			puts "You already shot at that square"
		end
		
	end until valid_coords && ! null_string && ! hit_already
	
	return coordinates
end


def main()

	# Print welcome message
	title = "Battleships"
	underline = "=" * title.length
	puts title
	puts underline
	puts

	#puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	# Create new array to store battleships
	# Each array element is a hash with a tile value (water or ship) and a known value (true or false)
	
	ships = []
	ships.push(Ship.new("aircraft carrier", 5))
	ships.push(Ship.new("cruiser", 4))
	ships.push(Ship.new("destroyer", 3))
	ships.push(Ship.new("destroyer", 3))
	ships.push(Ship.new("submarine", 2))
	
	boardmap = Board.new(GRID_SIZE, :green)
	boardmap.arrange_ships(ships)
	boardmap.draw
	
	attempts = 0
	while boardmap.ships_remaining
		coordinates = get_input(boardmap)
		boardmap.fire coordinates, ships
		boardmap.draw
		attempts += 1
	end
	
	puts "Well done, you completed the game! You took " + attempts.to_s + " attempts."
end

main
