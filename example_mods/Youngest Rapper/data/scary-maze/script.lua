local ttype = 'expoinout';
local dur = 2;

function onSongStart()
	-- dad
	if not middlescroll then
		noteTweenX("asdad0", 0, getPropertyFromGroup('opponentStrums', 0, 'x') + 9.5 * 10, dur, ttype)
		noteTweenX("asdad1", 1, getPropertyFromGroup('opponentStrums', 1, 'x') + 9.5 * 10, dur, ttype)
		noteTweenX("asdad2", 2, getPropertyFromGroup('opponentStrums', 2, 'x') + 9.5 * 10, dur, ttype)
		noteTweenX("asdad3", 3, getPropertyFromGroup('opponentStrums', 3, 'x') + 9.5 * 10, dur, ttype)
	elseif middlescroll then
		noteTweenX("asdad0", 0, getPropertyFromGroup('opponentStrums', 0, 'x') + 9.5 * 10, dur, ttype)
		noteTweenX("asdad1", 1, getPropertyFromGroup('opponentStrums', 1, 'x') + 9.5 * 10, dur, ttype)
		noteTweenX("asdad2", 2, getPropertyFromGroup('opponentStrums', 2, 'x') - 8.5 * 10, dur, ttype)
		noteTweenX("asdad3", 3, getPropertyFromGroup('opponentStrums', 3, 'x') - 8.5 * 10, dur, ttype)
	end

	-- bf
	if not middlescroll then
		noteTweenX("asdad4", 4, getPropertyFromGroup('playerStrums', 0, 'x') - 8 * 10, dur, ttype)
		noteTweenX("asdad5", 5, getPropertyFromGroup('playerStrums', 1, 'x') - 8 * 10, dur, ttype)
		noteTweenX("asdad6", 6, getPropertyFromGroup('playerStrums', 2, 'x') - 8 * 10, dur, ttype)
		noteTweenX("asdad7", 7, getPropertyFromGroup('playerStrums', 3, 'x') - 8 * 10, dur, ttype)
	end
end
