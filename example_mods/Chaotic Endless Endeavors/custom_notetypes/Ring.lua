function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Ring' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'RING_assets');
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0');
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
		end
	end

	if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Ring' then 
		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
		end
	end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Ring' then
		setScore(score + 1500)
    		playSound('ring');
	end
end