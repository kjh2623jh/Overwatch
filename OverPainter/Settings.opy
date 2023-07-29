#!mainFile "OverPainter.opy"

settings {
    "main": {
        "modeName": "그림 그리기",
        "description": "제작 훈제김치\r\n코드 "
    },
    "lobby": {
        "returnToLobby": "never",
        "allowPlayersInQueue": true,
        "team1Slots": 12,
        "team2Slots": 0,
        "spectatorSlots": 3
    },
    "gamemodes": {
        "skirmish": {
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "enableRandomHeroes": true,
            "respawnTime%": 0,
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
            "general": {
                "ultGen%": 10,
                "passiveUltGen%": 0,
                "combatUltGen%": 0,
                "enablePrimaryFire": false,
                "abilityCooldown%": 50,
                "enableMelee": false,
                "movementSpeed%": 110,
                "enableHeadshotsOnly": true
            },
            "enabledHeroes": [
                "zenyatta"
            ]
        }
    }
}