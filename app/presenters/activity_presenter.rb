class ActivityPresenter < SimpleDelegator
  include ActionView::Helpers::SanitizeHelper

  def self.activities(*activities)
    activities.flatten.map { |activity| ActivityPresenter.new(activity) }
  end

  def initialize(activity)
    @activity = activity
    super
  end

  def activity_feed_line
    case @activity.subject_type
    when "Jam"
      jam = @activity.subject
      filename = sanitize(jam.file.filename.to_s)
      "<span class='jam-activity'>You uploaded #{filename} to #{room_link_for(jam.room)}</span>".html_safe
    when "Room"
      room = @activity.subject
      "<span class='room-activity'>You created #{room_link_for(room)}</span>".html_safe
    end
  end

  private

  def room_link_for(room)
    "<a href='/rooms/#{room.public_id}'>#{room.public_id}"
  end
end
