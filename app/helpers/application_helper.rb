module ApplicationHelper
  def bulma_flash_mapping(message_type)
    case message_type
    when 'alert'
      'danger'
    else
      message_type
    end
  end
end
