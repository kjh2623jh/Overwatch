settings {
    "main": {
        "modeName": "체스"
    },
    "lobby": {
        "ffaSlots": 4
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
            "mccree": {
                "enableUlt": false,
                "enablePrimaryFire": false,
                "enableSecondaryFire": false,
                "enableMelee": false,
                "enableInfiniteAmmo": true
            },
            "enabledHeroes": [
                "mccree"
            ]
        }
    }
}


globalvar a
globalvar b

playervar a
playervar b

subroutine a


rule "init":
    disableInspector()
    disableAnnouncer()
    disableGamemodeCompletion()
    disableMusic()
    disableScoring()
    a = 0
    createInWorldText(hostPlayer, "▶", updateEveryTick(vect(0, 20.5, -5.5) + 0.1 * (vect(hostPlayer.getHorizontalFacingAngle(), -1 * hostPlayer.getVerticalFacingAngle()*63, 0))) \
                       , 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    b = getLastCreatedText()
    # createInWorldText([i for i in localPlayer if localPlayer.AI], "▶", updateEveryTick(vect(-0.27, 8.75, 20) + 0.1 * (vect(localPlayer.getHorizontalFacingAngle(), -1 * localPlayer.getVerticalFacingAngle(), 0))), 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, localPlayer.D, SpecVisibility.DEFAULT)


rule "join":
    @Event eachPlayer
    
    # eventPlayer.startCamera([vect(0, 26.607, -13.935), vect(0, 26.607, 13.935)][a], [vect(0, -0.88, 0.48), vect(0, -0.88, -0.48)][a], 0)
    eventPlayer.startCamera([vect(0, 26.607, -13.935), vect(0, 26.607, 13.935)][a], [vect(0, 26.607, -13.935), vect(0, 26.607, 13.935)][a] + angleToDirection(0, 63), 0)
    hudHeader(getAllPlayers(), "{0} {1}".format(eventPlayer.getHorizontalFacingAngle(), eventPlayer.getVerticalFacingAngle()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableRespawn()
    # eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.disablePlayerCollision()
    eventPlayer.disableHeroHUD()



# rule "in":
#     @Condition hostPlayer.isHoldingButton(Button.INTERACT)

#     a = not a


rule "aa":
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)

    if hostPlayer.b:
        hostPlayer.startCamera([vect(0, 26.607, -13.935), vect(0, 26.607, 13.935)][a], [vect(0, 26.607, -13.935), vect(0, 26.607, 13.935)][a] + angleToDirection(0, 63), 0)
    else:
        hostPlayer.stopCamera()
    hostPlayer.b=not hostPlayer.b