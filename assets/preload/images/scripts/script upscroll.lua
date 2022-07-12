addThingX = 0;
addThingY = 90;

addThingX_song_and_time = 150;
addThingY_song_and_time = 0;

addThingXoffset = 15;
addThingYoffset = 260;

addThingX_song_and_time_offset = 425;
addThingY_song_and_time_offset = 551;

function onCreate()
    --sprites
    makeLuaSprite('comboSpr', 'playstate_ui/combo', 15 + addThingXoffset, 40 + addThingYoffset);
    scaleObject('comboSpr', 0.2, 0.2, true);
    setObjectCamera('comboSpr', 'hud');
    addLuaSprite('comboSpr', false);

    makeLuaSprite('missesSpr', 'playstate_ui/misses', (15 + addThingX) + addThingXoffset, (40 + addThingY) + addThingYoffset);
    scaleObject('missesSpr', 0.2, 0.2, true);
    setObjectCamera('missesSpr', 'hud');
    addLuaSprite('missesSpr', false);

    makeLuaSprite('rankSpr', 'playstate_ui/rating', (15 + (addThingX * 2)) + addThingXoffset, (40 + (addThingY * 2)) + addThingYoffset);
    scaleObject('rankSpr', 0.2, 0.2, true);
    setObjectCamera('rankSpr', 'hud');
    addLuaSprite('rankSpr', false);

    makeLuaSprite('accuracySpr', 'playstate_ui/accuracy', (15 + (addThingX * 3)) + addThingXoffset, (40 + (addThingY * 3)) + addThingYoffset);
    scaleObject('accuracySpr', 0.2, 0.2, true);
    setObjectCamera('accuracySpr', 'hud');
    addLuaSprite('accuracySpr', false);

    makeLuaSprite('scoreSpr', 'playstate_ui/score', (15 + (addThingX * 4)) + addThingXoffset, (40 + (addThingY * 4)) + addThingYoffset);
    scaleObject('scoreSpr', 0.2, 0.2, true);
    setObjectCamera('scoreSpr', 'hud');
    addLuaSprite('scoreSpr', false);

    makeLuaSprite('timeSpr', 'playstate_ui/time', 15 + addThingX_song_and_time_offset, 40 + addThingY_song_and_time_offset);
    scaleObject('timeSpr', 0.2, 0.2, true);
    setObjectCamera('timeSpr', 'hud');
    addLuaSprite('timeSpr', false);

    makeLuaSprite('songSpr', 'playstate_ui/song_name', (15 + (addThingX_song_and_time * 2)) + addThingX_song_and_time_offset, (40 + (addThingY_song_and_time * 2)) + addThingY_song_and_time_offset);
    scaleObject('songSpr', 0.2, 0.2, true);
    setObjectCamera('songSpr', 'hud');
    addLuaSprite('songSpr', false);

    --text
    makeLuaText('combo', ': '..getProperty('combo'), getPropertyFromClass('FlxG', 'width'), 50 + addThingXoffset, 50 + addThingYoffset);
    setTextAlignment('combo');
    addLuaText('combo');

    makeLuaText('misses', ': '..getProperty('songMisses'), getPropertyFromClass('FlxG', 'width'), (50 + addThingX) + addThingXoffset, (50 + addThingY) + addThingYoffset);
    setTextAlignment('misses');
    addLuaText('misses');

    makeLuaText('rank', ': '..getProperty('ratingFC'), getPropertyFromClass('FlxG', 'width'), (50 + (addThingX * 2)) + addThingXoffset, (50 + (addThingY * 2)) + addThingYoffset);
    setTextAlignment('rank');
    addLuaText('rank');

    makeLuaText('accuracy', ': '..floorDecimal(getProperty('ratingPercent') * 100, 2), getPropertyFromClass('FlxG', 'width'), (50 + (addThingX * 3)) + addThingXoffset, (50 + (addThingY * 3)) + addThingYoffset);
    setTextAlignment('accuracy');
    addLuaText('accuracy');

    makeLuaText('score', ': the', getPropertyFromClass('FlxG', 'width'), (50 + (addThingX * 4)) + addThingXoffset, (50 + (addThingY * 4)) + addThingYoffset);
    setTextAlignment('score');
    addLuaText('score');

    makeLuaText('time', ': the', getPropertyFromClass('FlxG', 'width'), 70 + addThingX_song_and_time_offset, 55 + addThingY_song_and_time_offset);
    setTextAlignment('time');
    addLuaText('time');

    makeLuaText('song', ': the', getPropertyFromClass('FlxG', 'width'), (70 + (addThingX_song_and_time * 2)) + addThingX_song_and_time_offset, (55 + (addThingY_song_and_time * 2)) + addThingY_song_and_time_offset);
    setTextAlignment('song');
    addLuaText('song');
end

function onUpdate(elapsed)
    setTextString('combo', ': '..getProperty('combo'));
    setTextString('misses', ': '..getProperty('songMisses'))
    if (getProperty('ratingFC') == '') then
        setTextString('rank', ": ?");
    else
        setTextString('rank', ': '..getProperty('ratingFC'));
    end
    setTextString('accuracy', ': '..floorDecimal(getProperty('ratingPercent') * 100, 2));
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
