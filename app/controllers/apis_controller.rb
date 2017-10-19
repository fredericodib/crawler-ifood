class ApisController < ApplicationController

	def cardapio
		
		render json: {message: params[:url]}
	end
end
