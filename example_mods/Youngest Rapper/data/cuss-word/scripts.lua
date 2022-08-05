local ttype = 'elasticinout';
local dur = 2;

function onSongStart()
	-- dad
	noteTweenY("NoteMove0", 0, getPropertyFromGroup('opponentStrums', 0, 'y') - 200 * 10, dur, ttype)
	noteTweenY("NoteMove1", 1, getPropertyFromGroup('opponentStrums', 1, 'y') - 200 * 10, dur, ttype)
	noteTweenY("NoteMove2", 2, getPropertyFromGroup('opponentStrums', 2, 'y') - 200 * 10, dur, ttype)
	noteTweenY("NoteMove3", 3, getPropertyFromGroup('opponentStrums', 3, 'y') - 200 * 10, dur, ttype)

	-- bf
	if not middlescroll then
		noteTweenX("asdad4", 4, getPropertyFromGroup('playerStrums', 0, 'x') - 32 * 10, dur, ttype)
		noteTweenX("asdad5", 5, getPropertyFromGroup('playerStrums', 1, 'x') - 32 * 10, dur, ttype)
		noteTweenX("asdad6", 6, getPropertyFromGroup('playerStrums', 2, 'x') - 32 * 10, dur, ttype)
		noteTweenX("asdad7", 7, getPropertyFromGroup('playerStrums', 3, 'x') - 32 * 10, dur, ttype)
	end
end
