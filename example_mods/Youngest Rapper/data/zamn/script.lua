local combo = 0

function onCreatePost()
    makeLuaSprite('bg', 'bg3', -40, 0)
	scaleObject('bg', 1.15, 1.15)
    addLuaSprite('bg', true)
    setObjectOrder('dad', 100)
    setObjectOrder('gf', 100)
    setCharacterX('bf', 340)
    setCharacterY('bf', 200)
    setCharacterX('gf', 950)
    setProperty('boyfriend.scale.x', -1)
    makeLuaText('sheswhat', "SHE'S 12?", 1000, 140, -10)
    setTextFont('sheswhat', 'fortnite.otf')
    setObjectCamera('sheswhat', 'camera-game')
    setTextSize('sheswhat', 120)
    addLuaText('sheswhat')
end

function onSongStart()
	noteTweenX("NoteMove1", 0, 50, 1, elasticIn)
	noteTweenX("NoteMove2", 1, 170, 1, elasticIn)
	noteTweenX("NoteMove3", 2, 1000, 1, elasticIn)
	noteTweenX("NoteMove4", 3, 1120, 1, elasticIn)
	noteTweenX("NoteMove5", 4, 430, 1, elasticIn)
	noteTweenX("NoteMove6", 5, 530, 1, elasticIn)
	noteTweenX("NoteMove7", 6, 630, 1, elasticIn)
	noteTweenX("NoteMove8", 7, 730, 1, elasticIn)
    for i=0,3 do
        setPropertyFromGroup('playerStrums', i, 'scale.x', 0.6)
        setPropertyFromGroup('playerStrums', i, 'scale.y', 0.6)
        setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') / 1.05)
    end
end

function onUpdate()
    setTextString('sheswhat', "SHE'S " .. math.max(combo, 12) .. '?')
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if isSustainNote == false then
    combo = combo + 1
    end
end

function noteMiss()
    combo = 0
end