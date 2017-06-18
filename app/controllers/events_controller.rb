class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :update]
  before_action :set_events, only: :index

  authorize_resource

  def index
    @event = Event.new
    respond_to do |format|
      format.html {}
      format.json { render json: @events, each_serializer: EventSerializer }
    end
  end

  def show
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      render json: @event, serializer: EventSerializer
    else
      render_errors
    end
  end

  def update
    if @event.update(event_params)
      render json: @event, serializer: EditEventSerializer
    else
      render_errors
    end
  end

  private

  def render_errors
    render json: @event.errors.full_messages, status: :unprocessable_entity
  end

  def set_events
    @events = Event.crossing_interval(params[:start], params[:end]) if params[:start]
    @events = @events.for_user(current_user.id) if params[:for_user].present?
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time)
  end
end
