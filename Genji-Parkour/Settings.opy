#!mainFile "GenjiParkour.opy"

# Settings
settings {
    "main": {
        "modeName": "겐지 파쿠르",
        # <FG30FF0Bf> : 초록색
        # <FGFF0000f> : 빨간색
        # <FGFFFFFFf> : 기본 글자 색
        "description": "Created by: <FG30FF0Bf>훈제김치<FGFFFFFFf>\nCode: <FG30FF0Bf>95969\nhttps://discord.gg/dyGvBbBgxV<FGFFFFFFf>\nv 0.2.4"
    },
    "lobby": {
        "returnToLobby": "never",
        "allowPlayersInQueue": true,
        "team1Slots": 11,
        "team2Slots": 0,
        "spectatorSlots": 3
    },
    "gamemodes": {
        "ffa": {
            "enabled": false,
            "enableSelfInitiatedRespawn": false
        },
        "skirmish": {
            "enabledMaps": [
                "dorado"
            ]
        },
        "practiceRange": {
            "enabled": false,
            "enableTrainingPartner": false,
            "spawnTrainingBots": false
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
            "dva": {
                "enableSpawningWithUlt": true
            },
            "genji": {
                "enableSpawningWithUlt": true,
                "ultDuration%": 25,
                "passiveUltGen%": 0,
                "enableInfiniteAmmo": true
                # 튕겨내기: 비활성화
            },
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

# Extensions
#!extension buffStatusEffects
