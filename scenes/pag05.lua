-----------------------------------------------------------------------------------------
--
-- pag04.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

-- forward declarations and other locals
local background, buttomLeft, buttomRight, text, setaDireita, setaEsquerda, retangulo, posicaoAtual, plataforma, posicaoFinal, deslocamento_text, ponto_inicial, ponto_final, personagem, posicaoInicial, deslocamento, personagem_sheet

local sheetOptions =
{
	frames =
	{
			{   -- frame 1
					x = 0,
					y = 0,
					width = 150,
					height = 250
			},
			{   -- frame 2
					x = 150,
					y = 0,
					width = 140,
					height = 250
			},
			{
					x = 290,
					y = 0,
					width = 110,
					height = 250
			}

	}
}

-- sequences table
local sequences = 
{
	{
			name = "fastRun",
			frames = { 3,2,1 },
			time = 400,
			loopCount = 0,
			loopDirection = "forward"
	},

}

local function onButtomLeftTouch(self, event)
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page01.lua scene
		composer.gotoScene("scenes.pag04", "slideRight", 800)

		return true -- indicates successful touch
	end
end

local function onButtomRightTouch(self, event)
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page03.lua scene
		composer.gotoScene("scenes.pag06", "slideLeft", 800)

		return true -- indicates successful touch
	end
end

local function onSetaDireitaTouch(event)
	if (event.phase == "began") and posicaoAtual + 8 < 100 then
		-- Começa a mover o personagem para a direita
		personagem.direction = "direita"
		personagem.isMoving = true
		if posicaoAtual ~= 0 or posicaoAtual ~= 100 then
			print("posicao atual dir: " .. posicaoAtual)
			personagem.x = plataforma.x + posicaoAtual * 6 - personagem.width/4
		end
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		-- Para de mover o personagem
		personagem.isMoving = false
		posicaoFinal = posicaoAtual
		deslocamento = math.abs(posicaoFinal - posicaoInicial + 8)
		deslocamento_text.text = "Deslocamento: " .. deslocamento .. " m"
		posicaoInicial = posicaoFinal
		personagem:pause()
	end
end

local function onSetaEsquerdaTouch(event)
	if (event.phase == "began") and posicaoAtual > 0 then
		-- Começa a mover o personagem para a esquerda
		personagem.direction = "esquerda"
		personagem.isMoving = true
		if posicaoAtual ~= 0 or posicaoAtual ~= 100 then
			print("posicao atual esq: " .. posicaoAtual)
			personagem.x = plataforma.x + posicaoAtual * 6 + personagem.width/2
		end
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		-- Para de mover o personagem
		personagem.isMoving = false
		posicaoFinal = posicaoAtual
		deslocamento = math.abs(posicaoFinal - posicaoInicial - 8)
		deslocamento_text.text = "Deslocamento: " .. deslocamento .. " m"
		posicaoInicial = posicaoFinal
		personagem:pause()
	end
end

local function movePersonagem()
	if (personagem.isMoving) then
		personagem:play()
		if (personagem.direction == "direita") and posicaoAtual + 8 < 100 then
			personagem.x = personagem.x + 6 -- ou qualquer outra velocidade desejada
			posicaoAtual = posicaoAtual + 1
			personagem.xScale = 0.5
		elseif (personagem.direction == "esquerda") and posicaoAtual > 0 then
			personagem.x = personagem.x - 6 -- ou qualquer outra velocidade desejada
			posicaoAtual = posicaoAtual - 1
			personagem.xScale = -0.5
		end
	end
end

