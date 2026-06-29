class AvailabilityController < ApplicationController
  before_action :set_recommendation

  def show
    if @recommendation.availability_submitted_at.present?
      redirect_to availability_done_path(@recommendation.availability_token)
    end
  end

  def submit
    slots = build_slots(params[:slots])

    if slots.empty?
      flash.now[:alert] = "Please add at least one time slot."
      return render :show, status: :unprocessable_entity
    end

    @recommendation.update!(
      availability_slots: slots.to_json,
      availability_submitted_at: Time.current
    )

    RecommendationsMailer.availability_submitted(@recommendation).deliver_now

    redirect_to availability_done_path(@recommendation.availability_token)
  end

  def done
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find_by!(availability_token: params[:token])
  end

  def build_slots(raw)
    return [] unless raw.is_a?(ActionController::Parameters)
    raw.values.filter_map do |slot|
      date     = slot["date"].to_s.strip
      start    = slot["start_time"].to_s.strip
      duration = slot["duration"].to_s.strip.presence || "45"
      next if date.blank? || start.blank?
      "#{date} #{start} (#{duration} min)"
    end
  end
end
