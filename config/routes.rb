Rails.application.routes.draw do
  

  post '/cardapio.json' => 'apis#cardapio'
end
