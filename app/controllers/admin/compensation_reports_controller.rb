class Admin::CompensationReportsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_compensation_report, only: [:edit, :update, :destroy]

  def index
    @compensation_reports = CompensationReport.all.order(created_at: :desc)
  end

  def new
    @compensation_report = CompensationReport.new
  end

  def create
    @compensation_report = CompensationReport.new(compensation_report_params)
    if @compensation_report.save
      redirect_to admin_compensation_reports_path, notice: 'Compensation report was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @compensation_report.update(compensation_report_params)
      redirect_to admin_compensation_reports_path, notice: 'Compensation report was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @compensation_report.destroy
    redirect_to admin_compensation_reports_path, notice: 'Compensation report was successfully deleted.'
  end

  private

  def set_compensation_report
    @compensation_report = CompensationReport.find(params[:id])
  end

  def compensation_report_params
    params.require(:compensation_report).permit(:name, :location, :pdf)
  end
end
