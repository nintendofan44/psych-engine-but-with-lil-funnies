-- Event notes hooks
chosen = 0
act = -1
act2 = -1
d1 = true
d2 = true
math.randomseed( os.time() )

--precache

function onCreate()
	for i = 1,9 do
		precacheImage('notes-' .. i)
		precacheImage('nspl-' .. i)
	end
end

function onEvent(name, value1, value2)
	value1 = value1 or 0
	value2 = value2 or 0
	if name == 'noteswap' then
		chosen = math.random(1,8)
		act2 = curStep + value2
		act = curStep + value1
		d1 = false
		d2 = false
	end
end

function onStepHit()
	if curStep >= act2 and d2 == false then
		d2 = true
		for i = 0, getProperty('unspawnNotes.length')-1 do
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes-' .. chosen);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'nspl-' .. chosen);
		end
	end
	if curStep >= act and d1 == false then
		d1 = true
		for i=0,getProperty('playerStrums.length')-1 do
			setPropertyFromGroup('playerStrums', i, 'texture', 'notes-' .. chosen)
		end
		for i=0,getProperty('opponentStrums.length')-1 do
			setPropertyFromGroup('opponentStrums', i, 'texture', 'notes-' .. chosen)
		end
	end
end





