SLASH_JUNKREMOVER1 = "/junkremover"
SLASH_JUNKREMOVER2 = "/jr"

junkRemoverButtons = {}

junkRemoverButton = CreateFrame("Button", "Junk Remover Button", UIParent, "SecureActionButtonTemplate")
junkRemoverButton:SetScript("OnClick", function(self, button)
	if button == "Left Mouse Button" then
		local junkRemoverBag, junkRemoverSlot
			if junkRemoverItems ~= nil then
				for i = 1, table.getn(junkRemoverItems) do
					junkRemoverBag, junkRemoverSlot = junkRemoverFindItem(junkRemoverItems[i])
					if junkRemoverBag ~= -1 then
						C_Container.PickupContainerItem(junkRemoverBag, junkRemoverSlot)
						print(junkRemoverItems[i].." Removed")
						table.remove(junkRemoverItems, i)
						DeleteCursorItem()
					end
				end
			end
	end
end)

function SlashCmdList.JUNKREMOVER(msg, editbox)
	if msg == "on" then
		junkRemoverEnabled = true
		print("Junk Remover Enabled")
	elseif msg == "off" then
		junkRemoverEnabled = false
		print("Junk Remover Disabled")
	end
end

function junkRemoverFrameOnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "JunkRemover" then
		SetOverrideBindingClick(junkRemoverButton, true, "BUTTON3", junkRemoverButton:GetName(), "Left Mouse Button")
		junkRemoverItems = {}
		if not junkRemoverEnabled then
			junkRemoverEnabled = false
		end
		self:UnregisterEvent("ADDON_LOADED")
	end
	if junkRemoverEnabled then
		if event == "LOOT_OPENED" then
			local junkRemoverTemp, junkRemoverName, junkRemoverQuantity, junkRemoverQuality
			j = table.getn(junkRemoverItems) + 1
			for i = 1, GetNumLootItems() do
				junkRemoverTemp, junkRemoverName, junkRemoverTemp, junkRemoverTemp, junkRemoverQuality = GetLootSlotInfo(i)
				if junkRemoverQuality == 0 then
					junkRemoverItems[j] = junkRemoverName
					j = j + 1
				end
			end
		end
		if event == "BAG_UPDATE" then
			
		end
	end
end

function junkRemoverFindItem(name)
	local junkRemoverSlots = {}
	local junkRemoverName
	for i = 0, NUM_BAG_SLOTS do
	junkRemoverSlots = C_Container.GetContainerFreeSlots(i)
		for j = 1, C_Container.GetContainerNumSlots(i) do
			if not junkRemoverTableContains(j, junkRemoverSlots) then
				junkRemoverName = GetItemInfo(C_Container.GetContainerItemID(i, j))
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

function junkRemoverCheckButton(parent, x, y)
	local button = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	local font = button:CreateFontString(nil, nil, "GameFontNormal")
	font:SetText("Toggle Junk Remover on and off")
	font:SetPoint("LEFT", x + 10, 0)
	button:SetFontString(font)
	button:SetPoint("TOPLEFT", x, y)
	button:Show()
	table.insert(junkRemoverButtons, button)
end

function junkRemoverOptionsRefresh()
	junkRemoverButtons[1]:SetChecked(junkRemoverEnabled)
end

function junkRemoverOptionsOkay()
	junkRemoverEnabled = junkRemoverButtons[1]:GetChecked()
end

local junkRemoverFrame = CreateFrame("FRAME", nil, UIParent)
junkRemoverFrame:RegisterEvent("ADDON_LOADED")
junkRemoverFrame:RegisterEvent("LOOT_OPENED")
junkRemoverFrame:RegisterEvent("BAG_UPDATE")
junkRemoverFrame:SetScript("OnEvent", junkRemoverFrameOnEvent)

local junkRemoverOptions = CreateFrame("FRAME")
junkRemoverOptions.name = "Junk Remover"
junkRemoverCheckButton(junkRemoverOptions, 20, -20)
junkRemoverOptions.refresh = junkRemoverOptionsRefresh
junkRemoverOptions.okay = junkRemoverOptionsOkay
junkRemoverOptions.cancel = junkRemoverOptionsRefresh
InterfaceOptions_AddCategory(junkRemoverOptions)