local defaultNotePos = {}
local noteSize = 0.69
function onSongStart()
	for i = 0, 7 do
		x = getPropertyFromGroup("strumLineNotes", i, "x")

		y = getPropertyFromGroup("strumLineNotes", i, "y")

		direc = getPropertyFromGroup("strumLineNotes", i, "direction")

		table.insert(defaultNotePos, { x, y, direc })
	end
end

function onCreatePost()
	setProperty("showRating", false)
	setProperty("showComboNum", false)
	makeLuaText("thing", "Fun Is Infinite", 1000, 150, 0)
	addLuaText("thing")
	setObjectCamera("thing", "camHUD")
	setTextBorder("thing", 1.1, "000011")
	setTextSize("thing", 24)
	setProperty("scoreTxt.visible", false)
end

function onUpdatePost(elapsed)
	setProperty("thing.y", getProperty("scoreTxt.y"))
	--[[noteCount = getProperty("notes.length")

	for i = 0, noteCount - 1 do
		noteData = getPropertyFromGroup("notes", i, "noteData")
		if getPropertyFromGroup("notes", i, "isSustainNote") then
			if getPropertyFromGroup("notes", i, "mustPress") then
				setPropertyFromGroup(
					"notes",
					i,
					"angle",
					getPropertyFromGroup("playerStrums", noteData, "direction") - 90
				)
			else
				setPropertyFromGroup(
					"notes",
					i,
					"angle",
					getPropertyFromGroup("opponentStrums", noteData, "direction") - 90
				)
			end
		else
			if noteData >= 4 then
				setPropertyFromGroup("notes", i, "angle", getPropertyFromGroup("playerStrums", noteData, "angle"))
			else
				setPropertyFromGroup("notes", i, "angle", getPropertyFromGroup("opponentStrums", noteData, "angle"))
			end
		end
	end]]
end

function onUpdate(elapsed)
	setProperty("timeBar.color", getColorFromHex("0008FF"))

	songPos = getPropertyFromClass("Conductor", "songPosition")
	gurg = ((getPropertyFromClass("Conductor", "songPosition") / 1000) * (bpm / 60))
	currentBeat = (songPos / 1000) * (bpm / 120)
	currentBeat2 = (songPos / 1000) * (bpm / 120)
	for i = 0, 3 do
		setPropertyFromGroup(
			"strumLineNotes",
			i,
			"x",
			defaultNotePos[i + 1][1] - 15 * math.cos((currentBeat + i * 0.1) * math.pi)
		)
	end
	for i = 4, 7 do
		setPropertyFromGroup(
			"strumLineNotes",
			i,
			"x",
			defaultNotePos[i + 1][1] + 15 * math.cos((currentBeat + i * 0.3) * math.pi)
		)
	end
	for i = 0, 7 do
		setPropertyFromGroup(
			"strumLineNotes",
			i,
			"y",
			defaultNotePos[i + 1][2] - 15 * math.cos((currentBeat + i * 0.25) * math.pi)
		)
		setPropertyFromGroup(
			"strumLineNotes",
			i,
			"direction",
			defaultNotePos[i + 1][3] - 6 * math.cos((currentBeat2 + i * 0.01) * math.pi)
		)
	end
end

local bop = true
local boper = false
function onStepHit()
	if curStep == 784 then
		makeLuaSprite("fe", "redVG", 0, 0)
		screenCenter("fe", "xy")
		addLuaSprite("fe", "false")
		setObjectCamera("fe", "other")
		setProperty("fe.alpha", 0)
		doTweenAlpha("af", "fe", 1, 0.5, "sineOut")
		boper = true
	end
	if curStep == 250 then
		makeLuaText("fthing", "The Fun Never Ends", 1000, 150, 0)
		addLuaText("fthing")
		screenCenter("fthing", "xy")
		setTextBorder("fthing", 1.1, "000011")
		setTextSize("fthing", 40)
		setObjectCamera("fthing", "other")
		setProperty("fthing.alpha", 0)
		setProperty("fthing.color", getColorFromHex("11158E"))
		doTweenAlpha("afe", "fthing", 1, 0.3, "sineOut")
	end

	if curStep == 266 then
		doTweenAlpha("afe", "fthing", 0, 0.5, "sineOut")
	end
	if curStep == 1034 then
		boper = false
		doTweenAlpha("af", "fe", 0, 0.5, "sineOut")
	end
	if curStep == 1300 then
		boper = true
		doTweenAlpha("af", "fe", 1, 0.5, "sineOut")
	end
	if curStep == 1554 then
		boper = false
		doTweenAlpha("af", "fe", 0, 0.5, "sineOut")
	end
end

function onBeatHit()
	if bop == true then
		if curBeat % 1 == 0 then
			setProperty("camHUD.y", 20)
			doTweenY("cam", "camHUD", 0, 0.3, "circOut")
		end
		if curBeat % 3 == 0 then
			setProperty("camHUD.x", 20)
			doTweenX("came", "camHUD", 0, 0.3, "circOut")
		end
		if curBeat % 2 == 0 then
			setProperty("camHUD.y", -20)
			doTweenY("cam", "camHUD", 0, 0.3, "circOut")
		end
		if curBeat % 4 == 0 then
			setProperty("camHUD.x", -20)
			doTweenX("came", "camHUD", 0, 0.3, "circOut")
		end
	end
	if boper == true then
		if curBeat % 1 == 0 then
			setProperty("camHUD.angle", 2)
			doTweenAngle("cama", "camHUD", 0, 0.3, "circOut")
		end
		if curBeat % 2 == 0 then
			setProperty("camHUD.angle", -2)
			doTweenAngle("cama", "camHUD", 0, 0.3, "circOut")
		end
	end
end
