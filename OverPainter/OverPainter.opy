# 이펙트 제한이 256개로 너무 적어서 개발 중단해야할듯..

#!include "Settings.opy"
#!include "Definitions.opy"



rule "init":
    disableInspector()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()
    Words = ['a', 'b', 'c']
    Theme = random.choice(Words)
    PaintTime = createWorkshopSetting(int[30:600], "기본 설정", "그리는 시간", 300, 0)
    Goal = createWorkshopSetting(int[0:999], "기본 설정", "목표 점수", 0, 1)


rule "Player Join":
    @Event playerJoined

    eventPlayer.disableGamemodeHud()
    hudSubtext(getAllPlayers(), "{0} {1}".format(eventPlayer, eventPlayer.getScore()), HudPosition.RIGHT,
        (sorted(getAllPlayers(), lambda player: -1 * player.getScore())).index(eventPlayer), Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.pen_color = Color.WHITE
    eventPlayer.pen_size = 1
    eventPlayer.pen_shape = "A"
    

rule "Draw":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.last_pos = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 70, null, getAllPlayers(), false).getHitPosition()

    createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.pen_color, eventPlayer.last_pos, eventPlayer.pen_size, EffectReeval.NONE)
    waitUntil(distance(eventPlayer.last_pos, raycast(eventPlayer.getEyePosition(),
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 70, null, getAllPlayers(), false).getHitPosition()) > eventPlayer.pen_size, 999999)
    if RULE_CONDITION: goto RULE_START


rule "Game Start":
    bigMessage(getAllPlayers(), "주제: {}".format(Theme))
    Time = getMatchTime()

    waitUntil(getTotalTimeElapsed() - Time > PaintTime, 600)
    

rule "Win":
    @Event eachPlayer
    @Condition Goal
    @Condition eventPlayer.getScore() == Goal