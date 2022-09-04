
function onCreatePost()

    setProperty('camFollowPos.y', getProperty('camFollowPos.y') - 100);
    
end

function onCreate()

    makeLuaSprite('Sky', 'desertBackground/BlueSkys', -600, -250)
    makeLuaSprite('Cloud', 'desertBackground/Clouds', -450, -250)
    setScrollFactor('Cloud', 0.5, 0.5);
    makeLuaSprite('MethBG', 'desertBackground/BackgroundMeth', -700, 100)
    setScrollFactor('MethBG', 0.8, 0.8);
    makeAnimatedLuaSprite('Smokes', 'desertBackground/SmokesMeth', 730, -100)
    addAnimationByPrefix('Smokes', 'SmokesMoving', 'SmokesMeth', 24, false)
    setScrollFactor('Smokes', 0.8, 0.8);
    makeLuaSprite('bartop','',0,0)
    makeGraphic('bartop',1280,100,'000000')
    addLuaSprite('bartop',true)
    setScrollFactor('bartop',0,0)
    setObjectCamera('bartop','hud')
    if not middlescroll then
        setObjectCamera('bartop','notehud')
    else
        setObjectCamera('bartop','sus')
    end
    makeLuaSprite('barbot','',0,620)
    makeGraphic('barbot',1280,100,'000000')
    addLuaSprite('barbot',true)
    setScrollFactor('barbot',0,0)
    setObjectCamera('barbot','hud')
    if not middlescroll then
        setObjectCamera('barbot','notehud')
    else
        setObjectCamera('barbot','sus')
    end

    addLuaSprite('Sky', false)
    addLuaSprite('Cloud', false)
    addLuaSprite('MethBG', false)
    addLuaSprite('Smokes', false)
    addLuaSprite('barbot',true)
    addLuaSprite('bartop',true)

end

function onStepHit()
    if curStep == 704 then
        setProperty('Sky.color', getColorFromHex('FFEE60'))
        setProperty('Cloud.color', getColorFromHex('FFEE60'))
        setProperty('MethBG.color', getColorFromHex('FFEE60'))
        setProperty('Smokes.color', getColorFromHex('FFEE60'))
        setProperty('dad.color', getColorFromHex('FFEE60'))
        setProperty('gf.color', getColorFromHex('FFEE60'))
        setProperty('boyfriend.color', getColorFromHex('FFEE60'))
    end
    if curStep == 800 then
        setProperty('Sky.color', getColorFromHex('FFFFFF'))
        setProperty('Cloud.color', getColorFromHex('FFFFFF'))
        setProperty('MethBG.color', getColorFromHex('FFFFFF'))
        setProperty('Smokes.color', getColorFromHex('FFFFFF'))
        setProperty('dad.color', getColorFromHex('FFFFFF'))
        setProperty('gf.color', getColorFromHex('FFFFFF'))
        setProperty('boyfriend.color', getColorFromHex('FFFFFF'))
    end
end

function onBeatHit()

    objectPlayAnimation('Smokes', 'SmokesMoving', true);

end