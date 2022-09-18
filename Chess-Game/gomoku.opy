settings {
    "main": {
        "modeName": "오목/gomoku",
        "description": "제작: 깨꾸/코드(latest code): 33YES/ https://discord.gg/DKvxxD2bTJ"
    },
    "lobby": {
        "ffaSlots": 8,
        "enableMatchVoiceChat": true,
        "allowPlayersInQueue": true,
        "spectatorSlots": 12
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "lijiangNightMarket"
            ]
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "enableRandomHeroes": true,
            "respawnTime%": 0,
            "spawnHealthPacks": "disabled",
            "heroLimit": "off",
            "enableKillCam": false
        }
    },
    "heroes": {
        "allTeams": {
            "hanzo": {
                "enableUlt": false,
                "enablePrimaryFire": false,
                "enableMelee": false
                # 음파 화살: 비활성화
				# 이단뛰기: 비활성화
				# 폭풍 화살: 비활성화
            },
            "enabledHeroes": [
                "hanzo"
            ]
        }
    }
}

#Activated extensions

#!extension playMoreEffects


rule "초기설정":
    #시간
    L = createWorkshopSetting(int[5:100], "설정(Setting)", "제한시간(time limit)", 30, 0)
    V = createWorkshopSetting(bool, "설정(Setting)", "렌주룰(Renju)", true, 0)
    #판크기=H*2+1
    H = 7
    #중심위치
    B = vect(100, 0, 0)
    #알 크기
    O = 4
    #커서오차보정
    R = O * H / -4
    #커서민감도
    Q = O * H * 0.09
    if getCurrentMap() == Map.LIJIANG_NIGHT_MARKET:
        #중심위치
        B = vect(1, -1, -61)
        #알 크기
        O = 1
        #커서오차보정
        R = -1.2
        #커서민감도
        Q = 0.083
    disableInspector()
    if "{0}".format(Hero.GENJI) == "겐지":
        J = [" 차례", "연승중!", "대기목록", "남은 시간 ", "기권", "제작: 깨꾸\r\n코드: 33YES\r\n육목도 있어요!(EE8ZM)\r\n감도 조절", "목입니다.", "44입니다.", "33입니다.", " 기권", " 승리"]
    elif "{0}".format(Hero.GENJI) == "源氏":
        J = [" 连胜", "连胜", "名单", "剩余时间：", "放弃", "made by youtube 'kaeku'\r\ncode: 33YES\r\n灵敏度控制", "行", "44", "33", " 放弃", " 胜利"]
    elif "{0}".format(Hero.GENJI) == "ゲンジ":
        J = ["の順番", "連勝", "待機リスト", "残り時間：", "棄権", "made by youtube 'kaeku'\r\ncode: 33YES\r\n感度制御", "行", "44", "33", "棄権した。", "勝利"]
    else:
        J = ["'s turn", " winning streak", "wating list", "time remaining: ", "give up", "made by youtube 'kaeku'\r\ncode: 33YES\r\nSensitivity control", " row", "44", "33", " gave up.", " win"]
    G = []
    M = B + (vect(O * (-1 - H), 0, 0))
    N = []
    A = B + vect(0, O * H * 1.6, 0)
    R = B + vect(0, 0, R)
    hudHeader(getAllPlayers(), "{0}{1}".format(G[1] if P else G, J[0]), HudPosition.LEFT, -3, Color.AQUA if P else Color.ORANGE, HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    hudHeader([player for player in getAllPlayers() if E > 1], "{0} {1}{2}".format(D, E, J[1]), HudPosition.LEFT, -5, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader([player for player in getAllPlayers() if getNumberOfPlayers(Team.ALL) > 2], J[2], HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), "{0} vs {1}".format(G[0], G[1]), HudPosition.LEFT, -4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    disableGamemodeCompletion()
    hudHeader(getAllPlayers(), "{1}{0}".format(ceil(getMatchTime()), J[3]), HudPosition.LEFT, -5, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    disableMusic()
    setMatchTime(0.1)
    hudText(getAllPlayers(), null, " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, -0.1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), J[4], M, 2, Clip.NONE, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
    createIcon(G[0], G[0].I + R, Icon.ARROW_UP, IconReeval.VISIBILITY_AND_POSITION, Color.RED, false)
    createIcon(G[1], G[1].I + R, Icon.ARROW_UP, IconReeval.VISIBILITY_AND_POSITION, Color.RED, false)
    I = [Vector.LEFT, Vector.FORWARD, Vector.LEFT + Vector.FORWARD, Vector.LEFT + Vector.BACKWARD]
    wait(1)
    setMatchTime(L)
    hudSubtext(getAllPlayers(), "{0}: {1}, {2}".format(J[5], buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_2)), HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    disableAnnouncer()
    Sub1()


rule "접속":
    @Event playerJoined
    
    wait(0.35)
    G.append(eventPlayer)
    eventPlayer.startCamera(A, B, 0)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.setInvisibility(Invis.ALL)
    hudHeader([player for player in getAllPlayers() if G.index(eventPlayer) > 1], eventPlayer, HudPosition.RIGHT, G.index(eventPlayer), Color.BLUE if eventPlayer == localPlayer else Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    eventPlayer.disableHeroHUD()


rule "선수":
    @Event eachPlayer
    @Condition eventPlayer in G.slice(0, 2) == true
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.I = B
    eventPlayer.D = []
    chase(eventPlayer.I, Q * (vect(eventPlayer.getHorizontalFacingAngle(), 0, -1 * eventPlayer.getVerticalFacingAngle())), rate=10000, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.A = B
    chase(eventPlayer.A, B + vect(round(eventPlayer.I.x / O) * O, 0, round(eventPlayer.I.z / O) * O), rate=1000, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.setFacing(Vector.FORWARD, Relativity.TO_WORLD)


rule "시작":
    @Event eachPlayer
    @Condition eventPlayer == G[1]
    @Condition C == false
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    K = B + vect(0, 0.1, 0)
    N.append(B)
    eventPlayer.D.append(B)
    createEffect(P, Effect.GOOD_AURA, Color.ORANGE, K, O / 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if not P], Effect.GOOD_AURA, Color.AQUA, K, O / 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.AQUA, B, O / 2, EffectReeval.VISIBILITY)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, B, O / 2)
    setMatchTime(L)
    P = false


rule "두기":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == G[P]
    @Condition C == false
    @Condition K == true
    @Condition eventPlayer.A in N == false
    @Condition abs((eventPlayer.A - B).x) <= O * H
    @Condition abs((eventPlayer.A - B).z) <= O * H
    
    eventPlayer.W = []
    eventPlayer.X = []
    eventPlayer.Y = eventPlayer.A
    eventPlayer.Z = []
    eventPlayer.AB = eventPlayer.A
    eventPlayer.AD = []
    Sub0()
    if P and V:
        if eventPlayer.L > 5:
            smallMessage(eventPlayer, "{0}{1}".format(eventPlayer.L, J[6]))
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, A, 50)
            return
        elif eventPlayer.Q > 1 or eventPlayer.J:
            smallMessage(eventPlayer, J[7])
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, A, 50)
            return
        elif eventPlayer.K > 1:
            eventPlayer.AF = false
            for eventPlayer.AD in range(4):
                if eventPlayer.X[eventPlayer.AD]:
                    for eventPlayer.AE in range(len(eventPlayer.X[eventPlayer.AD])):
                        eventPlayer.Z = eventPlayer.AB
                        eventPlayer.Y = eventPlayer.X[eventPlayer.AD][eventPlayer.AE]
                        Sub0()
                        if eventPlayer.AH and eventPlayer.L < 6 and eventPlayer.Q < 2 and not eventPlayer.J and eventPlayer.K < 2:
                            if eventPlayer.AF:
                                smallMessage(eventPlayer, J[8])
                                playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, A, 50)
                                return
                            eventPlayer.AF = true
                            break
    N.append(eventPlayer.AB)
    eventPlayer.D.append(eventPlayer.AB)
    K = eventPlayer.AB + vect(0, 0.1, 0)
    setMatchTime(L)
    wait(0)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, A, 300)
    if P:
        createEffect(getAllPlayers(), Effect.SPHERE, Color.AQUA, eventPlayer.AB, O / 2, EffectReeval.VISIBILITY)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.AQUA, eventPlayer.A, O / 2)
    else:
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.AB, O / 2, EffectReeval.VISIBILITY)
        playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.A, O / 2)
    P = not P


