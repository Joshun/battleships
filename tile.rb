# Class for Tile object (represents an individual tile on the grid)
class Tile
	def initialize()
		@type = :water
		#~ @known = false
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
	def generate_str()
		if @known
			case @type
				when :water
					return "w".colorize(:background => :light_blue)
				when :ship
					return "s".colorize(:background => :red)
				else
					return " "
			end
		else
			return "*"
		end
	end	
end
