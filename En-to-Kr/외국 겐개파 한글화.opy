#Global variables

globalvar CheckpointDefaultRadius 0
globalvar AllowContinueslyOpenUp 1
globalvar LastCheckpointPlayerNum 2
globalvar PioneerOpenUpTimeLimit 3
globalvar Debug 4
globalvar I 5
globalvar Pioneer 6
globalvar GameState 7
globalvar CheckpointsPosition 8
globalvar CheckpointsAbility1Enabled 9
globalvar CheckpointsUltimateEnabled 10
globalvar CheckpointsCreator 11
globalvar CheckpointsCreatorText 12
globalvar TempNextCheckpointPosition 13
globalvar PioneerInteractState 14
globalvar T 15
globalvar PioneerAbility1Used 16
globalvar PioneerUltimateUsed 17
globalvar TargetPlayer 18
globalvar TargetCheckpointNum 19
globalvar OwnerPrivilege 20
globalvar OwnerPrivilegeHUD 21
globalvar OwnerSaveGameTipsHUD 22
globalvar LastPioneer 23
globalvar PioneerOpenUpTimeUsed 24
globalvar ChasingOpenUpTime 25
globalvar PlayersNameRecords 26
globalvar PlayersMaxCheckpointRecords 27
globalvar EnableTimer 28
globalvar PioneerModeShortcut 29
globalvar TimerModeShortcut 30
globalvar ShowShortcutPlayers 31
globalvar OwnerPrivilegeText 32
globalvar PlayersRecord 33
globalvar BugBhop 34
globalvar EmoteBhop 35
globalvar BugClimb 36
globalvar TripleJump 37
globalvar Top5 38
globalvar Top5Color 39
globalvar CleanEnvItems 40
globalvar ToolMan 41
globalvar ObjectivePosition 42
globalvar CheckpointsAutoTeleport 43
globalvar CheckpointsPreview 44
globalvar NextCheckpointPosition 45
globalvar TempArray 46


#Player variables

playervar CurrentCheckpointNum 0
playervar FreeMode 1
playervar SpectatorMode 2
playervar PreviousPosition 3
playervar MaxCheckpointNum 4
playervar JumpingCheckpoint 5
playervar JumpingCheckpointHUD 6
playervar NextCheckpointsPreview 7
playervar Invisible 8
playervar SelfKill 9
playervar Ability1Used 10
playervar UltimateUsed 11
playervar TempVar 12
playervar Timer 13
playervar BestRecord 14
playervar TimerPaused 15
playervar TimerPausedCheckpointNum 16
playervar StartForceInvisible 17
playervar StartForceInvisibleEffect 18
playervar ForceInvisiblePlayer 19
playervar ShowPlayerInfo 20
playervar PlayerInfoHUD 21
playervar RankSort 22
playervar Climb 23
playervar Bhop 24
playervar Jump 25
playervar BugJump 26


#Subroutine names

subroutine ToNextCheckpoint 0
subroutine ToCurrentCheckpoint 1
subroutine EnableAllAbilities 2
subroutine SetCheckpointAbilities 3
subroutine ResetPioneerState 4
subroutine CancelOpenUp 5
subroutine AutoSaveProgress 6
subroutine StopAndClearTimer 7
subroutine CancelAbilityAndMomentum 8


#Activated extensions

#!extension buffStatusEffects
#!extension explosionSounds


rule "关卡存放于此规则, 动作列表如果有东西请先删干净, 建议在【自己创建的】房间操作, 否则看不到开拓者名字":


