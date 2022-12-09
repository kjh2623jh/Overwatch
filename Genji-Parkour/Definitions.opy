#!mainFile "GenjiParkour.opy"

# ----------------GLOBAL------------------
#!define GameMode A
#!define Text B
#!define CheckPoint C
#!define PioneerArr D
#!define AbilityArr E
#!define UltimateArr F
#!define CheckPointSize G
#!define PioneerHud H
#!define Pioneer I
#!define PioneerMinDistans J
#!define PlayerList K
#!define TimeList L
#!define CheckPointList M
#!define Dva N
#!define PioneerCancelTime O
#!define PioneerCancelTimer P
#!define PioneerPosition Q
#!define PioneerTime R
#!define Time S
#!define Finished T
#!define Top3List U
#!define TopPlayerList V
#!define TopTimeList W

# ----------------PLAYER------------------
#!define language A
#!define check_point B
#!define arrived_check_point C
#!define is_pioneering D
#!define is_float E
#!define is_invincible F
#!define ability G
#!define ultimate H
#!define name I
#!define player_index J
#!define save_temp K
#!define is_last_check_point L
#!define dva_position_arr M
#!define dva_position N
#!define dva_index O
#!define is_invisible P
#!define time Q
#!define climb R
#!define bhop S
#!define climb_num T
#!define check U     

# ----------------SUBS------------------
#!define save Sub0
#!define toCheckPoint Sub1
#!define abilityReset Sub2
#!define invincibleMode Sub3


#Global variables
globalvar GameMode
globalvar Text
globalvar CheckPoint
globalvar PioneerArr
globalvar AbilityArr
globalvar UltimateArr
globalvar CheckPointSize 
globalvar PioneerHud 
globalvar Pioneer 
globalvar PioneerMinDistans
globalvar PlayerList
globalvar TimeList
globalvar CheckPointList
globalvar Dva
globalvar PioneerCancelTime
globalvar PioneerCancelTimer
globalvar PioneerPosition
globalvar PioneerTime
globalvar Time
globalvar Finished
globalvar Top3List
globalvar TopPlayerList
globalvar TopTimeList

#Player variables
playervar language
playervar check_point 
playervar arrived_check_point
playervar is_pioneering
playervar is_float
playervar is_invincible
playervar ability
playervar ultimate
playervar name
playervar player_index
playervar save_temp
playervar is_last_check_point
playervar dva_position_arr
playervar dva_position
playervar dva_index
playervar is_invisible
playervar time
playervar climb
playervar bhop
playervar climb_num
playervar check

#Subroutines
subroutine save 
subroutine toCheckPoint 
subroutine abilityReset
subroutine invincibleMode