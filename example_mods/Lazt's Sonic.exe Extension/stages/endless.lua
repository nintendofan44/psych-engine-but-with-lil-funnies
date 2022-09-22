function onCreate()
	makeLuaSprite("funsky", "funstage/sonicFUNsky", -300, 0)
	setScrollFactor("funsky", 0.8, 0.8)
	addLuaSprite("funsky")
	makeLuaSprite("backbush", "funstage/Bush2", -300, 150)
	setScrollFactor("backbush", 1, 1)
	addLuaSprite("backbush")
	makeAnimatedLuaSprite("backbop", "funstage/Majin Boppers Back", 0, -250)
	setScrollFactor("backbop", 0.9, 1)
	addAnimationByPrefix("backbop", "bopback", "MajinBop2 instance", 26, false)
	objectPlayAnimation("backbop", "bopback", false)
	addLuaSprite("backbop")
	makeLuaSprite("frontbush", "funstage/Bush 1", -150, 350)
	setScrollFactor("frontbush", 1, 1)
	addLuaSprite("frontbush")
	makeAnimatedLuaSprite("frontbop", "funstage/Majin Boppers Front", -350, -300)
	setScrollFactor("frontbop", 0.9, 1)
	addAnimationByPrefix("frontbop", "bopfront", "MajinBop1 instance", 26, false)
	objectPlayAnimation("frontbop", "bopfront", false)
	addLuaSprite("frontbop")
	makeLuaSprite("funfloor", "funstage/floor BG", -400, 550)
	setScrollFactor("funfloor", 1, 1)
	addLuaSprite("funfloor")
	makeAnimatedLuaSprite("fg1", "funstage/majin FG1", 1200, 750)
	setScrollFactor("fg1", 0.9, 1)
	addAnimationByPrefix("fg1", "bop1", "majin front bopper", 26, false)
	objectPlayAnimation("fg1", "bop1", false)
	setObjectOrder("fg1", 10)
	addLuaSprite("fg1")
	makeAnimatedLuaSprite("fg2", "funstage/majin FG2", -400, 750)
	setScrollFactor("fg2", 0.9, 1)
	addAnimationByPrefix("fg2", "bop2", "majin front bopper2", 28, false)
	objectPlayAnimation("fg2", "bop2", false)
	setObjectOrder("fg2", 11)
	addLuaSprite("fg2")

	precacheImage("majinthing/Majin_Notes")
	precacheImage("majinthing/Majin_Splashes")
	precacheImage("majinthing/three")
	precacheImage("majinthing/two")
	precacheImage("majinthing/one")
	precacheImage("majinthing/go")
end
local numbercount = 0
function onEvent(name, v1, v2)
	if name == "wewe" then
		makeLuaSprite("fut", "majinthing/future", 60, 230)

		addLuaSprite("fut", "false")
		scaleObject("fut", 0.3, 0.3)
		setObjectCamera("fut", "other")
		doTweenAlpha("fut", "fut", 0, 1.5, "sineOut")
	end
end
function onCreatePost()
	setProperty("gf.visible", false)
	setProperty("iconP1.color", getColorFromHex("171EEA"))
	setProperty("scoreTxt.visible", false)
	setProperty("boyfriend.color", getColorFromHex("464CFF"))
end
local vasuhu = { "noone", "backbush", "backbop", "frontbush", "frontbop", "funfloor", "fg1", "fg2" }
function onUpdate()
	for i = 1, 8 do
		setProperty(vasuhu[i + 1] .. ".alpha", getProperty("funsky.alpha"))
	end
end
local dadsingL = 4
local bfsingL = 4

realAnimdad = "idle"
realAnimbf = "idle"
function getAnim(char, prop)
	prop = prop or "name"
	return getProperty(char .. ".animation.curAnim." .. prop)
end
function onStepHit()
	if curStep % 4 == 0 then
		if getAnim("dad") == "idle" .. getProperty("dad.idleSuffix") then
			characterPlayAnim("dad", "idle" .. getProperty("dad.idleSuffix"), true)
		end
		if getAnim("boyfriend") == "idle" .. getProperty("boyfriend.idleSuffix") then
			characterPlayAnim("boyfriend", "idle" .. getProperty("boyfriend.idleSuffix"), true)
		end
		objectPlayAnimation("fg1", "bop1", true)
		objectPlayAnimation("fg2", "bop2", true)
		objectPlayAnimation("frontbop", "bopfront", true)
		objectPlayAnimation("backbop", "bopback", true)
	end
end
