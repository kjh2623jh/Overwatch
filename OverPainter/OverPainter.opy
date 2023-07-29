#!include "Settings.opy"
#!include "Definitions.opy"



rule "init":
    Words = ['a', 'b', 'c']
    Theme = random.choice(Words)


rule "Player Join":
    @Event playerJoined

