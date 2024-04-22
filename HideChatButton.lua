-- HideChatButton : a button to hide your chat.
local HCBframe = nil        -- our button frame
local HCBchatshown = true   -- current state
local HCBactivetabs = { [1] = true }

HCBClicker = function( self, button, down )
    if button == "LeftButton" then       
        -- toggle on or off
        if HCBchatshown == true then
            -- find visible windows
            for i = 1, NUM_CHAT_WINDOWS do
                local f = _G["ChatFrame"..i]
                if f then
                    if f:IsVisible() then
                        HCBactivetabs[ i ] = true
                        f:Hide()
                    else
                        HCBactivetabs[ i ] = false
                    end

                    -- override :Show()
                    f.HCBOverrideShow = f.Show
                    f.Show = f.Hide
                end
            end

            -- override and hide main tab group
            GeneralDockManager.HCBOverrideShow = GeneralDockManager.Show
            GeneralDockManager.Show = GeneralDockManager.Hide

            -- hide floating window tabs
            for i = 1, NUM_CHAT_WINDOWS do
                local f = _G["ChatFrame"..i.."Tab"]
                if f then
                    if HCBactivetabs[ i ] == true and f:IsVisible() then
                        f:Hide()
                    end
                    
                    -- override :Show()
                    f.HCBOverrideShow = f.Show
                    f.Show = f.Hide
                end
            end

            ChatFrameMenuButton:Hide()  -- menu button
            FriendsMicroButton:Hide()   -- friends micro button
            HCBchatshown = false        -- toggle shown state
        else
            -- revert override so everyone else can use as normal while we're visible
            GeneralDockManager.Show = GeneralDockManager.HCBOverrideShow
            
            GeneralDockManager:Show()   -- the tabs
            ChatFrameMenuButton:Show()  -- menu button
            FriendsMicroButton:Show()   -- friends micro button

            for i = 1, NUM_CHAT_WINDOWS do
                local f = _G["ChatFrame"..i]
                if f then
                    -- restore overrides
                    f.Show = f.HCBOverrideShow
                    
                    if HCBactivetabs[ i ] == true then
                        f:Show()
                    end
                end
                local f = _G["ChatFrame"..i.."Tab"]
                if f then
                    -- restore overrides
                    f.Show = f.HCBOverrideShow
                    
                    if HCBactivetabs[ i ] == true then
                        f:Show()
                    end
                end
            end
            HCBchatshown = true         -- toggle shown state
        end
    end
end


if not HCBframe then
    HCBframe = CreateFrame( "Button", "HCBframe", UIParent, "UIPanelButtonTemplate" )
    HCBframe:SetPoint( "BOTTOMLEFT", 2, 2 )
    HCBframe:SetWidth( 24 )
    HCBframe:SetHeight( 24 )
    HCBframe:SetScript( "OnMouseUp", HCBClicker )
end
