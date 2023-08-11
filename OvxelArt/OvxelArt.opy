#!include "Settings.opy"
#!include "Definitions.opy"



def paste():
    @Name "붙여넣기"
    @Delimiter

    Created = 1
    MaxNumber = 255


rule "init":
    disableInspector()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()

    Pixels = []
    PixelsPos = []
    Init = 0
    PixelsText = ""
    PixelsNumber = []
    PixelsNumber = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, "  ", 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    ColorPalette = [0, Color.RED, Color.BLUE]
    Created = 0
    MaxNumber = 0
    PaintedNumber = 0
    paste()

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
    
    # 픽셀들 끝에 선.. (캔버스)

    Init = 1


rule "Player Join":
    @Event playerJoined
    
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHUD()
    eventPlayer.startCamera(vect(0, 10, 5), vect(0, 10, 20), 0)
    waitUntil(Init == true, 10)
    createInWorldText(localPlayer, "˚", updateEveryTick(vect(0, 10, 19.9) + 0.1 * vect(localPlayer.getHorizontalFacingAngle(), -1 * localPlayer.getVerticalFacingAngle(), 0)),
                      2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, ColorPalette[eventPlayer.color], SpecVisibility.DEFAULT)
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
    @Condition Created
    @Condition Init
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.click_pos = vect(0, 10.8, 20) + 0.1 * vect(eventPlayer.getHorizontalFacingAngle(), -1 * eventPlayer.getVerticalFacingAngle(), 0)
    for eventPlayer.num in range(len(Pixels)):
        if Pixels[eventPlayer.num] and eventPlayer.color == PixelsNumber[eventPlayer.num] and distance(PixelsPos[eventPlayer.num], eventPlayer.click_pos) < 0.6:
            destroyEffect(Pixels[eventPlayer.num])
            createEffect(getAllPlayers(), Effect.SPHERE, ColorPalette[eventPlayer.color], PixelsPos[eventPlayer.num], 0.5, EffectReeval.VISIBILITY)
            Pixels[eventPlayer.num] = null
            PaintedNumber += 1
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
    @Condition MaxNumber == PaintedNumber
     
    bigMessage(getAllPlayers(), "완료!!")
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, vect(0, 0, 0), 10)


rule "Save":
    @Event eachPlayer
    @Condition not Created
    @Condition hostPlayer.isHoldingButton(Button.MELEE)

    getAllPlayers().disallowButton(Button.PRIMARY_FIRE)
    hudHeader(getAllPlayers(), "저장중...", HudPosition.TOP, 0, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    wait(0.1)
    Created = 1
    ColorPalette = []
    enableInspector()
    disableInspector()
    Created = 0
    destroyHudText(getLastCreatedText())
    getAllPlayers().allowButton(Button.PRIMARY_FIRE)