class SessionsController < ApplicationController
  def new
  end

  def create_remote
    user_data = $rpx.auth_info params[:token]
    user = User.find_by_identifier(user_data['identifier']) ||
      User.create!(:identifier => user_data['identifier'], :username => user_data['displayName'])
    session[:user_id] = user.id
    redirect_to dashboard_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_url
  end
end
