class IrregularEvent < ApplicationRecord
  belongs_to :user
  belongs_to :schedulable, polymorphic: true
end
