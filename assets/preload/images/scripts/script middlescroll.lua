addThingX_song_and_time = 0;
addThingY_song_and_time = 130;

addThingX_song_and_time_offset = 1070;
addThingY_song_and_time_offset = 165;

function onCreate()
    --sprites

    makeLuaSprite('timeSpr', 'playstate_ui/time', 15 + addThingX_song_and_time_offset, 40 + addThingY_song_and_time_offset);
    scaleObject('timeSpr', 0.2, 0.2, true);
    setObjectCamera('timeSpr', 'hud');
    addLuaSprite('timeSpr', false);

    makeLuaSprite('songSpr', 'playstate_ui/song_name', (15 + (addThingX_song_and_time * 2)) + addThingX_song_and_time_offset, (40 + (addThingY_song_and_time * 2)) + addThingY_song_and_time_offset);
    scaleObject('songSpr', 0.2, 0.2, true);
    setObjectCamera('songSpr', 'hud');
    addLuaSprite('songSpr', false);

    --text
    makeLuaText('time', ': the', getPropertyFromClass('FlxG', 'width'), -40 + addThingX_song_and_time_offset, 55 + addThingY_song_and_time_offset);
    setTextAlignment('time');
    addLuaText('time');

    makeLuaText('song', ': the', getPropertyFromClass('FlxG', 'width'), (-40 + (addThingX_song_and_time * 2)) + addThingX_song_and_time_offset, (55 + (addThingY_song_and_time * 2)) + addThingY_song_and_time_offset);
    setTextAlignment('song');
    addLuaText('song');
end

function onUpdate(elapsed)
end

function floorDecimal(value, decimals)
	if (decimals < 1) then
		return math.floor(value);
    end

	local tempMult = 1.0;
	for i = 0, decimals do
		tempMult = tempMult * 10;
    end

	local newValue = math.floor(value * tempMult);
	return newValue / tempMult;
end
