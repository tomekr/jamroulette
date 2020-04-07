module RoomsHelper
  def jam_user(jam)
    jam.user ? jam.user.display_name : 'Anonymous'
  end

  def format_duration(duration_in_seconds)
    if duration_in_seconds.present?
      Time.at(duration_in_seconds.to_i).utc.strftime('%M:%S')
    else
      'Unavailable'
    end
  end
end
