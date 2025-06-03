local logo = {}
local tempo = 0
local duracao = 3
local imagemCamelo

function logo.load(proximo)
    tempo = 0
    imagemCamelo = love.graphics.newImage("texturas/znstudio.png")
    logo.proximoEstado = proximo or "carregando"
end

function logo.update(dt)
    tempo = tempo + dt
    if tempo >= duracao then
        estadoAtual = require("estados." .. logo.proximoEstado)
        estadoAtual.load("menu") 
    end
end

function logo.draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local iw, ih = imagemCamelo:getWidth(), imagemCamelo:getHeight()

    local escala = math.min(w / iw, h / ih)
    local x = (w - iw * escala) / 2
    local y = (h - ih * escala) / 2

    love.graphics.draw(imagemCamelo, x, y, 0, escala, escala)
end


return logo
