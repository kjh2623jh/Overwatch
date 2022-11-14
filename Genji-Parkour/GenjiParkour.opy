# Genji Parkour WorkShop by: 훈제김치


settings {
    "main": {
        "modeName": "<FG30FF0Bf>겐지 파쿠르",
        # <FG30FF0Bf> : 초록색
        # <FGFF0000f> : 빨간색
        # <FGFFFFFFf> : 기본 글자 색
        "description": "Created by: <FG30FF0Bf>훈제김치<FGFFFFFFf>\nCode: <FG30FF0Bf>95969\nhttps://discord.gg/dyGvBbBgxV<FGFFFFFFf>\nv 0.2.0"
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



globalvar GameMode
globalvar Text
globalvar CheckPoint
globalvar PioneerArr
globalvar AbilityArr
globalvar UltimateArr
globalvar CheckPointSize 
globalvar PioneerHud 
globalvar Pioneer 
globalvar PioneerMinDistans
globalvar PlayerList
globalvar TimeList
globalvar CheckPointList
globalvar Dva
globalvar PioneerCancelTime
globalvar PioneerCancelTimer
globalvar PioneerPosition
globalvar PioneerTime
globalvar Time
globalvar Finished
globalvar Top3List
globalvar TopPlayerList
globalvar TopTimeList

playervar language
playervar check_point 
playervar arrived_check_point
playervar is_pioneering
playervar is_float
playervar is_invincible
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
playervar time
playervar climb
playervar bhop
playervar climb_num
playervar check

subroutine save 
subroutine toCheckPoint 
subroutine abilityReset
subroutine invincibleMode

#!extension buffStatusEffects


def save():
    @Name "여기에 붙여넣으세요"

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
    pauseMatchTime()
    # len(Text) == 20
    Text = [["pioneer mode", "edit mode", "change mode", ", press ", " to set starting point", "Pioneer plz", "Pioneer", "Pioneer Time", "Cancel", "Confirm", "Youtube '(genjiparkour) nemi'\ndiscord is on youtube\n", "server reset ", "m left", "next checkpoint\npioneer: ", "bhop", "climb", "invincible", "Clear!!", "invisible", "invisible off"], 
            ["개척 모드", "제작 모드", "모드 변경", "님, 시작할 위치에서 ", "를 누르세요.", "개척해주세요", "개척자", "개척 시간", "취소", "결정", "유튜브 '(겐지파쿠르) nemi'\n디스코드도 있어요\n", "서버 재시작까지 ", "분", "다음 개척지\n개척자: ", "콩콩이", "벽타기", "연습모드", "클리어!!", "투명화", "투명화 해제"]]
    PioneerHud = []
    CheckPointSize = createWorkshopSetting(float[0.1:3], "Setting", "개척지 크기 (CheckPoint Size)", 1.5, 0)
    waitUntil(hostPlayer.hasSpawned(), 5)
    Pioneer = hostPlayer
    if not hostPlayer.hasSpawned():
        Pioneer = random.choice(getPlayers(Team.ALL))
    PioneerMinDistans = createWorkshopSetting(int[1:20], "Setting", "개척 최소 거리 (Pioneer Minimum Distance)", 7, 1)
    PioneerCancelTime = createWorkshopSetting(int[0:15], "Setting", "개척 취소 시간 (Pioneer Time to Cancel)", 5, 1)
    Time = createWorkshopSetting(int[60:300], "Setting", "개척 제한시간 (Pioneer Time Limit)", 120, 1)
    PlayerList = []
    TimeList = []
    CheckPointList = []
    save()
    Dva = 1
    if CheckPoint:
        Top3List = []
        TopPlayerList = []
        TopTimeList = []
        hudSubtext(localPlayer, GameMode, HudPosition.LEFT, 0, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
        hudSubheader(localPlayer, "\n\nTop 3", HudPosition.RIGHT, -1.1, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
        hudSubtext(localPlayer, "{0}".format(
                                    "1. {0}  {1}{2}".format(TopPlayerList[TopTimeList.index(Top3List[0])], "{0} : {1}".format(floor(Top3List[0]/60), floor(Top3List[0]%60)), 
                                    "\n2. {0}  {1}{2}".format(TopPlayerList[TopTimeList.index(Top3List[1])], "{0} : {1}".format(floor(Top3List[1]/60), floor(Top3List[1]%60)), 
                                    "\n3. {0}  {1}".format(TopPlayerList[TopTimeList.index(Top3List[1])], "{0} : {1}".format(floor(Top3List[1]/60), floor(Top3List[1]%60))) if Top3List[2] else '') if Top3List[1] else '') if Top3List[0] else ''), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
        Finished = true
    else:
        hudHeader(localPlayer, [Text[localPlayer.language][0], Text[localPlayer.language][1]][GameMode], HudPosition.LEFT, 0, [Color.BLUE, Color.GREEN][GameMode], HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.ALWAYS)
        PioneerHud.append(getLastCreatedText())
        hudHeader(Pioneer, "{0}: {1}".format(buttonString(Button.INTERACT), Text[Pioneer.language][2]), HudPosition.LEFT, -0.5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        PioneerHud.append(getLastCreatedText())
        hudHeader(localPlayer, "{0}{1}{2}".format(Pioneer, Text[localPlayer.language][3], "{0}{1}".format(buttonString(Button.RELOAD), Text[localPlayer.language][4])), HudPosition.RIGHT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
        PioneerHud.append(getLastCreatedText())
        hudSubtext(Pioneer if Pioneer.is_pioneering else null, Text[Pioneer.language][5], HudPosition.TOP, 0, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudHeader(localPlayer if Pioneer.is_pioneering else null, "{0}: {1}".format(Text[localPlayer.language][6], Pioneer), HudPosition.RIGHT, -0.9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
        progressBarHud(localPlayer if Pioneer.is_pioneering and getNumberOfPlayers(Team.ALL) > 1 else null, PioneerTime / Time * 100, Text[localPlayer.language][7], HudPosition.RIGHT, -0.8, Color.GREEN, Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.ALWAYS)
        createEffect(Pioneer if PioneerCancelTimer else null, Effect.RING, Color.RED, PioneerPosition, CheckPointSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        hudSubtext(Pioneer if PioneerCancelTimer else null, "{0}: {1} - {2}".format(Text[Pioneer.language][8], buttonString(Button.PRIMARY_FIRE), 
                                                            "{0}: {1} {2}".format(Text[Pioneer.language][9], buttonString(Button.SECONDARY_FIRE), ceil(PioneerCancelTimer))), HudPosition.TOP, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    # hudSubheader(localPlayer, "v 1.0.0", HudPosition.LEFT, -2, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubheader(localPlayer, "v 0.2.0", HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, Text[localPlayer.language][10], HudPosition.LEFT, -1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, ["\n\nreset: {0}\nspectate: hold {1}\n{2}".format(buttonString(Button.RELOAD), buttonString(Button.INTERACT),
                            "move checkpoint: {0} + {1} / {2}".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE),
                            "{0}\n{1}".format(buttonString(Button.SECONDARY_FIRE),
                            "invincible: {0} + {1}\n{2}".format(buttonString(Button.MELEE), buttonString(Button.RELOAD),
                            "invisible: {0} + {1}\n{2}".format(buttonString(Button.CROUCH), buttonString(Button.MELEE),
                            "restart: {0} + {1} + {2}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_1),
                            "{0}\ninspector save: {1} + {2}".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE), buttonString(Button.ABILITY_2)) if localPlayer == hostPlayer else buttonString(Button.ABILITY_2))))))),
                            "\n\n제자리: {0}\n관전: {1}꾹\n{2}".format(buttonString(Button.RELOAD), buttonString(Button.INTERACT),
                            "단계 이동: {0} + {1} / {2}".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE),
                            "{0}\n{1}".format(buttonString(Button.SECONDARY_FIRE),
                            "연습모드: {0} + {1}\n{2}".format(buttonString(Button.MELEE), buttonString(Button.RELOAD),
                            "투명화: {0} + {1}\n{2}".format(buttonString(Button.CROUCH), buttonString(Button.MELEE),
                            "초기화: {0} + {1} + {2}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_1),
                            "{0}\n개척 저장: {1} + {2}".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE), buttonString(Button.ABILITY_2)) if localPlayer == hostPlayer else buttonString(Button.ABILITY_2)))))))][localPlayer.language], HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(localPlayer, "{0}{1}{2}".format(Text[localPlayer.language][11], 270 - floor(getTotalTimeElapsed()/60), Text[localPlayer.language][12]), HudPosition.RIGHT, -2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(localPlayer, '\n\nplayr list', HudPosition.RIGHT, -0.1, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
    chase(PioneerCancelTimer, 0, rate=1, ChaseReeval.NONE)


rule "Switch Modes":
    @Condition CheckPoint == false
    @Condition Pioneer.isHoldingButton(Button.INTERACT)

    GameMode = not GameMode


rule "edit mode not allowed":
    @Condition GameMode

    GameMode = not GameMode


rule "Player Joined":
    @Event playerJoined
    @Condition eventPlayer.hasSpawned()

    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disablePlayerCollision()
    eventPlayer.disableGamemodeHud()
    if "{0}".format(Hero.GENJI) == "겐지":
        eventPlayer.language = 1
    eventPlayer.name = "{0}".format(eventPlayer)
    if eventPlayer.name in PlayerList:
        eventPlayer.player_index = PlayerList.index(eventPlayer.name)
        eventPlayer.check_point = CheckPointList[eventPlayer.player_index]
        eventPlayer.time = TimeList[eventPlayer.player_index]
        eventPlayer.arrived_check_point = eventPlayer.check_point
        toCheckPoint()
    else:
        PlayerList.append(eventPlayer.name)
        TimeList.append(eventPlayer.time)
        CheckPointList.append(eventPlayer.check_point)
        eventPlayer.player_index = PlayerList.index(eventPlayer.name)
    if CheckPoint == false:
        if eventPlayer == Pioneer: ################################################################################################################################################################
            eventPlayer.is_last_check_point = true
        invincibleMode()
    createEffect(eventPlayer, Effect.RING, Color.WHITE, CheckPoint[eventPlayer.check_point], CheckPointSize, EffectReeval.POSITION_AND_RADIUS)
    createEffect([player for player in eventPlayer if CheckPoint[eventPlayer.check_point+1]], Effect.RING, Color.GREEN, CheckPoint[eventPlayer.check_point+1], CheckPointSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers() if eventPlayer.is_invincible else null, Effect.ANA_NANO_BOOSTED, Color.GREEN, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(eventPlayer if CheckPoint[eventPlayer.check_point + 1] else null, "{0}{1}".format(Text[localPlayer.language][13], PioneerArr[eventPlayer.check_point+1]), CheckPoint[eventPlayer.check_point+1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "【{0} {1} | {2}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1), abs(AbilityArr[eventPlayer.check_point+1]-eventPlayer.ability), "{0} {1}】   【{2}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), abs(UltimateArr[eventPlayer.check_point+1]-eventPlayer.ultimate), "{0} / {1}】{2}".format(eventPlayer.check_point, len(CheckPoint)-1, "   【{0} : {1}】".format(floor(eventPlayer.time/60), floor(eventPlayer.time%60)) if Finished else ''))), HudPosition.TOP, -2, Color.GREEN, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "{0} - {1}".format(Text[localPlayer.language][14] if eventPlayer.bhop else "        ", "        " if eventPlayer.climb else "{0}{1}".format(Text[localPlayer.language][15], "({0})".format(eventPlayer.climb_num) if eventPlayer.climb_num else "")), HudPosition.TOP, -1, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer if eventPlayer.is_invincible else null, Text[localPlayer.language][16], HudPosition.TOP, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0} {1}".format(eventPlayer, eventPlayer.arrived_check_point), HudPosition.RIGHT, (sorted(getAllPlayers(), lambda player: -1 * player.arrived_check_point)).index(eventPlayer), Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    createIcon(eventPlayer if CheckPoint[eventPlayer.check_point+1] and not eventPlayer.isInViewAngle(CheckPoint[eventPlayer.check_point+1], 60) else null, CheckPoint[eventPlayer.check_point+1], Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN, true)
    if Finished:
        chase(eventPlayer.time, 9999999, rate=1, ChaseReeval.NONE)


rule "Create First Checkpoint":
    @Condition CheckPoint == false
    @Condition Pioneer.isHoldingButton(Button.RELOAD)
    @Condition Pioneer.isOnGround() == true
    @Condition Pioneer.isInSpawnRoom() == false

    destroyHudText(PioneerHud[0])
    destroyHudText(PioneerHud[1])
    destroyHudText(PioneerHud[2])
    destroyHudText(PioneerHud[3])
    PioneerHud = null
    CheckPoint = [Pioneer.getPosition()]
    PioneerArr = ["{0}".format(Pioneer)]
    AbilityArr = [0]
    UltimateArr = [0]


def toCheckPoint():
    @Name "To Checkpoint"

    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.startForcingPosition(CheckPoint[eventPlayer.check_point], false)
    abilityReset()
    if eventPlayer.arrived_check_point == 0:
        eventPlayer.time = 0
    wait(0.1)
    eventPlayer.stopForcingPosition()


def abilityReset():
    @Name "Ability Reset"

    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    if CheckPoint[eventPlayer.check_point+1] and eventPlayer.is_pioneering == false and eventPlayer.is_invincible == false:
        if AbilityArr[eventPlayer.check_point+1]==0:
            eventPlayer.setAbility1Enabled(false)
        if UltimateArr[eventPlayer.check_point+1]==0:
            eventPlayer.setUltEnabled(false)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    if eventPlayer.isUsingUltimate() and eventPlayer.check_point<len(CheckPoint):
        kill(eventPlayer, null)
        eventPlayer.resurrect()
    eventPlayer.ability = 0
    eventPlayer.ultimate = 0

        
def invincibleMode():
    @Name "InvincibleMode"

    if eventPlayer.is_invincible:
        eventPlayer.is_float = true
        eventPlayer.is_invincible = false
        toCheckPoint()
        eventPlayer.is_float = false
        if Finished and eventPlayer.check_point < len(CheckPoint)-1:
            chase(eventPlayer.time, 99999999, rate=1, ChaseReeval.NONE)
    else:
        eventPlayer.is_invincible = true
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        stopChasingVariable(eventPlayer.time)
        smallMessage(eventPlayer, Text[localPlayer.language][16])


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


rule "Pioneer Start":
    @Event eachPlayer
    @Condition eventPlayer == Pioneer
    @Condition CheckPoint

    toCheckPoint()
    if eventPlayer.is_invincible:
        invincibleMode()
    eventPlayer.is_pioneering = true
    if getNumberOfPlayers(Team.ALL) > 1:
        PioneerTime = Time
        chase(PioneerTime, 0, rate=1, ChaseReeval.NONE)
    eventPlayer.setInvisibility(Invis.ALL)


rule "Pioneer":
    @Event eachPlayer
    @Condition eventPlayer == Pioneer
    @Condition eventPlayer.is_pioneering == true
    @Condition eventPlayer.is_invincible == false
    @Condition eventPlayer.is_float == false
    @Condition eventPlayer.isOnGround()
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > PioneerMinDistans

    eventPlayer.is_float = true
    PioneerPosition = eventPlayer.getPosition()
    PioneerCancelTimer = PioneerCancelTime
    invincibleMode()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), PioneerCancelTime)
    eventPlayer.is_invincible = false
    PioneerCancelTimer = 0
    if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        stopChasingVariable(PioneerTime)
        CheckPoint.append(PioneerPosition)
        PioneerArr.append(eventPlayer.name)
        AbilityArr.append(eventPlayer.ability)
        UltimateArr.append(eventPlayer.ultimate)
        if getNumberOfPlayers(Team.ALL) > 1 or eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.is_pioneering = false
            if eventPlayer.is_invisible == false:
                eventPlayer.setInvisibility(Invis.NONE)
        else:
            eventPlayer.check_point += 1
            eventPlayer.arrived_check_point += 1
            CheckPointList[eventPlayer.player_index] += 1
    toCheckPoint()
    eventPlayer.is_float = false
    

