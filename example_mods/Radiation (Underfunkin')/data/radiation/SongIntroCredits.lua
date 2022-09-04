-- Original Code by Sir Top Hat
-- Additional Code by MorenoTheCappuccinoChugger
-- Figured out read code thanks to Grizzle, rad stuff

--easy script configs
IntroTextSize = 25	--Size of the text for the Now Playing thing.
IntroSubTextSize = 30 --size of the text for the Song Name.
IntroSubText2Size = 20
--easy script configs

--actual script
function onCreate()
	
	
	--text for the song name
	makeLuaText('JukeBoxSubText', 'Radiation', 400, -185, 60) --songname 
	setTextAlignment('JukeBoxSubText', 'left')
	setObjectCamera('JukeBoxSubText', 'other')
	setProperty('JukeBoxSubText.alpha', 0)
	setTextSize('JukeBoxSubText', IntroSubTextSize*1.5)
	setTextFont('JukeBoxSubText', 'determination.ttf') --font
	setTextBorder('JukeBoxSubText', 2, '372eb0')
	addLuaText('JukeBoxSubText')
	
	
	makeLuaSprite('jingle', 'songnamething', getProperty('JukeBoxSubText.x'), getProperty('JukeBoxSubText.y') - 7)
	setObjectCamera('jingle', 'other')
	scaleObject('jingle', 0.6, 0.6)
	addLuaSprite('jingle', true)

	makeLuaText('JukeBoxSubText2', '- Yamahearted', 300, -185, 120) --credit
	setTextAlignment('JukeBoxSubText2', 'left')
	setObjectCamera('JukeBoxSubText2', 'other')
	setProperty('JukeBoxSubText2.alpha', 0)
	setTextSize('JukeBoxSubText2', IntroSubTextSize)
	setTextFont('JukeBoxSubText2', 'determination.ttf')
	setTextBorder('JukeBoxSubText2', 2, '372eb0')
	addLuaText('JukeBoxSubText2')
end

function onUpdatePost(el)
	setProperty('jingle.x', getProperty('JukeBoxSubText.x') - 90)
end

function onSongStart()
	doTweenX('MoveInFour', 'JukeBoxSubText', 100, 1, 'SineInOut')
	doTweenX('MoveInFive', 'JukeBoxSubText2', 100, 1, 'SineInOut')
	doTweenAlpha('JBST2', 'JukeBoxSubText2', 100, 2, 'SineIn')
	doTweenAlpha('JBST', 'JukeBoxSubText', 100, 2, 'SineIn')
	
	runTimer('JukeBoxWait', 3, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'JukeBoxWait' then
		doTweenX('MoveOutFour', 'JukeBoxSubText', 1250, 0.85, 'quadIn')
		doTweenX('MoveOutFive', 'JukeBoxSubText2', 1250, 0.85, 'quadIn')
		doTweenAlpha('JBST', 'JukeBoxSubText', 0, 0.83, 'circOut')
		doTweenAlpha('JBST2', 'JukeBoxSubText2', 0, 0.83, 'circOut')
		doTweenAlpha('J', 'jingle', 0, 0.83, 'circOut')
	end
end