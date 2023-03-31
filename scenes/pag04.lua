-----------------------------------------------------------------------------------------
--
-- pag04.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local media = require("media")
local audio = require("audio")
local scene = composer.newScene()

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, baloes, bola, ended, gravar, parar, audioCapture, isRecording, gravando, linhaBola, linhaBaloes, mascaraBola, mascaraBaloes, restart, audioRecorded

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag03", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag05", "slideLeft", 800 )
    
    return true -- indicates successful touch
  end
end


local function animateBalao()
	transition.to(baloes, { time=10000, x=610, y=display.contentHeight/4, transition=easing.easeOutBounce
	})
	transition.to(mascaraBaloes, { time=10000, x=660
	})

	transition.to(bola, { time=10000, x=610
	})
	transition.to(mascaraBola, { time=10000, x=660
	})

	ended = true
end

local function onRestart()
	transition.to(baloes, { time=100, x=display.contentWidth/8, y=display.contentHeight/3, transition=easing.easeOutBounce
	})
	transition.to(bola, { time=100, x=display.contentWidth/8
	})
	transition.to(mascaraBaloes, { time=100, x=display.contentWidth/8 + 50
	})
	transition.to(mascaraBola, { time=100, x=display.contentWidth/8 + 50
	})
end

local function detectSoundIntensity(event)
  audioRecorded = audio.loadSound( "baloes.wav", system.TemporaryDirectory )
  local soundIntensity = audio.getVolume( audioRecorded )
  print("soundIntensity: " .. soundIntensity)
  if soundIntensity > 0.8 then
    print("animateBalao")
		animateBalao()
	else
		print("Mais forte")
	end
end

local function recordAudio(event)
	if isRecording then
		print("stopAudio")
		audioCapture:stopRecording()
		gravando.text = "Toque para gravar"
		isRecording = false
		detectSoundIntensity()
	else
		print("recordAudio")
		-- Iniciar a captura de áudio
		audioCapture = media.newRecording( system.pathForFile( "baloes.wav", system.TemporaryDirectory ) )

		-- Iniciar a captura de áudio
		audioCapture:startRecording()
		gravando.text = "Toque para parar"
		isRecording = true
	end
end

function scene:create( event )
	local sceneGroup = self.view

	ended = false
	isRecording = false

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

  text = display.newImageRect( "images/texto-pag-04-1.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

	linhaBaloes = display.newImageRect( "images/curva.png", 485, 60 )
	linhaBaloes.anchorX = 0
	linhaBaloes.anchorY = 0
	linhaBaloes.x, linhaBaloes.y = display.contentWidth/8 + 25, display.contentHeight/3 - 50

	mascaraBaloes = display.newRect( display.contentWidth/8, display.contentHeight/3 - 50, 485, 75 )
	mascaraBaloes.anchorX = 0
	mascaraBaloes.anchorY = 0
	mascaraBaloes.x, mascaraBaloes.y = display.contentWidth/8 + 50, display.contentHeight/3 - 50

	print("Distancia:" .. display.contentHeight/3 - display.contentHeight/4)

	baloes = display.newImageRect( "images/baloes-branco.png", 50, 100 )
	baloes.anchorX = 0
	baloes.anchorY = 0
	baloes.x, baloes.y = display.contentWidth/8, display.contentHeight/3

	linhaBola = display.newImageRect( "images/linha-reta.png", 500, 2 )
	linhaBola.anchorX = 0
	linhaBola.anchorY = 0
	linhaBola.x, linhaBola.y = display.contentWidth/8 + 25, display.contentHeight/2.2 + 25

	mascaraBola = display.newRect( display.contentWidth/8, display.contentHeight/2.2 + 25, 500, 5 )
	mascaraBola.anchorX = 0
	mascaraBola.anchorY = 0
	mascaraBola.x, mascaraBola.y = display.contentWidth/8 + 50, display.contentHeight/2.2 + 25

	bola = display.newImageRect( "images/bola-branco.png", 50, 50 )
	bola.anchorX = 0
	bola.anchorY = 0
	bola.x, bola.y = display.contentWidth/8, display.contentHeight/2.2
	
	gravar = display.newImageRect( "images/gravar.png", 100, 100 )
	gravar.anchorX = 0
	gravar.anchorY = 0
	gravar.x, gravar.y = display.contentWidth/2 - 50,  (display.contentHeight - display.contentHeight/6)

	gravando = display.newText( "Toque para gravar", display.contentWidth/2, display.contentHeight/2, native.systemFont, 20 )
	gravando:setFillColor( 1, 0, 0 )
	gravando.anchorX = 0
	gravando.anchorY = 0
	gravando.x, gravando.y = display.contentWidth/2 - gravando.width/2,  (display.contentHeight - display.contentHeight/20)

	restart = display.newImageRect( "images/restart.png", 100, 100 )
	restart.anchorX = 0
	restart.anchorY = 0
	restart.x, restart.y = display.contentWidth/2 - 50,  (display.contentHeight/4.2)
	restart.alpha = 0

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
	sceneGroup:insert( linhaBaloes )
	sceneGroup:insert( baloes )
	sceneGroup:insert( linhaBola )
	sceneGroup:insert( bola )
	sceneGroup:insert( gravar )
	sceneGroup:insert( gravando )
	sceneGroup:insert( mascaraBaloes )
	sceneGroup:insert( mascaraBola )
	sceneGroup:insert( restart )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen (but is about to come on screen).
		if ended then
			onRestart()
		end
	elseif phase == "did" then
		-- Called when the scene is now on screen.
		-- 
		-- INSERT code here to make the scene come alive.
		-- e.g. start timers, begin animation, play audio, etc.
		buttomLeft.touch = onButtomLeftTouch
		buttomLeft:addEventListener( "touch", buttomLeft )
    
    buttomRight.touch = onButtomRightTouch
    buttomRight:addEventListener( "touch", buttomRight )

		gravar.tap = recordAudio
		gravar:addEventListener( "tap", gravar )

		restart.tap = onRestart
		restart:addEventListener( "tap", restart )
	end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener( "touch", buttomLeft )
		buttomRight:removeEventListener( "touch", buttomRight )
		gravar:removeEventListener( "tap", gravar )
		restart:removeEventListener( "tap", restart )
	elseif phase == "did" then
		-- Called immediately after scene goes off screen.
		if isRecording then
			audioCapture:stopRecording()
			gravando.text = "Toque para gravar"
		end
		
		transition.cancel( baloes )
		transition.cancel( bola )
		transition.cancel( mascaraBaloes )
		transition.cancel( mascaraBola )

		isRecording = false
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene