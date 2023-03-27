-----------------------------------------------------------------------------------------
--
-- pag04.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, velocidade_label, velocidade_input, posicao_inicial, posicao_inicial_input, tempo, tempo_input, estrada, carro, retangulo, deslocamento, comecar_btn, comecar_btn_text, reiniciar_btn, reiniciar_btn_text

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag07", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag09", "slideLeft", 800 )
    
    return true -- indicates successful touch
  end
end

local function onComecarBtnTouch( event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- Obter os valores de entrada
		local velocidade = tonumber(velocidade_input.text)
		local posicao_inicial = tonumber(posicao_inicial_input.text)
		local tempo = tonumber(tempo_input.text)
		-- Calcular a posição final do carro
		local posicao_final = posicao_inicial + velocidade * tempo

		carro.x = posicao_inicial

		-- Tempo para iniciar o movimento
		timer.performWithDelay(500, function()
			-- Iniciar o movimento do carro
			local transicao = transition.to(carro, {time = tempo * 1000, x = posicao_final, onComplete = function()
				-- Atualizar o texto do deslocamento
				deslocamento.text = "Deslocamento: " .. string.format("%.2f", posicao_final) .. " m"
			end})
		end)

		return true
	end
end

local function onReiniciarBtnTouch( event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- Reiniciar a posição do carro
		carro.x = 0

		-- Reiniciar o texto do deslocamento
		deslocamento.text = "Deslocamento: 0 m"

		-- Reiniciar posição inicial
		posicao_inicial = 0

		transition.cancel( transicao )

		return true
	end
end

function scene:create( event )
	local sceneGroup = self.view

  background = display.newImageRect( "images/background-color.png", display.contentWidth, display.contentHeight )
  background.anchorX = 0
  background.anchorY = 0
  background.x, background.y = 0, 0

  buttomRight = display.newImageRect( "images/buttom-right.png", 100, 100 )
  buttomRight.anchorX = 0
  buttomRight.anchorY = 0
  buttomRight.x, buttomRight.y = display.contentWidth - display.contentWidth/6,  (display.contentHeight - display.contentHeight/6)

	buttomLeft = display.newImageRect( "images/buttom-left.png", 100, 100 )
	buttomLeft.anchorX = 0
	buttomLeft.anchorY = 0
	buttomLeft.x, buttomLeft.y = display.contentWidth/20,  (display.contentHeight - display.contentHeight/6)

  text = display.newImageRect( "images/texto-pag-08.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

	velocidade_label = display.newText( "Velocidade: ", display.contentWidth/5, display.contentHeight/4, native.systemFont, 20);
	velocidade_label:setFillColor( 0, 0, 0 )

	velocidade_input = native.newTextField( velocidade_label.x + velocidade_label.width - 30, display.contentHeight/4, 50, 30 )
	velocidade_input.inputType = "number"
	velocidade_input.text = "0"

	posicao_inicial = display.newText( "Posição Inicial: ", velocidade_input.x + velocidade_input.width + 100, display.contentHeight/4, native.systemFont, 20);
	posicao_inicial:setFillColor( 0, 0, 0 )

	posicao_inicial_input = native.newTextField( posicao_inicial.x + posicao_inicial.width - 40, display.contentHeight/4, 50, 30 )
	posicao_inicial_input.inputType = "number"
	posicao_inicial_input.text = "0"

	tempo = display.newText( "Tempo: ", posicao_inicial_input.x + posicao_inicial_input.width + 60, display.contentHeight/4, native.systemFont, 20);
	tempo:setFillColor( 0, 0, 0 )

	tempo_input = native.newTextField( tempo.x + tempo.width - 10, display.contentHeight/4, 50, 30 )
	tempo_input.inputType = "number"
	tempo_input.text = "0"

	estrada = display.newImageRect( "images/estrada-longa.png", display.contentWidth, 30 )
	estrada.anchorX = 0
	estrada.anchorY = 0
	estrada.x, estrada.y = display.contentWidth/2 - estrada.width/2, display.contentHeight/3.3

	carro = display.newImageRect( "images/carro-sem-fundo.png", 70, 40 )
	carro.anchorX = 0
	carro.anchorY = 0
	carro.x, carro.y = estrada.x, estrada.y - carro.height/3

	comecar_btn = display.newImageRect("images/retangulo.png", 150, 35)
	comecar_btn.anchorX = 0
	comecar_btn.anchorY = 0
	comecar_btn.x, comecar_btn.y = display.contentWidth/3 - comecar_btn.width/2, estrada.y + comecar_btn.height * 1.5

	comecar_btn_text = display.newText( "Começar", comecar_btn.x + comecar_btn.width/2, comecar_btn.y + comecar_btn.height/2, native.systemFont, 20);
	comecar_btn_text:setFillColor( 0, 0, 0 )

	reiniciar_btn = display.newImageRect("images/retangulo.png", 150, 35)
	reiniciar_btn.anchorX = 0
	reiniciar_btn.anchorY = 0
	reiniciar_btn.x, reiniciar_btn.y = display.contentWidth/2 + reiniciar_btn.width/2, estrada.y + reiniciar_btn.height * 1.5

	reiniciar_btn_text = display.newText( "Reiniciar", reiniciar_btn.x + reiniciar_btn.width/2, reiniciar_btn.y + reiniciar_btn.height/2, native.systemFont, 20);
	reiniciar_btn_text:setFillColor( 0, 0, 0 )

	retangulo = display.newImageRect("images/retangulo.png", 300, 50)
	retangulo.anchorX = 0
	retangulo.anchorY = 0
	retangulo.x, retangulo.y = display.contentWidth/2 - retangulo.width/2, reiniciar_btn.y + retangulo.height * 1.5

	deslocamento = display.newText( "Distancia: 0 m", retangulo.x + retangulo.width/2, retangulo.y + retangulo.height/2, native.systemFont, 22);
	deslocamento:setFillColor( 0, 0, 0 )

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
	sceneGroup:insert( estrada )
	sceneGroup:insert( carro )
	sceneGroup:insert( velocidade_label )
	sceneGroup:insert( velocidade_input )
	sceneGroup:insert( posicao_inicial )
	sceneGroup:insert( posicao_inicial_input )
	sceneGroup:insert( tempo )
	sceneGroup:insert( tempo_input )
	sceneGroup:insert( comecar_btn )
	sceneGroup:insert( comecar_btn_text )
	sceneGroup:insert( reiniciar_btn )
	sceneGroup:insert( reiniciar_btn_text )
	sceneGroup:insert( retangulo )
	sceneGroup:insert( deslocamento )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen (but is about to come on screen).
	elseif phase == "did" then
		-- Called when the scene is now on screen.
		-- 
		-- INSERT code here to make the scene come alive.
		-- e.g. start timers, begin animation, play audio, etc.
		buttomLeft.touch = onButtomLeftTouch
		buttomLeft:addEventListener( "touch", buttomLeft )
    
    buttomRight.touch = onButtomRightTouch
    buttomRight:addEventListener( "touch", buttomRight )

		comecar_btn:addEventListener("touch", onComecarBtnTouch)
		reiniciar_btn:addEventListener("touch", onReiniciarBtnTouch)
	end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener( "touch", buttomLeft )
		buttomRight:removeEventListener( "touch", buttomRight )
		comecar_btn:removeEventListener("touch", onComecarBtnTouch)
		reiniciar_btn:removeEventListener("touch", onReiniciarBtnTouch)
	elseif phase == "did" then
		-- Called immediately after scene goes off screen.
		
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene