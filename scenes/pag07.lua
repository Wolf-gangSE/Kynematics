-----------------------------------------------------------------------------------------
--
-- pag04.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, retangulo, aceleracao_text, plataforma01, velocidadeInicial, velocidadeFinal, tempoInicial, tempoFinal, bola, plataforma02, lado01, lado02, retangulo2, aceleracao_media_text, bolaOrientation

local aceleracoes = {0}

physics.start()
physics.setGravity( 0, 9.8 )

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag06", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag08", "slideLeft", 800 )
    
    return true -- indicates successful touch
  end
end

local function onAccelerate( event )
	local vx, vy = bola:getLinearVelocity()
	local xGravity = event.xGravity
	local speedMultiplier = 4 -- adjust this value to control the speed of the ball
	local velocidade = vx + xGravity * speedMultiplier
	bola:setLinearVelocity( velocidade, vy )
	velocidadeFinal = velocidade
	print("velocidadeFinal: " .. velocidadeFinal)
	aceleracao_text.text = "Aceleração Atual: " .. math.floor( xGravity * 100 ) / 10 .. " m/s²"
	table.insert(aceleracoes, math.floor( xGravity * 100 ) / 10)

	if event.phase == "began" then
		tempoInicial = system.getTimer()/1000
	end
end

local function onLocalCollision( self, event )
	if ( event.phase == "began" ) then
		if aceleracoes ~= nil then
			print("aceleracoes: " .. #aceleracoes)
			local soma = 0

			for i = 1, #aceleracoes do
					soma = soma + aceleracoes[i]
					print("aceleracao: " .. aceleracoes[i])
			end
			

			local acl_media = soma / #aceleracoes
			if math.abs(acl_media) > 0 then
				aceleracao_media_text.text = "Aceleração Média: " .. math.floor( acl_media * 100 ) / 100 .. " m/s²"
				
			end
			aceleracoes = {}
		end
		-- if event.other == lado01 then
		-- 	-- bola colidiu com a lado01
		-- 	tempoFinal = system.getTimer()/1000
		-- 	print (tempoFinal - tempoInicial)
		-- 	print(velocidadeFinal)
		-- 	print(velocidadeInicial)
		-- 	print((velocidadeFinal - velocidadeInicial) / (tempoFinal - tempoInicial))
		-- 	aceleracao_media_text.text = "Aceleração Média: " .. math.floor( (velocidadeFinal - velocidadeInicial) / (tempoFinal - tempoInicial) * 100 ) / 100 .. " m/s²"
		-- 	tempoInicial = system.getTimer()/1000
		-- 	local vx , vy = bola:getLinearVelocity()
		-- 	velocidadeInicial = vx
		-- elseif event.other == lado02 then
		-- 	-- bola colidiu com o lado02
		-- 	tempoFinal = event.time/1000
		-- 	aceleracao_media_text.text = "Aceleração Média: " .. math.floor( (velocidadeFinal - velocidadeInicial) / (tempoFinal - tempoInicial) * 100 ) / 100 .. " m/s²"
		-- 	tempoInicial = event.time/1000
		-- 	local vx , vy = bola:getLinearVelocity()
		-- 	velocidadeInicial = vx
		-- end
		
		
	elseif ( event.phase == "ended" ) then
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

  text = display.newImageRect( "images/texto-pag-07-1.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

	plataforma01 = display.newImageRect( "images/plataforma-01.png", 580, 10 )
  plataforma01.anchorX = 0
  plataforma01.anchorY = 0
  plataforma01.x, plataforma01.y = display.contentWidth/8, display.contentHeight/3.05

	-- plataforma02 = display.newImageRect( "images/plataforma-01.png", 580, 10 )
	-- plataforma02.anchorX = 0
	-- plataforma02.anchorY = 0
	-- plataforma02.x, plataforma02.y = display.contentWidth/8, display.contentHeight/3.5
	-- plataforma02.alpha = 0

	lado01 = display.newImageRect( "images/plataforma-02.png", 20, 300 )
  lado01.anchorX = 0
  lado01.anchorY = 0
  lado01.x, lado01.y = plataforma01.x + plataforma01.width, plataforma01.y/2
	lado01.alpha = 0

	lado02 = display.newImageRect( "images/plataforma-02.png", 20, 300 )
	lado02.anchorX = 0
	lado02.anchorY = 0
	lado02.x, lado02.y = plataforma01.x - lado02.width, plataforma01.y/2
	lado02.alpha = 0

	retangulo = display.newImageRect("images/retangulo.png", 300, 50)
	retangulo.anchorX = 0
	retangulo.anchorY = 0
	retangulo.x, retangulo.y = display.contentWidth / 2 - retangulo.width / 2, (display.contentHeight / 2.7)

	retangulo2 = display.newImageRect("images/retangulo.png", 300, 50)
	retangulo2.anchorX = 0
	retangulo2.anchorY = 0
	retangulo2.x, retangulo2.y = display.contentWidth / 2 - retangulo.width / 2, (display.contentHeight / 2.3)

	aceleracao_text = display.newText("Aceleração Atual: 0 m/s²", retangulo.x + retangulo.width/2,
	retangulo.y + retangulo.height / 2, native.systemFont, 22)
	aceleracao_text:setFillColor(0, 0, 0)

	aceleracao_media_text = display.newText("Aceleração Média: 0 m/s²", retangulo2.x + retangulo2.width/2,
	retangulo2.y + retangulo2.height / 2, native.systemFont, 22)
	aceleracao_media_text:setFillColor(0, 0, 0)

	bola = display.newImageRect( "images/bola.png", 30, 30 )
  bola.anchorX = 0
  bola.anchorY = 0
  bolaOrientation = "right"

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
	sceneGroup:insert( retangulo )
	sceneGroup:insert( aceleracao_text )
	sceneGroup:insert( plataforma01 )
	sceneGroup:insert( lado01 )
	sceneGroup:insert( lado02 )
	sceneGroup:insert( bola )
	sceneGroup:insert( retangulo2 )
	sceneGroup:insert( aceleracao_media_text )
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
		bola.x, bola.y = plataforma01.x+20, plataforma01.y - bola.height
		buttomLeft.touch = onButtomLeftTouch
		buttomLeft:addEventListener( "touch", buttomLeft )
    
    buttomRight.touch = onButtomRightTouch
    buttomRight:addEventListener( "touch", buttomRight )

		physics.addBody( plataforma01, "static" )
		-- physics.addBody( plataforma02, "static" )
		physics.addBody( bola, "dynamic", { radius=15, density = 1.0, friction = 0.5, bounce = 0 } )
		physics.addBody( lado01, "static" )
		physics.addBody( lado01, "static", { isSensor = true })
		physics.addBody( lado02, "static" )
		physics.addBody( lado02, "static", { isSensor = true })

		timer.performWithDelay( 1000, function() 
			bola:setLinearVelocity( 100, 0 )
			velocidadeInicial = 100
			velocidadeFinal = 0
			tempoInicial = system.getTimer()/1000
		end, 1 )
		

		Runtime:addEventListener( "accelerometer", onAccelerate )

		bola.collision = onLocalCollision
		bola:addEventListener( "collision", bola )
		
	end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener( "touch", buttomLeft )
		buttomRight:removeEventListener( "touch", buttomRight )
		Runtime:removeEventListener( "accelerometer", onAccelerate )
	elseif phase == "did" then
		-- Called immediately after scene goes off screen.
		physics.removeBody( plataforma01 )
		-- physics.removeBody( plataforma02 )
		physics.removeBody( bola )
		physics.removeBody( lado01 )
		physics.removeBody( lado02 )
		
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene