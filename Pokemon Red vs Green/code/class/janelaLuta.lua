require 'class/Player'
require 'class/Pokemon'

janelaLuta = {
	sons = {
		['luta'] = love.audio.newSource('audio/luta.mp3', 'static')
	},
	
	player = {
		['red'] = Player('pikachu', 'charizard', 'venusaur', 'blastoise', 'lapras', 'snorlax',
						10, 60, 215, 60, 'z', 'x', 'c', 'a', 's', 'd'),
		['green'] = Player('blastoiseB', 'pidgeotB', 'arcanineB', 'alakazamB', 'exeggutorB', 'rhydonB',  
						100, 40, 0, 90, 'z', 'x', 'c', 'a', 's', 'd')
	},

	pkballNome1 = {'pikachu', 'charizard', 'venusaur', 'blastoise', 'lapras', 'snorlax'},
	botoes1 = {['z'] = '1', ['x'] = '2', ['c'] = '3', ['a'] = '4', ['s'] = '5', ['d'] = '6'},
	btnLabel1 = {'(z)', '(x)', '(c)', '(a)', '(s)', '(d)'},
	
	pkballNome2 = {'blastoise', 'pidgeot', 'arcanine', 'alakazam', 'exeggutor', 'rhydon'},
	botoes2 = {['kp1'] = '1', ['kp2'] = '2', ['kp3'] = '3', ['kp4'] = '4', ['kp5'] = '5', ['kp6'] = '6'},
	btnLabel2 = {'(1)', '(2)', '(3)', '(4)', '(5)', '(6)'},

	pkball = {},

	imagens = {
		['arena'] = love.graphics.newImage('imagem/arenaLiga.png')
	},

	fontes = {
		['nome'] = love.graphics.newFont('fonte/font.ttf', 25),
		['botao'] = love.graphics.newFont('fonte/font.ttf', 13),
		['chat'] = love.graphics.newFont('fonte/font.ttf', 20),
		['pokemon'] = love.graphics.newFont('fonte/font.ttf', 15)
	},

	-- Tempo entre clicar um botão e outro
	dbDelay = 0,
	dbMax = 20,

	-- Define o tamanho que vai aumentar as imagens
	escalaTam = 4,
	margem = 5,

	-- Posição da arena centralizada na tela
	arenaX = 0,

	-- Painel inferior
	pInfX = 0,
	pInfY = 0,
	pInfTamX = 0,
	pInfTamY = 0,

	-- Painel lateral
	pEscX = 0,
	pEscY = 0,
	pDirX = 0,
	pDirY = 0,
	pTamX = 0,
	pTamY = 0,
	btn1 = 'z',
	btn2 = 'kp1',
	auxBtn1,
	auxBtn2 = ' ',
	flag = false
}

function janelaLuta:inicia(larguraVirtual, alturaVirtual)
	for k, v in pairs(self.pkballNome1) do
		 self.pkball[v] = Pokemon('infoPokemon/'.. tostring(v) ..'B.txt')
	end

	for k, v in pairs(self.pkballNome2) do
		 self.pkball[v] = Pokemon('infoPokemon/'.. tostring(v) ..'B.txt')
	end
	
	self.arenaX = (larguraVirtual - self.escalaTam * self.imagens['arena']:getWidth())/2

	self.pInfX = self.arenaX + self.margem
	self.pInfY = self.imagens['arena']:getHeight() * self.escalaTam + self.margem
	self.pInfTamX = self.imagens['arena']:getWidth() * self.escalaTam - self.margem
	self.pInfTamY = alturaVirtual - self.pInfY - self.margem

	self.pEscX = self.pEscX + self.margem
	self.pEscY = self.pEscY + self.margem 
	self.pDirX = self.pInfX + self.pInfTamX + self.margem
	self.pDirY = self.pDirY + self.margem
	self.pTamX = self.arenaX - self.margem * 2
	self.pTamY = alturaVirtual - self.margem * 2

	self.dbDelay = 0

	self.maquinaEstados = 'S0'
end

function love.keypressed(key)
	self.teste = key
end

