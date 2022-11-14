settings {
    "main": {
        "modeName": "겐지 개척 파쿠르",
        "description": "modified by 훈제김치\ncode : PYDJ3\nhttps://discord.gg/dyGvBbBgxV\n22.11.15"
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
            "gameLengthInMn": 15,
            "scoreToWin": 5000,
            "enableSelfInitiatedRespawn": false
        },
        "skirmish": {
            "enabledMaps": [
                "rialto"
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
                "enableSpawningWithUlt": true,
                "selfDestructKb%": 200,
                "damageDealt%": 500
            },
            "genji": {
                # 튕겨내기: 비활성화
                "enableInfiniteAmmo": true
            },
            "hammond": {
                "secondaryFireCooldown%": 20,
                "movementSpeed%": 125,
                "movementGravity%": 75
            },
            "reaper": {
                "jumpVerticalSpeed%": 158,
                "movementSpeed%": 220,
                "movementGravity%": 25
            },
            "mercy": {
                # 부활: 비활성화
                "jumpVerticalSpeed%": 400
            },
            "enabledHeroes": [
                "genji"
            ],
            "general": {
                "enableUlt": false
            }
        }
    }
}

#Global variables

globalvar DvaPos 42
globalvar text 43
globalvar invincible 44
globalvar bhop 45
globalvar bhoptext 46
globalvar climb 47
globalvar climbtext 48
globalvar createbhoptext 49
globalvar forcingqreset 50
globalvar currentCpColor 51
globalvar nextCpRingColor 52
globalvar ColorList 53
globalvar auto_invisible 54
globalvar bannedSkills 55
globalvar nextCpLightShaftColor 57
globalvar MapCode 58
globalvar Dva 60
globalvar timerSetting 68
globalvar next2CpTextColor 69
globalvar playerList 71
globalvar playerLevel 72
globalvar playerTime 73


#Player variables

playervar climbCheck 26
playervar multiclimbCheck 27
playervar isInvincible 28
playervar Time 29
playervar isforcingqreset 30
playervar climbCnt 31
playervar texttemp 32
playervar playerlisttemp 33
playervar isInvinciblePossible 34
playervar save_skill 35
playervar bhopCheck 36
playervar check 37
playervar playerleveltemp 38
playervar playertimetemp 39
playervar Dvapostemp 40
playervar dva_position 41
playervar dva_position_arr 42
playervar dva_index 43
playervar bhopColor 85


#Subroutine names

subroutine init 0
subroutine memory 1
subroutine serverloadbuffer 2
subroutine serverloadbuffer2 3
subroutine genjiparkour 7


def memory():
    @Name "paste here./이곳에 붙여넣으세요."
    


