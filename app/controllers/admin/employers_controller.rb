class Admin::EmployersController < ApplicationController
  include AdminAuthorizable
  before_action :set_client
  before_action :set_employer, only: [:update, :destroy]

  def create
    @employer = @client.employers.new(employer_params)
    if @employer.save
      redirect_to admin_client_path(@client), notice: "Employer added."
    else
      redirect_to admin_client_path(@client), alert: @employer.errors.full_messages.join(", ")
    end
  end

  def update
    if @employer.update(employer_params)
      render json: { success: true }
    else
      render json: { success: false, errors: @employer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @employer.destroy
    redirect_to admin_client_path(@client), notice: "Employer removed."
  end

  private

  def set_client
    @client = Client.find_by!(slug: params[:client_id])
  end

  def set_employer
    @employer = @client.employers.find(params[:id])
  end

  def employer_params
    params.require(:employer).permit(:name, :website, :notes, :role_id)
  end
end
