class Task < ApplicationRecord

  enum status: { todo: 0, inprogress: 1, complete: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :estimate, presence: true

end
