class ApisController < ApplicationController

	def cardapio
		@obj = built_json(params[:url])
		render json: @obj
	end

	private

	def built_json(url)
		require 'nokogiri'
		document = `curl 'https://www.ifood.com.br#{url}'  -H 'Cookie: xtvrn=$555247$; nvgt44287=1508435222902_1_0|0_0|0; __sonar=3657417295964772483; SESSION=a7670c5d-89d0-4aed-9909-74c5b49631a7; AWSELB=DF4D93F50A05578787DFBCB0AF83D4C75D09FA4EA667EBDD9C946B224609BAAB31F103B9EB36D3557327135915A5C0AF9B5EABF09420BD03326324D216EA54E1996680D154; nlbi_597064=wWHtD/3+imW/M2TMDeo7zwAAAAC1+v/81w3dBvr/HrT0tmJW; i18next=pt-BR; visid_incap_597064=2QNkJX7oQpypfUeQVZFB/BXl6FkAAAAAQUIPAAAAAABsblOrG9tFS+U1zzit5s31; incap_ses_298_597064=ssLNDpmZFTssUBRP9bYiBM6A71kAAAAARUd0DyI8t+CVkUmzV3WS7A==; nav44287=80379b5b288f795ede6cc4f7309|2_298; xtan=-; xtant=1; xttvt=||; _gac_UA-90879438-1=1.1508521078.EAIaIQobChMIru_C9N7_1gIVQwaRCh0ZdQ8-EAAYASAAEgKnW_D_BwE; nvgc44287=0|0; _ga=GA1.3.755566639.1508435227; _gid=GA1.3.1498658286.1508868305; _gac_UA-20685796-1=1.1508521100.EAIaIQobChMIru_C9N7_1gIVQwaRCh0ZdQ8-EAAYASAAEgKnW_D_BwE' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' -H 'Accept: text/html, */*; q=0.01' -H 'Referer: https://www.ifood.com.br/delivery/brasilia-df/brasil-vexado-plano-piloto-asa-sul' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --compressed
`
		doc = Nokogiri::HTML(document)

		cardapios = []
		byebug
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

