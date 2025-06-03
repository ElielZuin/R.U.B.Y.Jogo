local jogo = {}
local som = require("sons.som")
local musicas = require("sons.musicas") -- Adiciona o módulo das músicas

local fase = nil
local movimentos = 0
local tempoInicial = 0
local tempo = 0
local carroSelecionado = nil
local offsetX, offsetY = 0, 0
local tamanhoOriginal = 104
local escala = 1
local tabuleiroX, tabuleiroY
local screenWidth, screenHeight

-- Botões
local larguraBotao = 160
local alturaBotao = 40
local espacamento = 20
local botaoReiniciar = {x = 0, y = 0, largura = larguraBotao, altura = alturaBotao}
local botaoMenu = {x = 0, y = 0, largura = larguraBotao, altura = alturaBotao}

-- Botões de música
local botoesMusica = {}

function jogo.load()
    local num = _G.faseSelecionada or 1
    fase = require("fases.fase" .. string.format("%02d", num))
    if fase.resetar then
        fase.resetar()
    end

    movimentos = 0
    tempoInicial = love.timer.getTime()
    carroSelecionado = nil
    recalcularEscala()

    musicas.tocarAleatoria()
end

function jogo.update(dt)
    tempo = math.floor(love.timer.getTime() - tempoInicial)
end

