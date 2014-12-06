# Battleships
#
# Joshua O'Leary
# Assignment 2
# 12/2014
# University of Sheffield

require "colorize"


GRID_SIZE = 10 #Width and height of grid
MAX_SHIP_ATTEMPTS = 5 #Maximum number of times to try ship positioning before giving up

# Types of ships [ ship_name: [quantity, size] ]
SHIP_TYPES = [ aircraft_carrier: [1, 5], cruiser: [1, 4], destroyer: [2, 3], submarine: [1, 2] ]

class Ship
	def initialize(type, size)
		@type = type
		@size = size
		@squares_left = size

		@position = nil
		@start_x = nil
		@end_x = nil
		@column = nil
		@start_y = nil
		@end_y = nil
		@row = nil
	end
	def get_type
		return @type
	end
	def get_size
		return @size
	end
	def set_squares_horizontal(start_x, end_x, row)
		@position = :horizontal
		@start_x = start_x
		@end_x = end_x
		@row = row
	end
	def set_squares_vertical(start_y, end_y, column)
		@position = :vertical
		@start_y = start_y
		@end_y = end_y
		@column = column
	end
	
	def see_if_hit(coordinates)
		x_coord = coordinates[0]
		y_coord = coordinates[1]
		
		if @position == :horizontal		
			if (x_coord >= @start_x) && (x_coord <= @end_x ) && (y_coord == @row)
				if reduce_squares
					return :sunk
				else
					return :hit
				end
			end
		else
			if (y_coord >= @start_y) && (y_coord <= @end_y) && (x_coord == @column)
				if reduce_squares
					return :sunk
				else
					return :hit
				end
			end
		end
		return :failed
	end

	private
	def reduce_squares
		if @squares_left > 1
			@squares_left -= 1
			return false
		else
			return true
		end
	end	
end

class Tile
	def initialize()
		@type = :water
		@known = false
	end
	def make_known()
		@known = true
	end
	def set_type(type)
		@type = type
	end
	def get_type()
		return @type
	end
	def is_known()
		return @known
	end
end

