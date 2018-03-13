class MissionsController < ApplicationController
  before_action :set_client

  def index
    render json: @client.entries, status: 200
    # TODO: get from local storage instead
  end

  def sync
    # Check if there is nextSyncUrl. Otherwise perform reset

  end

  def reset
    # Check if there is internet connection
    # if internet_connection => Empty all Mission, send initial synchronization request
    # else => error: no internet connection

    sync = @client.sync(initial: true) # type: all(default)

    sync.each_item do |entry|
      # Make each entry into ruby object
      puts "====="
      p entry.title
      p entry.due
      p entry.location.lat
      p entry.location.lon
    end

    # Handle nextPageUrl

    render json: sync, status: 200

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
