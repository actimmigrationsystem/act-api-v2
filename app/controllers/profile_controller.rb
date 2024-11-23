class ProfileController < ApplicationController
    before_action :set_profile, only: %i[show update destroy]

  # GET /profiles
  def index
    @profiles = Profile.all
    render json: @profiles, status: :ok
  end

  # GET /profiles/:id
  def show
    render json: @profile, status: :ok
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      render json: @profile, status: :created
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/:id
  def update
    if @profile.update(profile_params)
      render json: @profile, status: :ok
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:id
  def destroy
    @profile.destroy
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Profile not found" }, status: :not_found
  end

  def profile_params
    params.require(:profile).permit(:user_id, :first_name, :last_name, :phone_number, :email)
  end
end
