class Admin::MandatesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_mandate, only: [:edit, :update, :destroy]

  def index
    @mandates = Mandate.all.order(created_at: :desc)
  end

  def new
    @mandate = Mandate.new
  end

  def create
    @mandate = Mandate.new(mandate_params)
    if @mandate.save
      redirect_to admin_mandates_path, notice: 'Mandate was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @mandate.update(mandate_params)
      redirect_to admin_mandates_path, notice: 'Mandate was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @mandate.destroy
    redirect_to admin_mandates_path, notice: 'Mandate was successfully deleted.'
  end

  private

  def set_mandate
    @mandate = Mandate.find(params[:id])
  end

  def mandate_params
    params.require(:mandate).permit(:title, :description, :location, :firm_name, :firm_size, :active)
  end
end