rule "Pioneer Time":
    @Condition PioneerTime == false
    @Condition Pioneer.is_pioneering == true
    @Condition getNumberOfPlayers(Team.ALL) > 1

    Pioneer.is_pioneering = false
    if Pioneer.is_invisible == false:
        Pioneer.setInvisibility(Invis.NONE)
    Pioneer = random.choice([player for player in getAllPlayers() if player.arrived_check_point == len(CheckPoint)-1])


rule "Pioneered":
    @Event eachPlayer
    @Condition eventPlayer.is_last_check_point
    @Condition CheckPoint[eventPlayer.arrived_check_point + 1] == true
    @Condition eventPlayer != Pioneer

    eventPlayer.is_last_check_point = false
    if eventPlayer.check_point == eventPlayer.arrived_check_point:
        toCheckPoint()
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
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, CheckPoint[eventPlayer.check_point] + vect(0, 1.5, 0), 4)
    if eventPlayer.check_point == len(CheckPoint)-1 and Finished == false:
        if (eventPlayer != Pioneer and not Pioneer.is_pioneering) or getNumberOfPlayers(Team.ALL) == 1:
            Pioneer = 0
            wait(0)
            Pioneer = eventPlayer
        else:
            eventPlayer.is_last_check_point = true
            invincibleMode()
    abilityReset()
    if eventPlayer.check_point > eventPlayer.arrived_check_point:
        eventPlayer.arrived_check_point += 1
        CheckPointList[eventPlayer.player_index] += 1


