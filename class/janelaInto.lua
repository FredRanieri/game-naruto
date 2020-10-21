janelaInto = {
	-- Carregar informações graficas e de audio
	imagens = {
		['logoUnifei'] = love.graphics.newImage('imagem/logoUnifei.png'), 
		['background'] = love.graphics.newImage('imagem/background.png'),
		['psRed'] = love.graphics.newImage('imagem/psRed.png'),
		['psGreen'] = love.graphics.newImage('imagem/psGreen.png'),
		['logoPokemon'] = love.graphics.newImage('imagem/logoPokemon.png'),
	},

	sons = {
		['abertura'] = love.audio.newSource('audio/opening.mp3', 'static')
	},

	videos = {
		['abertura'] = love.graphics.newVideo('video/abertura.ogv')
	},
	
	fontes = {
		['titulo'] = love.graphics.newFont('fonte/font.ttf', 40),
		['botao'] = love.graphics.newFont('fonte/font.ttf', 20)
	},

	-- Variavel de controle de estados
	maquinaEstados = 'S0',

	-- Tempo entre clicar um botão e outro
	dbDelay = 0,
	dbMax = 20,

	-- MQ 0 - Varaveis de animação do logo
	logoAlpha = 50,
	logoBrilha = true,
	logoX = 0,
	logoY = 0,

	-- MQ 2 - Variaveis de posição do texto e animação do background
	txtPsNome = 0,
	txtStart = 0,
	txtCentro = 0,
	bgX = 0,
	logoPokeX = 0,
	psRedX = 0,
	psGreenX = 0,
	psY = 250,
}

function janelaInto:inicia(larguraVirtual, alturaVirtual)
	love.mouse.setVisible(false)
	-- MQ 0
	self.logoX = (larguraVirtual - self.imagens['logoUnifei']:getWidth())/2
	self.logoY = (alturaVirtual - self.imagens['logoUnifei']:getHeight())/2

	-- MQ 2
	self.txtPsNome = larguraVirtual / 6
	self.txtStart = larguraVirtual / 3 + 80
	self.txtCentro = alturaVirtual * 2 - 150
	self.logoPokeX = (larguraVirtual - self.imagens['logoPokemon']:getWidth())/2
	self.psRedX = (larguraVirtual - self.imagens['psRed']:getWidth())/2 - 300
	self.psGreenX = (larguraVirtual - self.imagens['psGreen']:getWidth())/2 + 300
	self.bgX = 0
end

function janelaInto:atualiza()
	----[[ Maquina de estado 0: Animação do logo ----]]
	if self.maquinaEstados == 'S0' then
		if self.logoAlpha == 255 then
			self.logoBrilha = false
		end

		-- Enquanto claridade não ta no maximo vai aumentoando, se não vai diminuindo
		if self.logoBrilha then
			self.logoAlpha = self.logoAlpha + 1
		else
			self.logoAlpha = self.logoAlpha - 1
		end

		-- Muda de estado quando termina animação ou quando apertar
		if love.keyboard.isDown('return', 'escape', 'space') or self.logoAlpha < 50 then
			self.dbDelay = 0
			self.videos['abertura']:play()
			self.maquinaEstados = 'S1'
		end

	----[[ Maquina de estado 1: Video de apresentação dos personagens ----]]
	elseif self.maquinaEstados == 'S1' then
		if love.keyboard.isDown('return', 'escape', 'space') and self.dbDelay > self.dbMax then
            self.dbDelay = 0
            self.videos['abertura']:pause()
            self.maquinaEstados = 'S2'
        end

		if self.videos['abertura']:isPlaying() == false then
			self.maquinaEstados = 'S2'
		end

	----[[ Maquina de estado 2: Tela inicial do jogo ----]]
	elseif self.maquinaEstados == 'S2' then
		self.sons['abertura']:play()
		self.bgX = self.bgX + 1

		if love.keyboard.isDown('return', 'escape', 'space') and self.dbDelay > self.dbMax then
            self.dbDelay = 0
            self.sons['abertura']:pause()
            
            return 'S1'
        end
	end
	self.dbDelay = self.dbDelay + 1 
	return 'S0'
end

function janelaInto:desenha()
	----[[ Maquina de estado 0: Animação do logo ----]]
	if self.maquinaEstados == 'S0' then	
		love.graphics.setColor(255, 255, 255, self.logoAlpha)
		love.graphics.draw(self.imagens['logoUnifei'], self.logoX, self.logoY)
	
	----[[ Maquina de estado 1: Video de apresentação dos personagens ----]]
	elseif self.maquinaEstados == 'S1' then
		love.graphics.draw(self.videos['abertura'], 0, 0)
	
	----[[ Maquina de estado 2: Tela inicial do jogo ----]]
	elseif self.maquinaEstados == 'S2' then
		love.graphics.draw(self.imagens['background'], self.bgX % self.imagens['background']:getWidth(), 0)
		love.graphics.draw(self.imagens['background'],
		 			(self.bgX % self.imagens['background']:getWidth()) - self.imagens['background']:getWidth(), 0)

		love.graphics.draw(self.imagens['logoPokemon'], self.logoPokeX, 0)

		love.graphics.draw(self.imagens['psRed'], self.psRedX, self.psY)
		love.graphics.draw(self.imagens['psGreen'], self.psGreenX, self.psY)

		love.graphics.setFont(self.fontes['titulo'])
		love.graphics.setColor(255, 0, 0)
		love.graphics.printf('Red', 0, self.txtPsNome, self.txtCentro - 175, 'center')
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf('vs', 0, self.txtPsNome, self.txtCentro - 25, 'center')
		love.graphics.setColor(0, 147, 0)
		love.graphics.printf('Green', 0, self.txtPsNome, self.txtCentro + 175, 'center')

		love.graphics.setFont(self.fontes['botao'])
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf('Pressione Enter para continuar',
								0, self.txtStart, self.txtCentro, 'center')
	end
end

return janelaInto