class ScenariosController < ApplicationController
  def index
    @scenarios = Scenario.all
  end

  def show
    @scenario = Scenario.find(params[:id])
  end
end
