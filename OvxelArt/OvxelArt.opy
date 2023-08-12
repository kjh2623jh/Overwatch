#!include "Settings.opy"
#!include "Definitions.opy"



def paste():
    @Name "붙여넣기"
    @Delimiter

    # Created = 1
    # MaxNumber = 255
    # ColorPalette = [0, Color.RED, Color.BLUE]
    # PixelsNumber = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, "  ", 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, \
    #              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]


rule "init":
    disableInspector()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()

    Created = 0
    MaxNumber = 0
    ColorPalette = 0
    PixelsNumber = []
    paste()
    Init = 0
    Pixels = []
    PixelsPos = []
    PixelsText = ""
    PaintedNumber = []
    #Bottom
    createInWorldText(getAllPlayers(), "─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─", vect(0, 2, 20), 2.3, Clip.NONE, WorldTextReeval.VISIBILITY, Color.GRAY, SpecVisibility.DEFAULT)
    #Left
    createInWorldText(getAllPlayers(), "│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n", vect(8.3, 4, 20), 2.3, Clip.NONE, WorldTextReeval.VISIBILITY, Color.GRAY, SpecVisibility.DEFAULT)
    #Top
    createInWorldText(getAllPlayers(), "─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─", vect(0, 18.3, 20), 2.3, Clip.NONE, WorldTextReeval.VISIBILITY, Color.GRAY, SpecVisibility.DEFAULT)
    #Right
    createInWorldText(getAllPlayers(), "│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n│\n", vect(-8.3, 4, 20), 2.3, Clip.NONE, WorldTextReeval.VISIBILITY, Color.GRAY, SpecVisibility.DEFAULT)

    if Created:
        for i in range(16):
            for j in range(16):
                PixelsPos.append(vect(-1*j+7.5, (i-18)*-1, 20))
                if PixelsNumber[i*16+j] != "  ":
                    createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, PixelsPos.last(), 0.5, EffectReeval.VISIBILITY)
                    Pixels.append(getLastCreatedEntity())
                else: Pixels.append(null)
                PixelsText = "{0}   {1}".format(PixelsText, PixelsNumber[i*16+j])
                wait()
            PixelsText = "{}\n".format(PixelsText)
        createInWorldText(localPlayer if localPlayer.number_hud else null, PixelsText, vect(0.3, 4.3, 20), 2.3, Clip.NONE, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
    else:
        for i in range(16):
            for j in range(16):
                PixelsPos.append(vect(-1*j+7.5, (i-18)*-1, 20))
                wait()
        ColorPalette = [0, Color.WHITE, Color.AQUA, Color.BLACK, Color.BLUE, Color.GRAY, Color.GREEN, Color.LIME_GREEN, Color.ORANGE, Color.PURPLE, Color.RED, Color.ROSE, Color.SKY_BLUE, Color.TURQUOISE, Color.VIOLET, Color.YELLOW]
        for i in range(1, len(ColorPalette)):
            ColorPos[i] = vect(-9.5-floor(i/8)*1.5, 3+i*2-16*floor(i/8), 20)
            createInWorldText(getAllPlayers(), '■', ColorPos.last(), 5, Clip.NONE, WorldTextReeval.VISIBILITY, ColorPalette[i], SpecVisibility.DEFAULT)
            wait()

    Init = 1


rule "Player Join":
    @Event playerJoined
    
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHUD()
    eventPlayer.startCamera(vect(0, 10, 5), vect(0, 10, 20), 0)
    waitUntil(Init == true, 10)
    createInWorldText(localPlayer, "˚", updateEveryTick(vect(0, 10, 19.9) + 0.1 * vect(localPlayer.getHorizontalFacingAngle(), -1 * localPlayer.getVerticalFacingAngle(), 0)),
                      2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, ColorPalette[localPlayer.color], SpecVisibility.DEFAULT)
    eventPlayer.teleport(vect(0, 0, 19))
    eventPlayer.color = 1
    eventPlayer.color_hud = []
    eventPlayer.number_hud = 1
    if Created:
        hudHeader(eventPlayer, 1, HudPosition.LEFT, 1, ColorPalette[1], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        eventPlayer.color_hud[1] = getLastCreatedText()
        for i in range(2, len(ColorPalette)):
            hudSubtext(eventPlayer, i, HudPosition.LEFT, i, ColorPalette[i], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            eventPlayer.color_hud[i] = getLastCreatedText()
    else:

    

rule "Click":
    @Event eachPlayer
    @Condition Init
    @Condition hostPlayer.temp == 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.click_pos = vect(0, 10.8, 20) + 0.1 * vect(eventPlayer.getHorizontalFacingAngle(), -1 * eventPlayer.getVerticalFacingAngle(), 0)
    if Created:
        for eventPlayer.num in range(len(Pixels)):
            if Pixels[eventPlayer.num] and eventPlayer.color == PixelsNumber[eventPlayer.num] and distance(PixelsPos[eventPlayer.num], eventPlayer.click_pos) < 0.6:
                destroyEffect(Pixels[eventPlayer.num])
                createEffect(getAllPlayers(), Effect.SPHERE, ColorPalette[eventPlayer.color], PixelsPos[eventPlayer.num], 0.5, EffectReeval.VISIBILITY)
                Pixels[eventPlayer.num] = null
                PaintedNumber.append(eventPlayer.num)
    elif (eventPlayer == hostPlayer) if createWorkshopSetting(bool, "제작 설정", "방장만 그리기", true, 0) else true:
        for eventPlayer.num in range(1, len(ColorPalette)):
            if distance(ColorPos[eventPlayer.num], eventPlayer.click_pos) < 0.7:
                eventPlayer.color = eventPlayer.num
                goto lbl
        for eventPlayer.num in range(len(PixelsPos)):
            if distance(PixelsPos[eventPlayer.num], eventPlayer.click_pos) < 0.6:
                if Pixels[eventPlayer.num]:
                    destroyEffect(Pixels[eventPlayer.num])
                createEffect(getAllPlayers(), Effect.SPHERE, ColorPalette[eventPlayer.color], PixelsPos[eventPlayer.num], 0.5, EffectReeval.VISIBILITY)
                Pixels[eventPlayer.num] = getLastCreatedEntity()
                PixelsNumber[eventPlayer.num] = eventPlayer.color

    lbl:
    waitUntil(distance(vect(0, 10.8, 20) + 0.1 * vect(eventPlayer.getHorizontalFacingAngle(), -1 * eventPlayer.getVerticalFacingAngle(), 0), eventPlayer.click_pos) > 0.3, 10)
    if RULE_CONDITION: goto RULE_START


rule "Color Change":
    @Event eachPlayer
    @Condition Created
    @Condition Init
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    destroyHudText(eventPlayer.color_hud[eventPlayer.color])
    hudSubtext(eventPlayer, eventPlayer.color, HudPosition.LEFT, eventPlayer.color, ColorPalette[eventPlayer.color], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.color_hud[eventPlayer.color] = getLastCreatedText()

    eventPlayer.color += 1
    if eventPlayer.color == len(ColorPalette): eventPlayer.color = 1
    
    destroyHudText(eventPlayer.color_hud[eventPlayer.color])
    hudHeader(eventPlayer, eventPlayer.color, HudPosition.LEFT, eventPlayer.color, ColorPalette[eventPlayer.color], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.color_hud[eventPlayer.color] = getLastCreatedText()


rule "Text":
    @Event eachPlayer
    @Condition Created
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.number_hud = not eventPlayer.number_hud


rule "Complete":
    @Condition Created
    @Condition PaintedNumber != []
    @Condition MaxNumber == len(PaintedNumber)
     
    bigMessage(getAllPlayers(), "완료!!")
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, vect(0, 0, 0), 10)
    wait()
    destroyAllEffects()
    wait(0.1)
    for i in range(len(PaintedNumber)):
        createEffect(getAllPlayers(), Effect.SPHERE, ColorPalette[PixelsNumber[PaintedNumber[i]]], PixelsPos[PaintedNumber[i]], 0.5, EffectReeval.VISIBILITY)
        wait()


rule "Save":
    @Event eachPlayer
    @Condition not Created
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    @Condition not hostPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    hudHeader(getAllPlayers(), "저장중...", HudPosition.TOP, 0, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    Created = 1
    hostPlayer.temp[0] = ColorPalette
    hostPlayer.temp[1] = PixelsNumber
    ColorPalette = [0, ]
    wait(0.1)

    for i in range(256):
        if not Pixels[i]:
            PixelsNumber[i] = "  "
        else:
            MaxNumber += 1
            if not PixelsNumber[i] in ColorPalette:
                ColorPalette.append(PixelsNumber[i])
            PixelsNumber[i] = ColorPalette.index(PixelsNumber[i])
        wait()
    for i in range(1, len(ColorPalette)):
        ColorPalette[i] = hostPlayer.temp[0][ColorPalette[i]]

    hostPlayer.temp[2] = Pixels
    hostPlayer.temp[3] = PixelsPos
    hostPlayer.temp[4] = ColorPos
    Pixels = 0
    PixelsPos = 0
    ColorPos = 0
    enableInspector()
    disableInspector()
    Created = 0
    MaxNumber = 0
    ColorPalette = hostPlayer.temp[0]
    PixelsNumber = hostPlayer.temp[1]
    Pixels = hostPlayer.temp[2]
    PixelsPos = hostPlayer.temp[3]
    ColorPos = hostPlayer.temp[4]
    hostPlayer.temp = 0
    destroyHudText(getLastCreatedText())