local bfs
local das
local sex
local x = 0

function onCreatePost()
    makeAnimatedLuaSprite('seam', 'seam', (defaultBoyfriendX + defaultOpponentX) / 2, -100)
    addAnimationByPrefix('seam', 'y', 'y', 6, true)
    objectPlayAnimation('seam', 'y');
	scaleObject('seam', 1.2, 1.2)
    addLuaSprite('seam', true);
    bfs = getProperty('boyfriend.scale.x')
    das = getProperty('dad.scale.x')
    sex = getProperty('dad.x')
end

function onUpdatePost()
    setProperty('camFollowPos.x', x)
    if getProperty('boyfriend.animation.curAnim.name') ~= 'idle' and getProperty('dad.animation.curAnim.name') ~= 'idle' then
        x = lerp(x, (defaultBoyfriendX + defaultOpponentX) / 2 + 50, 0.01)
        setProperty('boyfriend.scale.x', lerp(getProperty('boyfriend.scale.x'), bfs / 2, 0.01))
        setProperty('boyfriend.x', lerp(getProperty('boyfriend.x'), defaultBoyfriendX - 400, 0.01))
        setProperty('dad.scale.x', lerp(getProperty('dad.scale.x'), das / 1.9, 0.01))
        setProperty('dad.x', lerp(getProperty('dad.x'), sex + 400, 0.01))
    else
        setProperty('boyfriend.scale.x', lerp(getProperty('boyfriend.scale.x'), bfs, 0.01))
        setProperty('boyfriend.x', lerp(getProperty('boyfriend.x'), defaultBoyfriendX, 0.01))
        setProperty('dad.scale.x', lerp(getProperty('dad.scale.x'), das, 0.01))
        setProperty('dad.x', lerp(getProperty('dad.x'), sex, 0.01))
        if mustHitSection == true then
            x = lerp(x, defaultBoyfriendX + 430, 0.01)
        else
            x = lerp(x, defaultOpponentX - 340, 0.01)
        end
    end
end

function lerp(a,b,t)
    return a * (1-t) + b * t
end