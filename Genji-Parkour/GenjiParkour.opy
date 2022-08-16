# Genji Parkour WorkShop by: 훈제김치


settings {
    "main": {
        "modeName": "겐지 파쿠르",
        "description": "Created by: 훈제김치\nCode: <code>\nhttps://discord.gg/dyGvBbBgxV\n<date>"
    },
    "lobby": {
        "enableMatchVoiceChat": true,
        "returnToLobby": "never",
        "allowPlayersInQueue": true,
        "team1Slots": 12,
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
            "roleLimit": "2OfEachRolePerTeam",
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



globalvar GameMode
globalvar CheckPoint
globalvar PioneerArr
globalvar AbilityArr
globalvar UltimateArr
globalvar CpSize 
globalvar PioneerHud 
globalvar Pioneer 
globalvar PioneerMinDistans
globalvar PlayerList
globalvar CheckPointList
globalvar Dva

playervar check_point 
playervar arrived_check_point
playervar is_pioneering
playervar is_float
playervar is_invincible
playervar pioneer_ability
playervar ability
playervar ultimate
playervar name
playervar player_index
playervar save_temp

subroutine save 
subroutine toCheckPoint 
subroutine abilityReset



def save():
    @Name "paste here"

    /*
    GameMode = "제작: <name>"
    CheckPoint = [vect(0.235, 6.949, -54.319), vect(-4.961, 6.96, -70.946), vect(-15.015, 6.947, -53.262), ...]
    PioneerArr = ["name", "name", "name", ...]
    AbilityArr = [0, 1, 2, 1, 1, 2, 0, 0, 1, 0, ...]
    UltimateArr = [0, 1, 2, 0, 1, 0, 0, 1, 1, 0, ...]
    CpSize = 1.5
    PioneerHud = null
    Pioneer = <player name>
    PioneerMinDistans = 7
    Dva = null
    */

rule "Init":
    disableInspector()
    disableScoring()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    

    PioneerHud = []
    CpSize = createWorkshopSetting(float[0.1:3], "Setting", "CheckPoint Size", 1.5, 0)
    waitUntil(hostPlayer.hasSpawned(),5)
    Pioneer = hostPlayer
    if not hostPlayer.hasSpawned():
        Pioneer = random.choice(getPlayers(Team.ALL))
    PioneerMinDistans = createWorkshopSetting(int[1:20], "Setting", "개척 최소 거리", 7, 0)
    PlayerList = []
    CheckPointList = []
    save()
    # 시간제한은 없고 기술제한은 기본적으로 존재 ( 완성된 맵에서는 시간 있음 )
    if CheckPoint:
        hudHeader(getAllPlayers(), GameMode, HudPosition.TOP, -2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    else:
        hudHeader(getAllPlayers(), "{0}".format(["개척 모드", "제작 모드"][GameMode]), HudPosition.TOP, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudHeader(Pioneer, "press {0}: 모드 변경".format(buttonString(Button.INTERACT)), HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        PioneerHud.append(getLastCreatedText())
        hudHeader(getAllPlayers(), "{0}님 시작할 장소로 가 {1}를 누르세요.".format(Pioneer, buttonString(Button.RELOAD)), HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        PioneerHud.append(getLastCreatedText())
        hudHeader(Pioneer if Pioneer.is_pioneering else null, "개척해주세요", HudPosition.TOP, -1, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader(getAllPlayers() if Pioneer.is_pioneering else null, "개척자: {0}".format(Pioneer), HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0}/270m".format(floor(getTotalTimeElapsed()/60)), HudPosition.LEFT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Switch Pioneer Modes":
    @Condition CheckPoint == false
    @Condition Pioneer.isHoldingButton(Button.INTERACT)

    GameMode = not GameMode


rule "Player Joined":
    @Event playerJoined
    
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disablePlayerCollision()
    eventPlayer.name = "{0}".format(eventPlayer)
    if eventPlayer.name in PlayerList:
        eventPlayer.player_index = PlayerList.index(eventPlayer.name)
        eventPlayer.check_point = CheckPointList[eventPlayer.player_index]
        eventPlayer.arrived_check_point = eventPlayer.check_point
    else:
        eventPlayer.player_index = len(PlayerList)
        PlayerList.append(eventPlayer.name)
        CheckPointList.append(eventPlayer.check_point)
    createEffect(eventPlayer, Effect.RING, Color.BLUE, CheckPoint[eventPlayer.check_point], CpSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in eventPlayer if CheckPoint[eventPlayer.check_point+1]], Effect.RING, Color.PURPLE, CheckPoint[eventPlayer.check_point+1], CpSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(eventPlayer if CheckPoint[eventPlayer.check_point + 1] else null, "다음 개척지\n개척자: {0}".format(PioneerArr[eventPlayer.check_point+1]), CheckPoint[eventPlayer.check_point+1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "{0}/{1}\n{2}".format(eventPlayer.check_point, len(CheckPoint)-1, "{0} {1} | {2}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1), AbilityArr[eventPlayer.check_point+1]-eventPlayer.ability, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), UltimateArr[eventPlayer.check_point+1]-eventPlayer.ultimate))), HudPosition.RIGHT, -1, Color.BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0} {1}".format(eventPlayer, eventPlayer.arrived_check_point), HudPosition.RIGHT, (sorted(getAllPlayers(), lambda player: -1 * player.arrived_check_point)).index(eventPlayer), Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    createIcon(eventPlayer if CheckPoint[eventPlayer.check_point+1] and not eventPlayer.isInViewAngle(CheckPoint[eventPlayer.check_point+1], 60) else null, CheckPoint[eventPlayer.check_point+1], Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.PURPLE, true)


rule "Create First Checkpoint":
    @Condition CheckPoint == false
    @Condition Pioneer.isHoldingButton(Button.RELOAD)
    @Condition Pioneer.isOnGround() == true
    @Condition Pioneer.isInSpawnRoom() == false

    destroyHudText(PioneerHud[0])
    destroyHudText(PioneerHud[1])
    destroyHudText(PioneerHud[2])
    PioneerHud = null
    Pioneer.is_pioneering = true
    CheckPoint = [Pioneer.getPosition()]
    PioneerArr = ["{0}".format(Pioneer)]
    AbilityArr = [0]
    UltimateArr = [0]


def toCheckPoint():
    @Name "ToCheckpoint"

    eventPlayer.startForcingPosition(CheckPoint[eventPlayer.check_point], false)
    abilityReset()
    wait(0.1)
    eventPlayer.stopForcingPosition()


def abilityReset():
    @Name "AbilityReset"

    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.ability = 0
    eventPlayer.ultimate = 0
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setUltEnabled(true)
    if CheckPoint[eventPlayer.check_point+1] and eventPlayer.is_pioneering == false and eventPlayer.is_invincible == false:
        if AbilityArr[eventPlayer.check_point+1]==0:
            eventPlayer.setAbility1Enabled(false)
        if UltimateArr[eventPlayer.check_point+1]==0:
            eventPlayer.setUltEnabled(false)


rule "Die":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.is_invincible == false
    @Condition CheckPoint[eventPlayer.check_point + 1]
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > CpSize
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point+1]) > CpSize

    toCheckPoint()


rule "Pioneer Die":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer == Pioneer
    @Condition eventPlayer.is_pioneering == true
    @Condition eventPlayer.is_invincible == false
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > CpSize
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) <= PioneerMinDistans

    toCheckPoint()


rule "Pioneer":
    @Event eachPlayer
    @Condition eventPlayer == Pioneer
    @Condition eventPlayer.is_pioneering == true
    @Condition eventPlayer.is_invincible == false
    @Condition eventPlayer.isOnGround()
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > PioneerMinDistans

    CheckPoint.append(eventPlayer.getPosition())
    PioneerArr.append(eventPlayer.name)
    # AbilityArr.append(eventPlayer.pioneer_ability)
    AbilityArr.append(eventPlayer.ability)
    UltimateArr.append(eventPlayer.ultimate)
    if getNumberOfPlayers(Team.ALL) > 1 or eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.is_float = true
        eventPlayer.is_pioneering = false
        toCheckPoint()
        eventAbility.is_float = false
    else:
        abilityReset()
        eventPlayer.check_point += 1
        eventPlayer.arrived_check_point += 1


rule "Pioneered":
    @Event eachPlayer
    @Condition eventPlayer.check_point == len(CheckPoint)-1
    @Condition eventPlayer != Pioneer
    @Condition Pioneer.is_pioneering == false

    toCheckPoint()
    smallMessage(eventPlayer, "pioneered")
    
    
rule "Arrive":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.is_pioneering == false
    @Condition eventPlayer.is_float == false
    @Condition eventPlayer.is_invincible == false
    @Condition CheckPoint[eventPlayer.check_point + 1] == true
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point + 1]) < CpSize
    
    eventPlayer.check_point+=1
    abilityReset()
    if eventPlayer.check_point == len(CheckPoint)-1 and (eventPlayer != Pioneer and not Pioneer.is_pioneering or getNumberOfPlayers(Team.ALL) == 1):
        Pioneer = eventPlayer
        eventPlayer.is_pioneering = true
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
    if eventPlayer.check_point > eventPlayer.arrived_check_point:
        eventPlayer.arrived_check_point = eventPlayer.check_point
        CheckPointList[eventPlayer.player_index] = eventPlayer.arrived_check_point


rule "Finish": # if this workshop is finished map
    @Event eachPlayer
    @Condition eventPlayer.check_point == len(CheckPoint)-1


rule "Restart":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    eventPlayer.check_point = 0
    eventPlayer.arrived_check_point = 0
    CheckPointList[eventPlayer.player_index] = 0


rule "Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition CheckPoint

    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    toCheckPoint()


rule "Abiliy 1":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()

    if eventPlayer.is_invincible:
        waitUntil(not eventPlayer.isUsingAbility1(), 3)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    else:
        if eventPlayer.is_pioneering:
            eventPlayer.ability += 1
        elif eventPlayer.check_point < len(CheckPoint)-1:
            eventPlayer.ability += 1
            if AbilityArr[eventPlayer.check_point+1] - eventPlayer.ability < 1:
                eventPlayer.setAbility1Enabled(false)


rule "Ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()

    if eventPlayer.is_pioneering:
        eventPlayer.ultimate += 1
    elif eventPlayer.check_point < len(CheckPoint)-1:
        eventPlayer.ultimate += 1
        if UltimateArr[eventPlayer.check_point+1]- eventPlayer.ultimate < 1:
            eventPlayer.setUltEnabled(false)


rule "MoveCp":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.is_pioneering == false

    eventPlayer.is_float = true
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.check_point+=1
        if eventPlayer.check_point > eventPlayer.arrived_check_point:
            eventPlayer.check_point = 0
    else:
        eventPlayer.check_point-=1
        if eventPlayer.check_point < 0:
            eventPlayer.check_point = eventPlayer.arrived_check_point
    toCheckPoint()
    eventPlayer.is_float = false


rule "Invincible Mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    if eventPlayer.is_invincible:
        eventPlayer.is_invincible = false
        toCheckPoint()
    else:
        eventPlayer.is_invincible = true
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        smallMessage(eventPlayer, "invincible mode")


rule "Invincible Mode Skill":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.is_invincible

    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "Ultimate Charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() < 100

    eventPlayer.setUltCharge(100)
        

rule "Spectate":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.arrived_check_point < len(CheckPoint)-1 or Pioneer.is_pioneering == false

    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isAlive():
        eventPlayer.disableRespawn()
        eventPlayer.is_float = true
        kill(eventPlayer, null)
    else:
        eventPlayer.enableRespawn()
        eventPlayer.respawn()
        toCheckPoint()
        eventPlayer.is_float = false


rule "Revive":
    @Event playerDied
    @Condition eventPlayer.is_float == false

    if eventPlayer.is_invincible:
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer))
    else:
        toCheckPoint()
    eventPlayer.resurrect()


rule "Dva":
    @Condition isGameInProgress()

    wait(2)
    createDummy(Hero.DVA, Team.1, -1, vect(0, 0, 0), vect(0, 0, 0))
    Dva = getLastCreatedEntity()
    wait(1)
    Dva.setInvisibility(Invis.ALL)
    Dva.startForcingPosition(vect(0, 0, 0), true)
    Dva.startScalingSize(100, true)
    Dva.disableEnvironmentCollision(true)
    Dva.forceButtonPress(Button.ULTIMATE)
    wait(3)
    destroyAllDummies()


rule "Save Inspector":
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isStanding()

    GameMode = "제작: {0}".format(hostPlayer)
    hostPlayer.save_temp = []
    hostPlayer.save_temp.append(PlayerList)
    hostPlayer.save_temp.append(CheckPointList)
    enableInspector()
    disableInspector()
    PlayerList = hostPlayer.save_temp[0]
    CheckPointList = hostPlayer.save_temp[1]
    hostPlayer.save_temp = []