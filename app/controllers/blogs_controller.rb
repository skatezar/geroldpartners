class BlogsController < ApplicationController
  ACCESS_CODE = "1234"

  layout false

  def madrid_analyst_associate_comp_2026
    if session[:madrid_blog_unlocked]
      render :madrid_analyst_associate_comp_2026
    else
      render :madrid_access, status: :ok
    end
  end

  def madrid_unlock
    if params[:code] == ACCESS_CODE
      session[:madrid_blog_unlocked] = true
      redirect_to madrid_analyst_associate_comp_2026_path
    else
      flash.now[:error] = "Incorrect access code."
      render :madrid_access, status: :unprocessable_entity
    end
  end
end
