class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  before_action :authenticate_user!

  def index
    @events = Event.all
  end

  def show
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
