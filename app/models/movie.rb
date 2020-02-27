class Movie < ActiveRecord::Base
	def self.available_ratings
		ratings = self.all.select("rating").distinct.order("rating")
		ratings_list = []
		ratings.each do |rating|
			ratings_list.append(rating.rating)
		end
		return ratings_list
	end

	def self.with_ratings(selected_ratings)
		if selected_ratings == nil or selected_ratings.length == 0
			return Movie.all
		elsif selected_ratings.length == 1
			return Movie.where("rating = '" + selected_ratings[0] + "'")
		else
			clause = ""
			selected_ratings.each_with_index do |rating, idx|
				if idx != selected_ratings.length - 1
					clause += "rating = '#{rating}' OR "
				else
					clause += "rating = '#{rating}'"
				end
			end

			return Movie.where(clause)
		end

	end
end
