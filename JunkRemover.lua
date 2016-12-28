SLASH_JUNKREMOVER1 = "/junkremover"
SLASH_JUNKREMOVER2 = "/jr"

function SlashCmdList.JUNKREMOVER(msg, editbox)
	if msg == "on" then
		junkRemoverEnabled = true
		print("Junk Remover Enabled")
	elseif msg == "off" then
		junkRemoverEnabled = false
		print("Junk Remover Disabled")
	end
end

function junkRemoverFrameOnEvent(self, event)
	if event == "ADDON_LOADED" and arg1 == "JunkRemover" then
		if not junkRemoverEnabled then
			junkRemoverEnabled = true
			print("True")
		end
		self:UnregisterEvent("ADDON_LOADED")
	end
	if junkRemoverEnabled then
		if event == "LOOT_OPENED" then
			local junkRemoverTemp, junkRemoverName, junkRemoverQuantity, junkRemoverQuality
			j = 1
			junkRemoverItems = {}
			for i = 1, GetNumLootItems() do
				junkRemoverTemp, junkRemoverName, junkRemoverTemp, junkRemoverQuality = GetLootSlotInfo(i)
				if junkRemoverQuality == 0 then
					junkRemoverItems[j] = junkRemoverName
					j = j + 1
				end
			end
		end
		if event == "BAG_UPDATE" then
			local junkRemoverBag, junkRemoverSlot
			if junkRemoverItems ~= nil then
				for i = 1, table.getn(junkRemoverItems) do
					junkRemoverBag, junkRemoverSlot = junkRemoverFindItem(junkRemoverItems[i])
					if junkRemoverBag ~= -1 then
						print(junkRemoverItems[i].." Removed")
						table.remove(junkRemoverItems, i)
						PickupContainerItem(junkRemoverBag, junkRemoverSlot)
						DeleteCursorItem()
					end
				end
			end
		end
	end
end

function junkRemoverFindItem(name)
	local junkRemoverSlots = {}
	local junkRemoverName
	for i = 0, NUM_BAG_SLOTS do
	junkRemoverSlots = GetContainerFreeSlots(i)
		for j = 1, GetContainerNumSlots(i) do
			if not junkRemoverTableContains(j, junkRemoverSlots) then
				junkRemoverName = GetItemInfo(GetContainerItemID(i, j))
				if name == junkRemoverName then
					return i, j
				end
			end
		end
	end
	return -1, -1
end

function junkRemoverTableContains(number, tab)
	for i = 1, table.getn(tab) do
		if tab[i] == number then
			return true
		end
	end
	return false
end

local junkRemoverFrame = CreateFrame("FRAME", nil, UIParent)
junkRemoverFrame:RegisterEvent("ADDON_LOADED")
junkRemoverFrame:RegisterEvent("LOOT_OPENED")
junkRemoverFrame:RegisterEvent("BAG_UPDATE")
junkRemoverFrame:SetScript("OnEvent", junkRemoverFrameOnEvent)
