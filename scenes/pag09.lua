-----------------------------------------------------------------------------------------
--
-- pag04.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text

local function onButtomLeftTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene( "scenes.pag08", "slideRight", 800 )
		
		return true	-- indicates successful touch
	end
	
end

local function onButtomRightTouch( self, event ) 
  if event.phase == "ended" or event.phase == "cancelled" then
    -- go to page03.lua scene
    composer.gotoScene( "scenes.pag10", "slideLeft", 800 )
    
    return true -- indicates successful touch
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

  text = display.newImageRect( "images/texto-pag-09.png", display.contentWidth - display.contentWidth/4, display.contentHeight - display.contentHeight/6 )
  text.anchorX = 0
  text.anchorY = 0
  text.x, text.y = display.contentWidth/8, 50

  sceneGroup:insert( background )
	sceneGroup:insert( buttomRight )
	sceneGroup:insert( buttomLeft )
  sceneGroup:insert( text )
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
		
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene