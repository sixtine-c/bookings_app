class Api::V1::MissionsController < Api::V1::BaseController
  before_action :set_missions, only: %i[show update destroy]

  # outpupath = 'lib/data/missions.json'

  def index
    @missions = Mission.all
  end

  def show
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      render :show
    else
      render_error
    end
  end

  def update
    if @mission.update(mission_params)
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @mission.destroy
  end

  private

  def set_missions
    @mission = Mission.find(params[:id])
  end

  def mission_params
    params.require(:mission).permit(:listing_id, :mission_type, :date, :price)
  end

  def render_error
    render json: { errors: @mission.errors.full_messages },
           status: :unprocessable_entity
  end
end
