class Task < ApplicationRecord
  belongs_to :meeting ,optional: :true
  has_many :uploads, as: :item
  has_many :comments ,as: :item
  belongs_to :assignee ,foreign_key: :assignee_id,class_name:"User" ,optional: :true
  belongs_to :assigner ,foreign_key: :assigner_id,class_name:"User",optional: :true
  has_many :state_transitions,as: :item




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

  def toggle_state(user_id)
      if self.status!="completed"
        StateTransition.create(from:self.status,to:"completed",transition_by:user_id,item_type:"Task",item_id:self.id)
        self.update(status:"completed")
      else
        StateTransition.create(from:self.status,to:"pending",transition_by:user_id,item_type:"Task",item_id:self.id)
        self.update(status:"pending")
      end
    return self.status
  end

  def get_timeline
      timeline=[]
      t={}
      t["event"]="Task Created"
      t["date"]=self.created_at.strftime("%d/%m/%Y")
      t["text"]="Task Created by #{self.assigner.name rescue "NA"}"
      timeline<<t
      self.state_transitions.each do |state|
        t["event"]="State Transition"
        t["date"]=state.created_at.strftime("%d/%m/%Y")
        t["text"]="Task state changed to #{state.to}  from #{state.from} by #{state.transition_user.name}"
       timeline<<t
      end
    return timeline
  end

end
