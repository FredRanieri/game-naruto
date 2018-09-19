Pokemon = Class{}

function Pokemon:init(caminho)
	self.fps = 13
	self.tempo = 0

	self.controleX = 0
	self.controleY = 0

	self.frame = 1
	self.frameX = 1
	self.frameY = 1

	self.lutando = false

	self.carregaInfo = love.filesystem.read(caminho)

	self.infoPokemon = {}

	for i in string.gmatch(self.carregaInfo, "%S+") do
		table.insert(self.infoPokemon, {i})
	end 

	self.imagem = love.graphics.newImage(self.infoPokemon[1][1]) 

	self.tamX = tonumber(self.infoPokemon[2][1])
	self.tamY = tonumber(self.infoPokemon[3][1]) 

	self.numFrameX = tonumber(self.infoPokemon[4][1])
	self.numFrameY = tonumber(self.infoPokemon[5][1])
	self.numFrame = tonumber(self.infoPokemon[6][1])

	self.posX = tonumber(self.infoPokemon[7][1])
	self.posY = tonumber(self.infoPokemon[8][1]) 

	self.vida = tonumber(self.infoPokemon[9][1])
	self.dano = {tonumber(self.infoPokemon[10][1]), tonumber(self.infoPokemon[11][1])}

	self.vivo = true

	self.imgSp = love.graphics.newQuad(0, 0, self.tamX, self.tamY, self.imagem:getDimensions())

	self.tempo = 1 / self.fps
end

function Pokemon:atualiza(dt)
	if dt > 0.035 then return end

	self.tempo = self.tempo - dt

	if self.tempo <= 0 then
		self.tempo = 1 / self.fps
			
		self.frame = self.frame + 1
		self.frameX = self.frameX + 1
			
		if self.frame == self.numFrame then
			self.frame = 1
			self.frameX = 1
			self.frameY = 1

		elseif self.frameX == self.numFrameX then
			self.frameX = 1
			self.frameY = self.frameY + 1

			if self.frameY == self.numFrameY then
				self.frameY = 1
			end
		end
	end

	self.controleX = self.tamX * self.frameX
	self.controleY = self.tamY * self.frameY
	self.imgSp:setViewport(self.controleX + 0.25, self.controleY, self.tamX, self.tamY)
end

function Pokemon:animacao(escala, x, y, flag)

	if flag then
		love.graphics.draw(self.imagem, self.imgSp, self.posX, self.posY, 0, escala, escala)
	else
		love.graphics.draw(self.imagem, self.imgSp, x, y, 0, escala, escala)
	end
end