require 'open-uri'

class MissionsController < ApplicationController
  before_action :set_client, except: :index

  def index
    if internet_connection?
      set_client
      fetch_all if Mission.count == 0
      # TODO: sync if internet_connection
    end

    # Newest mission first
    @missions = Mission.order(created_at: :desc)
    # Oldest mission first
    # @missions = Mission.order(:created_at)

    render :index, status: 200
  end

  def sync
    # Check if there is nextSyncUrl. Otherwise perform reset
    @client.entries.each_item do |entry|
      puts "====="
      this_entry = @client.entry(entry.id)
      p this_entry.revision
    end
    render json: @client.entries, status: 200
  end

  def reset
    # TODO: Check if there is internet connection
    # if internet_connection => Empty all Mission, send initial synchronization request
    # else => error: no internet connection
    Mission.destroy_all

    # TODO: Handle nextPageUrl
    # TODO: what to render?
    render json: fetch_all, status: 200
  end

  private

  def set_client
    @client ||= Contentful::Client.new(
      space: ENV['SPACE_ID'],
      access_token: ENV['CONTENT_DELIVERY_API_TOKEN'],
      dynamic_entries: :auto
    )
  end

  def fetch_all
    all_entries = @client.sync(initial: true) # type: all(default)
    all_entries.each_item do |entry|
      # Make each entry into ruby object

      # TODO: refactor after sync works
      unless Mission.find_by(contentful_id: entry.id)
        Mission.create(
          title: entry.title,
          contentful_id: entry.id,
          revision: entry.revision,
          longitude: entry.location.lon,
          latitude: entry.location.lat,
          due: entry.due
          )
      end
    end
    all_entries
  end

  def internet_connection?
    begin
      true if open("https://cdn.contentful.com")
    rescue
      false
    end
  end
end
