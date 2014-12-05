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

#~ class Ship
	#~ def initialize(type, quantity, size)
		#~ @type = type
		#~ @quantity = quantity
		#~ @size = size
	#~ end
	#~ def get_type
		#~ return @type
	#~ end
	#~ def get_quantity
		#~ return @quantity
	#~ end
	#~ def get_size
		#~ return @size
	#~ end
#~ end

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

class Board
	def initialize(size)
		@size = size
		@tiles = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { {:tile=>:water, :known=>true} } }
	end

	def draw(border_colour)

		# Print top border (0-9)
		print "  "
		(0..@size - 1).each do |num|
			print num.to_s.colorize(border_colour) + " "
		end
		puts

		# Print array contents
		(0..(@tiles.length - 1)).each do |row|
			(0..(@tiles[row].length - 1)).each do |column|
				# Print left border (0-9)
				if column == 0
					print row.to_s.colorize(border_colour) + " "
				end
				
				if @tiles[column][row][:known]
					#print array[column][row][:tile]
					print self.mapsymbol_to_string(@tiles[column][row][:tile]) + " "
				else
					print "* "
				end
			end
			puts
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

	def get_random_coordinates(x_max, y_max)
		x_coord = rand(0..x_max)
		y_coord = rand(0..y_max)
		
		return { x: x_coord, y: y_coord }
	end


	def horizontal_or_vertical()
		if rand(0..1) == 0
			return :horizontal
		else
			return :vertical
		end
	end

	def check_clear_row(row, start_column, size)
		end_column = start_column + size - 1
		i = 0
		(start_column..end_column).each do |index|
			puts i
			i += 1
			if @tiles[index][row][:tile] != :water
				return false
			end
		end
		return true
	end

	def check_clear_column(column, start_row, size)
		end_row = start_row + size - 1
		i = 0
		(start_row..end_row).each do |index|
			puts i
			i += 1
			if @tiles[column][index][:tile] != :water
				return false
			end
		end
		return true
	end

	def try_arrange_ships(ships)
		shipnum = 0
		ships.each do |ship|
			ship_name = ship.get_type
			ship_size = ship.get_size
			puts shipnum
			direction = self.horizontal_or_vertical
			if direction == :horizontal
				coordinates = self.get_random_coordinates(GRID_SIZE - ship_size, GRID_SIZE - 1)
				if( ! self.check_clear_row(coordinates[:y], coordinates[:x], ship_size) )
					return false
				end
				puts ship_name + " start " + coordinates[:x].to_s + ":" + coordinates[:y].to_s + " end " + (coordinates[:x] + ship_size - 1).to_s + ":" + coordinates[:y].to_s
				add_horizontal_ship(coordinates[:x], coordinates[:x] + ship_size - 1, coordinates[:y])
			elsif direction == :vertical
				coordinates = self.get_random_coordinates(GRID_SIZE - 1, GRID_SIZE - ship_size)
				if( ! self.check_clear_column(coordinates[:x], coordinates[:y], ship_size) )
					return false
				end
				puts ship_name + " start " + coordinates[:x].to_s + ":" + coordinates[:y].to_s + " end " + (coordinates[:x] + ship_size - 1).to_s + ":" + coordinates[:y].to_s
				add_vertical_ship(coordinates[:y], coordinates[:y] + ship_size - 1, coordinates[:x])
			end
			shipnum += 1			
		end
		return true
	end
	
	def arrange_ships(ships)
		while(! try_arrange_ships(ships) )
			self.scrap_all
		end
	end

	def add_horizontal_ship(start_x, end_x, row)
		(start_x..end_x).each do |column|
			puts column
			@tiles[column][row][:tile] = :ship
		end
	end

	def add_vertical_ship(start_y, end_y, column)
		(start_y..end_y).each do |row|
			puts "row:" + row.to_s
			puts "col: " + column.to_s
			@tiles[column][row][:tile] = :ship
		end
	end

	def scrap_all()
		@tiles.each do |i|
			i.each do |j|
				j[:tile] = :water
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
	
	boardmap = Board.new(10)
	boardmap.arrange_ships(ships)
	boardmap.draw(:green)
end

main
