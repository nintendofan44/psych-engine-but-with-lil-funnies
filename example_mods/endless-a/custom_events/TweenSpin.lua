function onEvent(n, v1, v2)
	if n == "TweenSpin" then
		runTimer("tweenstop", 0.20)
		-- bf notespin
		noteTweenAngle("A", 5, 360, 0.15, "circinout")
		noteTweenAngle("B", 6, 360, 0.15, "circinout")
		noteTweenAngle("C", 7, 360, 0.15, "circinout")
		noteTweenAngle("D", 8, 360, 0.15, "circinout")
		noteTweenAngle("E", 9, 360, 0.15, "circinout")

		-- oppt notespin
		noteTweenAngle("F", 0, 360, 0.15, "circinout")
		noteTweenAngle("G", 1, 360, 0.15, "circinout")
		noteTweenAngle("H", 2, 360, 0.15, "circinout")
		noteTweenAngle("I", 3, 360, 0.15, "circinout")
		noteTweenAngle("J", 4, 360, 0.15, "circinout")
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "tweenstop" then
		noteTweenAngle("A", 5, 0, 0.000000001, "linear")
		noteTweenAngle("B", 6, 0, 0.000000001, "linear")
		noteTweenAngle("C", 7, 0, 0.000000001, "linear")
		noteTweenAngle("D", 8, 0, 0.000000001, "linear")
		noteTweenAngle("E", 9, 0, 0.000000001, "linear")

		-- oppt notespin
		noteTweenAngle("F", 0, 0, 0.000000001, "linear")
		noteTweenAngle("G", 1, 0, 0.000000001, "linear")
		noteTweenAngle("H", 2, 0, 0.000000001, "linear")
		noteTweenAngle("I", 3, 0, 0.000000001, "linear")
		noteTweenAngle("J", 4, 0, 0.000000001, "linear")
	end
end
