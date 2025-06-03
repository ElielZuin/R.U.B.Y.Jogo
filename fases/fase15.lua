local fase = {}

fase.mapa = {
    {"2", "N", "N", "N", "N", "1", "", "", ""},
    {"O", "C", "C", "C", "C", "L", "", "", ""},
    {"O", "C", "C", "C", "C", "S", "P", "P", "P"},
    {"O", "C", "C", "C", "C", "L", "", "", ""},
    {"O", "C", "C", "C", "C", "L", "", "", ""},
    {"3", "B", "B", "B", "B", "4", "", "", ""},
}

fase.blocos = {
    ["C"] = love.graphics.newImage("texturas/bgchao.png"),
    ["P"] = love.graphics.newImage("texturas/bgponte.png"),
    ["S"] = love.graphics.newImage("texturas/bgsaida.png"),
    ["N"] = love.graphics.newImage("texturas/N.png"),
    ["B"] = love.graphics.newImage("texturas/B.png"),
    ["O"] = love.graphics.newImage("texturas/O.png"),
    ["L"] = love.graphics.newImage("texturas/L.png"),
    ["1"] = love.graphics.newImage("texturas/1.png"),
    ["2"] = love.graphics.newImage("texturas/2.png"),
    ["3"] = love.graphics.newImage("texturas/3.png"),
    ["4"] = love.graphics.newImage("texturas/4.png"),
}

fase.fundoImagem = love.graphics.newImage("texturas/fundonoturno4.png")

fase.carros = {
    {imagem = love.graphics.newImage("texturas/vermelho.png"), x = 1, y = 3, largura = 2, altura = 1, direcao = "horizontal", tipo = "vermelho"},
    {imagem = love.graphics.newImage("texturas/laranja3.png"), x = 2, y = 1, largura = 2, altura = 1, direcao = "horizontal"},
    {imagem = love.graphics.newImage("texturas/azulclaro3.png"), x = 2, y = 2, largura = 2, altura = 1, direcao = "horizontal"},
    {imagem = love.graphics.newImage("texturas/roxo4.png"), x = 4, y = 4, largura = 2, altura = 1, direcao = "horizontal"},
    {imagem = love.graphics.newImage("texturas/caminhao2.png"), x = 4, y = 6, largura = 3, altura = 1, direcao = "horizontal"},
    
    {imagem = love.graphics.newImage("texturas/limao1.png"), x = 1, y = 1, largura = 1, altura = 2, direcao = "vertical"},
    {imagem = love.graphics.newImage("texturas/rosa2.png"), x = 3, y = 3, largura = 1, altura = 2, direcao = "vertical"},
    {imagem = love.graphics.newImage("texturas/ciano2.png"), x = 3, y = 5, largura = 1, altura = 2, direcao = "vertical"},
    {imagem = love.graphics.newImage("texturas/caminhao1.png"), x = 6, y = 3, largura = 1, altura = 3, direcao = "vertical"},
    {imagem = love.graphics.newImage("texturas/onibus2.png"), x = 4, y = 1, largura = 1, altura = 3, direcao = "vertical"},
    
}

-- Cópia original dos carros para resetar
fase.carrosOriginais = {}
for _, carro in ipairs(fase.carros) do
    local copia = {}
    for k, v in pairs(carro) do
        copia[k] = v
    end
    table.insert(fase.carrosOriginais, copia)
end

function fase.resetar()
    if fase.carrosOriginais then
        fase.carros = {}
        for _, carro in ipairs(fase.carrosOriginais) do
            local novo = {}
            for k, v in pairs(carro) do
                novo[k] = v
            end
            table.insert(fase.carros, novo)
        end
    end
end

function fase.podeMoverComCaminho(carro, novoX, novoY)
    local passoX = novoX > carro.x and 1 or (novoX < carro.x and -1 or 0)
    local passoY = novoY > carro.y and 1 or (novoY < carro.y and -1 or 0)
    local x, y = carro.x, carro.y
    while x ~= novoX or y ~= novoY do
        x = x + passoX
        y = y + passoY
        for _, outro in ipairs(fase.carros) do
            if outro ~= carro then
                for i = 0, outro.largura - 1 do
                    for j = 0, outro.altura - 1 do
                        if x >= outro.x + i and x < outro.x + i + 1 and
                           y >= outro.y + j and y < outro.y + j + 1 then
                            return false
                        end
                    end
                end
            end
        end
    end
    return true
end

function fase.verificaVitoria()
    for _, carro in ipairs(fase.carros) do
        if carro.tipo == "vermelho" then
            local finalX = carro.x + carro.largura - 1
            local y = carro.y
            if fase.mapa[y] and (fase.mapa[y][finalX] == "S" or fase.mapa[y][finalX] == "P") then
                return true
            end
        end
    end
    return false
end

return fase
