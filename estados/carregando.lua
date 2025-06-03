local carregando = {}

local fundoImagem
local tempo = 0
local tempoTotal = 1
local progresso = 0
local destino = nil

function carregando.load(dest)
    destino = dest
    fundoImagem = love.graphics.newImage("texturas/ruby.png")
    tempo = 0
    progresso = 0
end

function carregando.update(dt)
    tempo = tempo + dt
    progresso = math.min(tempo / tempoTotal, 1)

    if progresso >= 1 then
        estadoAtual = require("estados." .. destino)
        if estadoAtual.load then estadoAtual.load() end
    end
end

function carregando.draw()
    local largura = love.graphics.getWidth()
    local altura = love.graphics.getHeight()

    -- Fundo
    love.graphics.draw(fundoImagem, 0, 0, 0,
        largura / fundoImagem:getWidth(),
        altura / fundoImagem:getHeight())

    -- Barra de carregamento
    local barraLargura = largura * 0.5
    local barraAltura = 30
    local barraX = (largura - barraLargura) / 2
    local barraY = altura - 100

    -- Fundo da barra
    love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
    love.graphics.rectangle("fill", barraX, barraY, barraLargura, barraAltura, 10)

    -- Progresso
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", barraX, barraY, barraLargura * progresso, barraAltura, 10)

    -- Texto "Carregando"
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Carregando", 0, barraY - 40, largura, "center")
end

return carregando
