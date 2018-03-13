class MissionsController < ApplicationController
  before_action :set_client

  def index
    render json: @client.entries, status: 200
    # TODO: get from local storage instead
  end

  def synch

  end

  def reset

  end

  private

  def set_client
    @client ||= Contentful::Client.new(
      space: ENV['SPACE_ID'],
      access_token: ENV['CONTENT_DELIVERY_API_TOKEN'],
      dynamic_entries: :auto
    )
  end
end
