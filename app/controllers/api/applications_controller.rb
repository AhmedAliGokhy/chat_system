module Api
  class ApplicationsController < ApplicationController
    def index
      applications = Application.all
      render json: applications.as_json(only: [:name, :token]), status: :ok
    end

    def show
      application = Application.find_by token: params[:token]
      render json: application.as_json(only: [:name, :token]), status: :ok
    end

    def create
      application = Application.new(application_params)

      if application.save
        REDIS_CLIENT.set(application.token, 0)
        
        render json: application.as_json(only: [:name, :token]), status: :ok
      else
        render json: application.errors, status: :unprocessable_entity
      end
    end

    def update
      application = Application.find_by token: params[:token]

      if application.update(application_params)
        render json: application.as_json(only: [:name, :token]), status: :ok
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