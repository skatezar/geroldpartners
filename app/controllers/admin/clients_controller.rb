class Admin::ClientsController < ApplicationController
  include AdminAuthorizable
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = Client.all.order(created_at: :desc)
  end

  def show
    @roles = @client.roles.order(:title)
    @recommendations_by_role = @client.recommendations.includes(:role).order(created_at: :desc).group_by(&:role)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.user = current_user
    if @client.save
      redirect_to admin_client_path(@client), notice: 'Client created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = client_params
    if attrs[:password].blank?
      attrs = attrs.except(:password, :password_confirmation)
    end
    if @client.update(attrs)
      redirect_to admin_client_path(@client), notice: 'Client updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to admin_clients_path, notice: 'Client deleted.'
  end

  private

  def set_client
    @client = Client.find_by!(slug: params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :slug, :password, :password_confirmation, :contact_emails, :timezone)
  end
end
