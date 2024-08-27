-- count is needed to prevent my_siege_button and my_attack_button duplication if user exits to menu during popup_pre_battle screen
local count = 1

core:add_listener(
    "PreBattleScreen",
    "PanelOpenedCampaign",
    function(context)
        return context.string == "popup_pre_battle"
    end,
    function()
        if count == 1 then
            -- turns autoresolve outcome invisible
            local autoresolve_outcome = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "autoresolve_outcome")
                if is_uicomponent(autoresolve_outcome) then
                autoresolve_outcome:SetVisible(false)
                end
            -- tries to create my_siege_button first then my_attack_button both have to be under the same listener otherwise it does not work properly
            local root = core:get_ui_root()
            local parent1 = find_uicomponent(root, "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_siege")
            local original_button_autoresolve = find_uicomponent(parent1, "button_autoresolve")
            -- parent button_set_siege will not allow a new button to be added unless one of the original ones is temporarily turned invisible
            original_button_autoresolve:SetVisible(false)
            local my_siege_button = UIComponent(parent1:CreateComponent("my_siege_button", "ui/templates/square_medium_button"))
            my_siege_button:SetImagePath("ui/skins/default/icon_auto_resolve.png")
            my_siege_button:SetTooltipText("I work the same as the autoresolve button, except I do not highlight lost units until it is too late.", true)
            -- here the original_button_autoresolve is turned visible again after a 0.2 sec delay
            cm:callback(function()
               original_button_autoresolve:SetVisible(true)
            end, 0.2)
            -- tries to create my_attack button
            local parent2 = find_uicomponent(root, "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack")
            local my_attack_button = UIComponent(parent2:CreateComponent("my_attack_button", "ui/templates/square_medium_button"))
            my_attack_button:SetImagePath("ui/skins/default/icon_auto_resolve.png")
            my_attack_button:SetTooltipText("I work the same as the autoresolve button, except I do not highlight lost units until it is too late.", true)
            -- count increases to prevent my_button duplication
            count = count + 1
        end
    end,
    true
)

-- once the battle is over count is reset back to 1 to reactive the above function
core:add_listener(
    "BattleExit",
    "ScriptEventPlayerBattleSequenceCompleted",
    true,
    function()
        count = 1
    end,
    true
)

-- listener for clicking my_attack_button
core:add_listener(
    "my_attack_button_listener",
    "ComponentLClickUp",
    function(context)
        return context.string == "my_attack_button"
    end,
    function()
        local root = core:get_ui_root()
        local autoresolve_button = find_uicomponent(root, "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack", "button_autoresolve")
        autoresolve_button:SimulateLClick()
    end,
    true
)

-- listener for clicking my_siege_button
core:add_listener(
    "my_siege_button_listener",
    "ComponentLClickUp",
    function(context)
        return context.string == "my_siege_button"
    end,
    function()
        local root = core:get_ui_root()
        local autoresolve_button = find_uicomponent(root, "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_siege", "button_autoresolve")
        autoresolve_button:SimulateLClick()
    end,
    true
)