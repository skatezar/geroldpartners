class ClientsController < ApplicationController
  before_action :set_client

  def show
    unless authorized?
      render :password
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
