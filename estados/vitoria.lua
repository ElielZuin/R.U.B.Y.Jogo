local vitoria = {}

local fundoImagem
local larguraTela, alturaTela
local botaoMenu = {}
local mouseX, mouseY = 0, 0
local mouseSobreBotao = false

local som = require("sons.som")

function vitoria.load()
    fundoImagem = love.graphics.newImage("texturas/ruby.png")
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()

    botaoMenu = {
        largura = 200,
        altura = 50,
        x = (larguraTela - 200) / 2,
        y = alturaTela - 100
    }
end

function vitoria.update(dt)
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()

    botaoMenu.x = (larguraTela - botaoMenu.largura) / 2
    botaoMenu.y = alturaTela - 100

    mouseX, mouseY = love.mouse.getPosition()
    local dentro = mouseX >= botaoMenu.x and mouseX <= botaoMenu.x + botaoMenu.largura and
                   mouseY >= botaoMenu.y and mouseY <= botaoMenu.y + botaoMenu.altura

    if dentro and not mouseSobreBotao then
        som.SomHover()
    end
    mouseSobreBotao = dentro
end

function vitoria.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(fundoImagem, 0, 0, 0,
        larguraTela / fundoImagem:getWidth(),
        alturaTela / fundoImagem:getHeight())

    local boxWidth = 400
    local boxHeight = 200
    local boxX = (larguraTela - boxWidth) / 2
    local boxY = (alturaTela - boxHeight) / 2

    love.graphics.setColor(1, 1, 1, 0.85)
    love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight, 20)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf("FASE CONCLUÍDA!", boxX, boxY + 20, boxWidth, "center")

    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("Tempo: " .. tostring(_G.tempoFinal or 0) .. " segundos", boxX, boxY + 80, boxWidth, "center")
    love.graphics.printf("Movimentos: " .. tostring(_G.movimentosFinais or 0), boxX, boxY + 120, boxWidth, "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", botaoMenu.x, botaoMenu.y, botaoMenu.largura, botaoMenu.altura, 10)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("VOLTAR AO MENU", botaoMenu.x, botaoMenu.y + 15, botaoMenu.largura, "center")

    love.graphics.setColor(1, 1, 1)
end

function vitoria.mousepressed(x, y, button)
    if button == 1 then
        if x >= botaoMenu.x and x <= botaoMenu.x + botaoMenu.largura and
           y >= botaoMenu.y and y <= botaoMenu.y + botaoMenu.altura then
            som.SomClique()
            estadoAtual = require("estados.carregando")
            estadoAtual.load("menu")
        end
    end
end

return vitoria
