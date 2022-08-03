local darknotevisibility = false;

function onCreate()

   makeLuaSprite('sky', 'Majin/sonicFUNsky', -800, -600)
   setLuaSpriteScrollFactor('sky', 0.7, 0.7)
   scaleObject('sky', 1.2, 1.2)
   addLuaSprite('sky', false)

   makeLuaSprite('bush2', 'Majin/Bush2', -400, 0)
   setLuaSpriteScrollFactor('bush2', 0.8, 0.8)
   scaleObject('bush2', 1.1, 1.1)
   addLuaSprite('bush2', false)

   makeAnimatedLuaSprite('boppersback', 'Majin/Majin Boppers Back', 0, -400)
   addAnimationByPrefix('boppersback', 'bop', 'MajinBop2 instance', 24, true)
   addLuaSprite('boppersback', false)
   setLuaSpriteScrollFactor('boppersback', 0.8, 0.8)
   objectPlayAnimation('boppersback', 'bop', true)
   scaleObject('boppersback', 1.2, 1.2)

   makeLuaSprite('bush1', 'Majin/Bush1', -400, 300)
   setLuaSpriteScrollFactor('bush1', 0.9, 0.9)
   scaleObject('bush1', 1.1, 1.1)
   addLuaSprite('bush1', false)

   makeAnimatedLuaSprite('boppersfront', 'Majin/Majin Boppers Front', -200, -400)
   addAnimationByPrefix('boppersfront', 'bop', 'MajinBop1 instance', 24, true)
   addLuaSprite('boppersfront', false)
   objectPlayAnimation('boppersfront', 'bop', true)
   scaleObject('boppersfront', 1.2, 1.2)

   makeLuaSprite('floor', 'Majin/Floor BG', -600, 500)
   setLuaSpriteScrollFactor('floor', 1, 1)
   scaleObject('floor', 1.5, 1.5)
   addLuaSprite('floor', false)

   makeLuaSprite('gofun', 'Majin/gofun', 260, 70)
   setLuaSpriteScrollFactor('gofun', 0, 0)
   scaleObject('gofun', 1, 1)

   makeLuaSprite('one', 'Majin/one', 260, 70)
   setLuaSpriteScrollFactor('one', 0, 0)
   scaleObject('one', 1, 1)

   makeLuaSprite('two', 'Majin/two', 260, 70)
   setLuaSpriteScrollFactor('two', 0, 0)
   scaleObject('two', 1, 1)

   makeLuaSprite('three', 'Majin/three', 260, 70)
   setLuaSpriteScrollFactor('three', 0, 0)
   scaleObject('three', 1, 1)

   setObjectCamera('black', 'camother')
   setObjectCamera('circle', 'camother')
   setObjectCamera('text', 'camother')
   setObjectCamera('gofun', 'other');
   setObjectCamera('one', 'other');
   setObjectCamera('two', 'other');
   setObjectCamera('three', 'other');

   precacheImage('Majin_Notes')
   precacheImage('three')
   precacheImage('two')
   precacheImage('one')
   precacheImage('gofun')
   precacheImage('Bf_Notes');
   precacheImage('Eggman and Bf');
   precacheImage('sunky and bf');
end

function onBeatHit()
   if curBeat == 119 then
      setProperty('defaultCamZoom', 0.9);
   end
end

function onBeatHit()
   if curBeat == 223 then
      setProperty('defaultCamZoom', 0.8);
   end
end

function onBeatHit()
   if curBeat == 238 then
      setProperty('defaultCamZoom', 0.75);
   end
end

function onBeatHit()
   if curBeat == 239 then
      setProperty('defaultCamZoom', 0.7);
   end
end

function onBeatHit()
   if curBeat == 256 then
      setProperty('defaultCamZoom', 0.49);
   end
end

function lerp(a, b, t)
   return a * (1 - t) + b * t
end

function bound(value, min, max)
   return math.max(min, math.min(max, value));
end

function remapToRange(value, start1, stop1, start2, stop2)
   return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1));
end
