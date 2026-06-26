class ClientsController < ApplicationController
  before_action :set_client

  def show
    if params[:token].present? && ActiveSupport::SecurityUtils.secure_compare(params[:token].to_s, @client.preview_token.to_s)
      session[session_key] = true
      return redirect_to client_path(@client.slug)
    end
    unless authorized?
      return render :password
    end
    @status_filter = params[:status]
    recs = @client.recommendations.includes(:role).order(created_at: :desc)
    recs = recs.where(status: @status_filter) if @status_filter.present? && Recommendation::STATUSES.key?(@status_filter)
    @recommendations = recs
    @recommendations_by_role = recs.group_by(&:role)
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

  def request_interview
    unless authorized?
      return redirect_to client_path(@client.slug), alert: "Please enter the password first."
    end
    rec = @client.recommendations.find(params[:recommendation_id])
    if rec.email.blank?
      return redirect_to client_path(@client.slug, status: params[:current_filter].presence),
                         alert: "No email on file for #{rec.name}. Please ask the admin to add one."
    end
    begin
      RecommendationsMailer.interview_request(rec).deliver_now
      redirect_to client_path(@client.slug, status: params[:current_filter].presence),
                  notice: "Interview request sent to #{rec.name}."
    rescue => e
      Rails.logger.error("Interview request email failed for rec=#{rec.id}: #{e.message}")
      redirect_to client_path(@client.slug, status: params[:current_filter].presence),
                  alert: "Could not send interview request. Please try again."
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
