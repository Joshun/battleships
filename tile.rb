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
