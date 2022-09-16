local cx = -730;
local cy = -260;
local scr = 1.03;
local scr2 = 1.02;
local scr3 = 1.01;

function onCreate()
    makeLuaSprite('Fim3', 'exe/endless-a/Fim3', cx, cy)
    setScrollFactor('Fim3', scr, scr)
    scaleObject('Fim3', 1.1, 1.1)
    addLuaSprite('Fim3')

    makeLuaSprite('Fim2', 'exe/endless-a/Fim2', cx, cy)
    setScrollFactor('Fim2', scr, scr2)
    scaleObject('Fim2', 1.1, 1.1)
    addLuaSprite('Fim2')

    makeLuaSprite('Fim1', 'exe/endless-a/Fim1', cx, cy)
    setScrollFactor('Fim1', scr, scr3)
    scaleObject('Fim1', 1.1, 1.1)
    addLuaSprite('Fim1')
end

function onUpdate(elapsed)
end
