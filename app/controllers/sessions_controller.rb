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

  def login_as
    raise "INTRUDER ALERT!" unless %w{ development cucumber test}.include?(ENV['RAILS_ENV'])
    session[:user_id] = User.find_or_create_by_username params[:username]
    redirect_to dashboard_url
  end
end
