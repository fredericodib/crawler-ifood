class ApisController < ApplicationController

	def cardapio
		@obj = built_json(params[:url])
		render json: @obj
	end

	private

	def built_json(url)
		require 'nokogiri'
		document = `#{url}`
		doc = Nokogiri::HTML(document)

		cardapios = []
		doc.css('div.info').drop(4).each do |elem| 
			nome = elem.css('a.headline-clickable h3').text
			cardapio = {}
			cardapio[:nome_categoria] = nome
			cardapio[:items] = []

			elem.css('div.result-text').each do |item|
				item_hash = {}
				#item_hash[:foto] = item.css('div.photo-item img').attr('src').value
				item_hash[:nome] = item.css('div.text-wrap h4').text
				item_hash[:descricao] = item.css('div.text-wrap p').text
				item_hash[:valor] = item.css('div.result-actions span').text.gsub(" ", "").gsub("\n", "")
				cardapio[:items] << item_hash
			end

			cardapios << cardapio
		end
		return {cardapio: cardapios}
	end
end

