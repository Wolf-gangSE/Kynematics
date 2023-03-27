-----------------------------------------------------------------------------------------
--
-- pag04.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, estrada, carro, retangulo, velocidade_text, velocidade, posicao_anterior, tempo_anterior, posicaoInicial, posicaoFinal, tempoInicial, tempoFinal, retangulo2, velocidade_text2

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag05", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag07", "slideLeft", 800 )
    
    return true -- indicates successful touch
  end
end

local function onCarTouch(event)
	local estradaLeft = estrada.x
	local estradaRight = estrada.x + estrada.width
	local carroLeft = event.x - carro.width/2
	local carroRight = event.x + carro.width/2
  if event.phase == "moved" then
		if carroLeft >= estradaLeft and carroRight <= estradaRight then
    	carro.x = event.x - carro.width/2
			-- calcular a distância percorrida
			local distancia = math.abs(carro.x/50 - posicao_anterior)

			posicaoFinal = posicaoFinal + distancia

			-- calcular o tempo decorrido
			local tempo = (event.time - tempo_anterior)/1000

			tempoFinal = tempoFinal + tempo

			-- calcular a velocidade
			velocidade = distancia / tempo

			-- atualizar a posição e o tempo anterior
			posicao_anterior = carro.x/50
			tempo_anterior = event.time

		end
	elseif event.phase == "began" then
    -- inicializar a posição e o tempo anterior
    posicao_anterior = carro.x/50
    tempo_anterior = event.time
		tempoInicial = event.time
		tempoFinal = 0
		posicaoInicial = carro.x/50
		posicaoFinal  = 0
	elseif event.phase == "ended" then
		-- calcular velocidade média
		tempoFinal = event.time
		local tempoTotal = (tempoFinal - tempoInicial)/1000
		print("tempoTotal: " .. tempoTotal)
		print("posicaoFinal: " .. posicaoFinal)
		print("posicaoInicial: " .. posicaoInicial)
		local velocidadeMedia = (posicaoFinal - posicaoInicial) / tempoTotal
		velocidade_text2.text = "Velocidade média: " .. string.format("%.2f", math.abs(velocidadeMedia)) .. " m/s"
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

  text = display.newImageRect( "images/texto-pag-06.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

	estrada = display.newImageRect( "images/estrada.png", 590, 100 )
	estrada.anchorX = 0
	estrada.anchorY = 0
	estrada.x, estrada.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.35

	carro = display.newImageRect( "images/carro-sem-fundo.png", 120, 75 )
	carro.anchorX = 0
	carro.anchorY = 0
	carro.x, carro.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.38

	-- retangulo = display.newImageRect("images/retangulo.png", 300, 50)
	-- retangulo.anchorX = 0
	-- retangulo.anchorY = 0
	-- retangulo.x, retangulo.y = display.contentWidth / 2 - retangulo.width / 2, (display.contentHeight / 2.6)

	-- velocidade_text = display.newText("Velocidade: 0 m/s", retangulo.x + retangulo.width / 2,
	-- retangulo.y + retangulo.height / 2, native.systemFont, 22)
	-- velocidade_text:setFillColor(0, 0, 0)

	retangulo2 = display.newImageRect("images/retangulo.png", 300, 50)
	retangulo2.anchorX = 0
	retangulo2.anchorY = 0
	retangulo2.x, retangulo2.y = display.contentWidth / 2 - retangulo2.width / 2, (display.contentHeight / 2.5)

	velocidade_text2 = display.newText("Velocidade média: 0 m/s", retangulo2.x + retangulo2.width / 2, retangulo2.y + retangulo2.height / 2, native.systemFont, 22)
	velocidade_text2:setFillColor(0, 0, 0)



  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
	sceneGroup:insert( estrada )
	sceneGroup:insert( carro )
	-- sceneGroup:insert( retangulo )
	-- sceneGroup:insert( velocidade_text )
	sceneGroup:insert( retangulo2 )
	sceneGroup:insert( velocidade_text2 )
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


		carro:addEventListener("touch", onCarTouch)

	end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener( "touch", buttomLeft )
		buttomRight:removeEventListener( "touch", buttomRight )
		carro:removeEventListener( "touch", onCarTouch )
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