def Sub0():
    @Name "판별"
    
    eventPlayer.J = false
    eventPlayer.K = false
    eventPlayer.Q = false
    eventPlayer.AH = false
    for eventPlayer.N in range(4):
        if not eventPlayer.Z or eventPlayer.X[eventPlayer.N]:
            eventPlayer.H = 1
            eventPlayer.L = 1
            eventPlayer.C = false
            eventPlayer.G = false
            eventPlayer.T = false
            eventPlayer.O = false
            eventPlayer.U = false
            eventPlayer.AA = []
            eventPlayer.AG = false
            for eventPlayer.M in range(-1, 3, 2):
                if P and V:
                    if [1, 2, 1, 1] == eventPlayer.P.slice(0, 4) and eventPlayer.P[4] != 1:
                        eventPlayer.S = [2, 1, 1]
                    elif [2, 1, 1] == eventPlayer.P.slice(0, 3) and eventPlayer.P[3] != 1:
                        eventPlayer.S = [1, 2, 1, 1]
                        eventPlayer.C = true
                    elif [1, 2, 1] == eventPlayer.P.slice(0, 3) and eventPlayer.P[3] != 1:
                        eventPlayer.S = [1, 2, 1]
                        eventPlayer.T = true
                    elif [1, 1, 2, 1] == eventPlayer.P.slice(0, 4) and eventPlayer.P[4] != 1:
                        eventPlayer.S = [2, 1]
                    elif [2, 1] == eventPlayer.P.slice(0, 2) and eventPlayer.P[2] != 1:
                        eventPlayer.S = [1, 1, 2, 1]
                        if eventPlayer.P[2] == 2:
                            eventPlayer.G = true
                        eventPlayer.C = true
                    else:
                        if [1, 1, 1, 2, 2] == eventPlayer.P:
                            eventPlayer.AC = [2]
                        elif 2 == eventPlayer.P[0] and eventPlayer.P[1] != 1:
                            eventPlayer.AC = [1, 1, 1, 2, 2]
                        else:
                            eventPlayer.AC = []
                        eventPlayer.S = false
                    eventPlayer.P = []
                    eventPlayer.F = false
                    eventPlayer.R = false
                    eventPlayer.V = false
                for eventPlayer.E in range(1, 6):
                    eventPlayer.B = eventPlayer.Y + O * eventPlayer.M * eventPlayer.E * I[eventPlayer.N]
                    if eventPlayer.B in eventPlayer.D.concat(eventPlayer.Z):
                        if not (P and V):
                            goto lbl_0
                        eventPlayer.P.append(1)
                        lbl_0:
                        if eventPlayer.F and P and V:
                            goto lbl_1
                        eventPlayer.L += 1
                        lbl_1:
                        eventPlayer.H += 1
                        if eventPlayer.V:
                            eventPlayer.AG = true
                        eventPlayer.V = false
                    elif eventPlayer.B in N or abs((eventPlayer.B - B).x) > O * H or abs((eventPlayer.B - B).z) > O * H:
                        if eventPlayer.V:
                            eventPlayer.U += 1
                        else:
                            eventPlayer.O += 1
                        break
                    else:
                        if not (P and V):
                            goto lbl_2
                        eventPlayer.P.append(2)
                        lbl_2:
                        if not eventPlayer.R and P and V:
                            goto lbl_3
                        break
                        lbl_3:
                        if eventPlayer.Z:
                            goto lbl_4
                        eventPlayer.AA.append(eventPlayer.B)
                        lbl_4:
                        eventPlayer.R = true
                        eventPlayer.V = true
                        eventPlayer.F = true
                if eventPlayer.P[len(eventPlayer.S)] != 1 and eventPlayer.S and eventPlayer.P.slice(0, len(eventPlayer.S)) == eventPlayer.S:
                    eventPlayer.J = true
                    break
            if eventPlayer.Z and not eventPlayer.AG and not eventPlayer.O:
                eventPlayer.AH = true
            if eventPlayer.L > 4:
                break
            elif eventPlayer.U < 2 and eventPlayer.H == 3 and not eventPlayer.O and (not ([2, 1, 2] == eventPlayer.P.slice(0, 3) and eventPlayer.G)):
                eventPlayer.K += 1
                if eventPlayer.Z:
                    goto lbl_5
                eventPlayer.X[eventPlayer.N] = eventPlayer.AA
                lbl_5:
            elif (eventPlayer.H == 4 and eventPlayer.O < 2 and (not (eventPlayer.C and ([1, 2, 1] == eventPlayer.P.slice(0, 3) or [2, 1] == eventPlayer.P.slice(0, 2))))) and (not (eventPlayer.T and [2, 1, 2] == eventPlayer.P.slice(0, 3))):
                eventPlayer.Q += 1


