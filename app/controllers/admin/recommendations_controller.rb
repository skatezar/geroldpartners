class Admin::RecommendationsController < ApplicationController
  include AdminAuthorizable
  before_action :set_client
  before_action :set_recommendation, only: [:edit, :update, :destroy, :send_to_client]

  def new
    @recommendation = @client.recommendations.build
  end

  def create
    @recommendation = @client.recommendations.build(recommendation_params)
    if @recommendation.save
      redirect_to admin_client_path(@client), notice: 'Recommendation added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recommendation.update(recommendation_params)
      redirect_to admin_client_path(@client), notice: 'Recommendation updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recommendation.destroy
    redirect_to admin_client_path(@client), notice: 'Recommendation removed.'
  end

  def send_to_client
    emails = params[:client_email].to_s.split(",").map(&:strip).reject(&:blank?)
    invalid = emails.reject { |e| e.match?(URI::MailTo::EMAIL_REGEXP) }
    if emails.empty? || invalid.any?
      return redirect_to admin_client_path(@client),
             alert: "Invalid email address#{"es" if invalid.size > 1}: #{invalid.join(", ")}. Please correct and try again."
    end
    RecommendationsMailer.send_to_client(@recommendation, emails).deliver_later
    redirect_to admin_client_path(@client),
                notice: "Recommendation for #{@recommendation.name} sent to #{emails.join(", ")}."
  end

  private

  def set_client
    @client = Client.find_by!(slug: params[:client_id])
  end

  def set_recommendation
    @recommendation = @client.recommendations.find(params[:id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:name, :email, :linkedin_url, :description, :cv,
                                           :compensation_expectation, :visa_requirement, :earliest_start, :role_id)
  end
end
