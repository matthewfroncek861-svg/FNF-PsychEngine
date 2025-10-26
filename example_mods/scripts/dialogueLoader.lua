local songHasStartDialogue = false
local songHasEndDialogue = false
local dialogueData = {
	--song, dialogue name, isEndDialogue, before dialogue cutscene tag, end of dialogue cutscene tag, dialogue music
	{'the idea', 'opening', false, 'cooldown', '', 'the_idea_dialogue_music'},
	{'the idea', 'song1End', true, '', '', 'ominous_combo_meal'},
	{'combo meal', 'song2End', true, 'transform', '', ''},
}
local startDialogue = {'none'}
local endDialogue = {'none'}
function onCreate()
	--luaDebugMode = true
	for i = 0,#dialogueData-1 do 
		if not dialogueData[i+1][3] then --start dialogue
			if string.lower(songName) == dialogueData[i+1][1] then 
				startDialogue = dialogueData[i+1]
				songHasStartDialogue = true
			end
		else --end dialogue
			if string.lower(songName) == dialogueData[i+1][1] then 
				endDialogue = dialogueData[i+1]
				songHasEndDialogue = true
			end
		end
	end
end

local dialogueCount = 0 --the one psych uses doesnt seem like it resets if multiple dialogue so yeah
local endofDialogueCutsceneTag = ''

function onStartCountdown()
	if songHasStartDialogue and not seenCutscene and isStoryMode then
		setProperty('camHUD.alpha', 0)
		if startDialogue[4] ~= '' then --load cutscenes
			runTimer(startDialogue[4], 0.1)
			startDialogue[4] = '' --stop from replaying
			return Function_Stop;
		end
		endofDialogueCutsceneTag = startDialogue[5]
		dialogueCount = 0
		startDialogueFromPath('dialogue/'..startDialogue[2]..'.json'); --using custom function so its not tied to song folder, psych why
		setObjectCamera('psychDialogue', 'other')
		songHasStartDialogue = false; --set to false once played dialogue
		onNextDialogue(0)
		if startDialogue[6] ~= '' then 
			playMusic(startDialogue[6])
		end
		
		return Function_Stop;
	end
	if endofDialogueCutsceneTag ~= '' then --load end of dialgoue cutscene
		runTimer(endofDialogueCutsceneTag, 0.1)
		endofDialogueCutsceneTag = '' --stop from replaying
		return Function_Stop;
	end
	doTweenAlpha('hud', 'camHUD', 1, crochet/1000, 'cubeInOut')
	return Function_Continue;
end

function onEndSong()

	if songHasEndDialogue and isStoryMode then
		
		doTweenAlpha('hud', 'camHUD', 0, crochet/1000, 'cubeInOut')
		if endDialogue[4] ~= '' then --load cutscenes ig
			runTimer(endDialogue[4], 0.1)
			endDialogue[4] = '' --stop from replaying
			return Function_Stop;
		end

		endofDialogueCutsceneTag = endDialogue[5] --set end tag

		dialogueCount = 0
		startDialogueFromPath('dialogue/'..endDialogue[2]..'.json');
		setObjectCamera('psychDialogue', 'other')
		songHasEndDialogue = false; --set to false once played dialogue
		onNextDialogue(0)
		playMusic(endDialogue[6], 0.6) --for some reason if the song time repeats it tries to end song again
		
		return Function_Stop;
	end
	if endofDialogueCutsceneTag ~= '' then --load end of dialgoue cutscene
		runTimer(endofDialogueCutsceneTag, 0.1)
		endofDialogueCutsceneTag = '' --stop from replaying
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsleft)
	if tag == 'transform' then
		playMusic('')
		startVideo('end_card')
		songHasEndDialogue = false --stop stuff
		--StartAndEnd()--add cutscene here when we got shit ready for it
	elseif tag == 'endCard' then 
		StartAndEnd()

	elseif tag == 'StartAndEnd' then
		StartAndEnd()

	elseif tag == 'cooldown' then
		runTimer('StartAndEnd',1)
	end
end

function StartAndEnd() --call when ending a cutscene
	if getProperty('endingSong') then 
		onEndSong()
	else 
		onStartCountdown()
	end
end


function onNextDialogue(a)

	luaDebugMode = true

	if dialogueCount > 0 then 
		stopSound('dialogue'..(dialogueCount-1)) --cancel last just in case
	end
	
	if getProperty('endingSong') then 
		playSound(''..endDialogue[2]..'/voiceLine'..dialogueCount, 1.5, 'dialogue'..dialogueCount) --play voicelines
	else 
		playSound(''..startDialogue[2]..'/voiceLine'..dialogueCount, 1.5, 'dialogue'..dialogueCount)
	end
	setSoundVolume('dialogue'..dialogueCount, 4)
	dialogueCount = dialogueCount + 1
	
end

function onSkipDialogue(a)
	stopSound(''..dialogueCount) --cancel when skipped
end