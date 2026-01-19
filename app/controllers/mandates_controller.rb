class MandatesController < ApplicationController
  def apply
    @mandate = Mandate.find(params[:id])
    @application = JobApplication.new(
      mandate: @mandate,
      name: params[:name],
      email: params[:email],
      linkedin_url: params[:linkedin_url]
    )

    if @application.save
      # Handle CV file if present
      if params[:cv].present?
        @application.cv.attach(params[:cv])
      end

      # Send email notification
      JobApplicationMailer.new_application(@application).deliver_now

      render json: { success: true, message: 'Application submitted successfully!' }
    else
      render json: { success: false, errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
