module Api
  class ApplicationsController < ApplicationController
    def create
      application = Application.new(application_params)

      if application.save
        render json: application, status: :ok
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