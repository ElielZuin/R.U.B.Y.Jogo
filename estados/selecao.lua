local sons = require("sons.som")

local selecao = {}

local botoes = {}
local larguraBotao, alturaBotao = 100, 60
local margem = 20
local linhas = 4
local colunas = 5
local fundoImagem
local mouseX, mouseY = 0, 0

-- Armazena último botão em hover pra evitar som repetido
local ultimoHover = nil

function selecao.load()
    fundoImagem = love.graphics.newImage("texturas/fundocidade2.png")
    atualizaLayoutBotoes()
end

function atualizaLayoutBotoes()
    botoes = {}
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    larguraBotao = math.min(150, screenWidth * 0.12)
    alturaBotao = math.min(150, screenHeight * 0.1)

    local totalLargura = colunas * larguraBotao + (colunas - 1) * margem
    local totalAltura = linhas * alturaBotao + (linhas - 1) * margem
    local inicioX = (screenWidth - totalLargura) / 2
    local inicioY = (screenHeight - totalAltura) / 2

    for i = 1, 20 do
        local linha = math.ceil(i / colunas)
        local coluna = (i - 1) % colunas + 1
        local x = inicioX + (coluna - 1) * (larguraBotao + margem)
        local y = inicioY + (linha - 1) * (alturaBotao + margem)

        table.insert(botoes, {
            numero = i,
            x = x,
            y = y,
            cor = linha == 1 and {0, 0.6, 0} or
                 linha == 2 and {1, 0.5, 0} or
                 linha == 3 and {0, 0, 0.5} or
                 linha == 4 and {0.7, 0, 0},
        })
    end
end

function selecao.update(dt)
    mouseX, mouseY = love.mouse.getPosition()

    -- Verifica hover atual
    local hoverAtual = nil
    for _, botao in ipairs(botoes) do
        if isMouseOver(botao) then
            hoverAtual = botao.numero
            break
        end
    end

    -- Toca som se mudou o hover
    if hoverAtual ~= ultimoHover then
        if hoverAtual then
            sons.SomInicio()
        end
        ultimoHover = hoverAtual
    end
end

function selecao.draw()
    love.graphics.draw(fundoImagem, 0, 0, 0,
        love.graphics.getWidth() / fundoImagem:getWidth(),
        love.graphics.getHeight() / fundoImagem:getHeight())

    for _, botao in ipairs(botoes) do
        local brilho = isMouseOver(botao) and 0.3 or 0
        love.graphics.setColor(
            math.min(botao.cor[1] + brilho, 1),
            math.min(botao.cor[2] + brilho, 1),
            math.min(botao.cor[3] + brilho, 1), 0.9)

        love.graphics.rectangle("fill", botao.x, botao.y, larguraBotao, alturaBotao, 10)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf(tostring(botao.numero), botao.x, botao.y + alturaBotao / 2 - 10, larguraBotao, "center")
    end
end

function selecao.mousepressed(x, y, button)
    if button == 1 then
        for _, botao in ipairs(botoes) do
            if isMouseOver(botao) then
                _G.faseSelecionada = botao.numero
                sons.SomClique()
                estadoAtual = require("estados.carregando")
                estadoAtual.load("jogo")
                break
            end
        end
    end
end

function isMouseOver(botao)
    return mouseX >= botao.x and mouseX <= botao.x + larguraBotao and
           mouseY >= botao.y and mouseY <= botao.y + alturaBotao
end

function selecao.resize(w, h)
    atualizaLayoutBotoes()
end

return selecao
