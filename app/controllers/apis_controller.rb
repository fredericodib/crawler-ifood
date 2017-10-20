class ApisController < ApplicationController

	def cardapio
		@obj = built_json(params[:url])
		render json: @obj
	end

	private

	def built_json(url)
		require 'nokogiri'
		document = `curl 'https://www.ifood.com.br#{url}' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: xtvrn=$555247$; nvgt44287=1508435222902_1_0|0_0|0; __sonar=3657417295964772483; SESSION=b386a13b-dae8-43ec-bc78-7a7dab952866; AWSELB=DF4D93F50A05578787DFBCB0AF83D4C75D09FA4EA668911D1816F58D96838AC384EB7E1C2357FA8414F7783210B36DCCD4021D84EF5179D3A113D959858AEDF7F185EB7F79; nlbi_597064=aNW/KrPQIXpFlr5xDeo7zwAAAADv+kV9StNdTYTbftiKxd6Q; i18next=pt-BR; nav44287=80379b5b288f795ede6cc4f7309|2_294; incap_ses_240_597064=ren6DPqOAEwnExPuyqdUA1I/6lkAAAAAPc8lsB8RkOcu7LfiUV9j6Q==; xtan=-; xtant=1; xttvt=||; visid_incap_597064=2QNkJX7oQpypfUeQVZFB/BXl6FkAAAAAQUIPAAAAAABsblOrG9tFS+U1zzit5s31; incap_ses_684_597064=drcTa+qi9Qsjmxbjcg5+CXFB6lkAAAAA/7DJsPG29XAZTqFPQAvzQg==; _gac_UA-90879438-1=1.1508521078.EAIaIQobChMIru_C9N7_1gIVQwaRCh0ZdQ8-EAAYASAAEgKnW_D_BwE; _ga=GA1.3.755566639.1508435227; _gid=GA1.3.1809632893.1508435227; _gac_UA-20685796-1=1.1508521100.EAIaIQobChMIru_C9N7_1gIVQwaRCh0ZdQ8-EAAYASAAEgKnW_D_BwE; nvgc44287=0|0' -H 'Connection: keep-alive' --compressed`
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

