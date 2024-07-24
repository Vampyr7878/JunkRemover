local JunkRemover = LibStub("AceAddon-3.0"):NewAddon("JunkRemover")

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

function JunkRemover:FrameOnEvent(event, arg1)
	if junkRemoverEnabled then
		if event == "LOOT_OPENED" then
			local name, quality
			j = table.getn(JunkRemover.Items) + 1
			for i = 1, GetNumLootItems() do
				_, name, _, _, quality = GetLootSlotInfo(i)
				if quality == 0 then
					JunkRemover.Items[j] = name
					j = j + 1
				end
			end
		end
	end
end

function JunkRemover:FindItem(name)
	local slots = {}
	local itemName
	for i = 0, NUM_BAG_SLOTS do
	slots = C_Container.GetContainerFreeSlots(i)
		for j = 1, C_Container.GetContainerNumSlots(i) do
			if not self:TableContains(j, slots) then
				itemName = C_Item.GetItemInfo(C_Container.GetContainerItemID(i, j))
				if name == itemName then
					return i, j
				end
			end
		end
	end
	return -1, -1
end

function JunkRemover:TableContains(number, tab)
	for i = 1, table.getn(tab) do
		if tab[i] == number then
			return true
		end
	end
	return false
end

function JunkRemover:OnInitialize()
	self.Frame = CreateFrame("FRAME", nil, UIParent)
	self.Frame:RegisterEvent("LOOT_OPENED")
	self.Frame:RegisterEvent("BAG_UPDATE")
	self.Frame:SetScript("OnEvent", self.FrameOnEvent)
	self.Items = {}
	if not junkRemoverEnabled then
		junkRemoverEnabled = false
	end
	self.Button = CreateFrame("Button", "Junk Remover Button", UIParent, "SecureActionButtonTemplate")
	self.Button:SetScript("OnClick", function(self, button)
		if button == "Left Mouse Button" then
			local bag, slot
			if JunkRemover.Items ~= nil then
				for i = 1, table.getn(JunkRemover.Items) do
					bag, slot = JunkRemover:FindItem(JunkRemover.Items[i])
					if bag ~= -1 then
						C_Container.PickupContainerItem(bag, slot)
						print(JunkRemover.Items[i].." Removed")
						table.remove(JunkRemover.Items, i)
						DeleteCursorItem()
					end
				end
			end
		end
	end)
	SetOverrideBindingClick(self.Button, true, "BUTTON3", self.Button:GetName(), "Left Mouse Button")
	local options = {
		name = "Junk Remover",
		handler = JunkRemover,
		type = "group",
		args = {
			toggle = {
				name = "Toggle Junk Remover",
				type = "toggle",
				desc = "Toggle Junk Remover on and off",
				set = "SetToggle",
				get = "GetToggle",
			}
		}
	}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("JunkRemover", options, nil)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("JunkRemover", "Junk Remover")
end

function JunkRemover:SetToggle(info, val)
	junkRemoverEnabled = val
end

function JunkRemover:GetToggle(info)
	return junkRemoverEnabled
end