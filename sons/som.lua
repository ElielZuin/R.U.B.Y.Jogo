local som = {}

local somClique = love.audio.newSource("sons/MouseClick.mp3", "static")
local hoverBotoes = love.audio.newSource("sons/hoverBotoes.mp3", "static")
local InicioFase = love.audio.newSource("sons/IniciarFase.mp3", "static")
local MovimentoCarro = love.audio.newSource("sons/Movimento.mp3", "static")

function som.SomHover()
    hoverBotoes:stop()
    hoverBotoes:play()
end

function som.SomInicio()
    InicioFase:stop()
    InicioFase:play()
end

function som.SomMovimento()
    MovimentoCarro:stop()
    MovimentoCarro:play()
end

function som.SomClique()
    somClique:stop()
    somClique:play()
end

return som
