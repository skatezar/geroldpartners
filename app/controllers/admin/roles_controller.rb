class Admin::RolesController < ApplicationController
  include AdminAuthorizable
  before_action :set_client

  def create
    @role = @client.roles.build(role_params)
    if @role.save
      redirect_to admin_client_path(@client), notice: "Role added."
    else
      redirect_to admin_client_path(@client), alert: @role.errors.full_messages.to_sentence
    end
  end

  def destroy
    @client.roles.find(params[:id]).destroy
    redirect_to admin_client_path(@client), notice: "Role removed."
  end

  private

  def set_client
    @client = Client.find_by!(slug: params[:client_id])
  end

  def role_params
    params.require(:role).permit(:title)
  end
end
