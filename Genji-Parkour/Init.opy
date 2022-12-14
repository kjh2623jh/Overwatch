#!mainFile "GenjiParkour.opy"


def save():
    @Name "여기에 붙여넣으세요"
    @Delimiter
    
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
    # len(Text) == 24
    Text = [["pioneer mode", "edit mode", "change mode", ", press ", " to set starting point", "Pioneer plz", "Pioneer", "Pioneer Time", "Cancel", "Confirm",
            "Youtube '(genjiparkour) nemi'\ndiscord is on youtube\n", "server reset ", "m left", "next checkpoint\npioneer: ", "bhop", "climb", "invincible", "Clear!!", "invisible", "invisible off",
            "you can't spectate when pioneering", "saved", "plz start at outside from base", "create bhop"], 
            ["개척 모드", "제작 모드", "모드 변경", "님, 시작할 위치에서 ", "를 누르세요.", "개척해주세요", "개척자", "개척 시간", "취소", "결정",
            "유튜브 '(겐지파쿠르) nemi'\n디스코드도 있어요\n", "서버 재시작까지 ", "분", "다음 개척지\n개척자: ", "콩콩이", "벽타기", "연습모드", "클리어!!", "투명화", "투명화 해제",
            "개척중에는 관전할 수 없습니다", "저장됨", "기지 밖에서 시작해주세요", "앉콩"]]
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
    hudSubheader(localPlayer, "v 0.2.3.2", HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, Text[localPlayer.language][10], HudPosition.LEFT, -1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, ["\n\nreset: {0}\nspectate: hold {1}\n{2}".format(buttonString(Button.RELOAD), buttonString(Button.INTERACT),
                            "move checkpoint: {0} + {1} / {2}".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE),
                            "{0}\n{1}".format(buttonString(Button.SECONDARY_FIRE),
                            "invincible: {0} + {1}\n{2}".format(buttonString(Button.MELEE), buttonString(Button.RELOAD),
                            "invisible: {0} + {1}\n{2}".format(buttonString(Button.CROUCH), buttonString(Button.MELEE),
                            "restart: {0} + {1} + {2}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_1), buttonString(Button.ABILITY_2)) if Finished else \
                            "inspector save: {0} + {1}".format(buttonString(Button.MELEE), buttonString(Button.ABILITY_2)) if localPlayer == hostPlayer else ''))))),
                            
                            "\n\n제자리: {0}\n관전: {1}꾹\n{2}".format(buttonString(Button.RELOAD), buttonString(Button.INTERACT),
                            "단계 이동: {0} + {1} / {2}".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE),
                            "{0}\n{1}".format(buttonString(Button.SECONDARY_FIRE),
                            "연습모드: {0} + {1}\n{2}".format(buttonString(Button.MELEE), buttonString(Button.RELOAD),
                            "투명화: {0} + {1}\n{2}".format(buttonString(Button.CROUCH), buttonString(Button.MELEE),
                            "초기화: {0} + {1} + {2}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_1), buttonString(Button.ABILITY_2)) if Finished else \
                            "개척 저장: {0} + {1}".format(buttonString(Button.MELEE), buttonString(Button.ABILITY_2)) if localPlayer == hostPlayer else '')))))][localPlayer.language], HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
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
    eventPlayer.language = 1 if "{0}".format(Hero.GENJI) == "겐지" else 0
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
    if len(CheckPoint) < 2:
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