class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :assigned_task ,class_name:"Task",foreign_key: :assignee_id
  has_many :allocated_task ,class_name:"Task",foreign_key: :assigner_id
  has_many :created_meetings ,class_name:"Meeting",foreign_key: :created_by_id
  has_many :user_meetings
  has_many :meetings,through: :user_meetings

  before_create :allocate_uuid

  def allocate_uuid
    self.uuid=SecureRandom.hex(16)
    # self.password="1linkwok@"
    # self.confirm_password="1linkwok@"
  end

  def before_import_save(_row)
    self.password = '1linkwok@'
    self.password_confirmation = '1linkwok@'
  end
end
