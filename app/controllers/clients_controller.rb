class ClientsController < ApplicationController
  before_action :set_client

  def show
    unless authorized?
      return render :password
    end
    @recommendations = @client.recommendations.order(created_at: :desc)
    @status_filter = params[:status]
    if @status_filter.present? && Recommendation::STATUSES.key?(@status_filter)
      @recommendations = @recommendations.where(status: @status_filter)
    end
  end

  def authenticate
    if @client.authenticate(params[:password].to_s)
      session[session_key] = true
      redirect_to client_path(@client.slug)
    else
      flash.now[:alert] = "Incorrect password."
      render :password, status: :unauthorized
    end
  end

  def update_recommendation_status
    unless authorized?
      return redirect_to client_path(@client.slug), alert: "Please enter the password first."
    end
    rec = @client.recommendations.find(params[:recommendation_id])
    new_status = params[:status].to_s
    if Recommendation::STATUSES.key?(new_status) && rec.update(status: new_status)
      redirect_to client_path(@client.slug, status: params[:current_filter].presence),
                  notice: "Updated #{rec.name} to “#{rec.status_label}”."
    else
      redirect_to client_path(@client.slug, status: params[:current_filter].presence),
                  alert: "Could not update status."
    end
  end

  private

  def set_client
    @client = Client.find_by!(slug: params[:slug] || params[:id])
  end

  def authorized?
    session[session_key] == true
  end

  def session_key
    "client_access_#{@client.id}"
  end
  helper_method :authorized?
end
