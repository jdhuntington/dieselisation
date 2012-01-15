require 'scenario_runner/formatter'
require 'scenario_runner/assertions'

module ScenarioRunner
  module_function
  def turn step
    username, step_action = step.split(/:\s*/)

    Assertions.assert "current_player", "'#{username}'" # Eww
    Formatter.log_turn username, step_action

    step_action_parts = step_action.split
    $g.act({ 'verb'      => step_action_parts[0],
             'target'    => step_action_parts[1],
             'bid'       =>  step_action_parts[2],
             'player_id' => $g.current_player.id })

    $g.confirm!
    Formatter.game_link $g.game_state
  end
end
