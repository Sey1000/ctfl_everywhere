class Mission < ApplicationRecord

  private

  def client
    @client ||= Contentful::Client.new(
      space: ENV[SPACE_ID],
      access_token: ENV[CONTENT_DELIVERY_API_TOKEN],
      dynamic_entries: :auto
      # raise_errors: true
    )
  end

end
