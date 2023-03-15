-----------------------------------------------------------------------------------------
--
-- pag03.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require( "physics" )
local scene = composer.newScene()


physics.start()
physics.setGravity( 0, 9.8 )
physics.setDrawMode( "hybrid" )


-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, rect1, estrada, carro, restart, personagem, carroMovimento, personagemMovimento

local velocidade = 5000

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag02", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag04", "slideLeft", 800 )
    
    return true -- indicates successful touch
  end
end

local function onCarroTap()
	transition.to(carro, {x = 500, time = velocidade})
	transition.to(movimentoCarro, {x = 510, time = velocidade})
	transition.to(repousoCarro, {x = 510, time = velocidade})
	carroMovimento = true
	timer.performWithDelay( velocidade, function ()
		restart.alpha = 1
		carroMovimento = false
	end, 1 )
	
end

local function onPersonagemTap()
	transition.to(personagem, {x = 575, time = velocidade})
	transition.to(movimentoPersonagem, {x = 555, time = velocidade})
	transition.to(repousoPersonagem, {x = 555, time = velocidade})
	personagemMovimento = true
	timer.performWithDelay( velocidade, function ()
		restart.alpha = 1
		personagemMovimento = false
	end, 1 )
	
end

local function onRestartTap()
	transition.to(carro, {x = display.contentWidth/8, time = velocidade/2})
	transition.to(personagem, {x = display.contentWidth/8, time = velocidade/2})
	transition.to(movimentoPersonagem, {x = display.contentWidth/8 - 20, time = velocidade/2})
	transition.to(movimentoCarro, {x = display.contentWidth/8 + 10, time = velocidade/2})
	transition.to(repousoPersonagem, {x = display.contentWidth/8 - 20, time = velocidade/2})
	transition.to(repousoCarro, {x = display.contentWidth/8 + 10, time = velocidade/2})
	restart.alpha = 0
end

local function onEnterFrame()
	if carroMovimento == true and personagemMovimento == true then
		movimentoCarro.alpha = 0
		movimentoPersonagem.alpha = 0
		repousoCarro.alpha = 1
		repousoPersonagem.alpha = 1
	else
		if carroMovimento == true then
			movimentoCarro.alpha = 1
			repousoCarro.alpha = 0
		else
			movimentoCarro.alpha = 0
			repousoCarro.alpha = 1
		end
		if personagemMovimento == true then
			movimentoPersonagem.alpha = 1
			repousoPersonagem.alpha = 0
		else
			movimentoPersonagem.alpha = 0
			repousoPersonagem.alpha = 1
		end
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

  text = display.newImageRect( "images/texto-pag-03.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

	rect1 = display.newRect( 0, 0, 580, 10 )
	rect1.anchorX = 0
	rect1.anchorY = 0
	rect1.x, rect1.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.85
	rect1.alpha = 0
	physics.addBody( rect1, "static" )

	rect2 = display.newRect( 0, 0, 580, 10 )
	rect2.anchorX = 0
	rect2.anchorY = 0
	rect2.x, rect2.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.52
	rect2.alpha = 0
	physics.addBody( rect2, "static" )

	estrada = display.newImageRect( "images/estrada.png", 580, 130 )
	estrada.anchorX = 0
	estrada.anchorY = 0
	estrada.x, estrada.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.52

	carro = display.newImageRect( "images/carro-sem-fundo.png", 175, 100 )
	carro.anchorX = 0
	carro.anchorY = 0
	carro.x, carro.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.62
	physics.addBody( carro, "dynamic")
	carroMovimento = false

	personagem = display.newImageRect( "images/bicicleta.png", 100, 100 )
	personagem.anchorX = 0
	personagem.anchorY = 0
	personagem.x, personagem.y = display.contentWidth/8, display.contentHeight - display.contentHeight/1.32
	physics.addBody( personagem, "dynamic")
	personagemMovimento = false

	restart = display.newImageRect( "images/restart.png", 100, 100 )
	restart.anchorX = 0
	restart.anchorY = 0
	restart.x, restart.y = display.contentWidth/2 - 50,  (display.contentHeight/4.2)
	restart.alpha = 0

	movimentoCarro = display.newImageRect( "images/movimento.png", 150, 38 )
	movimentoCarro.anchorX = 0
	movimentoCarro.anchorY = 0
	movimentoCarro.alpha = 0
	movimentoCarro.x, movimentoCarro.y = display.contentWidth/8 + 10,  (display.contentHeight/2.1)

	movimentoPersonagem = display.newImageRect( "images/movimento.png", 150, 38 )
	movimentoPersonagem.anchorX = 0
	movimentoPersonagem.anchorY = 0
	movimentoPersonagem.alpha = 0
	movimentoPersonagem.x, movimentoPersonagem.y = display.contentWidth/8 - 20,  (display.contentHeight/4.8)

	repousoCarro = display.newImageRect( "images/repouso.png", 150, 38 )
	repousoCarro.anchorX = 0
	repousoCarro.anchorY = 0
	repousoCarro.alpha = 1
	repousoCarro.x, repousoCarro.y = display.contentWidth/8 + 10,  (display.contentHeight/2.1)

	repousoPersonagem = display.newImageRect( "images/repouso.png", 150, 38 )
	repousoPersonagem.anchorX = 0
	repousoPersonagem.anchorY = 0
	repousoPersonagem.alpha = 1
	repousoPersonagem.x, repousoPersonagem.y = display.contentWidth/8 - 20,  (display.contentHeight/4.8)

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
	sceneGroup:insert( estrada )
	sceneGroup:insert( carro )
	sceneGroup:insert( rect1 )
	sceneGroup:insert( restart )
	sceneGroup:insert( rect2 )
	sceneGroup:insert( personagem )
	sceneGroup:insert( movimentoCarro )
	sceneGroup:insert( movimentoPersonagem )
	sceneGroup:insert( repousoCarro )
	sceneGroup:insert( repousoPersonagem )
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

		carro.tap = onCarroTap
		carro:addEventListener( "tap", carro )

		personagem.tap = onPersonagemTap
		personagem:addEventListener( "tap", personagem )

		restart.tap = onRestartTap
		restart:addEventListener( "tap", restart )

		Runtime:addEventListener( "enterFrame", onEnterFrame )


	end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener( "touch", buttomLeft )
		buttomRight:removeEventListener( "touch", buttomRight )
		carro:removeEventListener( "tap", carro )
		restart:removeEventListener( "tap", restart )

		physics.removeBody( carro )
		physics.removeBody( rect1 )
		physics.removeBody( rect2 )
		physics.removeBody( personagem )
	elseif phase == "did" then
		-- Called immediately after scene goes off screen.

		
	end

end

function scene:destroy( event )
	physics.stop()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene