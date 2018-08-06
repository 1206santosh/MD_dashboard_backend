class Upload < ApplicationRecord
  has_one_attached :file
  belongs_to :item ,polymorphic: true ,optional: true

end
