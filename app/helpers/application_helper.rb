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
end
