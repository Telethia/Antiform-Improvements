LUAGUI_NAME = "Persistent Antiform"
LUAGUI_AUTH = "Zurph/Kayya"
LUAGUI_DESC = "Allows Antiform to persist between rooms, use Reaction Commands, and revert with L2/R2. Credits to TopazTK & Num for offsets."

function _OnInit()
	if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
		ConsolePrint("Persistent Anti: Installation successful.")
		canExecute = true
	else
		ConsolePrint("Persistent Anti: Installation Failed.")
	end
end
local CurrForm = 0x446086
local ForceAnti2 = 0x3A3062-0x56454E --Is Sora in Anti? If so, Force back to Form 00.
local RCDisable = 0x405FA7 -0x56454E 
--Function above checks if the current form is AntiForm. If Antiform, will constantly write 0x5 to the third byte of 0x24AA314+0x56454E, which grays an RC out.
local AntiCost = 0x2A5A2F0-0x56454E

function _OnFrame()
Slot1 = 0x24BC74A --Offset 0x56454E subtracted.
Input = 0x1ACF3C --Offset 0x56454E subtracted.
StartingItems = 0x2541446 --Offset 0x56454E subtracted. This is starting item #40, for Sora. Prevents from overlapping with starting items.
CurrFormCheck = ReadByte(CurrForm)
	-- if ReadByte(StartingItems) ~= 0x1E then
	--	WriteByte(StartingItems, 0x1E)
	-- end
	if AntiCost ~= 4 then 		--DEBUG: Set antiforms cost to 0
		WriteByte(AntiCost, 4)
	end
	if CurrFormCheck == 0x06 and ReadInt(Input) == 768 then --Revert from Anti using L2+R2
		WriteFloat(Slot1+0x1B4,0)
	end
	if CurrFormCheck == 0x06 and ReadByte(ForceAnti2) == 0x00 then 
		WriteArray(RCDisable, {0x90, 0x90, 0x90, 0x90})
		WriteByte(ForceAnti2, 0x06)
	--elseif CurrFormCheck ~= 6 then
		--WriteByte(ForceAnti2, 0x00)	
		--WriteArray(RCDisable, {0xC6, 0x43, 0x35, 0x05})
end
end

--To-do:
--Find functions for:
--1) Disabling Camp Menu
--2) Disabling HP Orb Pickup
--3) Disabling Revert CMD in battle (Though, L2+R2 to revert is a workaround for now)
