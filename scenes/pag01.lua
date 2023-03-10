-----------------------------------------------------------------------------------------
--
-- pag01.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declaration
local background, border, titles

-- Touch listener function for background object
local function onBackgroundTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page1.lua scene
		composer.gotoScene( "scenes.pag02", "slideLeft", 800 )
		
		return true	-- indicates successful touch
	end
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	background = display.newImageRect( sceneGroup, "images/capa-back.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	border = display.newImageRect( sceneGroup, "images/border.png", display.contentWidth, display.contentHeight )
	border.anchorX = 0
	border.anchorY = 0
	border.x, border.y = 0, 0

	titles = display.newImageRect( sceneGroup, "images/titles.png", (display.contentWidth/2 + display.contentWidth/4), (display.contentHeight/3 + display.contentHeight/6))
	titles.anchorX = 0
	titles.anchorY = 0
	titles.x, titles.y = display.contentWidth/8, 100
	
	-- Add more text
	local pageText = display.newText( "[ Toque na tela para continuar ]", 0, 0, native.systemFont, 18 )
	pageText.x = display.contentWidth * 0.5
	pageText.y = display.contentHeight - (display.contentHeight*0.1)
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( border )
	sceneGroup:insert( titles )
	sceneGroup:insert( pageText )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		
		background.touch = onBackgroundTouch
		background:addEventListener( "touch", background )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

		-- remove event listener from background
		background:removeEventListener( "touch", background )
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene