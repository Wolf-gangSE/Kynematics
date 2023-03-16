-----------------------------------------------------------------------------------------
--
-- pag02.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require( "physics" )
local media = require("media")
local audio = require("audio")
local scene = composer.newScene()

physics.start()
physics.setDrawMode( "normal" )
physics.setGravity( 0, 9.8 )

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, plataforma01, plataforma02, plataforma03, lado01, lado02, bola, bolaOrientation, audioCapture, audioRecorded, recordAudioTimer, detectSoundIntensityTimer

local recordPath = system.pathForFile( "newRecording.wav", system.TemporaryDirectory )

local i = 0

local ended = false

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag01", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag03", "slideLeft", 800 )
    
    return true -- indicates successful touch
  end
end

local function onCollision(event)
  if event.phase == "began" and event.other == lado01 then
    -- bola colidiu com o lado01
    print("Colisão com lado01")
    bolaOrientation = "right"
  elseif event.phase == "began" and event.other == lado02 then
    -- bola colidiu com o lado02
    print("Colisão com lado02")
    bolaOrientation = "left"
  elseif event.phase == "began" and event.other == linhaChegada then
    -- bola colidiu com a linha de chegada
    print("Colisão com linha de chegada")
    timer.cancel( recordAudioTimer )
    timer.cancel( detectSoundIntensityTimer )
    ended = true
    bola:setLinearVelocity( 0, 0 )
  end
end

-- local function onGyroscopeUpdate( event )
--   local xSpeed = event.yRotation * 500
--   local ySpeed = event.xRotation * 500

--   bola:setLinearVelocity( xSpeed, ySpeed )
-- end



-- Função para detectar a intensidade do som
local function detectSoundIntensity(event)
  audioRecorded = audio.loadSound( "newRecording" .. i .. ".wav", system.TemporaryDirectory )
  local soundIntensity = audio.getVolume( audioRecorded )
  print("soundIntensity: " .. soundIntensity)
  if soundIntensity > 0.8 then
    if bolaOrientation == "left" then
      bola:setLinearVelocity( soundIntensity * -200, soundIntensity * 200 )
    else
      bola:setLinearVelocity( soundIntensity * 200, soundIntensity * 200 )
    end
  end
  --os.remove( recordPath )
end

local function recordAudio(event)
  i = i + 1
  print("recordAudio")
  -- Iniciar a captura de áudio
  audioCapture = media.newRecording( system.pathForFile( "newRecording" .. i .. ".wav", system.TemporaryDirectory ) )

  -- Iniciar a captura de áudio
  audioCapture:startRecording()

  

  -- stop recording audio after seconds
  detectSoundIntensityTimer = timer.performWithDelay(1000, function()
    audioCapture:stopRecording() -- stop the recording
    print("stopRecording")
    detectSoundIntensity()
  end)

end

function scene:create( event )
	local sceneGroup = self.view
  print( "pag02: create" )

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

  text = display.newImageRect( "images/texto-pag-02.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/4 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

  plataforma01 = display.newImageRect( "images/plataforma-01.png", 580, 20 )
  plataforma01.anchorX = 0
  plataforma01.anchorY = 0
  plataforma01.x, plataforma01.y = display.contentWidth/8, display.contentHeight/2
  

  plataforma02 = display.newImageRect( "images/plataforma-01.png", 580, 20 )
  plataforma02.anchorX = 0
  plataforma02.anchorY = 0
  plataforma02.x, plataforma02.y = display.contentWidth/8, display.contentHeight/5
  

  plataforma03 = display.newImageRect( "images/plataforma-01.png", 350, 20 )
  plataforma03.anchorX = 0
  plataforma03.anchorY = 0
  plataforma03.x, plataforma03.y = display.contentWidth/8, display.contentHeight/3.5

  plataforma04 = display.newImageRect( "images/plataforma-01.png", 350, 20 )
  plataforma04.anchorX = 0
  plataforma04.anchorY = 0
  plataforma04.x, plataforma04.y = display.contentWidth/2.5, display.contentHeight/2.7

  linhaChegada = display.newImageRect( "images/fine-line.png", 100, 21 )
  linhaChegada.anchorX = 0
  linhaChegada.anchorY = 0
  linhaChegada.x, linhaChegada.y =  display.contentWidth - display.contentWidth/8 - 115, display.contentHeight/2

  lado01 = display.newImageRect( "images/plataforma-02.png", 20, 300 )
  lado01.anchorX = 0
  lado01.anchorY = 0
  lado01.x, lado01.y = display.contentWidth/8, display.contentHeight/4.6

  lado02 = display.newImageRect( "images/plataforma-02.png", 20, 300 )
  lado02.anchorX = 0
  lado02.anchorY = 0
  lado02.x, lado02.y = display.contentWidth/1.17, display.contentHeight/4.6

  bola = display.newImageRect( "images/bola.png", 50, 50 )
  bola.anchorX = 0
  bola.anchorY = 0
  bola.x, bola.y = display.contentWidth/6, display.contentHeight/4.5
  bolaOrientation = "right"

  

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
  sceneGroup:insert( plataforma01 )
  sceneGroup:insert( plataforma02 )
  sceneGroup:insert( plataforma03 )
  sceneGroup:insert( plataforma04 )
  sceneGroup:insert( lado01 )
  sceneGroup:insert( lado02 )
  sceneGroup:insert( bola )
  sceneGroup:insert( linhaChegada )

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

    physics.addBody( plataforma01, "static")
    physics.addBody( plataforma02, "static" )
    physics.addBody( plataforma03, "static" )
    physics.addBody( plataforma04, "static" )
    physics.addBody( lado01, "static")
    physics.addBody( lado01, "static", { isSensor = true })
    physics.addBody( lado02, "static")
    physics.addBody( lado02, "static", { isSensor = true })
    physics.addBody( bola, "dynamic", { radius=25, density=1.0, friction=0.3, bounce=0.3 } )
    physics.addBody( linhaChegada, "static", { isSensor = true })


		buttomLeft.touch = onButtomLeftTouch
		buttomLeft:addEventListener( "touch", buttomLeft )

    buttomRight.touch = onButtomRightTouch
    buttomRight:addEventListener( "touch", buttomRight )

    bola:addEventListener( "collision", onCollision )

    


    if (ended ~= true) then
      recordAudioTimer = timer.performWithDelay(2000, recordAudio, 0)
    end
    -- Configurar um temporizador para chamar a função de detecção de intensidade de som regularmente
    

    
    -- if system.hasEventSource( "gyroscope" ) then
    --   print( "Gyroscope is supported on this platform.")
    --   Runtime:addEventListener( "gyroscope", onGyroscopeUpdate )
    -- else
    --   print( "Gyroscope is not supported on this platform.")

    -- end
    
	end

end

function scene:hide( event )
  local sceneGroup = self.view
  local phase = event.phase

  if event.phase == "will" then
    background:removeEventListener( "touch", buttomLeft )
    background:removeEventListener( "touch", buttomRight )
    if ( recordAudioTimer ) then
      timer.cancel( recordAudioTimer )
    end

    if ( detectSoundIntensityTimer ) then
      timer.cancel( detectSoundIntensityTimer )
    end

    physics.removeBody( bola )
    physics.removeBody( plataforma01 )
    physics.removeBody( plataforma02 )
    physics.removeBody( plataforma03 )
    physics.removeBody( plataforma04 )
    physics.removeBody( lado01 )
    physics.removeBody( lado02 )
    physics.removeBody( linhaChegada )

    bola:removeEventListener( "collision", onCollision )


  elseif phase == "did" then
    -- Called when the scene is now off screen.
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