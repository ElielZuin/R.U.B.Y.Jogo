local musicas = {}

local lista = {
    "sons/musicas/HeroesTonight.mp3",
    "sons/musicas/HotelRoomService.mp3",
    "sons/musicas/NFSU2_1.mp3",
    "sons/musicas/NFSU2_2.mp3",
    "sons/musicas/NFSU2_3.mp3",
    "sons/musicas/GiveMeEverything.mp3",
    "sons/musicas/WakeMeUp.mp3"
}

local atual = nil
local volume = 0.4

function musicas.tocarAleatoria()
    if atual then
        atual:stop()
    end
    local index = love.math.random(1, #lista)
    atual = love.audio.newSource(lista[index], "stream")
    atual:setLooping(true)
    atual:setVolume(volume)
    atual:play()
end

function musicas.parar()
    if atual then atual:stop() end
end

function musicas.pausar()
    if atual then atual:pause() end
end

function musicas.continuar()
    if atual then atual:play() end
end

function musicas.proxima()
    musicas.tocarAleatoria()
end

function musicas.diminuirVolume()
    volume = math.max(0, volume - 0.1)
    if atual then atual:setVolume(volume) end
end

function musicas.aumentarVolume()
    volume = math.min(1, volume + 0.1)
    if atual then atual:setVolume(volume) end
end

return musicas
