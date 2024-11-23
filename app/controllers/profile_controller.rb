# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show update destroy]

  # GET /profiles/:id
  def show
    render json: {
      profile: @profile,
      profile_picture_url: @profile.profile_picture.attached? ? url_for(@profile.profile_picture) : nil
    }, status: :ok
  end

  # PATCH/PUT /profiles/:id
  def update
    if @profile.update(profile_params)
      render json: @profile, status: :ok
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Profile not found" }, status: :not_found
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone_number, :email, :profile_picture)
  end
end