rule "기본변수설정":
    disableInspector()
    genjiparkour()
    F = createWorkshopSetting(int[1:100], "기본설정(Setting)", "경쟁모드에서의 단계수(last check point in competition mode)", 30, 0)
    N = createWorkshopSetting(float[0.1:3], "기본설정(Setting)", "개척지 크기(size of check point)", 2, 0)
    if "{0}".format(Hero.GENJI) == "겐지":
        AH = [["Recommended Workshop of the Week\r\nOthello/reversi(code: eaavv)\r\nOthello! now play!\r\n\r\n\r\n\r\n\r\n\r\n\r\n"], ["겐지 파쿠르 디스코드 있습니다! 유튜브 통해 들어오세요\r\n유튜브 : nemi (겐지파쿠르도 같이 검색하면 바로 나옵니다,)\r\n\r\n\r\n\r\n\r\n\r\n"], ["Recommended Workshop of the Week\r\nOthello/reversi(code: eaavv)\r\nOthello! now play!\r\n\r\n\r\n\r\n\r\n\r\n\r\n"], ["Recommended Workshop of the Week\r\nOthello/reversi(code: eaavv)\r\nOthello! now play!\r\n\r\n\r\n\r\n\r\n\r\n\r\n"]]
    AB = []
    AC = []
    AD = []
    AJ = createWorkshopSetting(float[2:100], "기본설정(Setting)", "개척 최소 거리(minimum distance between check points)", 10, 0)
    AO = ""
    AM[11] = 0
    AI = createWorkshopSetting(float[0.1:10], "기본설정(Setting)", "영웅 크기(scale of hero)", 1, 0)
    waitUntil(isGameInProgress(), 99999)
    if Gamemode.FFA == getCurrentGamemode():
        goto lbl_0
    wait(5)
    lbl_0:
    memory()
    if Z == 1:
        Y = ["단계 변경\r\n", "관전/관전취소\r\n", " \r\n\r\n\r\n제작: 깨꾸\r\n코드: X8080\r\n수정: 훈제김치\r\n코드: PYDJ3", "단계 순위", "개척취소", "제작: ", "다시시작\r\n", " 님이 개척하는 중입니다.", "다른 플레이어가 도착할 때까지 기다리세요.", "무한 모드", "시간제한", "스킬 횟수 제한", "개척자 교체까지 남은 시간", " 승리까지 남은 시간", "다음 개척지\r\n개척자: ", " 님, 10M이상 떨어진 곳에 착지하세요.", "마지막 ", "단계 개척자는 개척하고 10초후에 이동할 수 있습니다.", "다시하세요!", " 님이 개척하였습니다!", "10초후에 마지막 단계로 갈 수 있습니다.", "시간초과!", "도착!", " 님이 마지막 개척을 취소했습니다.", " 승리!", "자유 모드", "경쟁 모드", "현재 단계까지 파쿠르를 저장할 수 있습니다.", "클리어", "다시 시작!", "제작중...", "저장한 뒤에도 개척지를 추가할 수 있습니다.", "다음 위치 보기\r\n", "분 ", "초", "기지에서 나온 후, ", "시작할 위치에서 궁극기를 누르세요.", "다음 위치", "인사", "투명화", "투명화해제\r\n", "제자리 가기\r\n", "제작도구: 깨꾸의 개척파쿠르\r\n수정: 훈제김치\r\n코드: PYDJ3", "개척하기"]
    elif Z == 2:
        Y = ["更改步骤\r\n", "观看/取消观看\r\n", " \r\n\r\n\r\nmade by kaeku\r\ncode: X8080\r\nmodified by 훈제김치\r\ncode : PYDJ3", "level排名", "取消先驱", "生产：", "重新启动\r\n", "开创性", "等待其他玩家到达。", "无限模式", "超时", "技能计数限制", "剩下的时间来替换开拓者", "获胜的剩余时间", "下一位开拓者\r\n先锋：", ",登陆距离超过10M。", "最后一个", "皮尔斯先驱者可以在开创后移动10秒。", "请再做一次！", "先行者！", "您可以在10秒内转到最后一步。", "超时！", "到达！", "您取消了最后一位先驱。", " 胜利！", "自由模式", "竞争模式", "您可以保存此跑酷", "清除", "重新启动！", "正在生产中...", "保存后可以添加边界。", "查看下一个位置\r\n", "分 ", "秒", "从大本营搬出去, ", "按最终(Q)选择起点.", "下个阶段", "你好", "无形", "出现\r\n", "转到位置\r\n", "making tool: kaeku's pioneer parkour\r\nmodified by 훈제김치\r\ncode : PYDJ3", "开发 "]
    elif Z == 3:
        Y = ["段階変更\r\n", "観戦/観戦キャンセル\r\n", " \r\n\r\n\r\nmade by kaeku\r\ncode: X8080\r\nmodified by 훈제김치\r\ncode : PYDJ3", "段階のランキング", "開拓キャンセル", "制作：", "再起動\r\n", "さんが開拓しています。", "他のプレイヤーが到着するまでお待ちください。", "無限モード", "時間制限", "スキル回数制限", "パイオニア交換までの残り時間", "勝利まで残り時間", "次のフロンティア\r\nパイオニア：", "様,10M以上離れたところに着地します。", "最後の", "段階パイオニアは開拓し,10秒後に移動することができます。", "もう一度してください！", "さんが開拓しました！", "10秒後に最後のステップに行くことができます。", "タイムアウト！", "到着！", "さんが最後の開拓をキャンセルしました。", "勝利！", "自由モード", "競争モード", "この波クールを保存することができます。", "クリア", "再起動！", "製作中...", "保存した後もフロンティアを追加することができます。", "次の場所を表示する\r\n", "分 ", "秒", "ベースキャンプから出て, ", "究極の(Q)を押して開始点を選択します.", "　次の\r\nステージ", "你好", "見えない", "に見える\r\n", "所定の位置へ\r\n", "making tool: kaeku's pioneer parkour\r\nmodified by 훈제김치\r\ncode : PYDJ3", "開拓"]
    else:
        Y = ["change current stage\r\n", "OBSERVE/QUIT\r\n", " \r\n\r\n\r\nmade by kaeku\r\ncode: X8080\r\nmodified by 훈제김치\r\ncode : PYDJ3", "ranking", "cancel ", "made by ", "RESET\r\n", " is making the next step.", "wait for other players to arrive.", "infinite mode", "time limit", "Skill count", "time left for the 'pioneer' to change", "'s victory to time left", "next check point\r\npioneer: ", ", land 10m away from your starting point.", "the person who made stage ", " can move after 10 sec.", "try again!", "  created the next check point!", "you can go to the last stage after 10 sec.", "overtime!", "clear!", " cancelled to make the last stage.", " win!", "free mode", "competitive mode", "you can save these stages.", "clear", "reset!", "Making...", "After saving, you can add the check points.", "VIEW THE NEXT CHECK POINT\r\n", ":", "", "move out from the base camp and ", "press ultimate to select your starting point.", " next\r\nstage", "hello", "Invisible", "visible\r\n", "starting point\r\n", "making tool: kaeku's pioneer parkour\r\nmodified by 훈제김치\r\ncode : PYDJ3", "to pioneer"]
    AF = createWorkshopSetting(bool, "기본설정(Setting)", "관전(observe)", true, 0)
    AG = createWorkshopSetting(bool, "기본설정(Setting)", "개척취소(cancle)", true, 0)
    serverloadbuffer()
    serverloadbuffer2()
    if Gamemode.SKIRMISH != getCurrentGamemode():
        hudSubtext(getAllPlayers(), "  ", HudPosition.TOP, -0.8, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader(getAllPlayers(), "{0}:{1} | {2}".format(floor(getMatchTime() / 60), floor(getMatchTime() % 60), Y[12] if E else "{0}{1}".format(J, Y[13])), HudPosition.TOP, -0.2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    AK = createWorkshopSetting(int[30:3600], "기본설정(Setting)", "개척제한시간(Time limit to pioneer)", 120, 0)
    setMatchTime(AK)
    setObjectiveDescription(getAllPlayers(), Y[12] if E else "{0}{1}".format(J, Y[13]), HudReeval.VISIBILITY_AND_STRING)
    V = 0
    if getCurrentMap() == Map.DORADO:
        V = [vect(-7.819, 5.019, 10.906), vect(-5.498, 5.55, 13.43), vect(33.977, 6.798, -2.614)]
    AH = 0
    AL = createWorkshopSetting(int[1:3600], "기본설정(Setting)", "개척취소시간(Time to cancle)", 3, 0)


rule "기타모드 시작":
    @Condition isGameInProgress() == false
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    setMatchTime(1)


def serverloadbuffer():
    @Name "서버부하방지용"
    
    disableScoring()
    hudSubtext(getAllPlayers(), Y[3], HudPosition.RIGHT, -0.4, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    G = 1
    chase(P, 0, rate=1, ChaseReeval.NONE)
    hudHeader([player for player in M if M.isOnGround() and AG and getMatchTime() and true], "{2}: {1} {0}".format(ceil(P if not G or getNumberOfPlayers(Team.ALL) == 1 else min(P, getMatchTime())), Y[4], buttonString(Button.PRIMARY_FIRE)), HudPosition.TOP, -0.8, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText([player for player in getAllPlayers() if G == 2 and not J.hasSpawned() or getNumberOfPlayers(Team.ALL) == 1 or G != 2 and not E], null, " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, -0.5, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    if A:
        hudSubtext(getAllPlayers(), Y[42], HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        if not AA:
            hudText(getAllPlayers(), " {0}{1} ".format(Y[5], K) if L[1] else null, "\r\n\r\n", null, HudPosition.TOP, -1, Color.PURPLE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            X = len(A) - 1
            AE = false if L.exclude(0).exclude(L[1]) and L[1] else true
            hudHeader([player for player in getAllPlayers() if AB], "{0}\r\n{1}{2}".format(Y[28], "{0}{1}".format("1: {0} {1}".format(AC[AB.index(sorted(AB)[0])], AD[AB.index(sorted(AB)[0])]), "\r\n2: {0} {1}".format(AC[AB.index(sorted(AB)[1])], AD[AB.index(sorted(AB)[1])]) if AB[1] else ""), "\r\n3: {0} {1}".format(AC[AB.index(sorted(AB)[2])], AD[AB.index(sorted(AB)[2])]) if AB[2] else ""), HudPosition.RIGHT, -0.7, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        else:
            AB = []
            AC = []
            AD = []
            hudHeader(E, "{0}{1}".format(E, Y[15]), HudPosition.TOP, -0.9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
            hudHeader(getAllPlayers(), Y[30], HudPosition.TOP, -1, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            hudSubtext(hostPlayer, "자유롭게 단계를 이동할 수 있습니다.\r\n마지막 단계를 클리어하면 개척할 수 있습니다." if Z else "You can move the steps freely.\r\nYou can pioneer by clearing the final stage.\r\nIt's even better to delete and paste\r\nexisting act", HudPosition.LEFT, 2.05, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            G = false
            X = false
            AE = false
    else:
        hudSubtext(getAllPlayers(), Y[2], HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        if AH[Z]:
            for V in range(len(AH[Z])):
                hudSubtext(getAllPlayers(), AH[Z][V], HudPosition.LEFT, V - 10, Color.SKY_BLUE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        else:
            hudSubtext(getAllPlayers(), " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.LEFT, -1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        E = hostPlayer
        J = E
        hudHeader([player for player in getAllPlayers() if E and E != player and player.A == len(A) - 1], "{0}{1}".format(E, Y[7]), HudPosition.LEFT, -20, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudHeader([player for player in J if not E and J.A == len(A) - 1], Y[8], HudPosition.LEFT, -20, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudHeader(getAllPlayers(), "{0}, {1}{2}".format("{0}{1}".format(E, " 님" if Z == 1 else ""), "" if Gamemode.FFA == getCurrentGamemode() else Y[35], Y[36]), HudPosition.TOP, -0.9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        O = getLastCreatedText()
        hudHeader(getAllPlayers(), Y[9], HudPosition.TOP, -1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        O.append(getLastCreatedText())
        if Z == 1:
            hudHeader(hostPlayer, "{0}: 모드변경  　　\r\n{1}: 스킬 횟수 {2}".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD), "{0}제한\r\n{1}: 시간 {2}제한".format("무" if T else "", buttonString(Button.MELEE), "무" if S else "")), HudPosition.TOP, -0.95, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        elif Z == 2:
            hudHeader(hostPlayer, "{0}: 模式变更  　　\r\n{1}: 技能 {2}".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD), "{0}数\r\n{1}: {2}有时间限制".format("无" if T else "", buttonString(Button.MELEE), "没" if S else "")), HudPosition.TOP, -0.95, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        elif Z == 3:
            hudHeader(hostPlayer, "{0}: モードの変更  　　\r\n{1}: スキル{2}".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD), "{0}カウント\r\n{1}: 時間{2}制限".format("ノ" if T else "", buttonString(Button.MELEE), "無" if S else "")), HudPosition.TOP, -0.95, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        else:
            hudHeader(hostPlayer, "{0}: change mode \r\n{1}: {2}".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD), "{0}skill count\r\n{1}: time {2}limit".format("not " if T else "", buttonString(Button.MELEE), "un" if S else "")), HudPosition.TOP, -0.95, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        O.append(getLastCreatedText())
        hudHeader(S, Y[10], HudPosition.TOP, -0.88, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        O.append(getLastCreatedText())
        hudHeader(T, Y[11], HudPosition.TOP, -0.89, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        O.append(getLastCreatedText())
        AP = ["VaziracKakux", "ChrisEvans"]
        #if createWorkshopSetting(bool, "기본설정(Setting)", "저장 방법 설명(how to save)", true, 10):
        #if Z == 1:
        #hudSubtext(hostPlayer, "\r\n제작하기\r\n→ 저장하기 직전 (미완성시 앉으면서) 근접공격하기\r\n→ ESC 누르기\r\n→ 워크샵 인스펙터\r\n→ 하단의 [x]클릭 ", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #hudSubtext(hostPlayer, "→ ESC를 눌러 돌아간 후 다시 ESC를 눌러 워크샵 에디터 열기\r\n→ 가장 왼쪽 위의 + 클릭\r\n→ 오른쪽 주황색 [+]클릭\r\n→ 저장\r\n※개설자가 아니라면 아이디는 저장되지 않습니다.", HudPosition.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #hudSubtext(hostPlayer, "코드: X8080으로 가끔씩 최신버전으로 업데이트 해주세요.\r\n유튜브 '깨꾸'에 설정하는 방법이 있습니다.", HudPosition.LEFT, 2.1, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #else:
        #hudSubtext(hostPlayer, "\r\nHow to save\r\n→ (Crouch if not finished)melee\r\n→ press ESC\r\n→ open workshop inspector\r\n→ click the [x]", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #hudSubtext(hostPlayer, "→ Press ESC to go back and press ESC again to open workshop editor\r\n→ click the [+] sign on the top left corner", HudPosition.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #hudSubtext(hostPlayer, "→ click the yellow [+] sign\r\n→ save workshop\r\n※If you are not the origin host player ID will not be saved", HudPosition.LEFT, 2.1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        #__end__()
        #__end__()


def serverloadbuffer2():
    @Name "서버부하방지용2"
    
    hudSubtext(localPlayer, "{0}{1}".format("{0}+{1}: {2}\n".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), text[5]) if invincible else "", "{0}{1}{2}".format("{0}{1}{2}".format("{0}+{1}, {2}: ".format(buttonString(Button.INTERACT), buttonString(Button.JUMP), buttonString(Button.CROUCH)), "{0}{1}: {2}".format(Y[0], buttonString(Button.ULTIMATE), Y[41]), "{0}: {1}/{2}".format(Y[38], Y[39], Y[40])), "{0}{1}{2}".format("{0}: {1}".format(buttonString(Button.RELOAD), Y[1]) if localPlayer != E and localPlayer != M and A and AF and (localPlayer.B != len(A) - 1 or (not (not E or M))) else AO, "{0}: {1}".format(buttonString(Button.PRIMARY_FIRE), Y[32]) if localPlayer != M and localPlayer.isOnGround() and A[localPlayer.A + 1] else AO, "{0}+{1}: {2}".format(buttonString(Button.CROUCH), buttonString(Button.ULTIMATE), Y[6]) if X else AO), "{0}+{1}: {2}".format(buttonString(Button.INTERACT), buttonString(Button.ULTIMATE), Y[44]) if localPlayer == hostPlayer and AA and not E else AO)), HudPosition.RIGHT, -1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    if "{0}".format(Hero.GENJI) == "겐지":
        hudHeader([i for i in localPlayer if A], "{0}{1}{2}".format("현재 단계: {0}/{1}{2}".format(localPlayer.A + 1, len(A), (" {0}".format(getTotalTimeElapsed() - localPlayer.L) if timerSetting else " {0}:{1}".format(floor((getTotalTimeElapsed() - localPlayer.L) / 60), floor((getTotalTimeElapsed() - localPlayer.L) % 60))) if X and not localPlayer.K else AO), AO if not T else "\r\n {0}".format("{0}{1}".format(abilityIconString(localPlayer.getCurrentHero(), Button.ABILITY_1), C.last() if localPlayer == E else localPlayer.G)), AO if not S else "\r\n제한시간: {0}초".format(R[localPlayer.A] if localPlayer.isOnGround() else getTotalTimeElapsed() + 1 - localPlayer.I if localPlayer == E else 0 if localPlayer.A == len(A) - 1 else R[localPlayer.A] - (getTotalTimeElapsed() - localPlayer.I))), HudPosition.RIGHT, -3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    elif "{0}".format(Hero.GENJI) == "源氏":
        hudHeader([i for i in localPlayer if A], "{0}{1}{2}".format("现阶段: {0}/{1}{2}".format(localPlayer.A + 1, len(A), " {0}:{1}".format(floor((getTotalTimeElapsed() - localPlayer.L) / 60), floor((getTotalTimeElapsed() - localPlayer.L) % 60)) if X and not localPlayer.K else AO), AO if not T else "\r\n {0}".format("{0}{1}".format(abilityIconString(localPlayer.getCurrentHero(), Button.ABILITY_1), C.last() if localPlayer == E else localPlayer.G)), AO if not S else "\r\n剩余时间: {0}秒".format(R[localPlayer.A] if localPlayer.isOnGround() else getTotalTimeElapsed() + 1 - localPlayer.I if localPlayer == E else 0 if localPlayer.A == len(A) - 1 else R[localPlayer.A] - (getTotalTimeElapsed() - localPlayer.I))), HudPosition.RIGHT, -3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    elif "{0}".format(Hero.GENJI) == "ゲンジ":
        hudHeader([i for i in localPlayer if A], "{0}{1}{2}".format("現在の段階: {0}/{1}{2}".format(localPlayer.A + 1, len(A), " {0}:{1}".format(floor((getTotalTimeElapsed() - localPlayer.L) / 60), floor((getTotalTimeElapsed() - localPlayer.L) % 60)) if X and not localPlayer.K else AO), AO if not T else "\r\n {0}".format("{0}{1}".format(abilityIconString(localPlayer.getCurrentHero(), Button.ABILITY_1), C.last() if localPlayer == E else localPlayer.G)), AO if not S else "\r\n残り時間: {0}秒".format(R[localPlayer.A] if localPlayer.isOnGround() else getTotalTimeElapsed() + 1 - localPlayer.I if localPlayer == E else 0 if localPlayer.A == len(A) - 1 else R[localPlayer.A] - (getTotalTimeElapsed() - localPlayer.I))), HudPosition.RIGHT, -3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    else:
        hudHeader([i for i in localPlayer if A], "{0}{1}{2}".format("cp: {0}/{1}{2}".format(localPlayer.A + 1, len(A), " {0}:{1}".format(floor((getTotalTimeElapsed() - localPlayer.L) / 60), floor((getTotalTimeElapsed() - localPlayer.L) % 60)) if X and not localPlayer.K else AO), AO if not T else "\r\n {0}".format("{0}{1}".format(abilityIconString(localPlayer.getCurrentHero(), Button.ABILITY_1), C.last() if localPlayer == E else localPlayer.G)), AO if not S else "\r\ntime left: {0}".format(R[localPlayer.A] if localPlayer.isOnGround() else getTotalTimeElapsed() + 1 - localPlayer.I if localPlayer == E else 0 if localPlayer.A == len(A) - 1 else R[localPlayer.A] - (getTotalTimeElapsed() - localPlayer.I))), HudPosition.RIGHT, -3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "접속시":
    @Event playerJoined
    @Hero genji
    
    eventPlayer.J = false
    eventPlayer.A = 0
    eventPlayer.B = 0
    eventPlayer.setMoveSpeed(createWorkshopSetting(int[10:1000], "기본설정(Setting)", "이동속도(move speed)", 100, 0))
    hudSubtext(getAllPlayers(), l"{0} {1}".format(eventPlayer, eventPlayer.K if eventPlayer.K else eventPlayer.B + 1), HudPosition.RIGHT, (sorted(getAllPlayers(), lambda player: -1 * player.B)).index(eventPlayer) + 0.08 * sorted(getAllPlayers(), lambda player: player.N).index(eventPlayer), Color.AQUA, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    if eventPlayer == E:
        setMatchTime(AK)
        if len(A) > 1:
            goto lbl_0
        E = random.choice(getAllPlayers().exclude(eventPlayer))
        goto lbl_1
        lbl_0:
        E = random.choice([i for i in getAllPlayers().exclude(eventPlayer) if i.B == len(A) - 1])
        lbl_1:
        if not A:
            goto lbl_2
        E.teleport(A.last())
        lbl_2:
        if not G or getNumberOfPlayers(Team.ALL) == 1:
            goto lbl_3
        J = E
        lbl_3:
        E.A = E.B
    wait(0.25)
    eventPlayer.J = true
    eventPlayer.R = "{0}".format(eventPlayer)
    if not teamHasHero(Hero.HAMMOND, Team.ALL):
        goto lbl_4
    hudHeader([i for i in eventPlayer if not I[eventPlayer.A] and A and eventPlayer.A > len(A) - 1], " {0}{1} ".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), iconString(Icon.NO)), HudPosition.RIGHT, -1.9, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_4:
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        eventPlayer.disableGamemodeHud()
    createEffect(eventPlayer, Effect.RING, ColorList[currentCpColor], A[eventPlayer.A], N, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([i for i in eventPlayer if A[eventPlayer.A + 1]], Effect.RING, ColorList[nextCpRingColor], A[eventPlayer.A + 1], N, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if not nextCpLightShaftColor:
        goto lbl_5
    createEffect([i for i in eventPlayer if A[eventPlayer.A + 1]], Effect.LIGHT_SHAFT, ColorList[nextCpLightShaftColor + -1], A[eventPlayer.A + 1], N, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    lbl_5:
    createInWorldText([i for i in eventPlayer if A[eventPlayer.A + 1]], Y[37] if AE else "{0}{1}".format(Y[14], L[eventPlayer.A + 1]), A[eventPlayer.A + 1], 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, ColorList[nextCpRingColor], SpecVisibility.DEFAULT)
    if not next2CpTextColor:
        goto lbl_6
    createInWorldText([i for i in eventPlayer if A[eventPlayer.A + 2]], "다음", A[eventPlayer.A + 2], 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, ColorList[next2CpTextColor + -1], SpecVisibility.DEFAULT)
    lbl_6:
    createIcon([i for i in eventPlayer if ((not (eventPlayer.C or eventPlayer.Q)) and A[eventPlayer.A + 1]) and not eventPlayer.isInViewAngle(A[eventPlayer.A + 1], 60)], A[eventPlayer.A + 1], Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, ColorList[nextCpRingColor], true)
    if AI != 1:
        eventPlayer.startScalingSize(AI, false)


rule "시작지점설정":
    @Condition A == false
    @Condition E.isHoldingButton(Button.ULTIMATE) == true
    @Condition E.isOnGround() == true
    @Condition E.isInSpawnRoom() == false
    @Condition isGameInProgress() == true
    
    destroyHudText(O[0])
    destroyHudText(O[2])
    destroyHudText(O[3])
    destroyHudText(O[4])
    O = 0
    A = [E.getPosition()]
    hudHeader(E, "{0}{1}".format(E, Y[15]), HudPosition.TOP, -0.9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    B = 0
    C = 0
    D = 0
    I = 0
    R = 0
    if G == 2:
        hudSubheader(getAllPlayers(), "{1}{0}{2}".format(F, Y[16], Y[17]), HudPosition.RIGHT, -10, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    E.isInvincible = false


rule "출발지점으로":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition A[eventPlayer.A + 1] == true
    @Condition eventPlayer.C == false
    
    eventPlayer.isInvincible = false
    eventPlayer.isforcingqreset = true
    async(init, AsyncBehavior.RESTART)
    wait(0.05)
    if forcingqreset:
        eventPlayer.setFacing(directionTowards(A[eventPlayer.A], A[eventPlayer.A + 1]), Relativity.TO_WORLD)


def init():
    @Name "제자리로"
    
    if eventPlayer.getCurrentHero() == Hero.GENJI:
        if not A[eventPlayer.A]:
            goto lbl_0
        if eventPlayer == E or eventPlayer.isforcingqreset:
            if forcingqreset == false:
                lbl_0:
                eventPlayer.isforcingqreset = false
            eventPlayer.teleport(A[eventPlayer.A])
            eventPlayer.startForcingPosition(A[eventPlayer.A], false)
            eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.setStatusEffect(null, Status.ROOTED, 0.5)
            eventPlayer.cancelPrimaryAction()
        wait(0.05)
        eventPlayer.F = B[eventPlayer.A]
        eventPlayer.G = C[eventPlayer.A]
        eventPlayer.H = D[eventPlayer.A]
        if eventPlayer.A == len(A) - 1 or not A[1]:
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            eventPlayer.allowButton(Button.CROUCH)
        else:
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(eventPlayer.G == true)
            eventPlayer.setAbility2Enabled(eventPlayer.H == true)
            if I[eventPlayer.A] or not teamHasHero(Hero.HAMMOND, Team.ALL):
                eventPlayer.allowButton(Button.CROUCH)
            else:
                eventPlayer.disallowButton(Button.CROUCH)
        eventPlayer.I = getTotalTimeElapsed()
        if eventPlayer.B:
            goto lbl_1
        eventPlayer.L = getTotalTimeElapsed()
        lbl_1:
        #if random.randint(0, 10):
        #            goto lbl_2
        #if not eventPlayer.R in AP:
        #            goto lbl_3
        #removeFromGame(eventPlayer)
        lbl_2:
        lbl_3:
        #eventPlayer.cancelPrimaryAction()
        wait(0.2)
        eventPlayer.stopForcingPosition()
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.setAbilityCooldown(Button.CROUCH, 0)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
        eventPlayer.S = false
        eventPlayer.setGravity(100)
        playerTime[playerList.index("{0}".format(eventPlayer))] = getTotalTimeElapsed() - eventPlayer.L


rule "부활":
    @Event playerDied
    @Condition A == true
    @Condition eventPlayer.D == false
    
    if eventPlayer == E:
        B[eventPlayer.A] = 0
        C[eventPlayer.A] = 0
        D[eventPlayer.A] = 0
        I[eventPlayer.A] = 0
    eventPlayer.isforcingqreset = true
    init()
    eventPlayer.resurrect()
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)


rule "다시하기":
    @Event eachPlayer
    @Condition eventPlayer == E
    @Condition eventPlayer.isOnGround() == true
    @Condition distance(eventPlayer, A[eventPlayer.A]) > N
    @Condition eventPlayer.isAlive() == true
    @Condition (distance(eventPlayer, A[eventPlayer.A]) < AJ or V and any([distance(eventPlayer.getEyePosition(), player) < 1 for player in V])) == true
    @Condition W == false
    @Condition eventPlayer.hasStatusEffect(Status.ROOTED) == false
    @Condition eventPlayer.isInvincible == false
    
    eventPlayer.P = true
    W = true
    B[eventPlayer.A] = 0
    C[eventPlayer.A] = 0
    D[eventPlayer.A] = 0
    I[eventPlayer.A] = 0
    async(init, AsyncBehavior.RESTART)
    wait(0.1)
    smallMessage(eventPlayer, Y[18])
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.CROUCH)
    W = false
    if forcingqreset:
        eventPlayer.setFacing(eventPlayer.O, Relativity.TO_WORLD)
    eventPlayer.P = false


rule "중간취소":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isInvincible != true
    @Condition A == true
    @Condition (eventPlayer == E and W) == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.getCurrentHero() != Hero.DVA
    
    eventPlayer.bhopCheck = 1
    if eventPlayer == hostPlayer and X and not E and eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.A = len(A) - 2
        eventPlayer.B = eventPlayer.A
        eventPlayer.X = true
        eventPlayer.teleport(A.last())
    else:
        eventPlayer.P = true
        if eventPlayer != E:
            goto lbl_0
        W = true
        lbl_0:
        eventPlayer.teleport(A[eventPlayer.A])
        if eventPlayer == E:
            B[eventPlayer.A] = 0
            C[eventPlayer.A] = 0
            D[eventPlayer.A] = 0
            I[eventPlayer.A] = 0
        eventPlayer.isforcingqreset = true
        async(init, AsyncBehavior.RESTART)
        wait(0.1)
        if eventPlayer != E:
            goto lbl_1
        W = false
        lbl_1:
        if not A[eventPlayer.A + 1]:
            goto lbl_2
        if forcingqreset:
            lbl_2:
            eventPlayer.setFacing(eventPlayer.O, Relativity.TO_WORLD)
        eventPlayer.P = false


rule "개척자위치":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.getVerticalSpeed() > 1
    
    eventPlayer.stopAcceleration()
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "개척시간":
    @Event eachPlayer
    @Condition S == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isInvincible == false
    
    eventPlayer.I = getTotalTimeElapsed()


rule "도착시간초과":
    @Event eachPlayer
    @Condition S == true
    @Condition eventPlayer.isOnGround() == false
    @Condition A[eventPlayer.A + 1] == true
    @Condition R[eventPlayer.A] - (getTotalTimeElapsed() - eventPlayer.I) < 0
    
    async(init, AsyncBehavior.RESTART)
    wait(0.1)
    smallMessage(eventPlayer, Y[21])
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
    if not teamHasHero(Hero.HAMMOND, Team.ALL):
        goto lbl_0
    eventPlayer.applyImpulse(-1 * eventPlayer.getVelocity(), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.teleport(A[eventPlayer.A])
    lbl_0:


rule "땅에닿으면 죽음":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    @Condition A[eventPlayer.A + 1] == true
    @Condition eventPlayer != E
    @Condition distance(eventPlayer, A[eventPlayer.A]) > N
    @Condition distance(eventPlayer, A[eventPlayer.A + 1]) > N
    @Condition eventPlayer.M == false
    @Condition eventPlayer.S == false
    @Condition eventPlayer.X == false
    @Condition eventPlayer.isInvincible == false
    
    eventPlayer.P = true
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
    eventPlayer.isforcingqreset = true
    init()
    wait(0.15)
    if forcingqreset:
        eventPlayer.setFacing(eventPlayer.O, Relativity.TO_WORLD)
    eventPlayer.P = false


rule "도착":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition A[eventPlayer.A + 1] == true
    @Condition E != eventPlayer
    @Condition (not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.X) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.M == false
    @Condition eventPlayer.hasSpawned() == true
    @Condition distance(eventPlayer.getPosition(), A[eventPlayer.A + 1]) < N
    @Condition eventPlayer.S == false
    @Condition eventPlayer.Y == false
    @Condition eventPlayer.isInvincible == false
    
    eventPlayer.A += 1
    if eventPlayer.A == len(A) - 1 and getNumberOfPlayers(Team.ALL) != 1:
        M = false
    if eventPlayer == J and getNumberOfPlayers(Team.ALL) == 1:
        goto lbl_0
    smallMessage(eventPlayer, Y[22])
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 50)
    lbl_0:
    if not (not G or getNumberOfPlayers(Team.ALL) == 1):
        goto lbl_1
    J = false
    lbl_1:
    if eventPlayer.A - eventPlayer.B == 1:
        eventPlayer.B max= eventPlayer.A
        playerLevel[playerList.index("{0}".format(eventPlayer))] = eventPlayer.B
    if eventPlayer != J and not X and not E and len(A) - 1 == eventPlayer.A:
        setMatchTime(AK)
        E = eventPlayer
        B[eventPlayer.A] = 0
        C[eventPlayer.A] = 0
        D[eventPlayer.A] = 0
        I[eventPlayer.A] = 0
        J = eventPlayer
        eventPlayer.X = false
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setAbility2Enabled(true)
        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.allowButton(Button.CROUCH)
    async(init, AsyncBehavior.RESTART)
    if eventPlayer.A != len(A) - 1:
        eventPlayer.O = directionTowards(A[eventPlayer.A], A[eventPlayer.A + 1])
        wait(0.15)
        if forcingqreset:
            eventPlayer.setFacing(eventPlayer.O, Relativity.TO_WORLD)


rule "개척":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer == E
    @Condition distance(A[eventPlayer.A], eventPlayer) >= AJ
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.J == true
    @Condition W == false
    @Condition (V and any([distance(eventPlayer.getEyePosition(), player) <= 1 for player in V])) == false
    # 
    @Condition eventPlayer.isInvincible == false
    #@Condition hostPlayer.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.isforcingqreset = true
    W = true
    U = eventPlayer.getPosition()
    AM = [distance(U, raycast(U, U + angleToDirection(i * 30, -45) * 15, null, null, false).getHitPosition()) for _, i in AM]
    while abs(len(AM.exclude(sorted(AM).last())) - 5.5) < 5.5:
        AM = [AM[(i + 11) % 12] + player + (AM[(i + 1) % 12]) for player, i in AM]
    AN[len(A)] = raycast(U, U + 15 * (angleToDirection(30 * AM.index(sorted(AM).last()), -45)), getAllPlayers(), eventPlayer, true).getHitPosition()
    ([i for i in getPlayersOnHero(Hero.GENJI, Team.1).exclude(eventPlayer) if i.A == eventPlayer.A]).teleport(A.last())
    if not S:
        goto lbl_0
    R[E.A] = getTotalTimeElapsed() + 1 - eventPlayer.I
    lbl_0:
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 50)
    Q = getMatchTime()
    if getNumberOfHeroes(Hero.GENJI, Team.ALL) == 1:
        goto lbl_1
    async(init, AsyncBehavior.RESTART)
    wait(0.1)
    lbl_1:
    if distance(A.last(), U) > AJ:
        smallMessage([player for player in getAllPlayers() if player.A == eventPlayer.A], "{0}{1}".format(eventPlayer, Y[19]))
        A.append(U)
        L.append(eventPlayer.R)
        E = false
        U = false
        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.setAbility1Enabled(eventPlayer.G == true)
        eventPlayer.setAbility2Enabled(eventPlayer.H == true)
        if I[eventPlayer.A] or not teamHasHero(Hero.HAMMOND, Team.ALL):
            eventPlayer.allowButton(Button.CROUCH)
        else:
            eventPlayer.disallowButton(Button.CROUCH)
        if G == 2:
            setMatchTime(AK + 60)
            if len(A) == F:
                bigMessage(eventPlayer, Y[20])
                wait(0.25)
                eventPlayer.setAbility1Enabled(false)
                eventPlayer.setAbility2Enabled(false)
                eventPlayer.setSecondaryFireEnabled(true)
                eventPlayer.disallowButton(Button.CROUCH)
                W = false
                wait(9.75)
                eventPlayer.setSecondaryFireEnabled(true)
                eventPlayer.setAbility1Enabled(C[eventPlayer.A] == true)
                eventPlayer.setAbility2Enabled(D[eventPlayer.A] == true)
                if I[eventPlayer.A]:
                    eventPlayer.allowButton(Button.CROUCH)
                else:
                    eventPlayer.disallowButton(Button.CROUCH)
        wait(0.05)
        M = eventPlayer
        W = false
        if not G or getNumberOfPlayers(Team.ALL) == 1:
            goto lbl_2
        #개척취소시간
        P = AL
        goto lbl_3
        lbl_2:
        P = 120
        lbl_3:
    else:
        W = false


rule "개척 취소":
    @Event eachPlayer
    @Condition eventPlayer == M
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition P == true
    @Condition eventPlayer.isOnGround() == true
    @Condition getMatchTime() == true
    @Condition W == false
    @Condition AG == true
    @Condition eventPlayer.S == false
    
    eventPlayer.S = true
    W = true
    M = false
    del L[len(A) - 1]
    del B[len(A) - 2]
    del C[len(A) - 2]
    del D[len(A) - 2]
    del I[len(A) - 2]
    del R[len(A) - 2]
    del A[len(A) - 1]
    setMatchTime(Q - createWorkshopSetting(int[0:60], "기본설정(Setting)", "개척취소시 줄어드는시간(subtrack time when canle the pioneering)", 3, 4))
    smallMessage([player for player in getAllPlayers() if player.A == len(A) - 1], "{0}{1}".format(eventPlayer, Y[23]))
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.A = len(A) - 1
    eventPlayer.B = eventPlayer.A
    async(init, AsyncBehavior.RESTART)
    wait(0.1)
    E = eventPlayer
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.CROUCH)
    B[eventPlayer.A] = 0
    C[eventPlayer.A] = 0
    D[eventPlayer.A] = 0
    I[eventPlayer.A] = 0
    W = false


rule "우클":
    @Event eachPlayer
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    if eventPlayer == E:
        B[len(A) - 1] += 1
    elif T and eventPlayer.A != len(A) - 1 and len(A) > 1:
        eventPlayer.F -= 1
        if eventPlayer.F < 1:
            while eventPlayer.isFiringSecondaryFire():
                wait(0.25, Wait.RESTART_WHEN_TRUE)
            if eventPlayer.isOnGround() or eventPlayer.F > 0:
                goto lbl_0
            wait(1, Wait.RESTART_WHEN_TRUE)
            if eventPlayer.isOnGround() or eventPlayer.F > 0:
                goto lbl_1
            eventPlayer.setSecondaryFireEnabled(true)
            lbl_0:
            lbl_1:


rule "시프트":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1() == true
    
    if eventPlayer == E:
        C[len(A) - 1] += 1
    elif T and eventPlayer.A != len(A) - 1 and len(A) > 1:
        eventPlayer.G -= 1
        if eventPlayer.G > 0:
            goto lbl_0
        while eventPlayer.isUsingAbility1():
            wait(0.25, Wait.RESTART_WHEN_TRUE)
        if eventPlayer.isOnGround() or eventPlayer.G > 0:
            goto lbl_1
        eventPlayer.setAbility1Enabled(false)
        lbl_0:
        lbl_1:


rule "E":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility2() == true
    
    if eventPlayer == E:
        D[len(A) - 1] += 1
    elif T and eventPlayer.A != len(A) - 1 and len(A) > 1:
        eventPlayer.H -= 1
        if eventPlayer.H > 0:
            goto lbl_0
        while eventPlayer.isUsingAbility2():
            wait(0.25, Wait.RESTART_WHEN_TRUE)
        if eventPlayer.isOnGround() or eventPlayer.H > 0:
            goto lbl_1
        eventPlayer.setAbility2Enabled(false)
        lbl_0:
        lbl_1:


rule "단계이동":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition A == true
    @Condition eventPlayer != E
    @Condition (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)) == true
    @Condition eventPlayer.S == false
    
    eventPlayer.isforcingqreset = true
    eventPlayer.isInvincible = false
    if not S:
        goto lbl_0
    stopChasingVariable(eventPlayer.I)
    lbl_0:
    stopChasingVariable(eventPlayer.L)
    eventPlayer.S = true
    eventPlayer.Y = true
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    if eventPlayer.isHoldingButton(Button.JUMP):
        if G and eventPlayer.A == eventPlayer.B or not G and eventPlayer.A == len(A) - 1:
            eventPlayer.A = 0
        else:
            eventPlayer.A += 1
    else:
        if eventPlayer.A:
            eventPlayer.A -= 1
        elif G:
            eventPlayer.A = eventPlayer.B
        else:
            eventPlayer.A = len(A) - 1
    if eventPlayer.C:
        goto lbl_1
    eventPlayer.setFacing(directionTowards(A[eventPlayer.A], A[eventPlayer.A + 1]), Relativity.TO_WORLD)
    async(init, AsyncBehavior.RESTART)
    lbl_1:
    wait(0.1)
    if eventPlayer.C:
        goto lbl_2
    eventPlayer.Y = false
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.C = true
    lbl_2:
    if RULE_CONDITION:
        goto RULE_START
    eventPlayer.C = false
    eventPlayer.setFacing(directionTowards(A[eventPlayer.A], A[eventPlayer.A + 1]), Relativity.TO_WORLD)
    async(init, AsyncBehavior.RESTART)
    eventPlayer.Y = false


rule "승리":
    @Event eachPlayer
    @Condition H == false
    @Condition G == 2
    @Condition eventPlayer.A >= F - 1
    
    bigMessage(getAllPlayers(), "{0}{1}".format(eventPlayer, Y[24]))
    H = true
    wait(10)
    if Gamemode.FFA == getCurrentGamemode():
        declarePlayerVictory(eventPlayer)
    else:
        declareTeamVictory(eventPlayer.getTeam())


rule "개척시간제한":
    @Condition isGameInProgress() == true
    @Condition getMatchTime() == false
    @Condition H == false
    @Condition W == false
    @Condition any([i == getCurrentGamemode() for i in [Gamemode.CTF, Gamemode.ELIMINATION, Gamemode.PRACTICE_RANGE]]) == false
    
    W = true
    if E and G and getNumberOfPlayers(Team.ALL) > 1:
        M = false
        if len(A) > 1:
            goto lbl_0
        E = random.choice(getAllPlayers().exclude(E))
        goto lbl_1
        lbl_0:
        E = random.choice(([player for player in getAllPlayers() if player.B == len(A) - 1]).exclude(E))
        lbl_1:
        if not A:
            goto lbl_2
        E.teleport(A.last())
        lbl_2:
        if not G or getNumberOfPlayers(Team.ALL) == 1:
            goto lbl_3
        J = E
        lbl_3:
        E.A = E.B
    setMatchTime(AK)
    W = false


rule "시간으로종료":
    @Condition isGameInProgress() == true
    @Condition getMatchTime() == false
    @Condition H == false
    @Condition E == false
    @Condition J == true
    @Condition G == 2
    @Condition W == false
    @Condition any([i == getCurrentGamemode() for i in [Gamemode.CTF, Gamemode.ELIMINATION, Gamemode.PRACTICE_RANGE]]) == false
    
    W = true
    bigMessage(getAllPlayers(), "{0}{1}".format(J, Y[24]))
    H = true
    wait(10)
    if Gamemode.FFA == getCurrentGamemode():
        declarePlayerVictory(J)
    else:
        declareTeamVictory(J.getTeam())


rule "탈주시":
    @Event playerLeft
    @Condition E == eventPlayer
    
    W = true
    setMatchTime(AK)
    if len(A) > 1:
        goto lbl_0
    E = random.choice(getAllPlayers().exclude(eventPlayer))
    goto lbl_1
    lbl_0:
    E = random.choice([i for i in getAllPlayers().exclude(eventPlayer) if i.B == len(A) - 1])
    lbl_1:
    if not A:
        goto lbl_2
    E.teleport(A.last())
    lbl_2:
    if not G or getNumberOfPlayers(Team.ALL) == 1:
        goto lbl_3
    J = E
    lbl_3:
    E.A = E.B
    W = false


rule "모드변경":
    @Condition A == false
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition O[1] == true
    
    G -= 1
    if G >= 0:
        goto lbl_0
    G = 2
    lbl_0:
    destroyHudText(O[1])
    if not G:
        hudHeader(getAllPlayers(), Y[25], HudPosition.TOP, -1, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        disableAnnouncer()
        disableMusic()
    elif G == 1:
        disableAnnouncer()
        disableMusic()
        hudHeader(getAllPlayers(), Y[9], HudPosition.TOP, -1, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    else:
        enableAnnouncer()
        enableMusic()
        hudHeader(getAllPlayers(), Y[26], HudPosition.TOP, -1, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    O[1] = getLastCreatedText()


rule "횟수제한넣을지":
    @Event eachPlayer
    @Condition A == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer == hostPlayer
    
    T = not T


rule "시간제한넣을지":
    @Event eachPlayer
    @Condition A == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer == hostPlayer
    
    S = not S


rule "투명화":
    @Event eachPlayer
    @Condition A == true
    @Condition teamHasHero(Hero.HAMMOND, Team.ALL) == false
    @Condition (eventPlayer.U or eventPlayer == E or (distance(eventPlayer, getClosestPlayer(eventPlayer, Team.ALL)) < 2 if auto_invisible else false)) != eventPlayer.W
    
    eventPlayer.W = not eventPlayer.W
    if eventPlayer.W:
        eventPlayer.setInvisibility(Invis.ALL)
    else:
        eventPlayer.setInvisibility(Invis.NONE)


rule "투명화":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicating(Comms.HELLO) == true
    
    eventPlayer.U = not eventPlayer.U
    if eventPlayer.U:
        smallMessage(eventPlayer, Y[39])
    else:
        smallMessage(eventPlayer, Y[40])


rule "인스펙터저장":
    @Condition A == true
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == true
    @Condition hostPlayer.isOnGround() == true
    
    playEffect(hostPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, hostPlayer, 50)
    if X:
        goto lbl_0
    K = hostPlayer.R
    lbl_0:
    AA = hostPlayer.isHoldingButton(Button.CROUCH)
    if AA:
        smallMessage(hostPlayer, Y[31])
    else:
        smallMessage(hostPlayer, Y[27])
    hostPlayer.V = Y
    Y = 0
    hostPlayer.Z = AP
    AP = 0
    hostPlayer.texttemp = text
    text = 0
    hostPlayer.playerlisttemp = playerList
    playerList = 0
    hostPlayer.playerleveltemp = playerLevel
    playerLevel = 0
    hostPlayer.playertimetemp = playerTime
    playerTime = 0
    hostPlayer.Dvapostemp = DvaPos
    DvaPos = 0
    enableInspector()
    disableInspector()
    Y = hostPlayer.V
    hostPlayer.V = 0
    AP = hostPlayer.Z
    hostPlayer.Z = 0
    text = hostPlayer.texttemp
    hostPlayer.texttemp = 0
    playerList = hostPlayer.playerlisttemp
    hostPlayer.playerlisttemp = 0
    playerLevel = hostPlayer.playerleveltemp
    hostPlayer.playerleveltemp = 0
    playerTime = hostPlayer.playertimetemp
    hostPlayer.playertimetemp = 0
    DvaPos = hostPlayer.Dvapostemp
    hostPlayer.Dvapostemp = 0


rule "개척취소제한":
    @Condition M == true
    @Condition P == false
    
    M = false


rule "관전":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) != true
    @Condition A == true
    @Condition (eventPlayer.D or (eventPlayer != M and (eventPlayer.B != len(A) - 1 or (not (E or M))))) == true
    @Condition AF == true
    @Condition (eventPlayer == E and M) == false
    
    eventPlayer.D = not eventPlayer.D
    if eventPlayer.D:
        eventPlayer.disableRespawn()
        chase(eventPlayer.L, 100000000, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        kill(eventPlayer, null)
        if eventPlayer.E:
            goto lbl_0
        eventPlayer.E = true
        wait(0.1)
        eventPlayer.forceButtonPress(Button.JUMP)
        lbl_0:
        eventPlayer.isInvinciblePossible = false
        eventPlayer.isInvincible = false
    else:
        eventPlayer.enableRespawn()
        if not S:
            goto lbl_1
        stopChasingVariable(eventPlayer.I)
        lbl_1:
        stopChasingVariable(eventPlayer.L)
        eventPlayer.resurrect()
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
        eventPlayer.isforcingqreset = true
        init()
        eventPlayer.isInvinciblePossible = true
    wait(0.4)


rule "클리어":
    @Event eachPlayer
    @Condition X == true
    @Condition eventPlayer.B == X
    @Condition eventPlayer.R == true
    
    smallMessage(getAllPlayers(), "{0} {1}".format(eventPlayer, Y[28]))
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    if eventPlayer.R in AC and getTotalTimeElapsed() - eventPlayer.L > AB[AC.index(eventPlayer.R)]:
        goto lbl_0
    eventPlayer.N = getTotalTimeElapsed() - eventPlayer.L
    del AB[AC.index(eventPlayer.R)]
    del AD[AC.index(eventPlayer.R)]
    del AC[AC.index(eventPlayer.R)]
    AB.append(eventPlayer.N)
    AC.append(eventPlayer.R)
    AD.append(eventPlayer.N if timerSetting else "{0}:{1}".format(floor(eventPlayer.N / 60), floor(eventPlayer.N % 60)))
    goto lbl_1
    lbl_0:
    if AB[AC.index(eventPlayer.R)] > getTotalTimeElapsed() - eventPlayer.L:
        goto lbl_2
    eventPlayer.N = AB[AC.index(eventPlayer.R)]
    lbl_1:
    lbl_2:
    eventPlayer.K = "{0} {1}".format(eventPlayer.N if timerSetting else "{0}:{1}".format(floor(eventPlayer.N / 60), floor(eventPlayer.N % 60)), Y[28])


rule "다시시작":
    @Event eachPlayer
    @Condition X == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    eventPlayer.isInvincible = false
    if not S:
        goto lbl_0
    stopChasingVariable(eventPlayer.I)
    lbl_0:
    stopChasingVariable(eventPlayer.L)
    eventPlayer.M = true
    eventPlayer.K = false
    eventPlayer.A = 0
    eventPlayer.B = 0
    eventPlayer.isforcingqreset = true
    async(init, AsyncBehavior.RESTART)
    wait(0.1)
    eventPlayer.M = false
    smallMessage(eventPlayer, Y[29])
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)


rule "방향저장":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.P == false
    
    eventPlayer.O = eventPlayer.getFacingDirection()


rule "다음위치보기":
    @Event eachPlayer
    @Condition (not W and eventPlayer.isOnGround() and eventPlayer != M and A[eventPlayer.A + 1] and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)) != eventPlayer.Q
    @Condition eventPlayer.isInvincible == false
    
    eventPlayer.Q = not eventPlayer.Q
    if eventPlayer.Q:
        eventPlayer.setPrimaryFireEnabled(false)
        eventPlayer.Q = AN[eventPlayer.A + 1]
        eventPlayer.startCamera(eventPlayer.Q, A[eventPlayer.A + 1], 0)
        eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
        eventPlayer.cancelPrimaryAction()
        eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.01, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.teleport(A[eventPlayer.A])
    else:
        eventPlayer.stopCamera()
        eventPlayer.clearStatusEffect(Status.ROOTED)
        eventPlayer.setPrimaryFireEnabled(true)
    wait()
    if RULE_CONDITION:
        goto RULE_START


/*
rule "----------------------------------------------------겐지파쿠르-----------------------------------------------------":
*/

def genjiparkour():
    @Name "겐지파쿠르 설정"
    
    #↓맵 코드를 적어주세요↓
    MapCode = ""
    hudSubheader(localPlayer, "11.15", HudPosition.LEFT, -99, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    if MapCode == "":
        goto lbl_0
    hudSubtext(localPlayer, "맵 코드 : {0}".format(MapCode), HudPosition.LEFT, -14, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    lbl_0:
    hudSubtext(localPlayer, " ", HudPosition.LEFT, 10.5, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudHeader(localPlayer if localPlayer.isInvincible else null, "연습모드", HudPosition.LEFT, 11, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    if "{0}".format(Hero.GENJI) == "겐지":
        Z = 1
        #한국
        text = ["벽타기", "콩콩이", "벽타기 사용", "콩콩이 사용", "앉콩", "연습모드 / 일반모드", "연습모드", "일반모드", "삼단점프 금지됨", "벽캔 금지됨", "앉콩 금지됨", "감정표현 금지됨", "벽타기 금지됨", "콩콩이 금지됨"]
    elif "{0}".format(Hero.GENJI) == "源氏":
        Z = 2
        #중국
        text = ["爬墙", "小跳", "爬墙已用", "小跳已用", "success", "无敌探点", "invincible mode", "normal mode", "Triple Jump is Disabled", "Multiclimb is Disabled", "Add Bhop is Disabled", "Emote jumping is Disabled", "Climb is Disabled", "Bhop is Disabled"]
    elif "{0}".format(Hero.GENJI) == "ゲンジ":
        Z = 3
        #일본
        text = ["climb", "bhop", "use climb", "use bhop", "success", "invincible / normal", "invincible mode", "normal mode", "Triple Jump is Disabled", "Multiclimb is Disabled", "Add Bhop is Disabled", "Emote jumping is Disabled", "Climb is Disabled", "Bhop is Disabled"]
    else:
        text = ["climb", "bhop", "use climb", "use bhop", "success", "invincible / normal", "invincible mode", "normal mode", "Triple Jump is Disabled", "Multiclimb is Disabled", "Add Bhop is Disabled", "Emote jumping is Disabled", "Climb is Disabled", "Bhop is Disabled"]
    bannedSkills = []
    if not createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "벽타기(Climb)", true, 2):
        bannedSkills.append("벽타기")
    if not createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "콩콩이(Bhop)", true, 3):
        bannedSkills.append("콩콩이")
    if not createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "삼단점프(triple jump)", true, 4):
        bannedSkills.append("삼단점프")
    if not createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "감정표현(emote)", true, 5):
        bannedSkills.append("감정표현")
    if not createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "벽캔(multiclimb)", true, 6):
        bannedSkills.append("벽캔")
    if not createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "앉콩(add bhop)", true, 7):
        bannedSkills.append("앉콩")
    if not (bannedSkills and createWorkshopSetting(bool, "UI 설정(UI setting)", "금지된 스킬 표시(show banned skills)", true, 6)):
        goto lbl_1
    hudSubtext(localPlayer, "금지된 기술 : {0}".format(("{0}{1}".format(bannedSkills, (", {0}{1}".format(bannedSkills[1], (", {0}{1}".format(bannedSkills[2], (", {0}{1}".format(bannedSkills[3], (", {0}{1}".format(bannedSkills[4], ", {0}".format(bannedSkills[5]) if bannedSkills[5] else "")) if bannedSkills[4] else "")) if bannedSkills[3] else "")) if bannedSkills[2] else "")) if bannedSkills[1] else "")) if true else 0), HudPosition.TOP, -2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    lbl_1:
    ColorList = [Color.WHITE, Color.YELLOW, Color.GREEN, Color.PURPLE, Color.RED, Color.BLUE, Color.AQUA, Color.ORANGE, Color.SKY_BLUE, Color.TURQUOISE, Color.LIME_GREEN, Color.BLACK, Color.ROSE, Color.VIOLET, Color.GRAY]
    forcingqreset = createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "도착 시 강제로 재위치(forcing quick reset when you reach cp)", true, 1)
    invincible = createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "연습모드(Invincible mode)", true, 0)
    auto_invisible = createWorkshopSetting(bool, "파쿠르 설정(Parkour Setting)", "자동 투명화(Auto Invisible)", true, 9)
    currentCpColor = createWorkshopSetting(enum["white", "yellow", "green", "pruple", "red", "blue", "auqa", "orange", "sky blue", "turquoise", "lime green", "black", "rose", "violet", "gray"], "파쿠르 설정(Parkour Setting)", "현재 개척지 색(current checkpoint color)", 5, 10)
    nextCpRingColor = createWorkshopSetting(enum["white", "yellow", "green", "pruple", "red", "blue", "auqa", "orange", "sky blue", "turquoise", "lime green", "black", "rose", "violet", "gray"], "파쿠르 설정(Parkour Setting)", "다음 개척지 색(next checkpoint ring color)", 3, 11)
    nextCpLightShaftColor = createWorkshopSetting(enum["None", "white", "yellow", "green", "pruple", "red", "blue", "auqa", "orange", "sky blue", "turquoise", "lime green", "black", "rose", "violet", "gray"], "파쿠르 설정(Parkour Setting)", "다음 개척지 기둥 색(next checkpoint lightshaft color)", 0, 12)
    next2CpTextColor = createWorkshopSetting(enum["None", "white", "yellow", "green", "pruple", "red", "blue", "auqa", "orange", "sky blue", "turquoise", "lime green", "black", "rose", "violet", "gray"], "파쿠르 설정(Parkour Setting)", "다다음 개척지 표시 색(checkpoint color after next Cp)", 0, 13)
    timerSetting = createWorkshopSetting(enum["1;23 (min;sec)", "12.34 (sec)"], "파쿠르 설정(Parkour Setting)", "타이머 설정(Timer Setting)", 0, 14)
    bhop = createWorkshopSetting(bool, "UI 설정(UI setting)", "콩콩이 표시(bhop box)", true, 2)
    bhoptext = createWorkshopSetting(bool, "UI 설정(UI setting)", "콩콩이 텍스트(bhop small message)", true, 4)
    climb = createWorkshopSetting(bool, "UI 설정(UI setting)", "벽타기 표시(climb box)", true, 1)
    climbtext = createWorkshopSetting(bool, "UI 설정(UI setting)", "벽타기 텍스트(climb small message)", true, 3)
    createbhoptext = createWorkshopSetting(bool, "UI 설정(UI setting)", "앉콩 텍스트(addbhop small message)", true, 5)
    Dva = 1


rule "연습모드":
    @Event eachPlayer
    @Condition (eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.INTERACT)) == true
    @Condition eventPlayer.isInvinciblePossible == true
    @Condition invincible == true
    
    if eventPlayer.isInvincible == false:
        if not S:
            goto lbl_0
        chase(eventPlayer.I, 100000000, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        chase(eventPlayer.L, 100000000, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        eventPlayer.isInvincible = true
        eventPlayer.save_skill = eventPlayer.G
        eventPlayer.setAbility1Enabled(true)
        bigMessage(eventPlayer, text[6])
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    elif eventPlayer.isInvincible == true:
        if not S:
            goto lbl_1
        stopChasingVariable(eventPlayer.I)
        lbl_1:
        stopChasingVariable(eventPlayer.L)
        eventPlayer.G = eventPlayer.save_skill
        bigMessage(eventPlayer, text[7])
        eventPlayer.isInvincible = false
        if O:
            goto lbl_2
        eventPlayer.teleport(A[eventPlayer.A])
        eventPlayer.isforcingqreset = true
        init()
        lbl_2:


rule "연습모드 스킬 세팅":
    @Event eachPlayer
    @Condition eventPlayer.isInvincible == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.G = eventPlayer.G + 1
    wait(0.5)
    if not eventPlayer.isInvincible:
        goto lbl_0
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbility1Enabled(true)
    lbl_0:


rule "연습모드 스킬 세팅 2":
    @Event playerDied
    @Condition eventPlayer.isInvincible == true
    
    wait(0.25)
    eventPlayer.setAbility1Enabled(true)


rule "판단 | 점프":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.check != 2
    
    eventPlayer.check += 1


rule "판단 | 콩콩이":
    @Event eachPlayer
    @Condition eventPlayer.check == 0
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.bhopCheck = 0


rule "판단 | 삼단점프 1":
    @Event eachPlayer
    @Condition eventPlayer.check == 1
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.check = 2


rule "판단 | 삼단점프 2":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.check == 0
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.check = 1


rule "판단 | 벽타기":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.climbCheck = true
    if eventPlayer.isInvincible:
        goto lbl_0
    eventPlayer.climbCnt += 1
    lbl_0:
    eventPlayer.check = 2
    if eventPlayer.climbCnt < 2:
        goto lbl_1
    eventPlayer.isforcingqreset = true
    init()
    goto lbl_2
    lbl_1:
    if "벽타기" in bannedSkills:
        lbl_2:
        eventPlayer.isforcingqreset = true
        init()
        smallMessage(eventPlayer, text[12])
    elif climbtext:
        smallMessage(eventPlayer, text[2])


rule "판단 | 벽캔":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.climbCheck == false
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.multiclimbCheck += 1


rule "판단 | 감정표현":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    eventPlayer.bhopCheck = 0


rule "판단 | 앉콩":
    @Event eachPlayer
    @Condition eventPlayer.isCrouching() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isOnGround() == false
    
    eventPlayer.bhopCheck = 0
    if "앉콩" in bannedSkills:
        eventPlayer.isforcingqreset = true
        init()
        smallMessage(eventPlayer, text[10])
    else:
        if bhop:
            eventPlayer.bhopColor = Color.GREEN
        if createbhoptext:
            smallMessage(eventPlayer, text[4])


rule "판단 | 착지":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.multiclimbCheck = 0
    eventPlayer.climbCheck = false
    if not eventPlayer.isInvincible and distance(eventPlayer.getPosition(), A[eventPlayer.A]) > N:
        goto lbl_0
    eventPlayer.check = 0
    lbl_0:
    wait(0)
    if eventPlayer.check != 0 and eventPlayer.isOnGround() == true:
        goto RULE_START
    eventPlayer.bhopCheck = 1


rule "판단 | 땅버그":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    #@Condition distance(eventPlayer, A[eventPlayer.A]) < N
    #@Condition distance(eventPlayer, A[eventPlayer.A + 1]) < N
    @Condition (distance(eventPlayer, A[eventPlayer.A]) < N or distance(eventPlayer, A[eventPlayer.A + 1]) < N) == true
    
    eventPlayer.climbCnt = 0


rule "콩콩이 HUD 생성":
    @Event playerJoined
    @Condition bhop == true
    @Condition eventPlayer.hasSpawned() == true
    
    hudHeader(eventPlayer, text[1], HudPosition.LEFT, 10, eventPlayer.bhopColor, HudReeval.COLOR, SpecVisibility.DEFAULT)


rule "콩콩이 가능":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition bhop == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.bhopColor = Color.GREEN


rule "콩콩이 불가":
    @Event eachPlayer
    @Condition eventPlayer.isJumping() == true
    @Condition bhop == true
    
    eventPlayer.bhopColor = Color.RED
    if eventPlayer.bhopCheck == 0:
        eventPlayer.bhopCheck = 1
        if "콩콩이" in bannedSkills:
            eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
            smallMessage(eventPlayer, text[13])
        elif bhoptext:
            smallMessage(eventPlayer, text[3])


rule "벽타기 가능":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition climb == true
    
    hudHeader(eventPlayer if not eventPlayer.climbCheck else null, "{0}{1}".format(text[0], "({0})".format(eventPlayer.multiclimbCheck) if eventPlayer.multiclimbCheck > 0 else ""), HudPosition.LEFT, 9, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "벽타기 불가":
    @Event eachPlayer
    @Condition climb == true
    
    hudHeader([i for i in eventPlayer if i.climbCheck == true], text[0], HudPosition.LEFT, 9, Color.RED, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)


rule "금지 | 삼단점프":
    @Event eachPlayer
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.check == 1
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition "삼단점프" in bannedSkills == true
    
    if eventPlayer.isOnWall() == true:
        return
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    smallMessage(eventPlayer, text[8])


rule "금지 | 감정표현":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    @Condition "감정표현" in bannedSkills == true
    
    eventPlayer.isforcingqreset = true
    init()
    smallMessage(eventPlayer, text[11])
    eventPlayer.bhopCheck = 1


rule "금지 | 벽캔":
    @Event eachPlayer
    @Condition eventPlayer.multiclimbCheck > 0
    @Condition "벽캔" in bannedSkills == true
    
    eventPlayer.isforcingqreset = true
    init()
    smallMessage(eventPlayer, text[9])


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

    
rule "플레이어 초기 설정":
    @Event playerJoined
    
    eventPlayer.isInvinciblePossible = true
    if "{0}".format(eventPlayer) in playerList or eventPlayer.getCurrentHero() == Hero.DVA:
        goto lbl_0
    playerList.append("{0}".format(eventPlayer))
    lbl_0:
    if O:
        goto lbl_1
    eventPlayer.isInvincible = true
    lbl_1:


rule "플레이어 단계 로드":
    @Event playerJoined
    @Condition "{0}".format(eventPlayer) in playerList == true
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.B = playerLevel[playerList.index("{0}".format(eventPlayer))]
    eventPlayer.A = playerLevel[playerList.index("{0}".format(eventPlayer))]
    eventPlayer.L = getTotalTimeElapsed() - playerTime[playerList.index("{0}".format(eventPlayer))]
    init()


rule "test":
    @Event eachPlayer
    
    #hudHeader(eventPlayer, eventPlayer.climbCnt, HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "{0} / {1}".format(dvacnt, len(DvaPos)), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