function scene:create(event)
	local sceneGroup = self.view

	background = display.newImageRect("images/background-color.png", display.contentWidth, display.contentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	buttomRight = display.newImageRect("images/buttom-right.png", 100, 100)
	buttomRight.anchorX = 0
	buttomRight.anchorY = 0
	buttomRight.x, buttomRight.y = display.contentWidth - display.contentWidth / 6,
	(display.contentHeight - display.contentHeight / 6)

	buttomLeft = display.newImageRect("images/buttom-left.png", 100, 100)
	buttomLeft.anchorX = 0
	buttomLeft.anchorY = 0
	buttomLeft.x, buttomLeft.y = display.contentWidth / 20, (display.contentHeight - display.contentHeight / 6)

	text = display.newImageRect("images/texto-pag-05.png", display.contentWidth - display.contentWidth / 4,
	display.contentHeight - display.contentHeight / 4)
	text.anchorX = 0
	text.anchorY = 0
	text.x, text.y = display.contentWidth / 8, 50

	plataforma = display.newImageRect("images/plataforma-uniforme.png", 600, 20)
	plataforma.anchorX = 0
	plataforma.anchorY = 0
	plataforma.x, plataforma.y = display.contentWidth / 2 - plataforma.width / 2, (display.contentHeight / 3)

	ponto_inicial = display.newText("0 m", plataforma.x + 30, plataforma.y + 40, native.systemFont, 30)
	ponto_inicial:setFillColor(0, 0, 0)

	ponto_final = display.newText("100 m", plataforma.x + plataforma.width - 40, plataforma.y + 40, native.systemFont, 30)
	ponto_final:setFillColor(0, 0, 0)

	retangulo = display.newImageRect("images/retangulo.png", 300, 50)
	retangulo.anchorX = 0
	retangulo.anchorY = 0
	retangulo.x, retangulo.y = display.contentWidth / 2 - retangulo.width / 2, (display.contentHeight / 2.5)

	deslocamento_text = display.newText("Deslocamento: 0 m", retangulo.x + retangulo.width / 2,
	retangulo.y + retangulo.height / 2, native.systemFont, 25)
	deslocamento_text:setFillColor(0, 0, 0)

	setaDireita = display.newImageRect("images/seta-dir.png", 70, 50)
	setaDireita.anchorX = 0
	setaDireita.anchorY = 0
	setaDireita.x, setaDireita.y = display.contentWidth / 2 + retangulo.width / 2 + 40, (display.contentHeight / 2.5)

	setaEsquerda = display.newImageRect("images/seta-esq.png", 70, 50)
	setaEsquerda.anchorX = 0
	setaEsquerda.anchorY = 0
	setaEsquerda.x, setaEsquerda.y = display.contentWidth / 2 - retangulo.width / 2 - setaEsquerda.width - 40,
	(display.contentHeight / 2.5)

	personagem_sheet = graphics.newImageSheet( "images/personagem-andando.png", sheetOptions )
	personagem = display.newSprite( personagem_sheet, sequences )
	personagem.xScale = 0.5
	personagem.yScale = 0.5
	personagem.anchorX = 0
	personagem.anchorY = 0
	personagem.x, personagem.y = plataforma.x, (plataforma.y - personagem.height/2)

	posicaoInicial = 0
	posicaoAtual = 0
	posicaoFinal = 100


	sceneGroup:insert(background)
	sceneGroup:insert(buttomRight)
	sceneGroup:insert(buttomLeft)
	sceneGroup:insert(text)
	sceneGroup:insert(setaDireita)
	sceneGroup:insert(setaEsquerda)
	sceneGroup:insert(retangulo)
	sceneGroup:insert(plataforma)
	sceneGroup:insert(ponto_inicial)
	sceneGroup:insert(ponto_final)
	sceneGroup:insert(deslocamento_text)
	sceneGroup:insert(personagem)
end

function scene:show(event)
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
		buttomLeft:addEventListener("touch", buttomLeft)

		buttomRight.touch = onButtomRightTouch
		buttomRight:addEventListener("touch", buttomRight)

		setaDireita:addEventListener("touch", onSetaDireitaTouch)
		setaEsquerda:addEventListener("touch", onSetaEsquerdaTouch)

		Runtime:addEventListener("enterFrame", movePersonagem)
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		buttomLeft:removeEventListener("touch", buttomLeft)
		buttomRight:removeEventListener("touch", buttomRight)
		setaDireita:removeEventListener("touch", onSetaDireitaTouch)
		setaEsquerda:removeEventListener("touch", onSetaEsquerdaTouch)
		Runtime:removeEventListener("enterFrame", movePersonagem)
	elseif phase == "did" then
		-- Called immediately after scene goes off screen.
	end
end

function scene:destroy(event)

end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
