class MandatesController < ApplicationController
  def show
    @mandate = Mandate.find(params[:id])
  end

  def apply
    @mandate = Mandate.find(params[:id])
    @application = JobApplication.new(
      mandate: @mandate,
      name: params[:name],
      email: params[:email],
      linkedin_url: params[:linkedin_url]
    )

    # Attach CV before validation if present
    if params[:cv].present?
      @application.cv.attach(params[:cv])
    end

    if @application.save
      # Send email notification
      JobApplicationMailer.new_application(@application).deliver_now
      begin
        JobApplicationMailer.confirmation(@application).deliver_now
      rescue => e
        Rails.logger.error("Failed to send job application confirmation to #{@application.email}: #{e.message}")
      end

      render json: { success: true, message: 'Application submitted successfully!' }
    else
      render json: { success: false, errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
