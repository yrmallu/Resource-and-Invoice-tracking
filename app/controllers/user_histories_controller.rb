class UserHistoriesController < ApplicationController
  before_action :logged_in?
  def index
    redirect_to dashboard_users_path and return unless current_user.is_admin?
    @activities = PublicActivity::Activity.includes(:trackable, :owner).order("created_at desc")
  end
end
