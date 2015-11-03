class Ball < ActiveRecord::Base
  belongs_to :playing_item

  def amount_as_bucket
    self.amount / self.playing_item.tab.club.balls_per_bucket
  end
end