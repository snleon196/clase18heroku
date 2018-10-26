module Api
  module V1
   class UsersController < ApplicationController
    before_action :authenticate_with_token!, only: [:update, :destroy]
    respond_to :json

  #Todos los usuarios
    def index
      respond_with User.all
      #render json: user, status: 200, message:"Loaded users", data:user
      #render json: {status: 'SUCCESS', message:'Loaded users', data:user},status: :ok
    end

    def show
      user = User.find(params[:id])
      #el render es otra manera de enviar la respuesta se remplaza respond_with
      render json: {status: 'SUCCESS', message: 'Loaded user', data:user},status: :ok
      end

      #Crear usuarios
    def create
      user = User.new(user_params)
      if user.save
        #render json: user, status: 201, message: "Saved user", data:user
        UserNotifierMailer.send_signup_email(user).deliver
        render json: {status: 'SUCCESS', message: 'Saved user', data:user},status: :ok
      else
        #render json: { errors: user.errors }, status: 422
        render json: {status: 'ERROR', message: 'User not saved', data:user.errors},status: :unprocessable_entity
      end
    end

    #Actualizar usuario
    
=begin
    def update
      user = User.find(params[:id])
    
      if user.update(user_params)
        #render json: user, status: 200, message: "Updated user", data:user
        render json: {status: 'SUCCESS', message: 'Updated user', data:user},status: :ok
      else
        #render json: { errors: user.errors }, status: 422
        render json: {status: 'ERROR', message: 'User not updated', data:user.errors},status: :unprocessable_entity
      end
    end
=end
#autorizar acciones
    def update
      user = current_user
  
      if user.update(user_params)
        render json: {status: 'SUCCESS', message: 'Updated user', data:user},status: :ok
      else
        render json: {status: 'ERROR', message: 'User not updated', data:user.errors},status: :unprocessable_entity
      end
    end
=begin
    #eliminar usuario
    def destroy
      user = User.find(params[:id])
      user.destroy
      render json: {status: 'SUCCESS', message: 'Deleted user', data:user},status: :ok
      #head 204
    end
=end
 #eliminar usuario
    def destroy
      current_user.destroy
      render json: {status: 'SUCCESS', message: 'Deleted user', data:current_user},status: :ok
    end

    private
  
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
   end
 end
end