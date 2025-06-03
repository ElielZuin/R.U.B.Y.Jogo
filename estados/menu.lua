local menu = {}
local som = require("sons.som")
local musicas = require("sons.musicas")

local larguraTela, alturaTela
local botaoJogar
local imagemFundo
local fonteBotao

-- Botões de música
local botoesMusica = {}

function menu.load()
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()

    imagemFundo = love.graphics.newImage("texturas/menu.png")
    fonteBotao = love.graphics.newFont(28)

    botaoJogar = {
        largura = 220,
        altura = 60
    }

    musicas.tocarAleatoria()

    menu.resize(larguraTela, alturaTela)
end

function menu.resize(w, h)
    larguraTela = w
    alturaTela = h
    botaoJogar.x = (larguraTela - botaoJogar.largura) / 2
    botaoJogar.y = (alturaTela - botaoJogar.altura) / 2

    -- Botões de controle de música
    local baseY = alturaTela - 50
    local baseX = larguraTela - 60
    local tam = 40
    botoesMusica = {
        {x = baseX - 200, y = baseY, label = ">>", acao = musicas.tocarAleatoria},
        {x = baseX - 150, y = baseY, label = "||", acao = musicas.pausar},
        {x = baseX - 100, y = baseY, label = ">", acao = musicas.continuar},
        {x = baseX - 50,  y = baseY, label = "+", acao = musicas.aumentarVolume},
        {x = baseX,       y = baseY, label = "-", acao = musicas.diminuirVolume},
    }
end

function menu.draw()
    -- fundo
    love.graphics.draw(imagemFundo, 0, 0, 0,
        larguraTela / imagemFundo:getWidth(),
        alturaTela / imagemFundo:getHeight()
    )

    -- botão jogar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", botaoJogar.x, botaoJogar.y, botaoJogar.largura, botaoJogar.altura, 12)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonteBotao)
    love.graphics.printf("JOGAR", botaoJogar.x, botaoJogar.y + 16, botaoJogar.largura, "center")

    -- botões de música
    love.graphics.setFont(love.graphics.newFont(18))
    for _, btn in ipairs(botoesMusica) do
        love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
        love.graphics.rectangle("fill", btn.x, btn.y, 40, 40, 8)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(btn.label, btn.x, btn.y + 10, 40, "center")
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        -- Clicou no botão "JOGAR"
        if x >= botaoJogar.x and x <= botaoJogar.x + botaoJogar.largura and
           y >= botaoJogar.y and y <= botaoJogar.y + botaoJogar.altura then
            som.SomClique()
            estadoAtual = require("estados.carregando")
            estadoAtual.load("selecao")
        end

        
        for _, btn in ipairs(botoesMusica) do
            if x >= btn.x and x <= btn.x + 40 and y >= btn.y and y <= btn.y + 40 then
                som.SomClique()
                btn.acao()
                break
            end
        end
    end
end

return menu