rule "경고":
    @Event eachPlayer
    @Condition eventPlayer == G[P]
    @Condition getMatchTime() == true
    @Condition getMatchTime() <= 11
    @Condition C == false
    @Condition G[1] == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, A, 100)
    smallMessage(eventPlayer, ceil(getMatchTime()))
    goto RULE_START


rule "시간초과시":
    @Condition isGameInProgress() == true
    @Condition getMatchTime() == 0
    @Condition C == false
    
    if not G[1]:
        goto lbl_0
    (G[not P]).L = 5
    lbl_0:


rule "기권":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer in G.slice(0, 2) == true
    @Condition eventPlayer.A == M
    @Condition C == false
    
    smallMessage(getAllPlayers(), "{0}{1}".format(eventPlayer, J[9]))
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, A, 50)
    (G[not G.index(eventPlayer)]).L = 5
    C = true


rule "나가면":
    @Event playerLeft
    
    if G.index(eventPlayer) > 1:
        goto lbl_0
    (G[not G.index(eventPlayer)]).L = 5
    F = true
    lbl_0:
    G.remove(eventPlayer)


rule "승리":
    @Condition sorted(G.slice(0, 2), lambda i: i.L).last().L > 4
    
    T = sorted(G.slice(0, 2), lambda i: i.L).last()
    wait(0)
    if V and G.index(T):
        if T.L == 5:
            goto lbl_0
        T.L = 0
        return
        lbl_0:
    C = true
    G.L = 0
    S = G[not G.index(T)]
    bigMessage(getAllPlayers(), "{0}{1}".format(T, J[10]))
    if D == T:
        E += 1
    else:
        D = T
        E = 1
    if not F and entityExists(S):
        if len(G) > 2:
            stopChasingVariable(S.I)
            stopChasingVariable(S.A)
        kill(S, T)
        G.remove(S)
        wait(0)
        G.append(S)
        S.resurrect()
    F = false
    wait(3)
    S = false
    destroyAllEffects()
    getAllPlayers().D = []
    N = []
    if "{0}".format(Hero.GENJI) == "겐지" and J[5].charAt(4) != "깨":
        removeFromGame(getAllPlayers())
    setMatchTime(L)
    wait(0.25)
    Sub1()
    K = false
    C = false


