function onEvent(name, value1, value2)
    if name == 'CameraZoomStuff' then
        setProperty('defaultCamZoom', (value1));
    end
end