rule "Player Left":
    @Event playerLeft
    @Condition CheckPoint

    wait(0.1)
    if getNumberOfPlayers(Team.ALL) < 2:
        PioneerTime = 0
    if eventPlayer == Pioneer:
        Pioneer = random.choice([player for player in getAllPlayers() if player.arrived_check_point == len(CheckPoint)-1])


rule "Finish":
    @Event eachPlayer
    @Condition eventPlayer.arrived_check_point == len(CheckPoint)-1
    @Condition Finished

    invincibleMode()
    stopChasingVariable(eventPlayer.time)
    if eventPlayer.time < TopTimeList[TopPlayerList.index(eventPlayer.name)]:
        TopTimeList[TopPlayerList.index(eventPlayer.name)] = eventPlayer.time
    else:
        TopPlayerList.append(eventPlayer.name)
        TopTimeList.append(eventPlayer.time)
    Top3List = sorted(TopTimeList)
    bigMessage(getAllPlayers(), "{0} {1} {2}".format(eventPlayer.name, Text[localPlayer.language][17], "{0}:{1}".format(floor(eventPlayer.time/60), floor(eventPlayer.time%60))))


rule "Restart":
    @Event eachPlayer
    @Condition Finished
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.is_float = true
    eventPlayer.check_point = 0
    eventPlayer.arrived_check_point = 0
    CheckPointList[eventPlayer.player_index] = 0
    toCheckPoint()
    eventPlayer.is_float = false
    eventPlayer.time = 0
    if eventPlayer.is_invincible:
        invincibleMode()
    if Finished:
        chase(eventPlayer.time, 9999999, rate=1, ChaseReeval.NONE)