rule "全局初始化":
    #关卡 9JBFS
    CheckpointsPosition = [] if CheckpointsPosition == 0 else CheckpointsPosition
    CheckpointsAbility1Enabled = [] if CheckpointsAbility1Enabled == 0 else CheckpointsAbility1Enabled
    CheckpointsUltimateEnabled = [] if CheckpointsUltimateEnabled == 0 else CheckpointsUltimateEnabled
    CheckpointsCreator = [] if CheckpointsCreator == 0 else CheckpointsCreator
    CheckpointsCreatorText = [] if CheckpointsCreatorText == 0 else CheckpointsCreatorText
    CheckpointsAutoTeleport = [] if CheckpointsAutoTeleport == 0 else CheckpointsAutoTeleport
    CheckpointsPreview = [] if CheckpointsPreview == 0 else CheckpointsPreview
    #设置
    EnableTimer = createWorkshopSetting(enum["pioneer mode", "nomal mode"], "pioneer", "game mode", 0, 0) if not EnableTimer else EnableTimer
    AllowContinueslyOpenUp = createWorkshopSetting(bool, "pioneer", "continuous pioneer", true, 3) if AllowContinueslyOpenUp == 0 else AllowContinueslyOpenUp
    PioneerOpenUpTimeLimit = createWorkshopSetting(int[60:600], "pioneer", "pioneer time limit", 300, 6) if PioneerOpenUpTimeLimit == 0 else PioneerOpenUpTimeLimit
    CheckpointDefaultRadius = createWorkshopSetting(float[0.5:5], "pioneer", "default level halo radius", 1, 5) if CheckpointDefaultRadius == 0 else CheckpointDefaultRadius
    LastCheckpointPlayerNum = createWorkshopSetting(int[1:12], "pioneer", "number of players required for countdown", 2, 6) if LastCheckpointPlayerNum == 0 else LastCheckpointPlayerNum
    CleanEnvItems = createWorkshopSetting(bool, "pioneer", "summon D.VA", true, 7) if CleanEnvItems == 0 else CleanEnvItems
    BugBhop = createWorkshopSetting(bool, "Mechanics", "Create bhop", false, 0) if BugBhop == 0 else BugBhop
    EmoteBhop = createWorkshopSetting(bool, "Mechanics", "Emote", false, 1) if EmoteBhop == 0 else EmoteBhop
    BugClimb = createWorkshopSetting(bool, "Mechanics", "Multiclimb", false, 2) if BugClimb == 0 else BugClimb
    TripleJump = createWorkshopSetting(bool, "Mechanics", "Tripple jump", false, 3) if TripleJump == 0 else TripleJump
    Debug = createWorkshopSetting(bool, "debug(don't change)", "Debug", false, 0)
    #常量
    PioneerModeShortcut = "Preview | LMB+RMB\nSpectate | F+E\nquick reset | R\nInvincible | R+V　\njump to next/prev | F+jump/crouch\n{0}".format("quick jump | Hold V\nRestart | F+crouch+E\nInivisble | group up　\ngive up pioneering | Hold LMB+RMB")
    TimerModeShortcut = "Preview | LMB+RMB\nSpectate | F+E\nquick reset | R\nInvincible | R+V　\njump to next/prev | F+jump/crouch\n{0}".format("quick jump | Hold V\nRestart | F+crouch+E\nInivisble | group up　\npause/resume timing | need healing")
    OwnerPrivilegeText = "delete last level | hold CTRL+SHIFT+D\nJump any player | Aim at the target and hold R\nsave all levels | F+thanks,see hint"
    Top5Color = [rgb(255, 215, 0), rgb(220, 223, 227), rgb(191, 173, 111), rgb(192, 192, 192), rgb(128, 138, 135)]
    #游戏全局变量
    Pioneer = 0
    GameState = 0 if GameState == 0 else GameState
    TempNextCheckpointPosition = 0
    PioneerInteractState = 0
    PioneerAbility1Used = 0
    PioneerUltimateUsed = 0
    TargetPlayer = 0
    TargetCheckpointNum = 0
    OwnerPrivilege = 0
    OwnerPrivilegeHUD = 0
    LastPioneer = 0
    PioneerOpenUpTimeUsed = 0
    ChasingOpenUpTime = 0
    PlayersNameRecords = []
    PlayersMaxCheckpointRecords = []
    ShowShortcutPlayers = []
    PlayersRecord = []
    Top5 = []
    TempArray[11] = null
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()
    if not Debug:
        disableInspector()
    #开拓者下一关临时光圈
    createEffect(getAllPlayers() if TempNextCheckpointPosition else null, Effect.RING, Color.PURPLE, TempNextCheckpointPosition, CheckpointDefaultRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #基本信息
    hudText(getAllPlayers(), abilityIconString(Hero.HAMMOND, Button.CROUCH), "Translated by: FATHER", "code: XRRR0                                     ", HudPosition.RIGHT, -1 * 999, rgba(255, 255, 255, 150), rgba(255, 0, 0, 100), rgba(255, 255, 255, 150), HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), abilityIconString(Hero.ECHO, Button.ULTIMATE), "editor creator：昭华#51234", "modified by: 明天又是新的一天", HudPosition.RIGHT, -1 * 998, rgba(255, 255, 255, 150), rgba(247, 163, 6, 150), rgba(255, 255, 255, 150), HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    #展开快捷键提示
    hudSubtext(getAllPlayers(), "{0} double click Interact({1}) to view hotkey".format(abilityIconString(Hero.TORBJORN, Button.ABILITY_2), buttonString(Button.INTERACT)), HudPosition.RIGHT, 1, rgba(220, 220, 220, 200), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(ShowShortcutPlayers, ("{0}{1}".format(PioneerModeShortcut, "\n teleport to other maps | F+spray" if Pioneer == localPlayer and getCurrentGamemode() == Gamemode.CONTROL else "")) if not EnableTimer else TimerModeShortcut, HudPosition.RIGHT, 2, rgba(220, 220, 220, 200), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #房间关键设置显示
    hudText(getAllPlayers(), abilityIconString(Hero.GENJI, Button.PRIMARY_FIRE), "{0} room settings:  \n --{1} {2}".format(abilityIconString(Hero.BASTION, Button.SECONDARY_FIRE), abilityIconString(Hero.LUCIO, Button.ABILITY_2), "{0}\n --{1} Mechanics:{2}".format("game mode:nomal mode" if EnableTimer else "time limit:{0} sec".format(PioneerOpenUpTimeLimit), abilityIconString(Hero.HANZO, Button.JUMP), "All disabled" if not BugBhop and not EmoteBhop and not BugClimb and not TripleJump else "{0}{1}{2}".format("create " if BugBhop else "", "emote " if EmoteBhop else "", "{0}{1}".format("Multi " if BugClimb else "", "tripple " if TripleJump else "")))), "pioneer parkour {0}".format("1.5.1"), HudPosition.LEFT, -1 * 999, rgba(255, 255, 255, 50), rgba(255, 255, 255, 150), Color.ORANGE, HudReeval.VISIBILITY_AND_COLOR, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "　", HudPosition.LEFT, -1 * 998, null, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "　", HudPosition.TOP, 1, null, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "　", HudPosition.RIGHT, 0, null, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    if not EnableTimer:
        #房主权限显示
        hudSubtext(hostPlayer if hostPlayer in ShowShortcutPlayers else null, OwnerPrivilegeText, HudPosition.RIGHT, 3, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #开拓者已用技能次数显示
        hudSubtext(Pioneer, "{0} {1} - {2}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1), PioneerAbility1Used, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), PioneerUltimateUsed)), HudPosition.TOP, 2, Color.SKY_BLUE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        #当前开拓者剩余时间
        progressBarHud(getAllPlayers(), 100 * ((PioneerOpenUpTimeLimit - PioneerOpenUpTimeUsed) / PioneerOpenUpTimeLimit), (["", "Waiting for the initial pioneer", "{0} [{1}] is pioneering{2}".format(heroIcon(Hero.GENJI), Pioneer, ",time left:{0} sec".format(ceil(PioneerOpenUpTimeLimit - PioneerOpenUpTimeUsed)) if PioneerOpenUpTimeUsed > 0 else ""), "No pioneer currently"])[GameState], HudPosition.TOP, 0, rgba(60 + (PioneerOpenUpTimeUsed / PioneerOpenUpTimeLimit * (255 - 60)), 255 - (PioneerOpenUpTimeUsed / PioneerOpenUpTimeLimit * (255 - 60)), 37, 180) if GameState == 2 else Color.WHITE, rgba(255, 255, 255, 150), ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
    elif EnableTimer:
        hudSubtext(getAllPlayers(), " {0} players have completed{1}\r\n".format(len(PlayersRecord), ",fastest record holder [{0}],use time:{1}sec".format(PlayersRecord[0][0], PlayersRecord[0][1]) if len(PlayersRecord) > 0 else ""), HudPosition.LEFT, -1 * 996, rgba(138, 172, 217, 200), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        #Top5
        hudSubtext(getAllPlayers() if Top5 else null, "Today`s Top {0}".format(len(Top5)), HudPosition.LEFT, -1 * 995, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        for I in range(5):
            hudText(getAllPlayers() if Top5[evalOnce(I)] else null, heroIcon(Hero.GENJI), "{0} [{1}]".format(["1st", "2nd", "3rd", "4th", "5th"][evalOnce(I)], Top5[evalOnce(I)][0]), "{0} sec".format(Top5[evalOnce(I)][1]), HudPosition.LEFT, -1 * 994 + I, Top5Color[I], Top5Color[I], Top5Color[I], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudSubtext(getAllPlayers(), "　", HudPosition.LEFT, -1 * 989, null, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #HighLights
        hudSubtext(getAllPlayers() if any([player.BestRecord < 16200 and Top5.index("{0}".format(player)) < 0 for player in getAllPlayers()]) else null, "HighLights", HudPosition.LEFT, -1 * 988, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    #夺旗模式必须手动点击开始游戏模式
    if getCurrentGamemode() == Gamemode.CTF:
        while not hostPlayer.hasSpawned():
            wait(1)
        startGamemode()
        wait(30)
    #当前模式不是突击模式的时候，需要等待游戏第一阶段自行完成
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        wait(getMatchTime())
    #本局游戏剩余时间倒计时显示 (0,255,160) - (255,50,160)
    hudSubheader(getAllPlayers(), "time left until server resets: {0} min {1} sec {2}".format(floor((15600 - getTotalTimeElapsed()) / 60), 60 - ceil(getTotalTimeElapsed() % 60), "\n\n\n"), HudPosition.LEFT, -1 * 997, rgba(255 * (getTotalTimeElapsed() / 15600), 255 - getTotalTimeElapsed() / 15600 * 255, 255 - getTotalTimeElapsed() / 15600 * 255, 150), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    pauseMatchTime()


rule "清理地图可破坏物":
    @Condition CleanEnvItems == true
    @Condition getCurrentGamemode() in [Gamemode.CONTROL, Gamemode.TDM] == false
    
    wait(5)
    createDummy(Hero.DVA, Team.1, 11, nearestWalkablePosition(vect(0, 0, 0)), null)
    ToolMan = getPlayersInSlot(11, Team.1)
    wait(1)
    ToolMan.setGravity(0)
    wait(1)
    ToolMan.teleport(getSpawnPoints(Team.1).getPosition()[0] + directionTowards(getSpawnPoints(Team.1).getPosition()[0], getSpawnPoints(Team.2).getPosition()[0]) * (distance(getSpawnPoints(Team.1).getPosition()[0], getSpawnPoints(Team.2).getPosition()[0]) / 2) + Vector.UP * 50)
    wait(1)
    ToolMan.startScalingSize(20, false)
    wait(1)
    ToolMan.setUltCharge(100)
    wait(1)
    ToolMan.forceButtonPress(Button.ULTIMATE)
    wait(5)
    destroyDummy(Team.1, 11)
    ToolMan = null


rule "玩家初始化":
    @Event playerJoined
    
    eventPlayer.TimerPausedCheckpointNum = -1 * 1
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableGamemodeInWorldUi()
    getAllPlayers().disableNameplatesFor(getAllPlayers())
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    if EnableTimer:
        eventPlayer.MaxCheckpointNum = len(CheckpointsPosition) - 1
        eventPlayer.BestRecord = 16200
    if GameState == 1:
        eventPlayer.FreeMode = true
    wait(random.uniform(1, 2))
    #爬墙已用
    createEffect(getAllPlayers() if eventPlayer.Climb == 0 else null, Effect.ANA_NANO_BOOSTED, Color.RED, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if not EnableTimer:
        #名字显示
        createInWorldText(getAllPlayers(), "{0}{1}".format(eventPlayer, " - {0}".format(eventPlayer.CurrentCheckpointNum) if EnableTimer else ""), eventPlayer, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, rgba(255, 255, 255, 130) if eventPlayer != Pioneer else rgba(79, 193, 255, 130), SpecVisibility.DEFAULT)
        #中间关卡进度
        hudSubtext(eventPlayer if GameState != 1 else null, "{0} / {1}".format(eventPlayer.CurrentCheckpointNum, len(CheckpointsPosition) - 1 if len(CheckpointsPosition) - 1 > 0 else 0), HudPosition.TOP, 4, rgba(255, 255, 255, 200), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        #左边排行进度
        hudSubtext(getAllPlayers(), "{0}: {1}".format(eventPlayer, eventPlayer.MaxCheckpointNum), HudPosition.LEFT, 0 - eventPlayer.MaxCheckpointNum + eventPlayer.RankSort, rgba(138, 172, 217, 200), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    elif EnableTimer:
        #名字显示
        createInWorldText(getAllPlayers(), "{0}{1}".format(eventPlayer, " - {0}".format(eventPlayer.CurrentCheckpointNum) if EnableTimer else ""), eventPlayer, 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.ORANGE if eventPlayer.BestRecord < 16200 else rgba(255, 255, 255, 150), SpecVisibility.DEFAULT)
        #左边排行进度
        hudText(getAllPlayers() if Top5.index("{0}".format(eventPlayer)) < 0 and eventPlayer.BestRecord < 16200 else null, heroIcon(Hero.GENJI), "[{0}] ".format(eventPlayer), "{0} sec".format(eventPlayer.BestRecord), HudPosition.LEFT, eventPlayer.BestRecord / 100, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        #中间关卡进度
        hudSubtext(eventPlayer, "{0} / {1}".format(eventPlayer.CurrentCheckpointNum, len(CheckpointsPosition) - 1), HudPosition.TOP, 4, rgba(255, 255, 255, 200), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        #中间计时器
        hudSubtext(eventPlayer if eventPlayer.Timer > 0 else null, "{0}".format(eventPlayer.Timer), HudPosition.TOP, 5, rgba(255, 255, 255, 200), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #当前关卡的光圈
    createEffect(eventPlayer if CheckpointsPosition[eventPlayer.CurrentCheckpointNum] != 0 else null, Effect.RING, Color.BLUE, CheckpointsPosition[eventPlayer.CurrentCheckpointNum], CheckpointDefaultRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #下一关光圈
    createEffect(eventPlayer if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0 else null, Effect.RING, Color.BLUE if not CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum + 1] else Color.RED, CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1], CheckpointDefaultRadius, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    createEffect(eventPlayer if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0 else null, Effect.RING, Color.SKY_BLUE if not CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum + 1] else Color.RED, CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1], CheckpointDefaultRadius, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    #下一关光柱
    createEffect(eventPlayer if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0 else null, Effect.SPARKLES, Color.SKY_BLUE if not CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum + 1] else Color.ORANGE, CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1], CheckpointDefaultRadius, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    #下一关图标
    createIcon(eventPlayer if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0 else null, CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] + vect(0, 2, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.ORANGE, true)
    #下一关文本
    createInWorldText(eventPlayer if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0 else null, "level {0} ,created by [{1}]".format(eventPlayer.CurrentCheckpointNum + 1, CheckpointsCreatorText[eventPlayer.CurrentCheckpointNum]), CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1], 1.4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, rgba(255, 255, 255, 200), SpecVisibility.DEFAULT)
    #技能可用剩余次数显示
    hudSubtext(null if eventPlayer == Pioneer else eventPlayer, "{0} {1} - {2}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1), max(0, CheckpointsAbility1Enabled[eventPlayer.CurrentCheckpointNum] - eventPlayer.Ability1Used), "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), max(0, CheckpointsUltimateEnabled[eventPlayer.CurrentCheckpointNum] - eventPlayer.UltimateUsed))), HudPosition.TOP, 2, rgba(255, 255, 255, 200), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    #显身提示
    hudText(0 if eventPlayer.Invisible else eventPlayer, iconString(Icon.WARNING), "hint: ", "visible", HudPosition.LEFT, -1 * 995, Color.RED, Color.RED, rgba(255, 255, 255, 150), HudReeval.VISIBILITY, SpecVisibility.DEFAULT)


rule "出生后隐身":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.Invisible = true
    eventPlayer.setInvisibility(Invis.ALL)


rule "玩家数据展示":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.ShowPlayerInfo = not eventPlayer.ShowPlayerInfo
    if eventPlayer.ShowPlayerInfo:
        hudSubtext(eventPlayer if eventPlayer.ShowPlayerInfo else null, " \nlocation:{0}　\nhorizontal speed:{1}\nvertical speed:{2}".format(eventPlayer.getPosition(), eventPlayer.getHorizontalSpeed(), "{0}\noverall speed:{1}\nheight:{2}".format(eventPlayer.getVerticalSpeed(), eventPlayer.getSpeed(), "{0}\njumping:{1}\non the ground:{2}".format(eventPlayer.getAltitude(), eventPlayer.isJumping(), "{0}\nis moving:{1}\n{2}".format(eventPlayer.isOnGround(), eventPlayer.isMoving(), "dash:{0} - {1}".format(eventPlayer.isHoldingButton(Button.ABILITY_1), "{0}\nultimate:{1}".format(eventPlayer.isUsingAbility1(), "{0} - {1}".format(eventPlayer.isHoldingButton(Button.ULTIMATE), eventPlayer.isUsingUltimate()))))))), HudPosition.RIGHT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        eventPlayer.PlayerInfoHUD = getLastCreatedText()
    else:
        destroyHudText(eventPlayer.PlayerInfoHUD)


rule "当没有开拓者也没有关卡的时候":
    @Condition Pioneer == null
    @Condition len(CheckpointsPosition) == 0
    
    GameState = 1


rule "结束游戏并自动重启":
    @Condition getTotalTimeElapsed() >= 15600
    
    declareTeamVictory(Team.1)
    wait(3)
    restartMatch()


rule "按下互动+R成为开拓者":
    @Event eachPlayer
    @Condition EnableTimer == false
    @Condition GameState == 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    if eventPlayer.isInAir():
        smallMessage(eventPlayer, "Please land on the ground and try again")
        return
    Pioneer = eventPlayer
    CheckpointsPosition[0] = Pioneer.getPosition()
    getAllPlayers().CurrentCheckpointNum = 0
    GameState = 2


rule "开拓者开始开拓":
    @Event eachPlayer
    @Condition eventPlayer == Pioneer
    @Condition eventPlayer.isAlive() == true
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition == false
    @Condition eventPlayer.isOnGround() == true
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4
    
    if distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) <= (CheckpointDefaultRadius + 0.4) * 2:
        ToCurrentCheckpoint()
        CancelOpenUp()
        return
    if eventPlayer.SelfKill:
        return
    TempNextCheckpointPosition = eventPlayer.getPosition()
    playEffect(Pioneer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, Pioneer, 100)
    Pioneer.setAbility1Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)


rule "开拓出下一关时提示确认与否":
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition != false
    
    smallMessage(Pioneer, "press {0} to cancel,Hold {1} to confirm".format(buttonString(Button.INTERACT), buttonString(Button.INTERACT)))
    wait(3)
    if RULE_CONDITION:
        goto RULE_START


rule "取消开拓":
    @Event eachPlayer
    @Condition eventPlayer == Pioneer
    @Condition eventPlayer.isAlive() == true
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition != false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    @Condition PioneerInteractState == 4
    
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
        return
    ToCurrentCheckpoint()
    CancelOpenUp()


def CancelOpenUp():
    @Name "Subroutine CancelOpenUp"
    
    CancelAbilityAndMomentum()
    ResetPioneerState()
    EnableAllAbilities()


def ResetPioneerState():
    @Name "Subroutine ResetPioneerState"
    
    PioneerInteractState = null
    TempNextCheckpointPosition = null
    PioneerAbility1Used = 0
    PioneerUltimateUsed = 0


rule "确认开拓":
    @Condition GameState == 2
    @Condition Pioneer.isAlive() == true
    @Condition TempNextCheckpointPosition != false
    @Condition Pioneer.isHoldingButton(Button.INTERACT) == true
    
    PioneerInteractState = 4
    wait(1, Wait.ABORT_WHEN_FALSE)
    T = [i for i in getAllPlayers() if i.CurrentCheckpointNum + 1 == len(CheckpointsPosition)]
    T.teleport(CheckpointsPosition[Pioneer.CurrentCheckpointNum])
    T.FreeMode = false
    kill(T, null)
    CheckpointsPosition.append(TempNextCheckpointPosition)
    CheckpointsAbility1Enabled.append(PioneerAbility1Used)
    CheckpointsUltimateEnabled.append(PioneerUltimateUsed)
    CheckpointsCreatorText.append("{0}".format(Pioneer))
    CheckpointsCreator.append(Pioneer)
    CheckpointsAutoTeleport.append(true if getCurrentGamemode() == Gamemode.CONTROL and (distance(CheckpointsPosition[Pioneer.CurrentCheckpointNum], TempNextCheckpointPosition) > 250 or abs((CheckpointsPosition[Pioneer.CurrentCheckpointNum] - TempNextCheckpointPosition).y) > 30) else false)
    T.setAbility1Enabled(CheckpointsAbility1Enabled[Pioneer.CurrentCheckpointNum] > 0)
    T.setUltEnabled(CheckpointsUltimateEnabled[Pioneer.CurrentCheckpointNum] > 0)
    T.setUltCharge(100)
    T.Ability1Used = 0
    T.UltimateUsed = 0
    wait()
    bigMessage(getAllPlayers(), "new level has been created！")
    wait()
    GameState = 3
    ResetPioneerState()
    Pioneer = null
    stopChasingVariable(PioneerOpenUpTimeUsed)
    PioneerOpenUpTimeUsed = 0
    ChasingOpenUpTime = false


rule "出现新的开拓者":
    @Condition Pioneer != null
    
    wait()
    if getCurrentGamemode() == Gamemode.CONTROL:
        ObjectivePosition = sorted([[0, distance(CheckpointsPosition[Pioneer.CurrentCheckpointNum], getObjectivePosition(0))], [1, distance(CheckpointsPosition[Pioneer.CurrentCheckpointNum], getObjectivePosition(1))], [2, distance(CheckpointsPosition[Pioneer.CurrentCheckpointNum], getObjectivePosition(2))]], lambda i: i[1])[0][0]
    bigMessage(getAllPlayers(), "new pioneer [{0}]".format(Pioneer))


rule "开拓时回到了点内":
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition == false
    @Condition distance(Pioneer, CheckpointsPosition[Pioneer.CurrentCheckpointNum]) <= CheckpointDefaultRadius + 0.4
    
    PioneerAbility1Used = 0
    PioneerUltimateUsed = 0


rule "如果地图为3CP图, 开拓者发送前进可以传送至其它小图":
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition == false
    @Condition Pioneer.isCommunicatingSpray() == true
    @Condition Pioneer.isHoldingButton(Button.INTERACT) == true
    @Condition getCurrentGamemode() == Gamemode.CONTROL
    
    ObjectivePosition += -2 if ObjectivePosition == 2 else 1
    while distance(CheckpointsPosition[Pioneer.CurrentCheckpointNum], getObjectivePosition(ObjectivePosition)) < 250 and abs((CheckpointsPosition[Pioneer.CurrentCheckpointNum] - getObjectivePosition(ObjectivePosition)).y) < 30:
        ObjectivePosition += -2 if ObjectivePosition == 2 else 1
    Pioneer.teleport(nearestWalkablePosition(getObjectivePosition(ObjectivePosition)) + vect(0, 1, 0))


rule "开拓时使用了影":
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition == false
    @Condition Pioneer.isUsingAbility1() == true
    
    waitUntil(distance(Pioneer, CheckpointsPosition[Pioneer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4, 0.3)
    if distance(Pioneer, CheckpointsPosition[Pioneer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4:
        PioneerAbility1Used = PioneerAbility1Used + 1


rule "开拓时使用了斩":
    @Condition GameState == 2
    @Condition TempNextCheckpointPosition == false
    @Condition Pioneer.isUsingUltimate() == true
    
    Pioneer.setUltEnabled(false)
    waitUntil(distance(Pioneer, CheckpointsPosition[Pioneer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4, 1.5)
    if distance(Pioneer, CheckpointsPosition[Pioneer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4:
        PioneerUltimateUsed = PioneerUltimateUsed + 1
    waitUntil(not Pioneer.isUsingUltimate(), 99999)
    Pioneer.setUltEnabled(true)
    Pioneer.setUltCharge(100)


rule "开拓者退出了游戏":
    @Event playerLeft
    @Condition eventPlayer == Pioneer
    
    Pioneer = random.choice([i for i in getAllPlayers() if i.CurrentCheckpointNum + 1 == len(CheckpointsPosition)])
    ResetPioneerState()
    stopChasingVariable(PioneerOpenUpTimeUsed)
    PioneerOpenUpTimeUsed = 0
    ChasingOpenUpTime = false
    if not Pioneer:
        GameState = 3
    else:
        bigMessage(getAllPlayers(), "pioneer quit the game, randomly pick [{0}] as the new pioneer".format(Pioneer))
        Pioneer.CurrentCheckpointNum = Pioneer.MaxCheckpointNum
        kill(Pioneer, null)


rule "连续开拓":
    @Event eachPlayer
    @Condition EnableTimer == false
    @Condition eventPlayer.isAlive() == true
    @Condition AllowContinueslyOpenUp != false
    @Condition Pioneer == null
    @Condition eventPlayer.CurrentCheckpointNum == len(CheckpointsPosition) - 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    Pioneer = eventPlayer
    ToCurrentCheckpoint()
    EnableAllAbilities()
    GameState = 2


rule "开拓时限":
    #当开拓者开始开拓
    @Condition GameState == 2
    #并且到达最后一个关卡的人数超过LastCheckpointPlayerNum人时
    @Condition len([i for i in getAllPlayers() if i.CurrentCheckpointNum + 1 == len(CheckpointsPosition)]) >= LastCheckpointPlayerNum
    @Condition Pioneer != false
    @Condition ChasingOpenUpTime == false
    
    #开始倒计时
    PioneerOpenUpTimeUsed = 0
    chase(PioneerOpenUpTimeUsed, PioneerOpenUpTimeLimit, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    ChasingOpenUpTime = true


rule "开拓超时，随机更换开拓者":
    @Condition GameState == 2
    @Condition len([i for i in getAllPlayers() if i.CurrentCheckpointNum + 1 == len(CheckpointsPosition)]) > 1
    @Condition ChasingOpenUpTime != false
    @Condition PioneerOpenUpTimeUsed == PioneerOpenUpTimeLimit
    
    ChasingOpenUpTime = false
    bigMessage(getAllPlayers(), "[{0}] pioneers overtime, randomly pick the next pioneer".format(Pioneer))
    wait()
    ResetPioneerState()
    T = [i for i in getAllPlayers() if i.CurrentCheckpointNum + 1 == len(CheckpointsPosition)]
    T.remove(Pioneer)
    Pioneer = random.choice(T)
    if Pioneer:
        bigMessage(getAllPlayers(), "new pioneer [{0}]".format(Pioneer))
        Pioneer.CurrentCheckpointNum = Pioneer.MaxCheckpointNum
        kill(Pioneer, null)
        smallMessage(Pioneer, "you become new pioneer")


rule "取消开拓者的自由行动":
    @Condition Pioneer.FreeMode != false
    
    Pioneer.FreeMode = false


rule "放弃开拓者身份":
    @Condition Pioneer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition Pioneer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    for T in range(3):
        wait(1, Wait.ABORT_WHEN_FALSE)
        smallMessage(Pioneer, "hold {0} and {1} to give up pioneering after {2} sec".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), 3 - T))
    bigMessage(getAllPlayers(), "[{0}] gives up pioneering".format(Pioneer))
    bigMessage(getAllPlayers(), "Other players who reach the final level can press {0}+{1} to become pioneer".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD)))
    wait()
    GameState = 3
    ResetPioneerState()
    Pioneer = null
    stopChasingVariable(PioneerOpenUpTimeUsed)
    PioneerOpenUpTimeUsed = 0
    ChasingOpenUpTime = false


rule "切换隐身":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicating(Comms.GROUP_UP) == true
    
    eventPlayer.Invisible = not eventPlayer.Invisible
    if eventPlayer.Invisible:
        bigMessage(eventPlayer, "invisible")
        eventPlayer.setInvisibility(Invis.ALL)
    else:
        bigMessage(eventPlayer, "visible")
        eventPlayer.setInvisibility(Invis.NONE)


rule "保持无敌和免碰撞":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.hasStatusEffect(Status.INVINCIBLE) == false
    
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.disablePlayerCollision()
    wait()
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)


rule "当没有开拓者也没有关卡的时候，提示所有人如何成为开拓者":
    @Condition GameState == 1
    
    smallMessage(getAllPlayers(), "press {0}+{1} to become pioneer".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD)))
    wait(3)
    if RULE_CONDITION:
        goto RULE_START


rule "落地":
    @Event eachPlayer
    @Condition GameState != 1
    @Condition (GameState == 2 and Pioneer == eventPlayer) == false
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.FreeMode == false
    @Condition eventPlayer.SpectatorMode == false
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4
    
    if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0 and distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1]) <= CheckpointDefaultRadius + 0.4:
        ToNextCheckpoint()
    else:
        if eventPlayer.isUsingUltimate():
            kill(eventPlayer, null)
            return
        eventPlayer.teleport(CheckpointsPosition[eventPlayer.CurrentCheckpointNum])
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
        if eventPlayer.getHorizontalSpeed() > 6:
            CancelAbilityAndMomentum()
        eventPlayer.disallowButton(Button.JUMP)
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "玩家进入下一个关卡":
    @Event eachPlayer
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.FreeMode == false
    @Condition GameState != 1
    @Condition CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1]) <= CheckpointDefaultRadius + 0.4
    @Condition eventPlayer.isOnGround() == true
    
    ToNextCheckpoint()


rule "回到当前关卡设置技能":
    @Event eachPlayer
    @Condition eventPlayer.FreeMode == false
    @Condition GameState != 1
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) <= CheckpointDefaultRadius + 0.4
    
    if eventPlayer.CurrentCheckpointNum + 1 < len(CheckpointsPosition):
        SetCheckpointAbilities()
    else:
        EnableAllAbilities()


def SetCheckpointAbilities():
    @Name "Subroutine SetCheckpointAbilities"
    
    eventPlayer.setAbility1Enabled(CheckpointsAbility1Enabled[eventPlayer.CurrentCheckpointNum] > 0)
    eventPlayer.setUltEnabled(CheckpointsUltimateEnabled[eventPlayer.CurrentCheckpointNum] > 0)
    eventPlayer.setUltCharge(100)
    eventPlayer.Ability1Used = 0
    eventPlayer.UltimateUsed = 0


def CancelAbilityAndMomentum():
    @Name "Subroutine CancelAbilityAndMomentum"
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(Vector.UP, 0, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.016, Wait.RESTART_WHEN_TRUE)
    eventPlayer.applyImpulse(normalize(eventPlayer.getVelocity()) * -1 * 1, eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


def ToCurrentCheckpoint():
    @Name "Subroutine ToCurrentCheckpoint"
    
    CancelAbilityAndMomentum()
    eventPlayer.teleport(CheckpointsPosition[eventPlayer.CurrentCheckpointNum])


def ToNextCheckpoint():
    @Name "Subroutine ToNextCheckpoint"
    
    eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum + 1
    if distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4:
        ToCurrentCheckpoint()
    if eventPlayer.CurrentCheckpointNum > eventPlayer.MaxCheckpointNum:
        eventPlayer.MaxCheckpointNum = eventPlayer.CurrentCheckpointNum
    if not EnableTimer:
        AutoSaveProgress()
        eventPlayer.RankSort = (len([i for i in getAllPlayers() if i.MaxCheckpointNum >= eventPlayer.MaxCheckpointNum])) / 100
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    if eventPlayer.CurrentCheckpointNum + 1 == len(CheckpointsPosition):
        eventPlayer.FreeMode = true
        EnableAllAbilities()
        if not EnableTimer:
            if GameState == 3 and Pioneer == null and CheckpointsCreator[eventPlayer.CurrentCheckpointNum - 1] != eventPlayer:
                Pioneer = eventPlayer
                eventPlayer.FreeMode = false
                CancelAbilityAndMomentum()
                EnableAllAbilities()
                GameState = 2
        elif EnableTimer and not eventPlayer.TimerPaused and eventPlayer.Timer > 0:
            stopChasingVariable(eventPlayer.Timer)
            if eventPlayer.Timer < eventPlayer.BestRecord:
                eventPlayer.BestRecord = eventPlayer.Timer
                if len([i for i in PlayersRecord if i[0] == "{0}".format(eventPlayer)]):
                    for I in range(len(PlayersRecord)):
                        if PlayersRecord[I][0] == "{0}".format(eventPlayer):
                            T = PlayersRecord[I]
                            del PlayersRecord[I]
                            T[1] = eventPlayer.BestRecord
                            PlayersRecord.append([T])
                            break
                else:
                    PlayersRecord[len(PlayersRecord)] = ["{0}".format(eventPlayer), eventPlayer.BestRecord]
                PlayersRecord = sorted(PlayersRecord, lambda player: player[1])
                Top5 = sorted(PlayersRecord, lambda player: player[1]).slice(0, 5)
            wait()
            bigMessage(getAllPlayers(), "Congratulation!")
            bigMessage(getAllPlayers(), "[{0}] has completed, use time  {1}  sec".format(eventPlayer, eventPlayer.Timer))
            eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE, OutlineVisibility.ALWAYS)
            wait()
            eventPlayer.Timer = 0


def EnableAllAbilities():
    @Name "Subroutine EnableAllAbilities"
    
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)


rule "自由行动或者已经通关的人无限制使用斩":
    @Event eachPlayer
    #当前玩家是开拓者并且正在开拓新关卡时不处理
    @Condition (eventPlayer.FreeMode or GameState == 1 or eventPlayer == Pioneer and GameState == 2 and TempNextCheckpointPosition) == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setUltEnabled(false)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    if eventPlayer.FreeMode or GameState == 1 or eventPlayer == Pioneer and GameState == 2 and TempNextCheckpointPosition:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)


rule "影使用限制":
    @Event eachPlayer
    @Condition eventPlayer != Pioneer
    @Condition eventPlayer.FreeMode == false
    @Condition eventPlayer.CurrentCheckpointNum < len(CheckpointsPosition) - 1
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4, 0.3)
    if distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4:
        eventPlayer.Ability1Used = eventPlayer.Ability1Used + 1
        if eventPlayer.Ability1Used >= CheckpointsAbility1Enabled[eventPlayer.CurrentCheckpointNum]:
            eventPlayer.setAbility1Enabled(false)


rule "斩使用限制":
    @Event eachPlayer
    @Condition eventPlayer != Pioneer
    @Condition eventPlayer.FreeMode == false
    @Condition eventPlayer.CurrentCheckpointNum < len(CheckpointsPosition) - 1
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setUltEnabled(false)
    waitUntil(distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4, 1.5)
    if distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4:
        eventPlayer.UltimateUsed = eventPlayer.UltimateUsed + 1
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    if eventPlayer.UltimateUsed < CheckpointsUltimateEnabled[eventPlayer.CurrentCheckpointNum] or eventPlayer.FreeMode:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)


rule "自杀回点":
    @Event eachPlayer
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.FreeMode == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4
    
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
        return
    ToCurrentCheckpoint()
    if eventPlayer == Pioneer and GameState == 2:
        ResetPioneerState()
        EnableAllAbilities()


rule "重生":
    @Event playerDied
    @Condition eventPlayer.SpectatorMode == false
    
    if eventPlayer == Pioneer and GameState == 2:
        ResetPioneerState()
        EnableAllAbilities()
    eventPlayer.PreviousPosition = eventPlayer.getPosition()
    if not eventPlayer.FreeMode and len(CheckpointsPosition) > 0:
        ToCurrentCheckpoint()
    else:
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.PreviousPosition))
    if not eventWasEnvironment:
        eventPlayer.cancelPrimaryAction()
    eventPlayer.resurrect()
    eventPlayer.SelfKill = false


rule "观战":
    @Event eachPlayer
    @Condition eventPlayer.NextCheckpointsPreview == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    
    eventPlayer.SpectatorMode = not eventPlayer.SpectatorMode
    if eventPlayer.SpectatorMode:
        CancelAbilityAndMomentum()
        eventPlayer.disableRespawn()
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "Spectate mode")
        smallMessage(eventPlayer, "press {0} or {1} to switch spectator, jump to switch perspective".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)))
    else:
        eventPlayer.enableRespawn()
        eventPlayer.resurrect()
        ToCurrentCheckpoint()
        smallMessage(eventPlayer, "nomal mode")
        CancelAbilityAndMomentum()
    wait(1)


rule "回到起点":
    @Event eachPlayer
    @Condition eventPlayer.NextCheckpointsPreview == false
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    if eventPlayer == Pioneer and GameState == 2:
        smallMessage(eventPlayer, "pioneer can't Restart")
        return
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_DISAPPEAR_SOUND, null, eventPlayer, 200)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.CurrentCheckpointNum = 0
    ToCurrentCheckpoint()
    eventPlayer.FreeMode = false
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR_SOUND, null, eventPlayer, 200)
    wait(1)