rule "커서민감도":
    @Event eachPlayer
    @Condition (eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.ABILITY_2)) == true
    
    eventPlayer.AI += 10 if eventPlayer.isHoldingButton(Button.ABILITY_2) else -10
    eventPlayer.setAimSpeed(100 + eventPlayer.AI)
    wait(0.1)
    if eventPlayer.AJ:
        goto lbl_0
    smallMessage(eventPlayer, "{0}%".format(eventPlayer.AI + 100))
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.AJ = true
    lbl_0:
    if RULE_CONDITION:
        goto RULE_START
    eventPlayer.AJ = false
    smallMessage(eventPlayer, "{0}%".format(eventPlayer.AI + 100))


def Sub1():
    @Name "보조이펙트"
    
    createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, M, O * 0.6, EffectReeval.VISIBILITY)
    createEffect(G[0], Effect.SPHERE, Color.GRAY, G[0].A, O / 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(G[1], Effect.SPHERE, Color.GRAY, G[1].A, O / 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if createWorkshopSetting(bool, "설정(Setting)", "눈금(grid)", true, 0):
        for U in range(1 + H * 2):
            createBeam(getAllPlayers(), Beam.GRAPPLE, B + (O * (vect(U - H, 0, H))), B + (O * (vect(U - H, 0, -1 * H))), Color.WHITE, EffectReeval.VISIBILITY)
            createBeam(getAllPlayers(), Beam.GRAPPLE, B + (O * (vect(H, 0, U - H))), B + (O * (vect(-1 * H, 0, U - H))), Color.WHITE, EffectReeval.VISIBILITY)


