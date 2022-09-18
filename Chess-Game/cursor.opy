rule "1. 기본변수 설정. 시점-글로벌변수 A, 각도 - 글로벌변수 B에서 vertical angle":
    A = vect(3.05, 5.08, -75)
    B = angleToDirection(30, 45)
    C = angleToDirection(horizontalAngleOfDirection(B), verticalAngleOfDirection(B) + 90)
    D = angleToDirection(horizontalAngleOfDirection(B) + 90, 0)


rule "2. 커서 만들기":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.startCamera(A, A + B, 0)
    eventPlayer.A = vect(0, 0, 0)
    eventPlayer.B = vect(0, 0, 0)
    eventPlayer.setFacing(vect(0, 0.5, 0.86), Relativity.TO_WORLD)
    chase(eventPlayer.B, 0.75 * (eventPlayer.getVerticalFacingAngle() * C + eventPlayer.getHorizontalFacingAngle() * D) + A + B * 100, rate=10000, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.A, raycast(A, eventPlayer.B, getAllPlayers(), eventPlayer, true).getHitPosition(), rate=10000, ChaseReeval.DESTINATION_AND_RATE)
    createIcon(eventPlayer, eventPlayer.B + C * 10.3, Icon.ARROW_UP, IconReeval.POSITION, Color.RED, false)
    eventPlayer.C = []
    eventPlayer.D = []


rule "3. 이펙트만들기":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition any([distance(eventPlayer.A, player) < 0.5 for player in eventPlayer.C]) == false
    
    eventPlayer.C.append(eventPlayer.A)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, eventPlayer.A, 0.5, EffectReeval.VISIBILITY)
    eventPlayer.D.append(getLastCreatedEntity())


rule "4. 이펙트지우기":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition any([distance(eventPlayer.A, player) < 1 for player in eventPlayer.C]) == true
    
    eventPlayer.E = eventPlayer.C.index(sorted(eventPlayer.C, lambda player: distance(eventPlayer.A, player))[0])
    destroyEffect(eventPlayer.D[eventPlayer.E])
    del eventPlayer.C[eventPlayer.E]
    del eventPlayer.D[eventPlayer.E]