rule "开关跳转指定关卡":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer == Pioneer == false
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    wait(0.65, Wait.ABORT_WHEN_FALSE)
    if not eventPlayer.isOnGround():
        return
    eventPlayer.JumpingCheckpoint = not eventPlayer.JumpingCheckpoint
    if eventPlayer.JumpingCheckpoint:
        hudHeader(eventPlayer, "Move the mouse left and right to adjust the level you want to jump\n　(Must have been already reached)\n　　　　　　[{0}]\n　　　　{1}confirm,".format(floor(((eventPlayer.MaxCheckpointNum + 1) / 360) * (eventPlayer.getHorizontalFacingAngle() + 180)), buttonString(Button.PRIMARY_FIRE)), HudPosition.TOP, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.JumpingCheckpointHUD = getLastCreatedText()
        eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    else:
        destroyHudText(eventPlayer.JumpingCheckpointHUD)
        eventPlayer.JumpingCheckpoint = false
        CancelAbilityAndMomentum()
        eventPlayer.clearStatusEffect(Status.ROOTED)


rule "跳转指定关卡":
    @Event eachPlayer
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.JumpingCheckpoint != false
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) == true
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer == Pioneer:
            smallMessage(eventPlayer, "pioneer can't jump")
            return
        eventPlayer.CurrentCheckpointNum = floor(((eventPlayer.MaxCheckpointNum + 1) / 360) * (eventPlayer.getHorizontalFacingAngle() + 180))
        ToCurrentCheckpoint()
        SetCheckpointAbilities()
        eventPlayer.FreeMode = false
        if EnableTimer and not eventPlayer.TimerPaused:
            StopAndClearTimer()
        if eventPlayer.CurrentCheckpointNum == 0 and eventPlayer.getSpeed() > 6:
            kill(eventPlayer, null)
    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        destroyHudText(eventPlayer.JumpingCheckpointHUD)
        eventPlayer.JumpingCheckpoint = false
        CancelAbilityAndMomentum()
        eventPlayer.clearStatusEffect(Status.ROOTED)


