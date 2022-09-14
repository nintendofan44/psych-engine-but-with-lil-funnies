--[[function onCreate()
    makeLuaSprite('missesSpr', '', 0, 600);
    makeGraphic('missesSpr', 1280, 230, '0EA4AC')
    screenCenter('missesSpr', 'x');
    setProperty('missesSpr.alpha', 0.4);
    setProperty('missesSpr.scale.y', 0.5);
    setObjectCamera('missesSpr', 'hud');
    addLuaSprite('missesSpr');
end

function onUpdate(elapsed)
    setProperty('missesSpr.scale.x', 1);
    setProperty('missesSpr.scale.y', luaLerp(0.5, getProperty('line.scale.y'), luaBound(1 - (elapsed * 9), 0, 1)));
end

function onBeatHit()
    scaleObject("missesSpr", 1, 0.6);
end

function luaLerp(a, b, ratio)
    return a + ratio * (b - a);
end

function luaBound(value, min, max)
    return math.max(min, math.min(max, value));
end

function onUpdate()
    local mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
    local curDir = 0;
    local curDir2 = 0;

    for i = 0, getProperty('playerStrums.length') - 1 do
        curDir = getPropertyFromGroup('playerStrums', i, 'direction') + 1
    end
    for i = 0, getProperty('opponentStrums.length') - 1 do
        curDir2 = getPropertyFromGroup('opponentStrums', i, 'direction') - 1
    end

    for i = 0, getProperty('playerStrums.length') - 1 do
        setPropertyFromGroup('playerStrums', i, 'direction', curDir);
    end
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if mustPress == true then
            setPropertyFromGroup('unspawnNotes', i, 'direction', curDir);
        end
    end

    for i = 0, getProperty('opponentStrums.length') - 1 do
        setPropertyFromGroup('opponentStrums', i, 'direction', curDir2);
    end
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if mustPress == false then
            setPropertyFromGroup('unspawnNotes', i, 'direction', curDir2);
        end
    end
end

function onBeatHit()
    local val = 10;

    if challenge then
        if (curBeat % 1 == 0) then
            for i = 0, getProperty('playerStrums.length') - 1 do
                setPropertyFromGroup('playerStrums', i, 'direction', val);
            end
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if mustPress == true then
                    setPropertyFromGroup('unspawnNotes', i, 'direction', val);
                end
            end
        
            for i = 0, getProperty('opponentStrums.length') - 1 do
                setPropertyFromGroup('opponentStrums', i, 'direction', -val);
            end
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if mustPress == false then
                    setPropertyFromGroup('unspawnNotes', i, 'direction', -val);
                end
            end
        end
        if (curBeat % 2 == 0) then
            for i = 0, getProperty('playerStrums.length') - 1 do
                setPropertyFromGroup('playerStrums', i, 'direction', -val);
            end
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if mustPress == true then
                    setPropertyFromGroup('unspawnNotes', i, 'direction', -val);
                end
            end
        
            for i = 0, getProperty('opponentStrums.length') - 1 do
                setPropertyFromGroup('opponentStrums', i, 'direction', val);
            end
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if mustPress == false then
                    setPropertyFromGroup('unspawnNotes', i, 'direction', val);
                end
            end
        end
    end
end--]]

function onCreatePost()
    if downscroll then
        --dad
        noteTweenDirection('1', 0, -180, 3, 'expoinout')
        noteTweenDirection('2', 1, -180, 3, 'expoinout')
        noteTweenDirection('3', 2, -180, 3, 'expoinout')
        noteTweenDirection('4', 3, -180, 3, 'expoinout')

        noteTweenY('1y', 0, 50, 3, 'expoinout')
        noteTweenY('2y', 1, 50, 3, 'expoinout')
        noteTweenY('3y', 2, 50, 3, 'expoinout')
        noteTweenY('4y', 3, 50, 3, 'expoinout')
    else
        --bf
        noteTweenDirection('5', 4, 180, 3, 'expoinout')
        noteTweenDirection('6', 5, 180, 3, 'expoinout')
        noteTweenDirection('7', 6, 180, 3, 'expoinout')
        noteTweenDirection('8', 7, 180, 3, 'expoinout')

        noteTweenDirection('5', 0, 50, 3, 'expoinout')
        noteTweenDirection('6', 1, 50, 3, 'expoinout')
        noteTweenDirection('7', 2, 50, 3, 'expoinout')
        noteTweenDirection('8', 3, 50, 3, 'expoinout')
    end
end
