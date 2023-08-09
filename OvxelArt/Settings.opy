#!mainFile "OvxelArt.opy"

settings {
    "main": {
        "modeName": "옵셀 페인터",
        "description": "제작 훈제김치\r\n코드"
    },
    "lobby": {
        "returnToLobby": "never",
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopChamber"
            ],
            "enableSelfInitiatedRespawn": false
        },
        "general": {
            "gamemodeStartTrigger": "manual",
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