function janelaLuta:atualiza(dt)
	if love.keyboard.isDown('escape') and self.dbDelay > self.dbMax then
		love.event.quit()
	end
	ataque1 = 0
	ataque2 = 0

	----- MQ 0 - Animação dos personagens -----
	if not self.sons['luta']:isPlaying() then self.sons['luta']:play() end 
	if self.maquinaEstados == 'S0' then
		if love.keyboard.isDown('return', 'space') and self.dbDelay > self.dbMax then		
			self.maquinaEstados = 'S1'
			self.dbDelay = 0
		end

	----- MQ 1 - Red seliciona um pokemon -----
	elseif self.maquinaEstados == 'S1' then
		if self.dbDelay > self.dbMax then 
			function love.keypressed(key)
				if self.botoes1[key] ~= nil then
					self.btn1 = key
					self.maquinaEstados = 'S2'
				end
			end
			self.dbDelay = 0
		end

	----- MQ 2 - Green seliciona um pokemon -----
	elseif self.maquinaEstados == 'S2' then
		if self.dbDelay > self.dbMax then 
			function love.keypressed(key)
				if self.botoes2[key] ~= nil then
					self.btn2 = key
					self.maquinaEstados = 'S3'
				end
			end
			self.dbDelay = 0
		end

	----- MQ 3 - Red seliciona se quer atacar ou trocar -----
	elseif self.maquinaEstados == 'S3' then
		if self.dbDelay > self.dbMax then 
			function love.keypressed(key)
				self.auxBtn1 = key
				self.maquinaEstados = 'S4'
			end
			self.dbDelay = 0
		end

	----- MQ 4 - Green seliciona se quer atacar ou trocar -----
	elseif self.maquinaEstados == 'S4' then
		if self.dbDelay > self.dbMax then 
			function love.keypressed(key)
				self.auxBtn2 = key
				self.maquinaEstados = 'S5'
				self.flag = true
			end
			self.dbDelay = 0
		end

	----- MQ 5 - Lutando -----
	elseif self.maquinaEstados == 'S5' then
		if self.flag then
			if self.botoes1[self.auxBtn1] ~= nil then
					self.btn1 = self.auxBtn1
			elseif self.auxBtn1 == 'q' then
				ataque1 = self.player['red'].pokemon[self.player['red'].pklutando].dano[1]
			elseif self.auxBtn1 == 'w' then
				ataque1 = self.player['red'].pokemon[self.player['red'].pklutando].dano[2]
				self.player['red'].pokemon[self.player['red'].pklutando].dano[2] = 0
			end

			if self.botoes2[self.auxBtn2] ~= nil then
					self.btn2 = self.auxBtn2
			elseif self.auxBtn2 == 'kp7' then
				ataque2 = self.player['green'].pokemon[self.player['green'].pklutando].dano[1]
			elseif self.auxBtn2 == 'kp8' then
				ataque2 = self.player['green'].pokemon[self.player['green'].pklutando].dano[2]
				self.player['green'].pokemon[self.player['green'].pklutando].dano[2] = 0
			end
		end
		self.flag = false
		if love.keyboard.isDown('return', 'space') and self.dbDelay > self.dbMax then 
			self.maquinaEstados = 'S6'
			self.dbDelay = 0
			ataque1 = 0
			ataque2 = 0
		end

	elseif self.maquinaEstados == 'S6' then
		if not self.player['red'].pokemon[self.player['red'].pklutando].vivo then
			if self.dbDelay > self.dbMax then 
				function love.keypressed(key)
					if self.botoes1[key] ~= nil then
						self.btn1 = key
						self.maquinaEstados = 'S6'
					end
				end
				self.dbDelay = 0
			end
		
		elseif not self.player['green'].pokemon[self.player['green'].pklutando].vivo then
			if self.dbDelay > self.dbMax then 
				function love.keypressed(key)
					if self.botoes2[key] ~= nil then
						self.btn2 = key
						self.maquinaEstados = 'S6'
					end
				end
				self.dbDelay = 0
			end
		else
			self.maquinaEstados = 'S3'
		end
	end

	self.player['red']:atualiza(dt, self.botoes1[self.btn1], ataque2)
	self.player['green']:atualiza(dt, self.botoes2[self.btn2], ataque1)

	self.dbDelay = self.dbDelay + 1 
	
	return 'S1'
end

