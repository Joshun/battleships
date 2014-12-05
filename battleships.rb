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
	end
	def get_type
		return @type
	end
	def get_size
		return @size
	end
end

class Tile
	def initialize()
		@type = :water
		@known = true
	end
	def makeKnown()
		@known = true
	end
	def setType(type)
		@type = type
	end
	def getType()
		return @type
	end
	def isKnown()
		return @known
	end
end

class Board
	def initialize(size, border_colour)
		@size = size
		@border_colour = border_colour
		@tiles = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { Tile.new } }
	end

	def draw()

		# Print top border (0-9)
		print "  "
		(0..@size - 1).each do |num|
			print num.to_s.colorize(@border_colour) + " "
		end
		puts

		# Print array contents
		(0..(@tiles.length - 1)).each do |row|
			(0..(@tiles[row].length - 1)).each do |column|
				# Print left border (0-9)
				if column == 0
					print row.to_s.colorize(@border_colour) + " "
				end
				
				if @tiles[column][row].isKnown
					#print array[column][row][:tile]
					print mapsymbol_to_string(@tiles[column][row].getType) + " "
				else
					print "* "
				end
			end
			puts
		end
	end

	def arrange_ships(ships)
		while(! try_arrange_ships(ships) ) #Keep trying to arrange ships, scrapping board and retrying upon failure
			scrap_all
		end
	end

	def fire(coordinates)
		x_coord = coordinates[0]
		y_coord = coordinates[1]
		tile = @tiles[x_coord][y_coord]
		tile.makeKnown
		
		if tile.getType == :water
			puts "Miss"
		else
			puts "Hit"
		end
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
		end_column = start_column + size - 1
		(start_column..end_column).each do |index|
			if @tiles[index][row].getType != :water
				return false
			end
		end
		return true
	end

	private
	def check_clear_column(column, start_row, size)
		end_row = start_row + size - 1
		(start_row..end_row).each do |index|
			if @tiles[column][index].getType != :water
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
			add_horizontal_ship(coordinates[:x], coordinates[:x] + ship_size - 1, coordinates[:y])
		elsif direction == :vertical
			coordinates = get_random_coordinates(GRID_SIZE - 1, GRID_SIZE - ship_size)
			if( ! check_clear_column(coordinates[:x], coordinates[:y], ship_size) )
				return false
			end
			add_vertical_ship(coordinates[:y], coordinates[:y] + ship_size - 1, coordinates[:x])
		end
		return true
	end
	
	private
	def try_arrange_ships(ships)
		ships.each do |ship|
			ship_name = ship.get_type
			ship_size = ship.get_size
			ship_positioned = false
			(0..MAX_SHIP_ATTEMPTS).each do |i| #Give up if cannot position ship
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
		(start_x..end_x).each do |column|
			@tiles[column][row].setType(:ship)
		end
	end

	private
	def add_vertical_ship(start_y, end_y, column)
		(start_y..end_y).each do |row|
			@tiles[column][row].setType(:ship)
		end
	end

	private
	def scrap_all()
		@tiles.each do |i|
			i.each do |j|
				j.setType(:water)
			end
		end
	end

end


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

def get_input()
	begin
		print "Coordinates: "
		input_string = gets.chomp.delete(" ")
		coordinate_strings = input_string.split(",")

		coordinates = Array.new
		coordinates[0] = coordinate_strings[0].to_i
		coordinates[1] = coordinate_strings[1].to_i
		
		if coordinate_strings[0] == nil || coordinate_strings[1] == nil
			null_string = true
		else
			null_string = false
		end
		
	end until check_valid_position(coordinates[0], coordinates[1]) && ! null_string
	
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
	
	boardmap = Board.new(10, :green)
	boardmap.arrange_ships(ships)
	boardmap.draw
	
	coordinates = get_input
	boardmap.fire coordinates
	boardmap.draw
end

main
