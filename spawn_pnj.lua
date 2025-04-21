-- Liste des positions des PNJ
local pnjPositions = {
    {position = vector3(-1874.5357, 2059.4232, 135.9028), heading = 90.0, model = "s_m_m_migrant_01"},  -- PNJ REMPLIR LES BOUTEILLES VIGNERON
    {position = vector3(-1928.756104, 2059.780274, 140.825684), heading = 00.0, model = "s_m_y_busboy_01"}, -- PNJ PRESSER LES GRAPPES VIGNERON
    {position = vector3(-689.169250, 5788.892090, 17.316528), heading = -100.0, model = "csb_sol"}  -- PNJ VENDRE LE VIN VIGNERON
}

-- Fonction pour créer les PNJ
Citizen.CreateThread(function()
    -- Parcourir la liste des PNJ et les créer
    for _, pnjData in ipairs(pnjPositions) do
        -- Charger le modèle du PNJ
        RequestModel(pnjData.model)
        while not HasModelLoaded(pnjData.model) do
            Wait(500)  -- Attendre que le modèle soit chargé
        end

        -- Créer le PNJ à la position spécifiée avec la rotation donnée
        local pnj = CreatePed(4, pnjData.model, pnjData.position.x, pnjData.position.y, pnjData.position.z, pnjData.heading, false, true)

        -- Rendre le PNJ statique (il ne bougera pas)
        SetEntityInvincible(pnj, true)  -- Rendre invincible
        SetEntityVisible(pnj, true, false)  -- S'assurer que le PNJ est visible
        TaskStandStill(pnj, -1)  -- Rendre le PNJ immobile, il restera sur place

        -- Désactivation des collisions pour empêcher les coups, les poussées, et les chutes
        SetEntityCanBeDamaged(pnj, false)  -- Le PNJ ne peut pas être endommagé
        SetEntityCollision(pnj, false, false)  -- Empêche les collisions physiques
        SetEntityHasGravity(pnj, false)  -- Désactive la gravité pour qu'il ne tombe pas

        -- Empêcher le PNJ de changer de position lorsqu'il est frappé
        Citizen.CreateThread(function()
            while true do
                Wait(0)
                -- Réinitialiser constamment la position du PNJ pour qu'il ne bouge pas
                SetEntityCoordsNoOffset(pnj, pnjData.position.x, pnjData.position.y, pnjData.position.z, true, true, true)
            end
        end)

        -- Bloquer tous les événements non temporaires pour garder le PNJ figé
        SetBlockingOfNonTemporaryEvents(pnj, true)  -- Empêche que le PNJ fasse des actions non souhaitées

        -- Empêcher la collision avec les joueurs
        Citizen.CreateThread(function()
            while true do
                Wait(0)  -- Boucle infinie pour vérifier constamment les collisions
                for _, player in ipairs(GetActivePlayers()) do
                    local playerPed = GetPlayerPed(player)
                    -- Empêche la collision avec chaque joueur
                    SetEntityNoCollisionEntity(pnj, playerPed, true)
                end
            end
        end)
    end
end)