function janelaLuta:desenha()
	---- Desenha o Layot da pagina ----
	love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', 0, 0, 1300, 800)

	love.graphics.draw(self.imagens['arena'], self.arenaX, 0, 0, self.escalaTam, self.escalaTam)
	love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('line', self.pInfX, self.pInfY, self.pInfTamX, self.pInfTamY, 20)
    love.graphics.rectangle('line', self.pEscX, self.pEscY, self.pTamX, self.pTamY, 20)
    love.graphics.rectangle('line', self.pDirX, self.pDirY, self.pTamX, self.pTamY, 20)

    love.graphics.setFont(self.fontes['nome'])
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print('Red', 35, 10)

	love.graphics.setColor(0, 147, 0, 255)
	love.graphics.print('Green', 1180, 10)

	for k, v in pairs(self.pkballNome1) do
		love.graphics.setFont(self.fontes['pokemon'])
		if self.player['red'].pokemon[tostring(k)].vivo then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(0, 0, 0, 255)
		end
		self.pkball[v]:animacao(1, (130 - self.pkball[v].tamX)/2, 115 * k - self.pkball[v].tamY - 20, false)		
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print(self.btnLabel1[k] .. ' ' .. self.pkballNome1[k], 15, 115 * k - 20)			
		love.graphics.setFont(self.fontes['botao'])
		love.graphics.print('vida: ' ..tostring(self.player['red'].pokemon[tostring(k)].vida), 15, 115 * k - 5)
	end

	for k, v in pairs(self.pkballNome2) do
		if self.player['green'].pokemon[tostring(k)].vivo then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(0, 0, 0, 255)
		end
		self.pkball[v]:animacao(1, 1155 +((130 - self.pkball[v].tamX)/2), 115 * k - self.pkball[v].tamY - 10, false)		
		love.graphics.setColor(0, 147, 0, 255)
		love.graphics.print(self.btnLabel2[k] .. ' ' .. self.pkballNome2[k], 1170, 115 * k - 10)
		love.graphics.setFont(self.fontes['botao'])
		love.graphics.print('vida: ' ..tostring(self.player['green'].pokemon[tostring(k)].vida), 1170, 115 * k +5)
	end
	love.graphics.setFont(self.fontes['chat'])
	----------------------------------------------
	---- MQ 0 - Animação dos personagens ----
	if self.maquinaEstados == 'S0' then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print('Começa a luta entre Red e Green!!!', 150, 600)
		love.graphics.setFont(self.fontes['botao'])
		love.graphics.print('(Pressione enter para continuar)', 920, 685)
	    love.graphics.setColor(255, 255, 255, 255)
	    self.player['red']:desenha(240, 336, true)
	    self.player['green']:desenha(800, 50, true)

	---- MQ 1 - Red seliciona um pokemon ----
	elseif self.maquinaEstados == 'S1' then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print('Red escolhe um pokemon!!!', 150, 600)
		love.graphics.setColor(255, 255, 255, 255)
	    self.player['red']:desenha(240, 336, true)
	    self.player['green']:desenha(800, 50, true)

	---- MQ 2 - Green seliciona um pokemon ----
	elseif self.maquinaEstados == 'S2' then
		love.graphics.setColor(0, 147, 0, 255)
		love.graphics.print('Green escolhe um pokemon!!!', 150, 600)
		love.graphics.setColor(255, 255, 255, 255)
	    self.player['red']:desenha(240, 336, true)
	    self.player['green']:desenha(800, 50, true)
	
	----- MQ 3 - Red seliciona se quer atacar ou trocar -----
	elseif self.maquinaEstados == 'S3' then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print('Red seleciona um ataque ou qual pokemon trocar:', 150, 600)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print('(q) Ataque  - ' .. tostring(self.player['red'].pokemon[self.player['red'].pklutando].dano[1]), 500, 630)
		love.graphics.print('(w) Especial - ' .. tostring(self.player['red'].pokemon[self.player['red'].pklutando].dano[2]), 500, 660)
		love.graphics.setColor(255, 255, 255, 255)
	    self.player['red']:desenha(240, 336, false)
	    self.player['green']:desenha(800, 50, false)

	----- MQ 4 - Green seliciona se quer atacar ou trocar -----
	elseif self.maquinaEstados == 'S4' then
		love.graphics.setColor(0, 147, 0, 255)
		love.graphics.print('Green seleciona um ataque ou qual pokemon trocar:', 150, 600)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print('(7) Ataque - ' .. tostring(self.player['green'].pokemon[self.player['green'].pklutando].dano[1]), 500, 630)
		love.graphics.print('(8) Especial - ' .. tostring(self.player['green'].pokemon[self.player['green'].pklutando].dano[2]), 500, 660)
		love.graphics.setColor(255, 255, 255, 255)
	    self.player['red']:desenha(240, 336, false)
	    self.player['green']:desenha(800, 50, false)
	
	----- MQ 5 - LUTA -----
	elseif self.maquinaEstados == 'S5' then
		if self.botoes1[self.auxBtn1] ~= nil then
			self.btn1 = self.auxBtn1
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.print('Red: Trocou de pokemon para ' .. self.pkballNome1[tonumber(self.botoes1[self.btn1])], 150, 620)
		
		else
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.print('Red: atacou', 150, 620)	
		end

		if self.botoes2[self.auxBtn2] ~= nil then
			self.btn2 = self.auxBtn2
			love.graphics.setColor(0, 147, 0, 255)
			love.graphics.print('Green trocou de pokemon para ' .. self.pkballNome2[tonumber(self.botoes2[self.btn2])], 150, 650)
		else
			love.graphics.setColor(0, 147, 0, 255)
			love.graphics.print('Green: atacou', 150, 650)
		end
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.setFont(self.fontes['botao'])
		love.graphics.print('(Pressione enter para continuar)', 920, 685)
		love.graphics.setFont(self.fontes['chat'])
		love.graphics.setColor(255, 255, 255, 255)
	    self.player['red']:desenha(240, 336, false)
	    self.player['green']:desenha(800, 50, false)
	
	----- MQ 6 - Se morreu -----
	elseif self.maquinaEstados == 'S6' then
		if not self.player['red'].pokemon[self.player['red'].pklutando].vivo then
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.print('Red escolhe um pokemon!!!', 150, 600)
			love.graphics.setColor(255, 255, 255, 255)
		    self.player['red']:desenha(240, 336, true)
		    self.player['green']:desenha(800, 50, false)
		elseif not self.player['green'].pokemon[self.player['green'].pklutando].vivo then
			love.graphics.setColor(0, 147, 0, 255)
			love.graphics.print('Green escolhe um pokemon!!!', 150, 600)
			love.graphics.setColor(255, 255, 255, 255)
		    self.player['red']:desenha(240, 336, false)
		    self.player['green']:desenha(800, 50, true)
		end
	end
end

return janelaLuta