settings {
    "main": {
        "modeName": "폭탄 돌리기",
        "description": "제작자: 훈제김치"
    },
    "lobby": {
        "enableMatchVoiceChat": true
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
            "respawnTime%": 10,
            "spawnHealthPacks": "disabled",
            "enableKillFeed": false,
            "heroLimit": "off",
            "enableEnemyHealthBars": false,
            "enableKillCam": false
        }
    },
    "heroes": {
        "allTeams": {
            "genji": {
                "enableUlt": false,
                "enablePrimaryFire": false,
                "damageReceived%": 10,
                "enableSecondaryFire": false,
                "damageDealt%": 10,
                "ability1Cooldown%": 40,
                "enableInfiniteAmmo": true,
                "ability2Cooldown%": 60
            },
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

#Global variables

globalvar Start 0
globalvar Bomb 1
globalvar MatchTime 2
globalvar num 3
globalvar WinnerScore 4
globalvar itemPos 5
globalvar eff 6
globalvar itemeffList 7
globalvar isItem 8


#Player variables

playervar item 0


#Activated extensions

#!extension buffStatusEffects
#!extension kineticExplosionEffects
#!extension explosionSounds


rule "init":
    #disableAnnouncer()
    disableGamemodeCompletion()
    disableScoring()
    Start = false
    MatchTime = 0
    Bomb = 0
    itemPos = vect(0, -1, 0)
    WinnerScore = createWorkshopSetting(int[1:15], "게임 설정", "우승 점수", 5, 0)
    itemeffList = ["쉴드", "쿨타임 증가", "스킬 밴", "수면", "에임 스피드 증가"]
    isItem = createWorkshopSetting(bool, "게임 설정", "아이템", true, 1)
    chase(MatchTime, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    createEffect(getAllPlayers() if Start else null, Effect.GOOD_AURA, Color.RED, Bomb, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.ORB, Color.YELLOW, itemPos, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.WRECKING_BALL_ADAPTIVE_SHIELD_TARGET, Color.WHITE, localPlayer if localPlayer.item == itemeffList[0] else vect(0, -1, 0), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hudHeader(Bomb, "폭탄이다!!", HudPosition.TOP, -1, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "근접공격을 통해 폭탄을 옮길 수 있습니다.\r\n{0} 를 통해 방어할 수 있습니다.\r\n\r\n{1}\r\n\r\n{2}".format(buttonString(Button.ABILITY_2), "{0} -> 근접공격".format(buttonString(Button.PRIMARY_FIRE)), "{0} -> 튕겨내기".format(buttonString(Button.SECONDARY_FIRE))), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "목표점수: {0}점".format(WinnerScore), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    progressBarHud(getAllPlayers(), MatchTime * (10 if getNumberOfLivingPlayers(Team.ALL) == 2 else 3.3), "{0}초 남았습니다.".format(MatchTime), HudPosition.TOP, -2, Color.GREEN if MatchTime > 20 else Color.YELLOW if MatchTime > 10 else Color.ORANGE if MatchTime > 3 else Color.RED, Color.WHITE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)


rule "player Join":
    @Event playerJoined
    
    eventPlayer.disableRespawn()
    eventPlayer.disableGamemodeHud()
    eventPlayer.enableDeathSpectateAllPlayers()
    hudSubtext(getAllPlayers(), "{0} {1}점".format(eventPlayer, eventPlayer.getScore()), HudPosition.RIGHT, (sorted(getAllPlayers(), lambda player: -1 * player.getScore())).index(eventPlayer), Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)


rule "Start":
    @Condition Start == false
    @Condition getNumberOfPlayers(Team.ALL) > 1
    @Condition isGameInProgress() == true
    
    for num in range(5, 0, -1):
        smallMessage(getAllPlayers(), "{0}".format(num))
        wait(1)
    Start = true
    MatchTime = 30
    if getNumberOfLivingPlayers(Team.ALL) != 2:
        goto lbl_0
    MatchTime = 10
    bigMessage(getAllPlayers(), "결승전!")
    lbl_0:
    getLivingPlayers(Team.ALL).setAbilityCooldown(Button.ABILITY_1, 0)
    getLivingPlayers(Team.ALL).setAbilityCooldown(Button.ABILITY_2, 0)


rule "giveBomb":
    @Condition Start == true
    
    Bomb = random.choice(getLivingPlayers(Team.ALL))


rule "adddummybot":
    @Condition hostPlayer.hasSpawned() == true
    
    wait(0.25)
    #createDummy(Hero.GENJI, Team.ALL, -1, vect(0, 1, 0), vect(0, 0, 0))
    createDummy(Hero.GENJI, Team.ALL, -1, vect(0, 1, 0), vect(0, 0, 0))


rule "dummybot melee":
    @Event eachPlayer
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.forceButtonPress(Button.MELEE)


rule "lmb -> e":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "rmb -> melee":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.forceButtonPress(Button.MELEE)


rule "killBomb":
    @Condition MatchTime == false
    
    itemPos = vect(0, -1, 0)
    kill(Bomb, null)
    playEffect(getAllPlayers(), DynamicEffect.ASHE_DYNAMITE_EXPLOSION, Color.WHITE, Bomb, 1)
    playEffect(getAllPlayers(), DynamicEffect.ASHE_DYNAMITE_EXPLOSION_SOUND, Color.WHITE, Bomb.getPosition(), 100)
    wait(0.25)
    Start = false
    Bomb = 0


rule "player took damage":
    @Event playerTookDamage
    
    heal(victim, null, eventDamage)
    if attacker == Bomb and Bomb.isMeleeing():
        if victim.item == itemeffList[0]:
            victim.item = null
        else:
            Bomb = victim
    victim.applyImpulse(attacker.getFacingDirection(), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.applyImpulse(Vector.UP, 4, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


rule "haveBomb":
    @Event eachPlayer
    @Condition Bomb == eventPlayer
    
    eventPlayer.setMoveSpeed(200)
    eventPlayer.setHealth(1)
    waitUntil(Bomb != eventPlayer, 99999)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setHealth(200)


rule "winner":
    @Condition getNumberOfLivingPlayers(Team.ALL) == 1
    @Condition Start == true
    
    wait(0.16)
    itemPos = vect(0, -1, 0)
    bigMessage(getAllPlayers(), "{0}승리!!".format(getLivingPlayers(Team.ALL)))
    getLivingPlayers(Team.ALL).addToScore(1)
    if getLivingPlayers(Team.ALL).getScore() < WinnerScore:
        goto lbl_0
    declarePlayerVictory(getLivingPlayers(Team.ALL))
    lbl_0:
    wait(0.25)
    getAllPlayers().resurrect()
    wait(2)
    Start = false
    Bomb = false


rule "restartMatch":
    @Condition isGameInProgress() == false
    
    wait(3)
    restartMatch()


rule "player get item":
    @Event eachPlayer
    @Condition distance(itemPos, eventPlayer.getEyePosition()) < 1
    @Condition Start == true
    
    itemPos = vect(0, -1, 0)
    smallMessage(getAllPlayers(), "{0}님이 아이템[{1}]을(를) 먹었습니다.".format(eventPlayer, eff))
    #eventPlayer.setStatusEffect(null, Status.ASLEEP, 1)
    #eventPlayer.setAimSpeed(1000)
    #waitUntil(eventPlayer.isOnGround(), 99999)
    #eventPlayer.communicate(Comms.EMOTE_UP)
    eventPlayer.item = eff


rule "item create":
    @Condition Start == true
    @Condition isItem == true
    
    wait(random.uniform(3, 8) if getNumberOfLivingPlayers(Team.ALL) == 2 else random.uniform(5, 20))
    itemPos = vect(random.uniform(-19, 19), random.uniform(1, 15), random.uniform(-19, 19))
    eff = random.choice(itemeffList)


/*
rule "Rule 15":
    hudHeader(getAllPlayers(), eff, HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
*/

rule "Rule 16":
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    
    playEffect(getAllPlayers(), DynamicEffect.SIGMA_ACCRETION_IMPACT, Color.WHITE, vect(0, 1, 0), 1)