rule "跳关+ ／ 跳关-":
    @Event eachPlayer
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.NextCheckpointsPreview == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition (eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    
    if eventPlayer == Pioneer and GameState == 2:
        smallMessage(eventPlayer, "pioneer can't jump")
        return
    if eventPlayer.SpectatorMode:
        smallMessage(eventPlayer, "can't jump in spectate mode")
        return
    eventPlayer.cancelPrimaryAction()
    eventPlayer.FreeMode = false
    if eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum + 1
        while CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum]:
            eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum + 1
        if eventPlayer.CurrentCheckpointNum > eventPlayer.MaxCheckpointNum:
            eventPlayer.CurrentCheckpointNum = 0
        ToCurrentCheckpoint()
        SetCheckpointAbilities()
        if EnableTimer and not eventPlayer.TimerPaused:
            StopAndClearTimer()
    if eventPlayer.isHoldingButton(Button.CROUCH):
        eventPlayer.teleport(vect(0, 500, 0))
        eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum - 1
        while CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum]:
            eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum - 1
        if eventPlayer.CurrentCheckpointNum < 0:
            eventPlayer.CurrentCheckpointNum = eventPlayer.MaxCheckpointNum
        ToCurrentCheckpoint()
        SetCheckpointAbilities()
        if EnableTimer and not eventPlayer.TimerPaused:
            StopAndClearTimer()


