class Meeting < ApplicationRecord
  has_many :tasks
  belongs_to :created_by ,foreign_key: :created_by_id ,class_name: "User"
  has_many :user_meetings
  has_many :users ,through: :user_meetings
end
