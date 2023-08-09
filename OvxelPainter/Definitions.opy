#!mainFile "OvxelPainter.opy"

# ------------ Definitions ------------
#!define maketext(x) \
    rule "text": \
        @Event eachPlayer \
        @Condition Init \
        @Condition distance(DotsPos[x], eventPlayer.mouse_pos) <= 3 \
 \
        createInWorldText(eventPlayer, DotsNumber[x], DotsPos[x] + vect(0, -0.2, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT) \
        eventPlayer.dots_number[x] = getLastCreatedText() \
        waitUntil(distance(DotsPos[x], eventPlayer.mouse_pos) > 3, 999999999) \
        destroyInWorldText(eventPlayer.dots_number[x])

# ------------ Global Var --------------
globalvar i
globalvar j
globalvar Init
globalvar Dots
globalvar DotsPos
globalvar DotsNumber
globalvar ColorPalette

# ------------ Player Var --------------
playervar color
playervar click_pos
playervar mouse_pos
playervar dots_number
playervar test

# -------------- Subrutine --------------
