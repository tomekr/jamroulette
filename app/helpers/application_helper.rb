module ApplicationHelper
  def bulma_flash_mapping(message_type)
    case message_type
    when 'alert'
      'danger'
    else
      message_type
    end
  end

  def beta_user?
    session[:is_beta_user].present?
  end

  def has_unread_notifications?(user)
    return false unless user

    user.notifications.unread.any?
  end
end
