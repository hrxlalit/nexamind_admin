module StoresHelper
	def get_day a
		case a
		when 0
		  "Mon"
		when 1
		  "Tue"
		when 2
		  "Wed"
		when 3
		  "Thu"
		when 4
		  "Fri"
		when 5
		  "Sat"
		when 6
		  "Sun"
		else
		  "You gave me #{x} -- I have no idea what to do with that."
		end
	end

	def store_type type
		case type
		when 0
		  "apparels"
		when 1
		  "food"
		when 2
		  "electronics"
		when 3
		  "events"
		else
		  "You gave me #{x} -- I have no idea what to do with that."
		end
	end
end
