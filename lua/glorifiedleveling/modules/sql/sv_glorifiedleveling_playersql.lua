
GlorifiedLeveling.SQL.Query( "CREATE TABLE IF NOT EXISTS `gl_players`( `SteamID64` VARCHAR(32) NOT NULL, `Level` BIGINT(64) NOT NULL, `XP` BIGINT(64) NOT NULL, `LastName` VARCHAR(64) DEFAULT '', PRIMARY KEY( `SteamID64` ) )" )

hook.Add( "PlayerInitialSpawn", "GlorifiedLeveling.SQLPlayer.PlayerInitialSpawn", function( ply )
    if ply:IsBot() then return end
    if not ply.GlorifiedLeveling then ply.GlorifiedLeveling = {} end
    GlorifiedLeveling.SQL.Query( "SELECT * FROM `gl_players` WHERE `SteamID64` = '" .. ply:SteamID64() .. "' LIMIT 1", function( queryResult )
        if queryResult and not table.IsEmpty( queryResult ) then
            local plyLevel = queryResult[1]["Level"]
            local plyXP = queryResult[1]["XP"]
            ply.GlorifiedLeveling.Level = plyLevel
            ply.GlorifiedLeveling.XP = plyXP
            ply:SetNW2Int( "GlorifiedLeveling.Level", plyLevel )
            ply:SetNW2Int( "GlorifiedLeveling.XP", plyXP )
            GlorifiedLeveling.SQL.Query( "UPDATE `gl_players` SET `LastName` = '" .. GlorifiedLeveling.SQL.EscapeString( ply:Nick() ) .. "' WHERE `SteamID64` = '" .. ply:SteamID64() .. "'" )
        else
            ply.GlorifiedLeveling.Level = 1
            ply.GlorifiedLeveling.XP = 0
            ply:SetNW2Int( "GlorifiedLeveling.Level", 1 )
            ply:SetNW2Int( "GlorifiedLeveling.XP", 0 )
            GlorifiedLeveling.SQL.Query( "INSERT INTO `gl_players` ( `SteamID64`, `Level`, `XP`, `LastName` ) VALUES ( '" .. ply:SteamID64() .. "', '1', '0', '" .. GlorifiedLeveling.SQL.EscapeString( ply:Nick() ) .. "' )" )
        end
    end )
end )