function jogo.draw()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.draw(fase.fundoImagem, 0, 0, 0,
        screenWidth / fase.fundoImagem:getWidth(),
        screenHeight / fase.fundoImagem:getHeight())

    for linha = 1, #fase.mapa do
        for coluna = 1, #fase.mapa[linha] do
            local letra = fase.mapa[linha][coluna]
            local img = fase.blocos[letra]
            if img then
                local x = tabuleiroX + (coluna - 1) * tamanhoOriginal * escala
                local y = tabuleiroY + (linha - 1) * tamanhoOriginal * escala
                love.graphics.draw(img, x, y, 0, escala, escala)
            end
        end
    end

    for _, carro in ipairs(fase.carros) do
        local px = tabuleiroX + (carro.x - 1) * tamanhoOriginal * escala
        local py = tabuleiroY + (carro.y - 1) * tamanhoOriginal * escala
        love.graphics.draw(carro.imagem, px, py, 0, escala, escala)
    end

    -- HUD
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle("fill", 0, screenHeight - 60, screenWidth, 60)

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.setFont(love.graphics.newFont(16))
    local minutos = math.floor(tempo / 60)
    local segundos = tempo % 60
    local tempoFormatado = string.format("%02d:%02d", minutos, segundos)
    love.graphics.printf("Tempo: " .. tempoFormatado, screenWidth - 160, screenHeight - 50, 150, "right")
    love.graphics.printf("Movimentos: " .. movimentos, screenWidth - 160, screenHeight - 30, 150, "right")

    -- Botões principais
    love.graphics.setColor(0.8, 0.3, 0.3)
    love.graphics.rectangle("fill", botaoReiniciar.x, botaoReiniciar.y, botaoReiniciar.largura, botaoReiniciar.altura, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("REINICIAR", botaoReiniciar.x, botaoReiniciar.y + 10, botaoReiniciar.largura, "center")

    love.graphics.setColor(0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", botaoMenu.x, botaoMenu.y, botaoMenu.largura, botaoMenu.altura, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("MENU", botaoMenu.x, botaoMenu.y + 10, botaoMenu.largura, "center")

    -- Botões de música (estilo menu)
    love.graphics.setFont(love.graphics.newFont(18))
    for _, btn in ipairs(botoesMusica) do
        love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
        love.graphics.rectangle("fill", btn.x, btn.y, 40, 40, 8)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(btn.label, btn.x, btn.y + 10, 40, "center")
    end
end

function jogo.mousepressed(x, y, button)
    if button == 1 then
        if x >= botaoReiniciar.x and x <= botaoReiniciar.x + botaoReiniciar.largura and
           y >= botaoReiniciar.y and y <= botaoReiniciar.y + botaoReiniciar.altura then
            som.SomClique()
            jogo.load()
            return
        end

        if x >= botaoMenu.x and x <= botaoMenu.x + botaoMenu.largura and
           y >= botaoMenu.y and y <= botaoMenu.y + botaoMenu.altura then
            som.SomClique()
            estadoAtual = require("estados.carregando")
            estadoAtual.load("menu")
            return
        end

        -- Clicou em algum botão de música
        for _, btn in ipairs(botoesMusica) do
            if x >= btn.x and x <= btn.x + 40 and y >= btn.y and y <= btn.y + 40 then
                som.SomClique()
                btn.acao()
                return
            end
        end

        for _, carro in ipairs(fase.carros) do
            local px = tabuleiroX + (carro.x - 1) * tamanhoOriginal * escala
            local py = tabuleiroY + (carro.y - 1) * tamanhoOriginal * escala
            local largura = carro.largura * tamanhoOriginal * escala
            local altura = carro.altura * tamanhoOriginal * escala
            if x >= px and x <= px + largura and y >= py and y <= py + altura then
                carroSelecionado = carro
                offsetX = x - px
                offsetY = y - py
                break
            end
        end
    end
end

function jogo.mousemoved(x, y)
    if carroSelecionado then
        local novaX = x - offsetX
        local novaY = y - offsetY
        local gridX = math.floor((novaX - tabuleiroX) / (tamanhoOriginal * escala)) + 1
        local gridY = math.floor((novaY - tabuleiroY) / (tamanhoOriginal * escala)) + 1

        if carroSelecionado.direcao == "horizontal" then
            if podeMoverComCaminho(carroSelecionado, gridX, carroSelecionado.y) then
                carroSelecionado.x = gridX
            end
        elseif carroSelecionado.direcao == "vertical" then
            if podeMoverComCaminho(carroSelecionado, carroSelecionado.x, gridY) then
                carroSelecionado.y = gridY
            end
        end
    end
end

function jogo.mousereleased(x, y, button)
    if button == 1 and carroSelecionado then
        carroSelecionado.x = math.floor(carroSelecionado.x + 0.5)
        carroSelecionado.y = math.floor(carroSelecionado.y + 0.5)
        som.SomMovimento()
        movimentos = movimentos + 1
        carroSelecionado = nil

        if fase.verificaVitoria and fase.verificaVitoria() then
            _G.tempoFinal = tempo
            _G.movimentosFinais = movimentos
            estadoAtual = require("estados.vitoria")
            estadoAtual.load("vitoria")
        end
    end
end

function recalcularEscala()
    if not fase or not fase.mapa then return end

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    local colunas = #fase.mapa[1]
    local linhas = #fase.mapa
    local margemInferiorHUD = 100

    local areaLargura = screenWidth * 0.95
    local areaAltura = (screenHeight - margemInferiorHUD) * 0.95

    local escalaX = areaLargura / (colunas * tamanhoOriginal)
    local escalaY = areaAltura / (linhas * tamanhoOriginal)
    escala = math.min(escalaX, escalaY)

    tabuleiroX = (screenWidth - colunas * tamanhoOriginal * escala) / 2
    tabuleiroY = (screenHeight - linhas * tamanhoOriginal * escala - margemInferiorHUD) / 2

    -- Botões principais
    local totalLargura = botaoReiniciar.largura + botaoMenu.largura + espacamento
    local inicioX = (screenWidth - totalLargura) / 2
    local y = screenHeight - 60
    botaoReiniciar.x = inicioX
    botaoReiniciar.y = y
    botaoMenu.x = inicioX + botaoReiniciar.largura + espacamento
    botaoMenu.y = y

    -- Botões de música (lado esquerdo da HUD)
    local baseY = screenHeight - 50
    local baseX = 20
    botoesMusica = {
        {x = baseX,      y = baseY, label = ">>", acao = musicas.tocarAleatoria},
        {x = baseX + 50, y = baseY, label = "||", acao = musicas.pausar},
        {x = baseX +100, y = baseY, label = ">",  acao = musicas.continuar},
        {x = baseX +150, y = baseY, label = "+",  acao = musicas.aumentarVolume},
        {x = baseX +200, y = baseY, label = "-",  acao = musicas.diminuirVolume}
    }
end

function jogo.resize(w, h)
    recalcularEscala()
end

function podeMoverComCaminho(carro, novoX, novoY)
    local passoX = novoX > carro.x and 1 or (novoX < carro.x and -1 or 0)
    local passoY = novoY > carro.y and 1 or (novoY < carro.y and -1 or 0)
    local x, y = carro.x, carro.y
    while x ~= novoX or y ~= novoY do
        x = x + passoX
        y = y + passoY
        if not podeMover(carro, x, y) then return false end
    end
    return true
end

function podeMover(carro, novoX, novoY)
    for i = 0, carro.largura - 1 do
        for j = 0, carro.altura - 1 do
            local col = novoX + i
            local lin = novoY + j
            if lin < 1 or lin > #fase.mapa or col < 1 or col > #fase.mapa[1] then return false end
            if fase.mapa[lin][col] == "" or fase.mapa[lin][col] == nil then return false end
            for _, outro in ipairs(fase.carros) do
                if outro ~= carro then
                    for oi = 0, outro.largura - 1 do
                        for oj = 0, outro.altura - 1 do
                            if col == outro.x + oi and lin == outro.y + oj then return false end
                        end
                    end
                end
            end
        end
    end
    return true
end

return jogo
