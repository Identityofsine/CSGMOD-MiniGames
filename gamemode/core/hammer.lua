function FindAllTeleports()
    local teleport_ents = {}
    for _, ent in ipairs(ents.FindByClass("trigger_teleport")) do
        table.insert(teleport_ents, ent)
    end
    return teleport_ents
end

function FixTeleporters()
    local teleports = FindAllTeleports()
    for k, v in pairs(teleports) do
        local teleporterKeyValues = v:GetKeyValues()
        v:SetKeyValue("filtername", "all")
        v:SetKeyValue("TeamNum", 1)
        v:Spawn();
    end

end
