globalvar workshopBool 0
globalvar workshopInt 1
globalvar workshopFloat 2
globalvar workshopEnum 3

subroutine workshop 0

rule "start":
    workshop()
    print("Done!")

def workshop():
    @Name "init"
    
    workshopBool = createWorkshopSetting(bool, "category", "boolVar", true, 0)
    workshopInt = createWorkshopSetting(int[1:10], "category", "intVar", 1, 0)
    workshopFloat = createWorkshopSetting(float[1.5:10], "category", "floatVar", 2.5, 0)
    workshopEnum = createWorkshopSetting(enum['a','b','c'], "category", "enumVar", 0, 0)