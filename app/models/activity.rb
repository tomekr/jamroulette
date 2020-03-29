class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true
end