rule "3CP图如果开拓关在另一小图, 自动传送":
    @Event eachPlayer
    @Condition eventPlayer.SpectatorMode == false
    @Condition eventPlayer.NextCheckpointsPreview == false
    @Condition CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum] == true
    
    eventPlayer.cancelPrimaryAction()
    eventPlayer.FreeMode = false
    eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum + 1
    while CheckpointsAutoTeleport[eventPlayer.CurrentCheckpointNum]:
        eventPlayer.CurrentCheckpointNum = eventPlayer.CurrentCheckpointNum + 1
    if eventPlayer.CurrentCheckpointNum > eventPlayer.MaxCheckpointNum:
        eventPlayer.MaxCheckpointNum = eventPlayer.CurrentCheckpointNum
    ToCurrentCheckpoint()
    SetCheckpointAbilities()
    if EnableTimer and not eventPlayer.TimerPaused:
        StopAndClearTimer()


rule "自由行动":
    @Event eachPlayer
    @Condition GameState == 1 == false
    @Condition (GameState == 2 and Pioneer == eventPlayer) == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    if not eventPlayer.FreeMode:
        smallMessage(eventPlayer, "Invincible mode")
        EnableAllAbilities()
        eventPlayer.FreeMode = not eventPlayer.FreeMode
    elif not eventPlayer.isUsingAbility1():
        ToCurrentCheckpoint()
        if CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0:
            SetCheckpointAbilities()
        CancelAbilityAndMomentum()
        eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
        wait(0.08)
        eventPlayer.stopForcingPosition()
        kill(eventPlayer if eventPlayer.isUsingUltimate() else null, null)
        eventPlayer.FreeMode = not eventPlayer.FreeMode


