class StaticPagesController < ApplicationController
  # Authentication for admin actions
  before_action :authenticate_admin!, except: :show

  # Show action for public visibility of static pages
  def show
    @page = StaticPage.find_by(slug: params[:slug])
    return unless @page.nil?

    render plain: "Page not found", status: :not_found
  end

  # Index action for listing all static pages (Admin only)
  def index
    @static_pages = StaticPage.all
  end

  # Edit action for Admin to edit static pages
  def edit
    @static_page = StaticPage.find(params[:id])
  end

  # Update action for Admin to save changes to static pages
  def update
    @static_page = StaticPage.find(params[:id])
    if @static_page.update(static_page_params)
      redirect_to admin_static_pages_path, notice: "Static page updated successfully."
    else
      render :edit
    end
  end

  private

  # Strong parameters for static pages
  def static_page_params
    params.require(:static_page).permit(:title, :content, :slug)
  end
end
