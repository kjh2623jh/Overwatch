# Genji Parkour WorkShop by: 훈제김치

#!include "Settings.opy"
#!include "Definitions.opy"


#!include "Init.opy"


rule "Create First Checkpoint":
    @Condition CheckPoint == false
    @Condition Pioneer.isHoldingButton(Button.RELOAD)
    @Condition Pioneer.isOnGround() == true

    if Pioneer.isInSpawnRoom():
        smallMessage(Pioneer, Text[localPlayer.language][22])
        return
    destroyHudText(PioneerHud[0])
    destroyHudText(PioneerHud[1])
    destroyHudText(PioneerHud[2])
    destroyHudText(PioneerHud[3])
    PioneerHud = null
    CheckPoint = [Pioneer.getPosition()]
    PioneerArr = ["{0}".format(Pioneer)]
    AbilityArr = [0]
    UltimateArr = [0]


rule "Die":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.is_invincible == false
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point]) > CheckPointSize + 0.3

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
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
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
    @Condition distance(eventPlayer, CheckPoint[eventPlayer.check_point + 1]) < CheckPointSize + 0.3
    
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
    elif eventPlayer.name not in TopPlayerList:
        TopPlayerList.append(eventPlayer.name)
        TopTimeList.append(eventPlayer.time)
    Top3List = sorted(TopTimeList)
    bigMessage(getAllPlayers(), "{0} {1} {2}".format(eventPlayer.name, Text[localPlayer.language][17], "{0}:{1}".format(floor(eventPlayer.time/60), floor(eventPlayer.time%60))))


rule "Restart":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition Finished

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
    waitUntil(not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)), 1)
    if eventPlayer.is_invincible:
        invincibleMode()


rule "Invincible Mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.is_float == false
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
    wait(0)
    if RULE_CONDITION: goto RULE_START
    wait(3.5)
    eventPlayer.allowButton(Button.ULTIMATE)
        

rule "Spectate":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isAlive():
        if eventPlayer.is_last_check_point and Pioneer.is_pioneering:
            smallMessage(eventPlayer, Text[eventPlayer.language][20])
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
        if eventPlayer.is_invincible:
            invincibleMode()
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
    Dva.dva_position_arr = [[0, Map.NEPAL, Map.DORADO, Map.LIJIANG_TOWER, Map.LIJIANG_TOWER_LNY, Map.BUSAN, Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.OASIS, Map.ILIOS, Map.PARIS, Map.PARAISO, Map.NEW_QUEEN_STREET], [vect(-50, 15, 0), vect(-195, -90, 0)], [vect(90, 10, -1)], [vect(0, 270, 280), vect(0, 95, 150), vect(0, 0, -35)], [vect(0, 270, 280), vect(0, 95, 150), vect(0, 0, -35)], [vect(50, 15, -115), vect(-330, 15, 140), vect(215, 15, 225)], [vect(-45, 5, 95)], [vect(-45, 5, 95)], [vect(-190, 15, 0), vect(135, 10, -240), vect(145, 10, 250)], [vect(30, 60, -155), vect(-200, 1, 10), vect(320, -20, -35)] ,[vect(-45, 15, -10)], [vect(0, 11, -60)], [vect(-0.5, 0, 15.5)]]
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
    smallMessage(hostPlayer, Text[hostPlayer.language][21])


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
    smallMessage(eventPlayer, Text[localPlayer.language][23])


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