a = { } -- plan b in case you are unable to use a mark note in the spot you want. uses the note count, not steps.
c = { } -- the colors picked for each swap
n = { 136, 232, 300, 348, 428, 471, 487, 504, 520, 592, 616, 688, 796, 1004, 1020, 1084, 1127, 1143, 1160, 1176, 1248, 1256, 1280, 1288, 1296, 1304, 1436, 1460, 1516, 1544 } --the step where the noteskin changes
chosen = 0
curcolor = 0
temp = 0
math.randomseed( os.time() )

function checkA(v,l)
	for index, value in ipairs(l) do
		if value == v then
			return true 
		end
	end
	return false
end

function bounceNotes()
	for i = 0,7 do 
		noteTweenY('swapanim' .. i, i, defaultPlayerStrumY0 - 40, 0.1, 'circOut')
	end
end

function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-dead-clown'); 
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx_splat'); 
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOverClowned'); 
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); 

	for i = 1,9 do
		precacheImage('notes-' .. i)
	end
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'swapmark' or checkA(i,a) == true then
			while temp == chosen do
				temp = math.random(1,8)
			end
			chosen = temp
			table.insert(c,chosen)
		end
		if chosen ~= 0 then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes-' .. chosen);
		end
	end
end

function onStepHit()
	if checkA(curStep,n) == true then 
		curcolor = curcolor + 1
		for i=0,getProperty('playerStrums.length')-1 do
			setPropertyFromGroup('playerStrums', i, 'texture', 'notes-' .. c[curcolor])
		end
		for i=0,getProperty('opponentStrums.length')-1 do
			setPropertyFromGroup('opponentStrums', i, 'texture', 'notes-' .. c[curcolor])
		end
		bounceNotes()
	end
end

--stuff im trying to add right now 
function onTweenCompleted(tag)
	if string.sub(tag,1,8) == 'swapanim' then
		san = string.sub(tag,9,9)
		noteTweenY('swapback' .. san, san, defaultPlayerStrumY0, 0.3, 'bounceOut')
	end
end

--end of stuff added right now
local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and not isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'breakfast');
	end
end

-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(count)
	-- triggered when the next dialogue line starts, 'line' starts with 1
end

function onSkipDialogue(count)
	-- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end
