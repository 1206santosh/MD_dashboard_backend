class StateTransition < ApplicationRecord
  belongs_to :item ,polymorphic: true ,optional: true
  belongs_to :transition_user ,foreign_key: :transition_by ,optional: true
end
