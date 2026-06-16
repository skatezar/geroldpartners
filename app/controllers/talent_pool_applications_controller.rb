class TalentPoolApplicationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @application = TalentPoolApplication.new(talent_pool_params)

    # Attach CV if present
    if params[:cv].present?
      @application.cv.attach(params[:cv])
    end

    if @application.save
      TalentPoolMailer.new_application(@application).deliver_now
      begin
        TalentPoolMailer.confirmation(@application).deliver_now
      rescue => e
        Rails.logger.error("Failed to send talent pool confirmation to #{@application.email}: #{e.message}")
      end
      render json: { success: true, message: 'Application submitted successfully!' }
    else
      render json: { success: false, errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def talent_pool_params
    params.permit(:name, :email, :phone)
  end
end
