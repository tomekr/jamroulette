class ActivityPresenter < SimpleDelegator
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::SanitizeHelper

  def self.activities(owner)
    owner.activities.map { |activity| new(activity) }
  end

  def initialize(activity)
    super
  end

  def activity_feed_line
    case subject_type
    when "Jam"
      jam = subject
      filename = sanitize(jam.file.filename.to_s)
      "<span class='jam-activity'>You uploaded #{filename} to #{room_link_for(jam.room)}</span>".html_safe
    when "Room"
      room = subject
      "<span class='room-activity'>You created #{room_link_for(room)}</span>".html_safe
    end
  end

  private

  def room_link_for(room)
    link_to room.public_id, "/rooms/#{room.public_id}"
  end
end
