function onEvent(name, value1, value2)
    if name == 'camerazoom' then
        doTweenZoom('bla', 'camGame', value1, value2, 'sineOut')
    end
end
