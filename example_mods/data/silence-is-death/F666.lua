-- Script made by Catbrother Everything with help by NardBruh. Credit is not needed but would be nice! :)

function onCreate()
	makeAnimatedLuaSprite('F666', 'characters/xo', 900, 800); -- Change to characters idle in XML
	addAnimationByPrefix('F666', 'idle', 'idle', 24, false); -- Change to characters idle in XML
    addAnimationByPrefix('F666', '0', 'left', 24, false); -- Change to characters leftnote in XML
    addAnimationByPrefix('F666', '1', 'down', 24, false); -- Change to characters downnote in XML
    addAnimationByPrefix('F666', '2', 'up', 24, false); -- Change to characters upnote in XML
    addAnimationByPrefix('F666', '3', 'right', 24, false); -- Change to characters rightnote in XML
	objectPlayAnimation('F666', 'idle'); 
	addLuaSprite('F666', false); -- false = add behind characters, true = add over characters
end
function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0 then
		objectPlayAnimation('F666', 'idle');
	end
end

lastNote = {0, ""}

function opponentNoteHit(id,d,t,s)

    lastNote[1] = d
    lastNote[2] = t
    
    if lastNote[2] == "No Animation" then 
		objectPlayAnimation('F666', lastNote[1]);
    end
	
	if lastNote[2] == "Duet" then 
		objectPlayAnimation('F666', lastNote[1]);
	end
end