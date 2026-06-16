class Admin::RecommendationsController < ApplicationController
  include AdminAuthorizable
  before_action :set_client
  before_action :set_recommendation, only: [:edit, :update, :destroy]

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

  private

  def set_client
    @client = Client.find_by!(slug: params[:client_id])
  end

  def set_recommendation
    @recommendation = @client.recommendations.find(params[:id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:name, :linkedin_url, :description, :cv)
  end
end