rule "Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
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


rule "Move CheckPoint":
    @Event eachPlayer
    @Condition CheckPoint
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isOnGround() or eventPlayer.is_invincible
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
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
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

    eventPlayer.disallowButton(Button.ULTIMATE)
    wait(0.5)
    eventPlayer.setUltCharge(100)
    wait(3.5)
    eventPlayer.allowButton(Button.ULTIMATE)
        

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
        stopChasingVariable(eventPlayer.time)
    else:
        eventPlayer.enableRespawn()
        eventPlayer.respawn()
        toCheckPoint()
        eventPlayer.is_float = false
        if Finished and eventPlayer.check_point < len(CheckPoint)-1:
            chase(eventPlayer.time, 99999999, rate=1, ChaseReeval.NONE)


rule "Invisible Mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.is_pioneering == false

    eventPlayer.is_invisible = not eventPlayer.is_invisible
    if eventPlayer.is_invisible:
        eventPlayer.setInvisibility(Invis.ALL)
        smallMessage(eventPlayer, Text[localPlayer.language][18])
    else:
        eventPlayer.setInvisibility(Invis.NONE)
        smallMessage(eventPlayer, Text[localPlayer.language][19])


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
    Dva.dva_position_arr = [[0, Map.NEPAL, Map.NUMBANI, Map.DORADO, Map.LIJIANG_TOWER, Map.LIJIANG_TOWER_LNY, Map.BUSAN, Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.OASIS, Map.ILIOS, Map.PARIS, Map.PARAISO, Map.NEW_QUEEN_STREET], [vect(-50, 15, 0), vect(-195, -90, 0)], [vect(100, -1, 25)], [vect(90, 10, -1)], [vect(0, 270, 280), vect(0, 95, 150), vect(0, 0, -35)], [vect(0, 270, 280), vect(0, 95, 150), vect(0, 0, -35)], [vect(50, 15, -115), vect(-330, 15, 140), vect(215, 15, 225)], [vect(-45, 5, 95)], [vect(-45, 5, 95)], [vect(-190, 15, 0), vect(135, 10, -240), vect(145, 10, 250)], [vect(30, 60, -155), vect(-200, 1, 10), vect(320, -20, -35)] ,[vect(-45, 15, -10)], [vect(0, 11, -60)], [vect(-0.5, 0, 15.5)]]
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
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition hostPlayer.isStanding()

    hostPlayer.save_temp = []
    hostPlayer.save_temp.append(GameMode)
    hostPlayer.save_temp.append(PlayerList)
    hostPlayer.save_temp.append(TimeList)
    hostPlayer.save_temp.append(CheckPointList)
    GameMode = "제작: {0}".format(hostPlayer)
    PlayerList = []
    TimeList = []
    CheckPointList = []
    enableInspector()
    disableInspector()
    GameMode = hostPlayer.save_temp[0]
    PlayerList = hostPlayer.save_temp[1]
    TimeList = hostPlayer.save_temp[2]
    CheckPointList = hostPlayer.save_temp[3]
    hostPlayer.save_temp = []
    smallMessage(hostPlayer, "저장됨")


rule "Jump":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.check != 2
    
    eventPlayer.check += 1


rule "Bhop":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.check == 0
    
    eventPlayer.bhop = true


rule "Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.check == 1
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.check = 2


rule "Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.check == 0
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.check = 1


rule "Climb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.climb = true
    eventPlayer.check = 2
    smallMessage(eventPlayer, Text[localPlayer.language][15])


rule "Multi Climb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.climb == false
    
    eventPlayer.climb_num += 1


rule "Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    eventPlayer.bhop = true


rule "Create Bhop":
    @Event eachPlayer
    @Condition eventPlayer.isCrouching() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isOnGround() == false
    
    eventPlayer.bhop = true
    smallMessage(eventPlayer, "앉콩")


rule "Use Bhop":
    @Event eachPlayer
    @Condition eventPlayer.isJumping() == true
    @Condition eventPlayer.bhop == true

    eventPlayer.bhop = false
    smallMessage(eventPlayer, Text[localPlayer.language][14])


rule "Ground":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.climb = false
    eventPlayer.bhop = false
    eventPlayer.climb_num = 0
    eventPlayer.check = 0

rule "a":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.teleport(vect(0, 0, 0))\

rule "b":
    hudHeader(hostPlayer, hostPlayer.getPosition(), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)