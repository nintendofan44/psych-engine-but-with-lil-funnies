function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'jimmy-dead'); 
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx_splat'); 
end

local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

local canEnd = false
function onEndSong()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if isStoryMode and not canEnd then
		setProperty('inCutscene', true);
		triggerEvent('startDia')
		canEnd = true
		runTimer('endDialogue',2)
		return Function_Stop;
	else
	return Function_Continue;
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'diabgm4');
	end
	if tag == 'endDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogueEnd', '');
	end
end

-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(count)
	-- triggered when the next dialogue line starts, 'line' starts with 1
end

function onSkipDialogue(count)
	-- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end