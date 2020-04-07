class ActivityPresenter < SimpleDelegator
  include ActionView::Helpers::SanitizeHelper

  def self.activities(owner, view)
    owner.activities.order(created_at: :desc).map { |activity| new(activity, view) }
  end

  def initialize(activity, view)
    super(activity)
    @view = view
  end

  # XXX Ensure all user controlled attributes are sanitized before embedding them into HTML
  def message
    case subject_type
    when 'Jam'
      "You uploaded #{jam_icon} #{sanitized_filename} " \
      "to #{room_icon} #{room_link_for(subject.room)} #{time}".html_safe
    when 'Room'
      "You created #{room_icon} #{room_link_for(subject)} #{time}".html_safe
    end
  end

  def type
    subject_type.downcase
  end

  private

  def time
    "#{@view.time_ago_in_words(subject.created_at)} ago"
  end

  def sanitized_filename
    sanitize(subject&.file&.filename.to_s)
  end

  def room_link_for(room)
    @view.link_to room.name, @view.room_path(room)
  end

  def room_icon
    '<i class="fas fa-door-open"></i>'
  end

  def jam_icon
    '<i class="fas fa-music"></i>'
  end
end
