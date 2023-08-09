#!include "Settings.opy"
#!include "Definitions.opy"



rule "init":
    disableInspector()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()

    Dots = []
    DotsPos = []
    Init = 0
    DotsNumberText = ""
    DotsNumber = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, \
                 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    ColorPalette = [0, Color.RED]

    for i in range(16):
        for j in range(16):
            DotsPos.append(vect(-1*j+7.5, (i-18)*-1, 20))
            createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, DotsPos.last(), 0.5, EffectReeval.VISIBILITY)
            Dots.append(getLastCreatedEntity())
            DotsNumberText = "{0}   {1}".format(DotsNumberText, DotsNumber[i*16+j])
            wait()
        DotsNumberText = "{}\n".format(DotsNumberText)
    Text = DotsNumberText
    DotsNumberText = ""
    createInWorldText(getAllPlayers(), Text, vect(0.3, 4.3, 19.9), 2.3, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)

    Init = 1


# def text():
#     @Name "text"

#     for i in range(16):
#         for j in range(16):
#             DotsNumberText = "{0}   {1}".format(DotsNumberText, DotsNumber[i])
#             wait()
#         DotsNumberText = "{}\n".format(DotsNumberText)
#     Text = DotsNumberText
#     DotsNumberText = ""


rule "Player Join":
    @Event playerJoined
    
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHUD()
    eventPlayer.startCamera(vect(0, 10, 5), vect(0, 10, 20), 0)
    waitUntil(Init == true, 10)
    createInWorldText(localPlayer, "˚", updateEveryTick(vect(0, 10, 20) + 0.1 * vect(localPlayer.getHorizontalFacingAngle(), -1 * localPlayer.getVerticalFacingAngle(), 0)),
                      2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.mouse_pos = vect(0, 10.8, 20) + 0.1 * vect(eventPlayer.getHorizontalFacingAngle(), -1 * eventPlayer.getVerticalFacingAngle(), 0)
    eventPlayer.dots_number = []
    eventPlayer.teleport(vect(0, 0, 19))
    eventPlayer.color = 1
    eventPlayer.color_hud = []
    hudHeader(localPlayer, 1, HudPosition.LEFT, 1, ColorPalette[1], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.color_hud[1] = getLastCreatedText()
    for i in range(2, len(ColorPalette)):
        hudSubtext(localPlayer, i, HudPosition.LEFT, i, ColorPalette[i], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        eventPlayer.color_hud[i] = getLastCreatedText()


rule "Click":
    @Event eachPlayer
    @Condition Init
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.click_pos = vect(0, 10.8, 20) + 0.1 * vect(eventPlayer.getHorizontalFacingAngle(), -1 * eventPlayer.getVerticalFacingAngle(), 0)
    for eventPlayer.num in range(len(Dots)):
        if distance(DotsPos[eventPlayer.num], eventPlayer.click_pos) < 0.6 and eventPlayer.color == DotsNumber[eventPlayer.num]:
            destroyEffect(Dots[eventPlayer.num])
            createEffect(getAllPlayers(), Effect.SPHERE, ColorPalette[DotsNumber[eventPlayer.num]], DotsPos[eventPlayer.num] + vect(0, 0, -0.2), 0.5, EffectReeval.VISIBILITY)
            # DotsNumber[eventPlayer.num] = " "
            # text()
    waitUntil(distance(vect(0, 10.8, 20) + 0.1 * vect(eventPlayer.getHorizontalFacingAngle(), -1 * eventPlayer.getVerticalFacingAngle(), 0), eventPlayer.click_pos) > 0.5, 10)
    if RULE_CONDITION: goto RULE_START


rule "Color Change":
    @Event eachPlayer
    @Condition Init
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    destroyHudText(eventPlayer.color_hud[eventPlayer.color])
    hudSubtext(localPlayer, eventPlayer.color, HudPosition.LEFT, eventPlayer.color, ColorPalette[eventPlayer.color], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.color_hud[eventPlayer.color] = getLastCreatedText()

    eventPlayer.color += 1
    if eventPlayer.color == len(ColorPalette): eventPlayer.color = 1
    
    destroyHudText(eventPlayer.color_hud[eventPlayer.color])
    hudHeader(localPlayer, eventPlayer.color, HudPosition.LEFT, eventPlayer.color, ColorPalette[eventPlayer.color], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.color_hud[eventPlayer.color] = getLastCreatedText()