rule "预览关卡":
    @Event eachPlayer
    @Condition eventPlayer.SpectatorMode == false
    @Condition len(CheckpointsPosition) > 1
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] != 0
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) <= CheckpointDefaultRadius + 0.4
    
    eventPlayer.NextCheckpointsPreview = not eventPlayer.NextCheckpointsPreview
    if eventPlayer.NextCheckpointsPreview:
        smallMessage(eventPlayer, "previewing the next level, any key to exit the preview")
        if not CheckpointsPreview[eventPlayer.CurrentCheckpointNum]:
            NextCheckpointPosition = CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1]
            TempArray = [distance(NextCheckpointPosition, raycast(NextCheckpointPosition, NextCheckpointPosition + angleToDirection(i * 30, -45) * 15, null, null, false).getHitPosition()) for _, i in TempArray]
            while abs(len(TempArray.exclude(sorted(TempArray).last())) - 5.5) < 5.5:
                TempArray = [TempArray[(i + 11) % 12] + player + (TempArray[(i + 1) % 12]) for player, i in TempArray]
            CheckpointsPreview[eventPlayer.CurrentCheckpointNum] = raycast(NextCheckpointPosition, NextCheckpointPosition + 15 * (angleToDirection(30 * TempArray.index(sorted(TempArray).last()), -45)), getAllPlayers(), eventPlayer, true).getHitPosition()
        eventPlayer.setFacing(directionTowards(CheckpointsPreview[eventPlayer.CurrentCheckpointNum], CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1]), Relativity.TO_WORLD)
        eventPlayer.startCamera(raycast(CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1], CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1] + eventPlayer.getFacingDirection() * -15, null, null, false).getHitPosition(), CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1], 30)
        eventPlayer.cancelPrimaryAction()
    else:
        eventPlayer.stopCamera()
        eventPlayer.cancelPrimaryAction()
        ToCurrentCheckpoint()
        eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1]), Relativity.TO_WORLD)


