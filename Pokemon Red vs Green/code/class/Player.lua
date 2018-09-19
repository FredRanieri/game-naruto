require 'class/Pokemon'

Player = Class{}

function Player:init(pk1, pk2, pk3, pk4, pk5, pk6, x1, x2, y1, y2)
	self.pkAtual = 0
	self.pokemon = {}
	self.pokemon['1'] = Pokemon('infoPokemon/' .. pk1 .. '.txt')
	self.pokemon['2'] = Pokemon('infoPokemon/' .. pk2 .. '.txt')
	self.pokemon['3'] = Pokemon('infoPokemon/' .. pk3 .. '.txt')
	self.pokemon['4'] = Pokemon('infoPokemon/' .. pk4 .. '.txt')
	self.pokemon['5'] = Pokemon('infoPokemon/' .. pk5 .. '.txt')
	self.pokemon['6'] = Pokemon('infoPokemon/' .. pk6 .. '.txt')

	self.imagem = love.graphics.newImage('imagem/psSprite.png')
	self.imgSp = love.graphics.newQuad(x1, y1, x2, y2, self.imagem:getDimensions())

	self.pklutando = 0
	self.treinador = true
end

function Player:atualiza(dt, btn, dano)
	for k, v in pairs(self.pokemon) do
		self.pokemon[k].lutando = false
	end

	self.treinador = false
	self.pokemon[btn].lutando = true
	self.pokemon[btn].vida = self.pokemon[btn].vida - dano
	self.pklutando = btn
	
	if self.pokemon[btn].vida <= 0 then
		self.pokemon[btn].vivo = false
		self.treinador = true
		
	end

	for k, v in pairs(self.pokemon) do
		if self.pokemon[k].lutando then
			self.pokemon[k]:atualiza(dt)
		end
	end
end

function Player:desenha(x, y, treinador)
	if self.treinador or treinador then 
		love.graphics.draw(self.imagem, self.imgSp, x, y, 0, 4, 4)
	else
		for k, v in pairs(self.pokemon) do
			if self.pokemon[k].lutando then
				self.pokemon[k]:animacao(4, 0, 0, true)
			end
		end
	end
end
