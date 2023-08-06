#!mainFile "OverPainter.opy"

settings {
    "main": {
        "modeName": "옵치 페인터",
        "description": "제작 훈제김치\r\n코드"
    },
    "lobby": {
        "enableMatchVoiceChat": true,
        "returnToLobby": "never",
        "allowPlayersInQueue": true
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopChamber"
            ],
            "enableSelfInitiatedRespawn": false
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "enableRandomHeroes": true,
            "spawnHealthPacks": "disabled",
            "enableKillFeed": false,
            "enableHeroSwitching": false,
            "heroLimit": "off",
            "enableEnemyHealthBars": false,
            "enableKillCam": false
        }
    },
    "heroes": {
        "allTeams": {
            "zenyatta": {
                "enableUlt": false,
                "enablePrimaryFire": false,
                "enableSecondaryFire": false,
                "enableAbility2": false,
                "enableMelee": false,
                "enableAbility1": false,
                "enableInfiniteAmmo": true
            },
            "enabledHeroes": [
                "zenyatta"
            ]
        }
    }
}

#!extension playMoreEffects