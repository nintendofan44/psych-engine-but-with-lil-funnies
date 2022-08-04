local credits = ""
local count = 0

function onSongStart()
    credits = getTextFromFile("data/" .. songName .. "/credits.txt")

    count  = select(2, credits:gsub('\n', '\n'))

    makeLuaSprite('bgSong', 'empty', -300, 200)
    makeGraphic('bgSong', 300,60,'282828')
    setObjectCamera('bgSong', 'other')
    addLuaSprite('bgSong', true)

    makeLuaSprite('bgSong2', 'empty', -300, 260)
    makeGraphic('bgSong2', 300,35 * (count + 1) + 10,'323233')
    setObjectCamera('bgSong2', 'other')
    addLuaSprite('bgSong2', true)

    makeLuaText('nameSong', songName, 300, -300, 210)
    setTextAlignment('nameSong', 'left')
    setObjectCamera('nameSong', 'other')
    setTextSize('nameSong', 30)
    setTextFont('nameSong', 'ArialCEBold.ttf')
    addLuaText('nameSong')

    makeLuaText('nameSong2', credits, 300, -300, 270)
    setTextAlignment('nameSong2', 'left')
    setObjectCamera('nameSong2', 'other')
    setTextSize('nameSong2', 15)
    setTextFont('nameSong2', 'ArialCE.ttf')
    addLuaText('nameSong2')

    doTweenX('ba', 'bgSong', 0, 1, 'CircOut')
    doTweenX('bal', 'bgSong2', 0, 1, 'CircOut')
    doTweenX('ball', 'nameSong', 10, 1, 'CircOut')
    doTweenX('balls', 'nameSong2', 10, 1, 'CircOut')

    runTimer('hide', 4)
end

function onTimerCompleted(hide)
    doTweenX('ba', 'bgSong', -300, 1, 'CircIn')
    doTweenX('bal', 'bgSong2', -300, 1, 'CircIn')
    doTweenX('ball', 'nameSong', -300, 1, 'CircIn')
    doTweenX('balls', 'nameSong2', -300, 1, 'CircIn')
    runTimer('ballsz', 2)
end

function onTimerCompleted(ballsz)
	removeLuaSprite('bgSong', true)
	removeLuaSprite('bgSong2', true)
	removeLuaText('nameSong', true)
	removeLuaText('nameSong2', true)
end