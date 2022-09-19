function onEvent(name, value1, value2)
    if name == 'Change Room' then
        if value1 == "1" then
           setProperty('stagefront1.visible', true);
           setProperty('stagefront2.visible', false);
	end
        if value1 == "2" then
           setProperty('stagefront1.visible', false);
           setProperty('stagefront2.visible', true);
        end
    end
end