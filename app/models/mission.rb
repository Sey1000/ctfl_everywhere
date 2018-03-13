class Mission < ApplicationRecord
  validates :title, presence: true

  validates :contentful_id, uniquness: true
end
