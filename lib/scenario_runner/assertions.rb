module ScenarioRunner
  module Assertions
    module_function
    def current_player
      $g.current_player.username
    end

    def player_cash username
      player = $g.lookup_player username
      player.balance
    end

    def available_cash username
      player = $g.lookup_player username
      player.available_balance
    end

    def bank_cash
      $g.game_instance.bank.balance
    end

    def owner asset_nickname
      user_id = $g.game_instance.lookup_private(asset_nickname).owner.identifier
      User.find(user_id).username
    end

    def round
      $g.game_instance.current_round
    end

    def assert actual, expected
      STDERR.puts({ :actual => actual, :expected => expected }.inspect)
      ::ScenarioRunner::Formatter.log_assertion actual, expected
      actual_eval   = eval actual
      expected_eval = eval expected
      answer        = actual_eval == expected_eval
      if answer
        true
      else
        ::ScenarioRunner::Formatter.log_failure actual, expected, actual_eval, expected_eval
        false
      end
    end
  end
end
