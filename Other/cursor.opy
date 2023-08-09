rule "a":
    createInWorldText(localPlayer, "▶", updateEveryTick(vect(-0.27, 9.3, 20) + 0.1 * (vect(localPlayer.getHorizontalFacingAngle(), -1 * localPlayer.getVerticalFacingAngle(), 0))), 2.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    