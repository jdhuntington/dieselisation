# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def friendly_game_status(game)
    case game.status
    when "new"
      "Not yet started"
    when "active"
      "In progress"
    when "finished"
      "Finished"
    end
  end

  def custom_button_to(name, options, html_options={ })
    html_options[:class] = 'custom-button'
    link_to content_tag(:span, name), options, html_options
  end
end
