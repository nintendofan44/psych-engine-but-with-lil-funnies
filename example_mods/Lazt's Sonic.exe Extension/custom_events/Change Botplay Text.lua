function onEvent(name, value1, value2)
    if name == 'Change Botplay Text' then
        function onUpdate()
            setTextString('botplayTxt', value1)
        end
    end
end