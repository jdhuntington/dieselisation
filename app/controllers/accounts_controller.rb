class AccountsController < ApplicationController
  before_filter :current_user

  def edit
  end

  def update
    params[:account].delete('identifier')
    @current_user.update_attributes!(params[:account])
    flash[:notice] = 'Account updated successfully'
    redirect_to :action => 'edit'
  end
end