rule "任意键退出预览关卡":
    @Event eachPlayer
    @Condition eventPlayer.NextCheckpointsPreview != false
    @Condition (eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.isHoldingButton(Button.MELEE)) == true
    
    eventPlayer.NextCheckpointsPreview = false
    eventPlayer.stopCamera()
    ToCurrentCheckpoint()
    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), CheckpointsPosition[eventPlayer.CurrentCheckpointNum + 1]), Relativity.TO_WORLD)


def AutoSaveProgress():
    @Name "Subroutine 自动保存进度"
    
    eventPlayer.TempVar = PlayersNameRecords.index("{0}".format(eventPlayer))
    if eventPlayer.TempVar >= 0:
        PlayersMaxCheckpointRecords[eventPlayer.TempVar] = eventPlayer.MaxCheckpointNum
    else:
        PlayersNameRecords.append("{0}".format(eventPlayer))
        eventPlayer.TempVar = PlayersNameRecords.index("{0}".format(eventPlayer))
        PlayersMaxCheckpointRecords[eventPlayer.TempVar] = eventPlayer.MaxCheckpointNum


rule "进入时恢复进度":
    @Event playerJoined
    @Condition EnableTimer == false
    
    eventPlayer.TempVar = PlayersNameRecords.index("{0}".format(eventPlayer))
    if eventPlayer.TempVar >= 0:
        eventPlayer.MaxCheckpointNum = PlayersMaxCheckpointRecords[eventPlayer.TempVar]
        eventPlayer.CurrentCheckpointNum = eventPlayer.MaxCheckpointNum


rule "开始计时":
    @Event eachPlayer
    @Condition EnableTimer != false
    @Condition eventPlayer.FreeMode == false
    @Condition eventPlayer.CurrentCheckpointNum == 0
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) > CheckpointDefaultRadius + 0.4
    @Condition eventPlayer.TimerPaused == false
    
    chase(eventPlayer.Timer, 16200, rate=1, ChaseReeval.NONE)


rule "停止计时":
    @Event eachPlayer
    @Condition EnableTimer != false
    @Condition eventPlayer.FreeMode == false
    @Condition eventPlayer.TimerPaused == false
    @Condition eventPlayer.CurrentCheckpointNum == 0
    @Condition distance(eventPlayer, CheckpointsPosition[eventPlayer.CurrentCheckpointNum]) <= CheckpointDefaultRadius + 0.4
    
    StopAndClearTimer()


def StopAndClearTimer():
    @Name "Subroutine StopAndClearTimer"
    
    stopChasingVariable(eventPlayer.Timer)
    eventPlayer.Timer = 0


rule "双击互动键":
    @Event eachPlayer
    @Condition eventPlayer != Pioneer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), 0.25)
    if eventPlayer.isHoldingButton(Button.INTERACT):
        if not eventPlayer in ShowShortcutPlayers:
            ShowShortcutPlayers.append(eventPlayer)
        else:
            ShowShortcutPlayers.remove(eventPlayer)


rule "暂停/恢复计时":
    @Event eachPlayer
    @Hero genji
    @Condition EnableTimer != false
    @Condition eventPlayer.isCommunicating(Comms.NEED_HEALING) == true
    
    if eventPlayer.Timer == 0:
        smallMessage(eventPlayer, "Pause is currently unavailable because the timer is 0")
        return
    eventPlayer.TimerPaused = not eventPlayer.TimerPaused
    if eventPlayer.TimerPaused:
        bigMessage(eventPlayer, "timer pauses")
        bigMessage(eventPlayer, "Use hotkeys again to restore current level progress and timers")
        stopChasingVariable(eventPlayer.Timer)
        eventPlayer.TimerPausedCheckpointNum = eventPlayer.CurrentCheckpointNum
    else:
        eventPlayer.teleport(vect(0, 500, 0))
        eventPlayer.cancelPrimaryAction()
        eventPlayer.FreeMode = false
        eventPlayer.CurrentCheckpointNum = eventPlayer.TimerPausedCheckpointNum
        ToCurrentCheckpoint()
        kill(eventPlayer, null)
        chase(eventPlayer.Timer, 16200, rate=1, ChaseReeval.NONE)
        eventPlayer.TimerPausedCheckpointNum = -1 * 1


rule "使其他玩家隐身1":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.StartForceInvisible == false
    
    for eventPlayer.TempVar in range(3):
        wait(1, Wait.ABORT_WHEN_FALSE)
        smallMessage(eventPlayer, "After {0} sec, press {1} can make players within 20 meters invisible".format(3 - eventPlayer.TempVar + 1, buttonString(Button.PRIMARY_FIRE)))
    eventPlayer.StartForceInvisible = true
    createEffect(eventPlayer, Effect.SPHERE, Color.BLACK, eventPlayer, 20, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.setStatusEffect(null, Status.HACKED, 9999)
    eventPlayer.StartForceInvisibleEffect = getLastCreatedEntity()


rule "使其他玩家隐身2":
    @Event eachPlayer
    @Condition eventPlayer.StartForceInvisible != false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.ForceInvisiblePlayer = [i for i in getPlayersInRadius(eventPlayer.getPosition(), 20, Team.ALL, LosCheck.OFF) if not i.Invisible]
    if eventPlayer.ForceInvisiblePlayer:
        eventPlayer.ForceInvisiblePlayer.Invisible = true
        eventPlayer.ForceInvisiblePlayer.setInvisibility(Invis.ALL)
        smallMessage(eventPlayer, "Successfully made all players within 20 meters invisible...")
    destroyEffect(eventPlayer.StartForceInvisibleEffect)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.StartForceInvisible = false


rule "房主权限狗":
    @Condition EnableTimer == false
    @Condition hostPlayer.isHoldingButton(Button.RELOAD) == true
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    OwnerPrivilege = not OwnerPrivilege
    if OwnerPrivilege:
        TargetPlayer = hostPlayer.getPlayerClosestToReticle(Team.ALL)
        hudHeader(hostPlayer, "Adjusting the level of [{0}] to level [{1}]\nMove the mouse to target level\nPress space to switch to yourself\n　　　　{2}".format(TargetPlayer, floor(len(CheckpointsPosition) / 360 * (hostPlayer.getHorizontalFacingAngle() + 180)), "{0}confirm, {1}cancel　　　　".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE))), HudPosition.TOP, 7, Color.ORANGE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        OwnerPrivilegeHUD = getLastCreatedText()
    else:
        destroyHudText(OwnerPrivilegeHUD)


