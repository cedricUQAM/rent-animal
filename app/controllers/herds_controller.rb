class HerdsController < ApplicationController
  before_action :authenticate_user!
  def index
    @herds = Herd.where(user_id: current_user)
    @markers = @herds.geocoded.map do |herd|
      {
        lat: herd.latitude,
        lng: herd.longitude,
        info_window: render_to_string(partial: "info_windows", locals: { herd: herd })
      }
    end
  end

  def show
    @herd = Herd.find(params[:id])
  end
  def new
    @herd = Herd.new
  end

  def create
    @herd = Herd.new(herd_params)
    @herd.user = current_user
    if @herd.save
      redirect_to herds_path
    else
      render :new
    end
  end

  def edit
    @herd = Herd.find(params[:id])
    @herd = Herd.update(herd_params)
    if @herd.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update

  end

  def destroy
  end
end

private

def herd_params
  params.require(:herd).permit(:name, :description, :unit_price, :species)
end
