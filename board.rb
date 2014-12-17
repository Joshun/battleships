class Board
	def initialize(size, border_colour)
		@@MAX_SHIP_ATTEMPTS = 5 #Maximum number of times to try positioning each ship before giving up	
		@size = size
		@border_colour = border_colour
		@tiles = Array.new(@size) { Array.new(@size) { Tile.new } }
		@ships_left = 0
	end

	# Method to draw the board on screen
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
				
				print @tiles[row][column].generate_str + " "
			end
			puts
		end
	end

	def arrange_ships(ships)
		#Get number of ships
		
		@ships_left = ships.length
		
		while(! try_arrange_ships(ships) ) #Keep trying to arrange ships, scrapping board and retrying upon failure
			scrap_all
		end
	end

	# Method that fires at given coordinates, seeing if a ship is present
	def fire(coordinates, ships)
		x_coord = coordinates[0]
		y_coord = coordinates[1]
		@tiles[y_coord][x_coord].make_known		
		try_fire_ship(coordinates, ships)
	end
	
	# Method to see if there are still ships remaining to destroy
	def ships_remaining
		if @ships_left > 0
			return true
		else
			return false
		end
	end

	# Method to determine whether or not a tile has been shot at already
	def get_square_known_status(coordinates)
		return @tiles[coordinates[1]][coordinates[0]].is_known
	end

	# Method used to randomly obtain coordinates in a given range
	private
	def get_random_coordinates(x_max, y_max)
		x_coord = rand(0..x_max)
		y_coord = rand(0..y_max)
		
		return { x: x_coord, y: y_coord }
	end

	# Method used to randomly decide whether to align a ship horizontally or vertically
	private
	def horizontal_or_vertical()
		if rand(0..1) == 0
			return :horizontal
		else
			return :vertical
		end
	end

	# Method to determine whether or not a section of a row is free from ships
	private
	def check_clear_row(row, start_column, size)
		end_column = start_column + size
		(start_column...end_column).each do |index|
			if @tiles[row][index].get_type != :water
				return false
			end
		end
		return true
	end

	# Method to determine whether or not a section of a column is free from ships
	private
	def check_clear_column(column, start_row, size)
		end_row = start_row + size
		(start_row...end_row).each do |index|
			if @tiles[index][column].get_type != :water
				return false
			end
		end
		return true
	end

	# Method that tries to add a ship to the grid, returning false on failure
	private
	def try_add_ship(ship, ship_size)
		direction = horizontal_or_vertical
		if direction == :horizontal
			coordinates = get_random_coordinates(@size - ship_size, @size - 1)
			if( ! check_clear_row(coordinates[:y], coordinates[:x], ship_size) )
				return false
			end
			add_horizontal_ship(coordinates[:x], coordinates[:x] + ship_size, coordinates[:y])
			ship.set_squares_horizontal(coordinates[:x], coordinates[:x] + ship_size - 1, coordinates[:y])
		elsif direction == :vertical
			coordinates = get_random_coordinates(@size - 1, @size - ship_size)
			if( ! check_clear_column(coordinates[:x], coordinates[:y], ship_size) )
				return false
			end
			add_vertical_ship(coordinates[:y], coordinates[:y] + ship_size, coordinates[:x])
			ship.set_squares_vertical(coordinates[:y], coordinates[:y] + ship_size - 1, coordinates[:x])
		end
		return true
	end
	
	# Method that tries to arrange all the ships on the grid, giving up if it fails
	# and returning false
	private
	def try_arrange_ships(ships)
		ships.each do |ship|
			ship_name = ship.get_type
			ship_size = ship.get_size
			ship_positioned = false
			(0...@@MAX_SHIP_ATTEMPTS).each do |i| #Give up if cannot position ship
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

	# Method to add a ship horizontally
	private
	def add_horizontal_ship(start_x, end_x, row)
		(start_x...end_x).each do |column|
			@tiles[row][column].set_type(:ship)
		end
	end

	# Method to add a ship vertically
	private
	def add_vertical_ship(start_y, end_y, column)
		(start_y...end_y).each do |row|
			@tiles[row][column].set_type(:ship)
		end
	end

	# Method to 'reset' the grid by setting all squares to :water
	private
	def scrap_all()
		@tiles.each do |i|
			i.each do |j|
				j.set_type(:water)
			end
		end
	end
	
	# Method that finds out whether the supplied coordinates would hit a ship
	private
	def try_fire_ship(coordinates, ships)
		ships.each do |ship|
			ship_status = ship.see_if_hit(coordinates)
			if ship_status == :hit
				puts "You hit!"
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
	
	# Method to determine whether or not a shot was close to hitting a ship
	private
	def shot_was_close(coordinates)
		x_coord = coordinates[0]
		y_coord = coordinates[1]

		if x_coord > 0 # Only check for left square if not on the edge
			left_square = @tiles[y_coord][x_coord - 1].get_type
		else
			left_square = :water # Can treat edges as water
		end
		
		if x_coord < @size - 1
			right_square = @tiles[y_coord][x_coord + 1].get_type
		else
			right_square = :water
		end			
	
		if y_coord > 0
			top_square = @tiles[y_coord - 1][x_coord].get_type
		else
			top_square = :water
		end		
		
		if y_coord < @size - 1
			bottom_square = @tiles[y_coord + 1][x_coord].get_type
		else
			bottom_square = :water
		end		
		
		return left_square == :ship || right_square == :ship || top_square == :ship || bottom_square == :ship
	end
end
