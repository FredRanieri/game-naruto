-- Carregar biblioteca de controle dos graficos como resolução virtual e alterar tamanho da janela
push = require 'push'
Class = require 'class'
janelaInto = require 'class/janelaInto'
janelaLuta = require 'class/janelaLuta'

-- Definir tamanho de tela
largura = 1280		          -- Largura da tela
altura = 720		          -- Altura da tela

larguraVirtual = 1280          -- Largura virtual
alturaVirtual = 720           -- Altura virtual

maquinaEstados = 'S0'

function love.load()
	-- Filtro de pixels
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Nome da janela
    love.window.setTitle('Pokemon')

    -- Inicia informações da janelas de into
    janelaInto:inicia(larguraVirtual, alturaVirtual)
    janelaLuta:inicia(larguraVirtual, alturaVirtual)

    -- initialize our virtual resolution
    push:setupScreen(larguraVirtual, alturaVirtual, largura, altura, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })
end

-- Alterar tamanho da janela durante o jogo
function love.resize(w, h)
    push:resize(w, h)
end

-- Controle de botões
function love.keypressed(key)

end

function love.update(dt)
    if maquinaEstados == 'S0' then
        maquinaEstados = janelaInto:atualiza()
    elseif maquinaEstados == 'S1' then
        maquinaEstados = janelaLuta:atualiza(dt)
    end
end

-- Função de render para desenhar na tela
function love.draw()
    push:start()

    if maquinaEstados == 'S0' then
        janelaInto:desenha()
    elseif maquinaEstados == 'S1' then
        janelaLuta:desenha()
    end
    
    push:finish()
end