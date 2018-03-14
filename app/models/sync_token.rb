class SyncToken < ApplicationRecord
  def self.instance
    SyncToken.first || SyncToken.new
  end
end
