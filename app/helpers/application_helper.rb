module ApplicationHelper

	def options_for_user_status_select
		[["All",""],["Active",1],["Blocked",2]]
	end

	def select_gender
		[["All",""],["Male","male"],["Female","female"]]
	end
end
