class Todo < ApplicationRecord
  belongs_to :goal

  validates :name, presence: true

  def display_name
    name.presence || "Todo ##{id}"
  end
end
