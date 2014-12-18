require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "empty review" do
    review = Review.new
    assert !review.save
  end
end
