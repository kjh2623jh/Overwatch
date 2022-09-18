settings {
    "main": {
        "modeName": "체스"
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
            "enableHeroSwitching": false,
            "heroLimit": "off",
            "enableEnemyHealthBars": false,
            "enableKillCam": false
        }
    },
    "heroes": {
        "allTeams": {
            "enabledHeroes": [
                "zenyatta"
            ]
        }
    }
}

rule "init":
    disableAnnouncer()
    disableGamemodeCompletion()
    disableMusic()
    disableScoring()


rule "Rule 1":
    @Event eachPlayer
    
    eventPlayer.startCamera(vect(0, 26.607, -13.935), vect(0, -0.88, 0.48), 0)
    hudHeader(getAllPlayers(), hostPlayer.getFacingDirection(), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableRespawn()


rule "Rule 2":
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    
    hostPlayer.teleport(vect(0.16, 26.607, -13.935))