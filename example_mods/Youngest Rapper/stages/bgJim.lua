names = {'morbinFan27', 'janh64', 'balls69', 'andy9099999', 'javy69420', 'SmashJT13', 'nothareal', 'monkecrack', 'jimmyisdoogal134', 'chair'}
chats = {'WEAK', 'L', ':tomato:', 'bruh', 'NOOOOOOO', '2/10', '3/10', '2', 'WTF', 'HOW', 'YOOOO', 'MONKE MODE ACTIVE', 'epic moment', 'gamer', 'AGAIN??!?', 'how', 'DESERVED'}
local timer = 0;

function onCreate()
    makeLuaSprite('bg', 'xp', 0, 0, 5);
	scaleObject('bg', 1.2, 1.2)
	setLuaSpriteScrollFactor('bg', 0, 0);
	addLuaSprite('bg', false);

    makeLuaSprite('bg1', 'ylylBack', 0, 0, 5);
	scaleObject('bg1', 0.75, 0.75)
	setLuaSpriteScrollFactor('bg1', 0, 0);
	addLuaSprite('bg1', true);

    makeLuaSprite('bg2', 'ylyl', 0, 0, 5);
	scaleObject('bg2', 0.75, 0.75)
	setLuaSpriteScrollFactor('bg2', 0, 0);
	addLuaSprite('bg2', true);
    setObjectOrder('dadGroup', 100)

    makeLuaText('chat', 'sex: Ballasdfdfsfdsafdsafdsfadsdfasafdsadfsasdfasdfasdfasdfasdfasdfasdfs', 500, 5, 420)
    setTextAlignment('chat', 'left')
    setTextSize('chat', 20)
    addLuaText('chat');
end

function onBeatHit()
    if curBeat % 4 == 0 then
    setTextString('chat', '')
    end
end

function onUpdatePost(elapsed)
    if timer <= 0 and startedCountdown then
        timer = 0.1
        setTextString('chat', getTextString('chat') .. names[math.random(9)] .. ':' .. chats[math.random(16)].. '\n')
    end
    timer = timer - elapsed

    setProperty('camFollowPos.x', 0)
    setProperty('camFollowPos.y', 0)
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end