class Board
	def initialize(size, border_colour)
		@size = size
		@border_colour = border_colour
		@tiles = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { Tile.new } }
		@ships_left = 0
	end

	def draw()

		# Print top border (0-9)
		print "  "
		(0...@size).each do |num|
			print num.to_s.colorize(@border_colour) + " "
		end
		puts

		# Print array contents
		(0...(@tiles.length)).each do |row|
			(0...(@tiles[row].length)).each do |column|
				# Print left border (0-9)
				if column == 0
					print row.to_s.colorize(@border_colour) + " "
				end
				
				if @tiles[column][row].is_known
					#print array[column][row][:tile]
					print mapsymbol_to_string(@tiles[column][row].get_type) + " "
				else
					print "* "
				end
			end
			puts
		end
	end

	def arrange_ships(ships)
		#Get number of ship squares
		total_ship_squares = 0
		ships.each do |ship|
			total_ship_squares += ship.get_size
		end
		@ship_squares = total_ship_squares
		
		@ships_left = ships.length
		
		while(! try_arrange_ships(ships) ) #Keep trying to arrange ships, scrapping board and retrying upon failure
			scrap_all
		end
	end

	def fire(coordinates, ships)
		x_coord = coordinates[0]
		y_coord = coordinates[1]
		tile = @tiles[x_coord][y_coord]
		tile.make_known
		
		#~ if tile.get_type == :water
			#~ puts "Miss"
		#~ else
			#~ puts "Hit"
			#~ @ship_squares_hit += 1
		#~ end
		
		try_fire_ship(coordinates, ships)
	end
	
	def ships_remaining
		if @ships_left > 0
			return true
		else
			return false
		end
	end

	def get_square_known_status(coordinates)
		return @tiles[coordinates[1]][coordinates[0]].is_known
	end

	private
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

	private
	def get_random_coordinates(x_max, y_max)
		x_coord = rand(0..x_max)
		y_coord = rand(0..y_max)
		
		return { x: x_coord, y: y_coord }
	end

	private
	def horizontal_or_vertical()
		if rand(0..1) == 0
			return :horizontal
		else
			return :vertical
		end
	end

	private
	def check_clear_row(row, start_column, size)
		end_column = start_column + size
		(start_column...end_column).each do |index|
			if @tiles[index][row].get_type != :water
				return false
			end
		end
		return true
	end

	private
	def check_clear_column(column, start_row, size)
		end_row = start_row + size
		(start_row...end_row).each do |index|
			if @tiles[column][index].get_type != :water
				return false
			end
		end
		return true
	end

	private
	def try_add_ship(ship, ship_size)
		direction = horizontal_or_vertical
		if direction == :horizontal
			coordinates = get_random_coordinates(GRID_SIZE - ship_size, GRID_SIZE - 1)
			if( ! check_clear_row(coordinates[:y], coordinates[:x], ship_size) )
				return false
			end
			add_horizontal_ship(coordinates[:x], coordinates[:x] + ship_size, coordinates[:y])
			ship.set_squares_horizontal(coordinates[:x], coordinates[:x] + ship_size - 1, coordinates[:y])
		elsif direction == :vertical
			coordinates = get_random_coordinates(GRID_SIZE - 1, GRID_SIZE - ship_size)
			if( ! check_clear_column(coordinates[:x], coordinates[:y], ship_size) )
				return false
			end
			add_vertical_ship(coordinates[:y], coordinates[:y] + ship_size, coordinates[:x])
			ship.set_squares_vertical(coordinates[:y], coordinates[:y] + ship_size - 1, coordinates[:x])
		end
		return true
	end
	
	private
	def try_arrange_ships(ships)
		ships.each do |ship|
			ship_name = ship.get_type
			ship_size = ship.get_size
			ship_positioned = false
			(0...MAX_SHIP_ATTEMPTS).each do |i| #Give up if cannot position ship
				if try_add_ship(ship, ship_size)
					ship_positioned = true
					break
				end
			end
			if ! ship_positioned #Unable to position ship - need to scrap board and try again
				return false
			end
		end
		return true #Assume all ships have been positioned correctly
	end

	private
	def add_horizontal_ship(start_x, end_x, row)
		(start_x...end_x).each do |column|
			@tiles[column][row].set_type(:ship)
		end
	end

	private
	def add_vertical_ship(start_y, end_y, column)
		(start_y...end_y).each do |row|
			@tiles[column][row].set_type(:ship)
		end
	end

	private
	def scrap_all()
		@tiles.each do |i|
			i.each do |j|
				j.set_type(:water)
			end
		end
	end
	
	private
	def try_fire_ship(coordinates, ships)
		ships.each do |ship|
			ship_status = ship.see_if_hit(coordinates)
			if ship_status == :hit
				puts "You hit the " + ship.get_type
				return
			elsif ship_status == :sunk
				puts "You sunk the " + ship.get_type
					if @ships_left >= 1
						@ships_left -= 1
					end
				return
			end
		end
		print "You missed"
		if shot_was_close(coordinates)
			puts "...your shot was very close!"
		else
			puts
		end
	end
	
	private
	def shot_was_close(coordinates)
		x_coord = coordinates[0]
		y_coord = coordinates[1]
		
		if x_coord > 0 && ! @tiles[y_coord][x_coord - 1].is_known
			left_square = @tiles[y_coord][x_coord - 1].get_type
		else
			left_square = :water
		end
		
		if x_coord < GRID_SIZE - 1 && ! @tiles[y_coord][x_coord + 1].is_known
			right_square = @tiles[y_coord][x_coord + 1].get_type
		else
			right_square = :water
		end
		
		if y_coord > 0 && ! @tiles[y_coord - 1][x_coord].is_known
			top_square = @tiles[y_coord - 1][x_coord].get_type
		else
			top_square = :water
		end
		
		if y_coord < GRID_SIZE - 1 && ! @tiles[y_coord + 1][x_coord].is_known
			bottom_square = @tiles[y_coord + 1][x_coord].get_type
		else
			bottom_square = :water
		end
		
		if left_square == :ship || right_square == :ship || top_square == :ship || bottom_square == :ship
			return true
		else
			return false
		end
	end
end


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
		print "Coordinates: "
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
		
	end until valid_coords && ! null_string && ! hit_already
	
	return coordinates
end


def main()
	puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	# Create new array to store battleships
	# Each array element is a hash with a tile value (water or ship) and a known value (true or false)
	
	ships = []
	ships.push(Ship.new("aircraft_carrier", 5))
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
