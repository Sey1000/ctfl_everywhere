require 'open-uri'

class MissionsController < ApplicationController
  before_action :set_client, except: :index

  def index
    # Makes /missions more dynamic
    # if internet_connection?
    #   set_client
    #   fetch_all if Mission.count == 0
    #   fetch_new
    #   fetch_deleted
    # end
    @missions = Mission.order(created_at: :desc) # most recent mission first
    render :index, status: 200
  end

  def sync
    fetch_all if Mission.count == 0
    fetch_new
    fetch_deleted
    @missions = Mission.order(created_at: :desc)
    render :index, status: 200
  end

  def reset
    # TODO: Check if there is internet connection
    # if internet_connection => Empty all Mission, send initial synchronization request
    # else => error: no internet connection
    Mission.destroy_all
    fetch_all
    # TODO: Handle nextPageUrl
    @missions = Mission.order(created_at: :desc)
    render :index, status: 200
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
    sync_init = @client.sync(initial: true, type: 'Entry')
    sync_init.each_item do |entry|
      # Make each entry into ruby object
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

    set_sync_token(sync_init.next_sync_url)
    sync_init
  end

  def fetch_new
    token = SyncToken.instance.token
    sync_incr = @client.sync(sync_token: token)
    sync_incr.each_item do |entry|
      puts "=======New entry==========="
      p entry
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

    set_sync_token(sync_incr.next_sync_url)
  end

  def fetch_deleted
    sync_del = @client.sync(initial: true, type: 'Deletion')
    sync_del.each_item do |entry|
      puts "========Deleted========"
      p entry
      mission = Mission.find_by(contentful_id: entry.id)
      mission.destroy if mission
    end

    set_sync_token(sync_del.next_sync_url)
  end

  def set_sync_token(url)
    re = /.+sync_token=(?<token>.*)/
    token = url.match(re)[:token]
    SyncToken.instance.update(token: token)
  end

  def internet_connection?
    begin
      true if open("https://cdn.contentful.com")
    rescue
      false
    end
  end
end
