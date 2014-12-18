class Comment < ActiveRecord::Base
  attr_accessible :comment, :date, :poster, :review_id
  belongs_to :reviews
end
