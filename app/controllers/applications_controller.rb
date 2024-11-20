class ApplicationsController < ApplicationController
    before_action :application_params_filter, only: [:create, :update]
    protect_from_forgery unless: -> { request.format.json? }

    def index
        all_applications = Application.all.map { |app| { token: app.token, name: app.name, created_at: app.created_at , chat_count: app.chat_count} } || []
        render json: all_applications, status: :ok
    end

    def update
        obj = [
            params[:id],
            application_params_filter[:name]
          ]
        if UpdateApplicationJob.perform_async(obj)
            render json: "application updated successfully" , status: :ok
        else
            render json: { errors: application.errors }, status: :unprocessable_entity
        end
    end

    def show
        application = Application.find_by(token: params[:id])
        if application
            render json: { name: application.name, token: application.token, created_at: application.created_at , chat_count: application.chat_count }, status: :ok 
        else
            render json: { errors: "Can't find the application", token: params[:id] }, status: :not_found
        end
    end
  
    def create
        generated_token = generate_token
        input_name = application_params_filter[:name]
        obj = [
            generated_token,
            input_name
          ]
        if CreateApplicationJob.perform_async(obj)
            render json: { name:  input_name, token:  generated_token }, status: :created
        else
            render json:  { error: 'Could not create application'}, status: :unprocessable_entity
        end
    end

    def destroy
        @application = Application.find_by(token: params[:id])
        if @application.destroy
            render json: { message: 'Application along with chats and messages deleted successfully' }, status: :ok
        else
            render json: { error: 'Failed to delete application' }, status: :unprocessable_entity
        end
    end

    private
  
    def application_params_filter
      params.require(:application).permit(:name)
    end

    def generate_token
      loop do
        token = SecureRandom.hex(10)
        break token unless Application.exists?(token: token)
      end
    end

end