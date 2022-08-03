local cx = -600;
local cy = 50;

function onCreate()
    makeLuaSprite('bluebg', 'other/obama/bluebg', cx, cy)
    setScrollFactor('bluebg', 0.6, 0.6)
    setProperty("bluebg.scale.x", 2)
    addLuaSprite('bluebg')

    makeLuaSprite('redfg', 'other/obama/redfg', cx, cy)
    setScrollFactor('redfg', 0.7, 0.7)
    setProperty("redfg.scale.x", 2)
    addLuaSprite('redfg')

    makeLuaSprite('rocks2', 'other/obama/rocks2', cx, cy)
    setScrollFactor('rocks2', 0.8, 0.8)
    setProperty("rocks2.scale.x", 2);
    addLuaSprite('rocks2')

    makeLuaSprite('rocks1', 'other/obama/rocks1', cx, cy)
    setScrollFactor('rocks1', 0.9, 0.9)
    setProperty("rocks1.scale.x", 2)
    addLuaSprite('rocks1')
end

function onUpdate(elapsed)
end
