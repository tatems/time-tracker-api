module Api
  class EventsController < ApiController
    before_action :set_events, except: :show
    before_action :set_event, only: [:show, :update, :destroy]

    def create
      @event = Event.new(permitted_params) do |e|
        e.datetime = DateTime.now
      end

      @event.save!

      render json: @event
    end

    def index
      render json: @events
    end

    def show
      render json: @event
    end

    def update
      @event.update!(permitted_params)
      render json: @event
    end

    def destroy
      @event.destroy!
      head :no_content
    end

    private

    def set_events
      if (params[:date].present? && DateTime.parse(params[:date])) || params[:subcategory_id].present?
        @events = Event.all
        @events = @events.where(subcategory_id: params[:subcategory_id]) if params[:subcategory_id].present?
        @events = Event.for_date(DateTime.parse(params[:date])) if params[:date].present?
      else 
        @events = Event.none
      end
    end

    def set_event
      @event = Event.find(params[:id])
    end

    def permitted_params
      params.require(:event).permit(:title, :time, :subcategory_id)
    end
  end
end