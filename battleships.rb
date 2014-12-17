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

# Function to check if the given coordinates are within the allowable range
def check_valid_position(xcoord, ycoord)
	if xcoord >= GRID_SIZE || xcoord < 0
		return false
	elsif ycoord >= GRID_SIZE || ycoord < 0
		return false
	else
		return true
	end
end

# Function to get user input, validate it and split it into two coordinates
def get_input(board)
	begin
		print "Coordinates (x,y): "
		input_string = gets.chomp.delete(" ") # Get a new string of user input, remove newline and spaces
		coordinate_strings = input_string.split(",") # Split input into x and y values by comma separation
		
		# If the string length is zero, skip the rest of the code block and try again
		if coordinate_strings.length == 0
			next
		end

		coordinates = Array.new
		coordinates[0] = coordinate_strings[0].to_i
		coordinates[1] = coordinate_strings[1].to_i
		
		valid_coords = check_valid_position(coordinates[0], coordinates[1])
		
		# See if string could be converted to integer or not
		if coordinate_strings[0] == nil || coordinate_strings[1] == nil
			null_string = true
		else
			null_string = false
		end
		
		hit_already = false
		if valid_coords && ! null_string
			hit_already = board.get_square_known_status(coordinates)
		end
		
		if hit_already
			puts "You already shot at that square"
		end
		# Keep looping until the user enters valid input - the function's job is to only 
		# return coordinates that are valid
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
	
	# Create a new array of ships 
	ships = [ 
		Ship.new("aircraft carrier", 5),
		Ship.new("cruiser", 4),
		Ship.new("destroyer", 3),
		Ship.new("destroyer", 3),
		Ship.new("submarine", 2)
	]
	
	# Create new Board instance to manage the location of ship and water tiles
	# (:green is the colour of the grid's coordinate lines)
	boardmap = Board.new(GRID_SIZE, :green)
	boardmap.arrange_ships(ships)
	boardmap.draw()
	
	# Keep requesting input, firing using that input and redrawing the board, until all the ships
	# have been eliminated.
	attempts = 0
	while boardmap.ships_remaining()
		coordinates = get_input(boardmap)
		boardmap.fire(coordinates, ships)
		boardmap.draw()
		attempts += 1
	end
	
	# End of game - print out how many attempts the player took to complete it
	puts "Well done, you completed the game! You took " + attempts.to_s + " attempts."
end

main
