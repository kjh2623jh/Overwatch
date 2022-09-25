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
globalvar CheckPointSize 
globalvar PioneerHud 
globalvar Pioneer 
globalvar PioneerMinDistans
globalvar PlayerList
globalvar CheckPointList
globalvar Dva
globalvar PioneerCancelTime
globalvar PioneerCancelTimer
globalvar PioneerCancel
globalvar PioneerPosition
globalvar PioneerTime
globalvar Time
globalvar Finished

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
playervar is_last_check_point
playervar dva_position_arr
playervar dva_position
playervar dva_index
playervar is_invisible

subroutine save 
subroutine toCheckPoint 
subroutine abilityReset
subroutine invincibleMode

#!extension buffStatusEffects


def save():
    @Name "paste here"

    smallMessage(hostPlayer, "Delete it")
    /*
    GameMode = "제작: <player>"
    CheckPoint = [vect(0.235, 6.949, -54.319), vect(-4.961, 6.96, -70.946), vect(-15.015, 6.947, -53.262), ...]
    PioneerArr = ["name", "name", "name", ...]
    AbilityArr = [0, 1, 2, 1, 1, 2, 0, 0, 1, 0, ...]
    UltimateArr = [0, 1, 2, 0, 1, 0, 0, 1, 1, 0, ...]
    CheckPointSize = 1.5
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
    CheckPointSize = createWorkshopSetting(float[0.1:3], "Setting", "개척지 크기", 1.5, 0)
    waitUntil(hostPlayer.hasSpawned(),5)
    Pioneer = hostPlayer
    if not hostPlayer.hasSpawned():
        Pioneer = random.choice(getPlayers(Team.ALL))
    PioneerMinDistans = createWorkshopSetting(int[1:20], "Setting", "개척 최소 거리", 7, 1)
    PioneerCancelTime = createWorkshopSetting(int[0:15], "Setting", "개척 취소 시간", 5, 1)
    Time = createWorkshopSetting(int[60:300], "Setting", "개척 제한시간", 120, 1)
    PlayerList = []
    CheckPointList = []
    save()
    Dva = 1
    if CheckPoint:
        hudHeader(getAllPlayers(), "제작: {0}".format(GameMode), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT) # 임시
        Finished = true
    else:
        # hm
        hudSubtext(getAllPlayers(), "{0}".format(["개척 모드", "제작 모드"][GameMode]), HudPosition.LEFT, 0, [Color.BLUE, Color.GREEN][GameMode], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        # hm
        hudSubtext(Pioneer, "press {0}: 모드 변경".format(buttonString(Button.INTERACT)), HudPosition.LEFT, -0.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        PioneerHud.append(getLastCreatedText())
        hudHeader(getAllPlayers(), "{0}님 시작할 장소로 가 {1}를 누르세요.".format(Pioneer, buttonString(Button.RELOAD)), HudPosition.RIGHT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        PioneerHud.append(getLastCreatedText())
        # hm
        hudSubtext(Pioneer if Pioneer.is_pioneering else null, "개척해주세요", HudPosition.TOP, 0, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader(getAllPlayers() if Pioneer.is_pioneering else null, "개척자: {0}".format(Pioneer), HudPosition.RIGHT, -0.9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        # progress bar
        progressBarHud(getAllPlayers() if Pioneer.is_pioneering else null, PioneerTime / Time * 100, "개척 시간", HudPosition.RIGHT, -0.8, Color.WHITE, Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.DEFAULT)
        hudHeader(getAllPlayers() if Pioneer.is_pioneering else null, "남은 시간", HudPosition.RIGHT, -0.8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        createEffect(Pioneer if PioneerCancelTimer else null, Effect.RING, Color.RED, PioneerPosition, CheckPointSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        hudSubtext(Pioneer if PioneerCancelTimer else null, "Cancel: {0} - Confirm: {1} {2}".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), ceil(PioneerCancelTimer)), HudPosition.TOP, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(getAllPlayers(), "v 0.1", HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "discord link in youtube '(genji parkour) nemi'", HudPosition.LEFT, -1, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    # to SubHeader?
    hudSubtext(getAllPlayers(), "server reset {0}m left".format(270 - floor(getTotalTimeElapsed()/60)), HudPosition.RIGHT, -2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Combo List", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    chase(PioneerCancelTimer, 0, rate=1, ChaseReeval.NONE)


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
    eventPlayer.disableGamemodeHud() # 임시
    eventPlayer.name = "{0}".format(eventPlayer)
    if eventPlayer.name in PlayerList:
        eventPlayer.player_index = PlayerList.index(eventPlayer.name)
        eventPlayer.check_point = CheckPointList[eventPlayer.player_index]
        eventPlayer.arrived_check_point = eventPlayer.check_point
    else:
        eventPlayer.player_index = len(PlayerList)
        PlayerList.append(eventPlayer.name)
        CheckPointList.append(eventPlayer.check_point)
    if CheckPoint == false:
        if eventPlayer.is_pioneering == false:
            eventPlayer.is_last_check_point = true
        invincibleMode()
    createEffect(eventPlayer, Effect.RING, Color.WHITE, CheckPoint[eventPlayer.check_point], CheckPointSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in eventPlayer if CheckPoint[eventPlayer.check_point+1]], Effect.RING, Color.GREEN, CheckPoint[eventPlayer.check_point+1], CheckPointSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.is_invincible else null, Effect.ANA_NANO_BOOSTED, Color.GREEN, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(eventPlayer if CheckPoint[eventPlayer.check_point + 1] else null, "다음 개척지\n개척자: {0}".format(PioneerArr[eventPlayer.check_point+1]), CheckPoint[eventPlayer.check_point+1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "{0} / {1}".format(eventPlayer.check_point, len(CheckPoint)-1), HudPosition.TOP, -2, Color.BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "{0} {1} | {2}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1), abs(AbilityArr[eventPlayer.check_point+1]-eventPlayer.ability), "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), abs(UltimateArr[eventPlayer.check_point+1]-eventPlayer.ultimate))), HudPosition.TOP, -1, Color.BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
    # mb just effect
    hudSubtext(eventPlayer if eventPlayer.is_invincible else null, "연습모드", HudPosition.TOP, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0} {1}".format(eventPlayer, eventPlayer.arrived_check_point), HudPosition.RIGHT, (sorted(getAllPlayers(), lambda player: -1 * player.arrived_check_point)).index(eventPlayer), Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    createIcon(eventPlayer if CheckPoint[eventPlayer.check_point+1] and not eventPlayer.isInViewAngle(CheckPoint[eventPlayer.check_point+1], 60) else null, CheckPoint[eventPlayer.check_point+1], Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN, true)


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
    Pioneer.is_invincible = false
    CheckPoint = [Pioneer.getPosition()]
    PioneerArr = ["{0}".format(Pioneer)]
    AbilityArr = [0]
    UltimateArr = [0]


def toCheckPoint():
    @Name "ToCheckpoint"

    waitUntil(not eventPlayer.isUsingAbility1(), 3)
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
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
        eventPlayer.resurrect()
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    if CheckPoint[eventPlayer.check_point+1] and eventPlayer.is_pioneering == false and eventPlayer.is_invincible == false:
        if AbilityArr[eventPlayer.check_point+1]==0:
            eventPlayer.setAbility1Enabled(false)
        if UltimateArr[eventPlayer.check_point+1]==0:
            eventPlayer.setUltEnabled(false)

        
def invincibleMode():
    @Name "InvincibleMode"

    if eventPlayer.is_invincible:
        eventPlayer.is_float = true
        eventPlayer.is_invincible = false
        toCheckPoint()
        eventPlayer.is_float = false
    else:
        eventPlayer.is_invincible = true
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        smallMessage(eventPlayer, "연습 모드")


rule "Die":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.is_invincible == false
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > CheckPointSize

    if (CheckPoint[eventPlayer.check_point + 1] and distance(eventPlayer, CheckPoint[eventPlayer.check_point+1]) > CheckPointSize) \
        or (eventPlayer.is_pioneering and distance(eventPlayer, CheckPoint[eventPlayer.check_point]) <= PioneerMinDistans):
        eventPlayer.is_float = true
        toCheckPoint()
        eventPlayer.is_float = false


rule "Pioneer":
    @Event eachPlayer
    @Condition eventPlayer == Pioneer
    @Condition eventPlayer.is_pioneering == true
    @Condition eventPlayer.is_invincible == false
    @Condition eventPlayer.is_float == false
    @Condition eventPlayer.isOnGround()
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > PioneerMinDistans
    @Condition PioneerTime == true

    eventPlayer.is_float = true
    PioneerPosition = eventPlayer.getPosition()
    PioneerCancelTimer = PioneerCancelTime
    invincibleMode()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), PioneerCancelTime)
    eventPlayer.is_invincible = false
    PioneerCancelTimer = 0
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        toCheckPoint()
    else:
        stopChasingVariable(PioneerTime)
        CheckPoint.append(PioneerPosition)
        PioneerArr.append(eventPlayer.name)
        AbilityArr.append(eventPlayer.ability)
        UltimateArr.append(eventPlayer.ultimate)
        if getNumberOfPlayers(Team.ALL) > 1 or eventPlayer.isHoldingButton(Button.INTERACT):
            eventPlayer.is_pioneering = false
            if eventPlayer.is_invisible == false:
                eventPlayer.setInvisibility(Invis.NONE)
        else:
            eventPlayer.check_point += 1
            eventPlayer.arrived_check_point += 1
            CheckPointList[eventPlayer.player_index] += 1
        toCheckPoint()
    eventPlayer.is_float = false
    


rule "PioneerTime":
    @Condition PioneerTime == false
    @Condition Pioneer.is_pioneering == true

    Pioneer.is_pioneering = false
    if Pioneer.is_invisible == false:
        Pioneer.setInvisibility(Invis.NONE)
    Pioneer = random.choice([player for player in getAllPlayers() if player.arrived_check_point == len(CheckPoint)-1])
    Pioneer.is_pioneering = true
    PioneerTime = Time
    Pioneer.setInvisibility(Invis.ALL)



rule "Pioneered":
    @Event eachPlayer
    @Condition eventPlayer.is_last_check_point
    @Condition CheckPoint[eventPlayer.check_point + 1] == true
    @Condition eventPlayer != Pioneer

    toCheckPoint()
    eventPlayer.is_last_check_point = false
    if eventPlayer.is_invincible:
        invincibleMode()
    
    
rule "Arrive":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.is_pioneering == false
    @Condition eventPlayer.is_float == false
    @Condition eventPlayer.is_invincible == false
    @Condition CheckPoint[eventPlayer.check_point + 1] == true
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point + 1]) < CheckPointSize
    
    eventPlayer.check_point+=1
    if eventPlayer.check_point == len(CheckPoint)-1 and Finished == false:
        if (eventPlayer != Pioneer and not Pioneer.is_pioneering) or getNumberOfPlayers(Team.ALL) == 1:
            Pioneer = eventPlayer
            eventPlayer.is_pioneering = true
            PioneerTime = Time
            chase(PioneerTime, 0, rate=1, ChaseReeval.NONE)
            eventPlayer.setInvisibility(Invis.ALL)
        else:
            eventPlayer.is_last_check_point = true
            invincibleMode()
    abilityReset()
    if eventPlayer.check_point > eventPlayer.arrived_check_point:
        eventPlayer.arrived_check_point += 1
        CheckPointList[eventPlayer.player_index] += 1


rule "Finish":
    @Event eachPlayer
    @Condition eventPlayer.arrived_check_point == len(CheckPoint)-1
    @Condition Finished

    invincibleMode()
    bigMessage(eventPlayer, "Clear!!")


rule "Restart":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.is_float = true
    eventPlayer.check_point = 0
    eventPlayer.arrived_check_point = 0
    CheckPointList[eventPlayer.player_index] = 0
    toCheckPoint()
    eventPlayer.is_float = false


rule "Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition CheckPoint

    if eventPlayer.is_pioneering and PioneerCancelTimer:
        eventPlayer.startForcingPosition(PioneerPosition, false)
        wait(0.1)
        eventPlayer.stopForcingPosition()
    else:
        eventPlayer.is_float = true
        toCheckPoint()
        eventPlayer.is_float = false


rule "Abiliy 1":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()

    if eventPlayer.is_invincible:
        waitUntil(not eventPlayer.isUsingAbility1(), 3)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    else:
        if eventPlayer.is_pioneering and PioneerCancelTimer == false:
            eventPlayer.ability += 1
        elif eventPlayer.check_point < len(CheckPoint)-1:
            eventPlayer.ability += 1
            if AbilityArr[eventPlayer.check_point+1] - eventPlayer.ability < 1:
                eventPlayer.setAbility1Enabled(false)


rule "Ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.is_invincible == false

    if eventPlayer.is_pioneering and PioneerCancelTimer == false:
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
    @Condition eventPlayer.is_float == false

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
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition CheckPoint

    invincibleMode()


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

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isAlive():
        if eventPlayer.is_last_check_point and Pioneer.is_pioneering:
            return
        eventPlayer.disableRespawn()
        eventPlayer.is_float = true
        kill(eventPlayer, null)
    else:
        eventPlayer.enableRespawn()
        eventPlayer.respawn()
        toCheckPoint()
        eventPlayer.is_float = false


rule "Invisible Mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.is_pioneering == false

    eventPlayer.is_invisible = not eventPlayer.is_invisible
    if eventPlayer.is_invisible:
        eventPlayer.setInvisibility(Invis.ALL)
        smallMessage(eventPlayer, "투명화")
    else:
        eventPlayer.setInvisibility(Invis.NONE)
        smallMessage(eventPlayer, "투명화 해제")


rule "Revive":
    @Event playerDied
    @Condition eventPlayer.is_float == false

    if eventPlayer.is_invincible:
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer))
    else:
        toCheckPoint()
    eventPlayer.resurrect()


rule "Dva":
    @Condition Dva == 1
    @Condition getNumberOfPlayers(Team.1) < 12

    wait(2)
    createDummy(Hero.DVA, Team.1, -1, vect(0, 10, 0), vect(0, 0, 0))
    Dva = getLastCreatedEntity()
    Dva.dva_position_arr = [[0, Map.NEPAL, Map.NUMBANI, Map.DORADO, Map.LIJIANG_TOWER, Map.LIJIANG_TOWER_LNY, Map.BUSAN, Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.OASIS, Map.ILIOS, Map.PARIS], [vect(-50, 15, 0), vect(-195, -90, 0)], [vect(100, -1, 25)], [vect(90, 10, -1)], [vect(0, 270, 280), vect(0, 95, 150), vect(0, 0, -35)], [vect(0, 270, 280), vect(0, 95, 150), vect(0, 0, -35)], [vect(50, 15, -115), vect(-330, 15, 140), vect(215, 15, 225)], [vect(-45, 5, 95)], [vect(-45, 5, 95)], [vect(-190, 15, 0), vect(135, 10, -240), vect(145, 10, 250)], [vect(30, 60, -155), vect(-200, 1, 10), vect(320, -20, -35)] ,[vect(-45, 15, -10)]]
    Dva.dva_index = Dva.dva_position_arr[0].index(getCurrentMap())
    wait(1)
    Dva.setInvisibility(Invis.ALL)
    if Dva.dva_index+1:
        for Dva.dva_position in range(len(Dva.dva_position_arr[Dva.dva_index])):
            Dva.startForcingPosition(Dva.dva_position_arr[Dva.dva_index][Dva.dva_position], true)
            Dva.setUltEnabled(true)
            Dva.setUltCharge(100)
            Dva.disableEnvironmentCollision(true)
            Dva.startScalingSize(100, true)
            Dva.forceButtonPress(Button.ULTIMATE)
            wait(4)
            Dva.respawn()
            wait(1)
    else:
        Dva.startForcingPosition(vect(0, 0, 0), true)
        Dva.setUltEnabled(true)
        Dva.setUltCharge(100)
        Dva.disableEnvironmentCollision(true)
        Dva.startScalingSize(100, true)
        Dva.forceButtonPress(Button.ULTIMATE)
        wait(3)
    Dva.dva_position_arr = []
    Dva = 0
    destroyAllDummies()


rule "Save Inspector":
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isStanding()

    hostPlayer.save_temp = []
    hostPlayer.save_temp.append(GameMode)
    hostPlayer.save_temp.append(PlayerList)
    hostPlayer.save_temp.append(CheckPointList)
    GameMode = "제작: {0}".format(hostPlayer)
    PlayerList = []
    CheckPointList = []
    enableInspector()
    disableInspector()
    GameMode = hostPlayer.save_temp[0]
    PlayerList = hostPlayer.save_temp[1]
    CheckPointList = hostPlayer.save_temp[2]
    hostPlayer.save_temp = []