# Class for ship object (stores ship position, type and size
class Ship
	def initialize(type, size)
		@type = type
		@size = size
		@squares_left = size # Number of squares (tiles) until sunk

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
	
	# See if coordinates lie in range of the ship
	def see_if_hit(coordinates)
		x_coord = coordinates[0]
		y_coord = coordinates[1]
		
		if @position == :horizontal		
			if (x_coord >= @start_x) && (x_coord <= @end_x ) && (y_coord == @row)
				if ship_sunk
					return :sunk
				else
					return :hit
				end
			end
		else
			if (y_coord >= @start_y) && (y_coord <= @end_y) && (x_coord == @column)
				if ship_sunk
					return :sunk
				else
					return :hit
				end
			end
		end
		return :failed
	end

	# Reduce the number of squares within the ship, return false if there are still squares remaining
	# and true if all have been destroyed
	private
	def ship_sunk
		if @squares_left >= 1
			@squares_left -= 1
			return false
		else
			return true
		end
	end	
end
