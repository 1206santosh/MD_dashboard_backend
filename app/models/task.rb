class Task < ApplicationRecord
  belongs_to :meeting ,optional: :true
  has_many :uploads, as: :item
  has_many :comments ,as: :item
  belongs_to :assignee ,foreign_key: :assignee_id,class_name:"User" ,optional: :true
  belongs_to :assigner ,foreign_key: :assigner_id,class_name:"User",optional: :true




  # state_machine :status,:initial => :pending do
  #
  #   event :complete do
  #     transition [:pending]=>:completed
  #   end
  #
  # end
  #
  def allocate_assignee(assignee_id)
     self.update(assignee_id:assignee_id)
  end

  def toggle_state
      if self.status!="completed"
        self.update(status:"pending")
      else
        self.update(status:"completed")
      end
  end
end
