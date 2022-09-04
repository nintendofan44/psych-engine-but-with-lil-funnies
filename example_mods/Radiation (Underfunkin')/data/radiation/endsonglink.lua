function onEndSong()
	addHaxeLibrary('CoolUtil')
	runHaxeCode([[ CoolUtil.browserLoad('https://gamejolt.com/games/underfunkin/700047') ]])
	close() -- make sure the script isn't being used now
	return Function_Continue;
end