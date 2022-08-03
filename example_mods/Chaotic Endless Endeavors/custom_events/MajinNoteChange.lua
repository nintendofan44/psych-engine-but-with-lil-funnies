function onCreate()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == '' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Majin_Notes', 'Majin_Notes');
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'NoNoteSplashes');
			setPropertyFromGroup('strumLineNotes', i, 'texture', 'Majin_Notes')
		end
	end
end
