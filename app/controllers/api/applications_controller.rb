module Api
  class ApplicationsController < ApplicationController
    def create
      application = Application.new(application_params)

      if application.save
        redis = Redis.new
        redis.set(application.token, 0)
        
        render json: { token: application.token }, status: :ok
      else
        render json: application.errors, status: :unprocessable_entity
      end
    end

    private

    def application_params
      params.require(:application).permit(:name)
    end
  end
end