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
local background, buttomLeft, buttomRight, text, baloes, bola, ended, gravar, parar, audioCapture, isRecording, gravando

local linhaBola = nil
local linhaBaloes = nil
local linhaBolaPontos = {}
local linhaBaloesPontos = {}

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
	transition.to(baloes, { time=10000, x=590, y=display.contentHeight/4, transition=easing.easeOutBounce, 
			onUpdate=function()
					table.insert(linhaBaloesPontos, baloes.x + baloes.width/2)
					table.insert(linhaBaloesPontos, baloes.y + baloes.height/2)
					linhaBaloes:append(baloes.x + baloes.width/2, baloes.y + baloes.height/2)
			end
	})

	transition.to(bola, { time=10000, x=590, 
			onUpdate=function()
					table.insert(linhaBolaPontos, bola.x + bola.width/2)
					table.insert(linhaBolaPontos, bola.y + bola.height/2)
					linhaBola:append(bola.x + bola.width/2, bola.y + bola.height/2)
			end
	})

	ended = true
end

local function onRestart()
	transition.to(baloes, { time=100, x=display.contentWidth/8, y=display.contentHeight/4, transition=easing.easeOutBounce, 
			onUpdate=function()
					linhaBaloes:removeSelf()
					linhaBaloes = display.newLine( linhaBaloesPontos )
					linhaBaloes:setStrokeColor( 0, 0, 0 )
					linhaBaloes.strokeWidth = 5
			end
	})
	transition.to(bola, { time=100, x=display.contentWidth/8, 
			onUpdate=function()
					linhaBola:removeSelf()
					linhaBola = display.newLine( linhaBolaPontos )
					linhaBola:setStrokeColor( 0, 0, 0 )
					linhaBola.strokeWidth = 5
			end
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

  text = display.newImageRect( "images/texto-pag-04.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

	baloes = display.newImageRect( "images/baloes.png", 50, 100 )
	baloes.anchorX = 0
	baloes.anchorY = 0
	baloes.x, baloes.y = display.contentWidth/8, display.contentHeight/3

	bola = display.newImageRect( "images/bola.png", 50, 50 )
	bola.anchorX = 0
	bola.anchorY = 0
	bola.x, bola.y = display.contentWidth/8, display.contentHeight/2.2

	-- criar pontos de partida para as linhas
	linhaBolaPontos = { bola.x + bola.width/2, bola.y + bola.height/2 }
	linhaBaloesPontos = { baloes.x + baloes.width/2, baloes.y + baloes.height/2 }

	-- criar linha para a trajetória da bola
	linhaBola = display.newLine(linhaBolaPontos[1], linhaBolaPontos[2], bola.x + bola.width/2, bola.y + bola.height/2)
	linhaBola:setStrokeColor(1, 1, 1, 0) -- cor vermelha
	linhaBola.strokeWidth = 50
	linhaBola:append(bola.x + bola.width/2, bola.y + bola.height/2)

	-- criar linha para a trajetória dos baloes
	linhaBaloes = display.newLine(linhaBaloesPontos[1], linhaBaloesPontos[2], baloes.x + baloes.width/2, baloes.y + baloes.height/2)
	linhaBaloes:setStrokeColor(1, 1, 1, 0) -- cor verde
	linhaBaloes.strokeWidth = 2
	linhaBaloes:append(baloes.x + baloes.width/2, baloes.y + baloes.height/2)

	gravar = display.newImageRect( "images/gravar.png", 100, 100 )
	gravar.anchorX = 0
	gravar.anchorY = 0
	gravar.x, gravar.y = display.contentWidth/2 - 50,  (display.contentHeight - display.contentHeight/6)

	gravando = display.newText( "Toque para gravar", display.contentWidth/2, display.contentHeight/2, native.systemFont, 20 )
	gravando:setFillColor( 1, 0, 0 )
	gravando.anchorX = 0
	gravando.anchorY = 0
	gravando.x, gravando.y = display.contentWidth/2 - gravando.width/2,  (display.contentHeight - display.contentHeight/20)

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
	sceneGroup:insert( baloes )
	sceneGroup:insert( bola )
	sceneGroup:insert( linhaBola )
	sceneGroup:insert( linhaBaloes )
	sceneGroup:insert( gravar )
	sceneGroup:insert( gravando )
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
	end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener( "touch", buttomLeft )
		buttomRight:removeEventListener( "touch", buttomRight )
	elseif phase == "did" then
		-- Called immediately after scene goes off screen.
		if isRecording then
			audioCapture:stopRecording()
		end
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene