class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    # Dashboard logic here
  end
end
