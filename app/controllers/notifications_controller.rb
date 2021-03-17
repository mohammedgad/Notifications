# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show update destroy fire]

  def index
    @notifications = Notification.all
  end

  def show; end

  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      render :show, status: :created, location: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def fire
    NotificationWorker.perform_async(@notification.id) if @notification.status == 'pending' && @notification.update(status: 'fired')
    render :show, status: :ok, location: @notification
  end

  def update
    if @notification.status == 'pending' && @notification.update(notification_params)
      render :show, status: :ok, location: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @notification.status == 'fired'
      render(json:
        {
          message: "Fired notifications can't be deleted",
          status: 'unprocessable_entity',
          code: '422'
        },
             status: :unprocessable_entity) && return
    end

    @notification.destroy
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:channel_type, :message_en, :message_ar, filter: {})
  end

  rescue_from ::ActiveRecord::RecordNotFound do
    render json: { message: 'Notification not found.', status: 'not_found', code: '404' }, status: :not_found
  end
end
