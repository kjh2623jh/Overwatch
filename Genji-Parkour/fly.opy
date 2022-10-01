settings {
    "main": {
        "modeName": "관전 플라이",
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopChamber"
            ]
        },
        "control": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "assault": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "escort": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "hybrid": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        }
    },
    "heroes": {
        "allTeams": {
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

rule "init":
    @Event eachPlayer

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)


rule "init":
    hudHeader(localPlayer, getServerLoad(), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Position":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.startForcingPosition(
        eventPlayer.getPosition() 
        + ((eventPlayer.getFacingDirection() * eventPlayer.getThrottle().z 
        + ((angleToDirection(eventPlayer.getHorizontalFacingAngle() + 90, 0)) * eventPlayer.getThrottle().x) 
        + (Vector.DOWN * ((1 if eventPlayer.isHoldingButton(Button.ULTIMATE) else -1) if eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.ABILITY_2) else 0))) 
        * (0.5 + eventPlayer.isHoldingButton(Button.ABILITY_1))), true)


rule "Camera":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    A = not A
    if A:
        eventPlayer.startCamera(eventPlayer + worldVector(vect(0, 0, -2), eventPlayer, Transform.ROTATION) + Vector.UP * 2.5 + eventPlayer.getFacingDirection() * -2.5, eventPlayer + Vector.UP * 2.5 + eventPlayer.getFacingDirection() * 50, 0)
    else:
        eventPlayer.stopCamera()