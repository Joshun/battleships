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

class Ship
	def initialize(type, quantity, size)
		@type = type
		@quantity = quantity
		@size = size
	end
	def get_type
		return @type
	end
	def get_quantity
		return @quantity
	end
	def get_size
		return @size
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

def horizontal_or_vertical()
	if rand(0..1) == 0
		return :horizontal
	else
		return :vertical
	end
end



def check_clear_row(grid, row, start_column, size)
	end_column = start_column + size - 1

	(start_column..end_column).each do |index|
		if grid[row][index][:tile] != :water
			return false
		end
	end
	return true
end

def check_clear_column(grid, column, start_row, size)
	end_row = start_row + size - 1

	(start_row..end_row).each do |index|
		puts "hello"
		if grid[index][column][:tile] != :water
			return false
		end
	end
	return true
end

def arrange_ships(ships)
	ships.each do |ship_type|
		ship_name = ship_type.get_type
		ship_quantity = ship_type.get_quantity
		ship_size = ship_type.get_size
		
		(0..ship_quantity - 1).each do |ship|
			direction = horizontal_or_vertical
			
		end
	end
end
	

def main()
	puts "Creating new battleship grid of (" + GRID_SIZE.to_s + "x" + GRID_SIZE.to_s + ") squares."
	# Create new array to store battleships
	# Each array element is a hash with a tile value (water or ship) and a known value (true or false)
	battleGrid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, {:tile=>:water, :known=>false} ) }
	
	draw_map(battleGrid, :green)
	
	ships = [];
	ships.push(Ship.new("aircraft_carrier", 1, 5))
	ships.push(Ship.new("cruiser", 1, 4))
	ships.push(Ship.new("destroyer", 2, 3))
	ships.push(Ship.new("submarines", 1, 2))
	arrange_ships(ships)
		
end

main
