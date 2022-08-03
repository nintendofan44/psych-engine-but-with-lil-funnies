_do = false

function onEvent(n,v1,v2)

if n == "Cam Boom Speed" then
	_do = true
end

end
function onBeatHit()

	if _do == true then
	if curBeat % 1 == 0 then
		triggerEvent("Add Camera Zoom",0.015*bam,0.03*bam)
	end
end

end