rule "调整关卡":
    @Condition OwnerPrivilege != false
    @Condition (hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) or hostPlayer.isHoldingButton(Button.JUMP)) == true
    
    if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if TargetPlayer == Pioneer:
            smallMessage(hostPlayer, "can't adjust the level of pioneering player ")
            return
        TargetPlayer.FreeMode = false
        TargetPlayer.teleport(nearestWalkablePosition(vect(0, 500, 0)))
        wait()
        TargetPlayer.CurrentCheckpointNum = floor(len(CheckpointsPosition) / 360 * (hostPlayer.getHorizontalFacingAngle() + 180))
        TargetPlayer.MaxCheckpointNum = floor(len(CheckpointsPosition) / 360 * (hostPlayer.getHorizontalFacingAngle() + 180))
        wait()
        TargetPlayer.teleport(nearestWalkablePosition(vect(0, 0, 0)))
    elif hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        OwnerPrivilege = false
        destroyHudText(OwnerPrivilegeHUD)
    elif hostPlayer.isHoldingButton(Button.JUMP):
        TargetPlayer = hostPlayer


rule "房主按住互动+发送语音感谢":
    @Condition hostPlayer.isCommunicating(Comms.THANKS) == true
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    
    if OwnerSaveGameTipsHUD:
        destroyHudText(OwnerSaveGameTipsHUD)
        OwnerSaveGameTipsHUD = 0
    else:
        smallMessage(hostPlayer, "Data has been imported into workshop inspector")
        enableInspector()
        disableInspector()
        hudHeader(hostPlayer, "　\n　Save steps:\n\n　　1.open workshop inspector\n　　2.click [X]\n　　3.open workshop editor\n　　4.paste data in the first rule\n\n{0}".format("(Use Interact+Thanks again to close this hint)\n"), HudPosition.TOP, 8, Color.ORANGE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        OwnerSaveGameTipsHUD = getLastCreatedText()


rule "非Debug模式下每5秒自动打开一次查看器":
    @Condition Debug == false
    
    enableInspector()
    disableInspector()
    wait(5)
    goto RULE_START


rule "删除最后一关":
    @Condition EnableTimer == false
    @Condition GameState != 1
    @Condition len(CheckpointsPosition) > 0
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition hostPlayer.getThrottle().x == -1 * 1
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    LastPioneer = CheckpointsCreator[len(CheckpointsCreatorText) - 1]
    del CheckpointsCreatorText[len(CheckpointsCreatorText) - 1]
    del CheckpointsCreator[len(CheckpointsCreator) - 1]
    del CheckpointsPosition[len(CheckpointsPosition) - 1]
    del CheckpointsAbility1Enabled[len(CheckpointsAbility1Enabled) - 1]
    del CheckpointsUltimateEnabled[len(CheckpointsUltimateEnabled) - 1]
    del CheckpointsAutoTeleport[len(CheckpointsAutoTeleport) - 1]
    del CheckpointsPreview[len(CheckpointsPreview) - 1]
    bigMessage(getAllPlayers(), "The last level has been deleted by the host")
    T = getAllPlayers()
    for I in range(len(T)):
        if len(CheckpointsPosition) > 0 and T[I].CurrentCheckpointNum + 1 > len(CheckpointsPosition):
            T[I].CurrentCheckpointNum = len(CheckpointsPosition) - 1
            T[I].teleport(CheckpointsPosition[T[I].CurrentCheckpointNum])
        if len(CheckpointsPosition) > 0 and T[I].MaxCheckpointNum + 1 > len(CheckpointsPosition):
            T[I].MaxCheckpointNum = len(CheckpointsPosition) - 1
        if len(CheckpointsPosition) == 0:
            T[I].FreeMode = true
            EnableAllAbilities()
    ResetPioneerState()
    if len(CheckpointsPosition) == 0:
        Pioneer = null
        GameState = 1
    elif Pioneer == null:
        if entityExists(LastPioneer):
            Pioneer = LastPioneer
        else:
            Pioneer = random.choice([i for i in getAllPlayers() if i.CurrentCheckpointNum + 1 == len(CheckpointsPosition)])
        Pioneer.CurrentCheckpointNum = Pioneer.MaxCheckpointNum
        kill(Pioneer, null)
        Pioneer.setAbility1Enabled(true)
        Pioneer.setUltEnabled(true)
        Pioneer.setUltCharge(100)
        GameState = 2
    else:
        GameState = 2
    PlayersMaxCheckpointRecords = [max(0, len(CheckpointsPosition) - 1 if player > len(CheckpointsPosition) - 1 else player) for player in PlayersMaxCheckpointRecords]


rule "落地重置二段,爬墙,小跳":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.Jump = 2
    eventPlayer.Bhop = 0
    eventPlayer.Climb = 1


rule "直接跳跃":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.Jump != 0
    
    eventPlayer.Jump -= 1


rule "跳跃变量归零, 用于判定三段":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.Jump == 1
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.Jump = 0


rule "常规小跳":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.Jump == 2
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.Jump = 1
    if not eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.Bhop = 1


rule "表情小跳":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    if EmoteBhop:
        eventPlayer.Bhop = 1
    else:
        kill(eventPlayer if not eventPlayer.FreeMode else null, null)
        smallMessage(eventPlayer, "{0}: Emote is disabled".format(heroIcon(Hero.GENJI)))


rule "蹲卡小 Githuboy#5249":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isCrouching() == true
    @Condition eventPlayer.getVerticalSpeed() >= 6
    
    if BugBhop:
        eventPlayer.Bhop = 1
        smallMessage(eventPlayer, "Success!")
    else:
        kill(eventPlayer if not eventPlayer.FreeMode else null, null)
        smallMessage(eventPlayer, "{0}: create is disabled".format(heroIcon(Hero.GENJI)))


rule "系统跳判定, 用于避免站卡小误判定":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.getSpeed() == 0
    @Condition eventPlayer.isOnGround() == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.BugJump = 1
    waitUntil(eventPlayer.getVerticalSpeed() > 6 or eventPlayer.isOnGround(), 3.5)
    if eventPlayer.getVerticalSpeed() > 6:
        wait(1)
    eventPlayer.BugJump = 0


rule "站卡小":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isCrouching() == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.getSpeed() >= 7.2
    @Condition eventPlayer.getSpeed() <= 7.505
    @Condition eventPlayer.getAltitude() >= 0.1
    @Condition eventPlayer.getAltitude() <= 0.145
    @Condition eventPlayer.getVerticalSpeed() >= 6
    @Condition eventPlayer.BugJump != 1
    
    if BugBhop:
        eventPlayer.Bhop = 1
        smallMessage(eventPlayer, "Success!")
    else:
        kill(eventPlayer if not eventPlayer.FreeMode else null, null)
        smallMessage(eventPlayer, "{0}: create is disabled".format(heroIcon(Hero.GENJI)))


rule "小跳":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.Bhop == 1
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.Bhop = 0
    smallMessage(eventPlayer, "Bhop")


rule "爬墙,蹭留":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.Climb == 1
    @Condition eventPlayer.isOnWall() == true
    
    if eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.Climb = 0
        eventPlayer.Jump = 0
        smallMessage(eventPlayer, "Climb")
    elif not BugClimb:
        kill(eventPlayer if not eventPlayer.FreeMode else null, null)
        smallMessage(eventPlayer, "{0}: Multi is disabled".format(heroIcon(Hero.GENJI)))


rule "三段":
    @Event eachPlayer
    @Hero genji
    @Condition TripleJump == false
    @Condition eventPlayer.Jump == 1
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isOnWall() == false
    
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


