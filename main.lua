estadoAtual = nil

function love.load()
    estadoAtual = require("estados.logo")
    estadoAtual.load("menu") 
end

function love.update(dt)
    if estadoAtual and estadoAtual.update then
        estadoAtual.update(dt)
    end
end

function love.draw()
    if estadoAtual and estadoAtual.draw then
        estadoAtual.draw()
    end
end

function love.mousepressed(x, y, button)
    if estadoAtual and estadoAtual.mousepressed then
        estadoAtual.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if estadoAtual and estadoAtual.mousereleased then
        estadoAtual.mousereleased(x, y, button)
    end
end

function love.mousemoved(x, y)
    if estadoAtual and estadoAtual.mousemoved then
        estadoAtual.mousemoved(x, y)
    end
end

function love.keypressed(key)
    if estadoAtual and estadoAtual.keypressed then
        estadoAtual.keypressed(key)
    end
end

function love.resize(w, h)
    if estadoAtual and estadoAtual.resize then
        estadoAtual.resize(w, h)
    end
end
