from psychopy import visual, core, data, gui, event, logging
import numpy as np
import psychopy
from psychopy import visual,core, data, logging, event, sound
import os
from psychopy import prefs
import numpy as np
#STIMULI#######################
win = visual.Window(size=(1920,1080),fullscr=True,allowGUI=None, monitor={}, color="black",winType="pyglet",units="pix")
black= visual.PatchStim(win, tex="sin", size=0.01, mask="circle", sf=0.05,ori=45, contrast=0.6)
cross = visual.Circle(win=win,units="pix", radius=2, fillColor="white", lineColor="white",edges=128)
cross1 = visual.Circle(win=win,units="pix", radius=2, fillColor="red", lineColor="red",edges=128)
resp = visual.TextStim(win, text="?", color="white", alignHoriz='center', alignVert='center',units="pix", height=20, opacity=1.0,name="cross")
tak = visual.TextStim(win, text="Dobrze!", color="white", alignHoriz='center', alignVert='center',units="pix", height=40, opacity=1.0,name="cross")
nie = visual.TextStim(win, text="Niestety nie", color="white", alignHoriz='center', alignVert='center',units="pix", height=40, opacity=1.0,name="cross")
kolko = visual.Circle(win=win,units="pix", radius=100, fillColor="grey", lineColor="white",edges=128)
circle = visual.Circle(win=win,units="pix", radius=40, fillColor="white", lineColor="white",edges=128)
#rect = psychopy.visual.Rect( win=win, width=80, height=40, pos=[0,0], fillColor=[1] * 3 ) 
#triangle=psychopy.visual.Polygon(win,fillColor="white", lineColor="white",edges=3, size=(80,80))
PAUSE = np.random.choice([8,10,12])
circleP = visual.Circle(win=win,units="pix", radius=40, fillColor="black", lineColor="white",edges=128)
rectP = psychopy.visual.Rect( win=win, width=100, height=60, pos=[0,0], fillColor="black") 
triangleP=psychopy.visual.Polygon(win,fillColor="black", lineColor="white",edges=3, size=(80,80))


rect = psychopy.visual.Rect( win=win, width=100, height=60, pos=[0,0], fillColor=[0,0,0],fillColorSpace='rgb',lineColor=[0,0,0]) 
triangle=psychopy.visual.Polygon(win,fillColor=[0,0,0],fillColorSpace='rgb',lineColor=[0,0,0],edges=3, size=(80,80))


triangle1=psychopy.visual.Polygon(win,fillColor="black", lineColor="white",edges=3, size=(80,80))
rect1 = psychopy.visual.Rect( win=win, width=80, height=40, pos=[0,0], fillColor="black")

gabor= visual.PatchStim(win, tex="sin", size=200, mask="gauss", sf=0.05,ori=180, contrast=0.3)

gabor1= visual.PatchStim(win, tex="sin", size=200, mask="gauss", sf=0.05,ori=180, contrast=0.3)
#CONDITIONS###########################
test=[1,0,1,0,1,0,1]
#trening=[0,1,2,3]
rytmiczne=[1,0,1]
uwagowe=[0,1,2,3,4]
trening=[1,0]
peryferia=[1,0,0,1]
#warunki=[1,0,1]
trials3 = data.TrialHandler(uwagowe, 1, method ='sequential', dataTypes=None, autoLog=True)
trials4 = data.TrialHandler(peryferia, 1, method ='sequential', dataTypes=None, autoLog=True)
trials2 = data.TrialHandler(rytmiczne, 1, method ='sequential', dataTypes=None, autoLog=True)
rytmW=[[2,2,1,2,1,1],[2,1,1,2,1,2],[2,1,2,2,1,1],[2,1,2,1,2,1],[2,1,2,1,2,1],[2,1,1,2,2,1],[2,1,1,1,1,2]]

rozne=[[0,1],[1,0],[4,5],[0,2],[1,2],[0,1],[4,6],[5,6],[2,3],[2,3],[0,1],[0,3],[2,3],[4,6],[0,1],[1,2],[0,3],[5,6],[0,2],[4,5],[5,6],[4,6],[0,3],[0,2],[4,5],[1,2],[1,3]]
takie=[[0,0],[1,1],[5,5],[3,3],[2,2],[6,6],[0,0],[4,4],[0,0],[2,2],[1,1],[4,4],[3,3],[1,1],[1,1],[6,6],[0,0],[5,5],[2,2],[5,5],[4,4]]
pauza=[8,10,12,12,10,8]  
dlugi=0.5
krotki=0.25
#EXPE SETTINGS
PAUSE = np.random.choice([8,10,12])
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)
cue = visual.ImageStim(win, image="Slajd11.png", pos=(0.0,0.0), ori=0.0)
instr = visual.TextStim(win, text="i", color="white", alignHoriz='center', alignVert='center',units="pix", height=40, opacity=1.0,name="cross")
instr_c = 1 # instruction counter

expe=data.ExperimentHandler('rytmy','1.1.0', dataFileName='ex')
cross.draw()
win.flip()
core.wait(1)
dlugosc=[1,2,3,4,1,2,3,4,1,2,3,4]
clockRT = psychopy.core.Clock()
clock = psychopy.core.Clock()
clockRESP=psychopy.core.Clock()
rytm=[1,1,1,1,1,1,1]



rtm=[5,6,7]
rea=[0,0,0,0,0,0,0,0]


def kolory(r):
    warunek=[1,0,0,1,0]
    if warunek[r]==9:
        cross1.draw()
        win.flip()
        key=event.waitKeys(keyList=['s'])
        clock.reset()
        c=clock.getTime()
        cross.draw()
        win.flip()
        core.wait(15)
        c1=clock.getTime()
        d=c1-c
        return c,d
    else:
                onset=[0,0,0]
                durat=[0,0,0]
                od=[0,0,0]
                triangle.fillColor=[-0.2,-0.2,-0.2]
                triangle.lineColor=[-0.2,-0.2,-0.2]
                rect.fillColor=[-0.2,-0.2,-0.2]
                rect.lineColor=[-0.2,-0.2,-0.2]
                cross.draw()
                win.flip()
                core.wait(1)
                for i in range(0,3):
                    if i % 2==0:
                            rect.draw()
                            win.flip()
                            core.wait(0.35)
                    if i % 2 !=0:    
                            triangle.draw()
                            win.flip()
                            core.wait(0.35)
                if warunek[r+j]==0:
                    triangle.fillColor=[-0.1,-0.1,-0.1]
                    triangle.lineColor=[-0.1,-0.1,-0.1]
                    rect.fillColor=[-0.1,-0.1,-0.1]
                    rect.lineColor=[-0.1,-0.1,-0.1]
                if warunek[r+j]==1:
                    triangle.fillColor=[-0.3,-0.3,-0.3]  
                    rect.fillColor=[-0.3,-0.3,-0.3]
                    triangle.lineColor=[-0.3,-0.3,-0.3]  
                    rect.lineColor=[-0.3,-0.3,-0.3]
                for i in range(0,3):
                        if i % 2==0:
                            rect.draw()
                            win.flip()
                            core.wait(0.35)
                        if i % 2 !=0:    
                            triangle.draw()
                            win.flip()
                            core.wait(0.35)
                         
          
                          
                black.draw()
                win.flip()
                black.draw()
                win.flip()
                core.wait(0.2)
                
                resp.draw()
                win.flip()
                core.getTime()
                
                allkeys = None
                
                allkeys = event.waitKeys(maxWait=2,timeStamped=clockRT)
                if allkeys==None:
                    rt=2
                    od='None'
                if allkeys!=None:
                    rt= allkeys[0][1]
                    od=allkeys[0][0]
                    if warunek[r]==0:
                        if od=='q':
                            tak.draw()
                            win.flip()
                            core.wait(1)
                        if od=='p':
                            nie.draw()
                            win.flip()
                            core.wait(1)
                    if warunek[r]==1:
                        if od=='p':
                            tak.draw()
                            win.flip()
                            core.wait(1)
                        if od=='q':
                            nie.draw()
                            win.flip()
                            core.wait(1)
                                    
                        
                    for thiskey in allkeys:
                        if thiskey == 'escape':
                            core.quit()
                cross.draw()
                win.flip()
                core.wait(2-rt)
               
                    
                    
                    
                    
                    
                
                




            
            
            
def ksztalty(r):
            warunek=[1,0,1,0]
            cross.draw()
            win.flip()
            core.wait(1)
            current_time=0
            rytm=[2,1,2,1,2,1]
            rect.draw()
            win.flip()
            core.wait(0.8)
            for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.6)
                if rytm[i]==1:
                    core.wait(0.3) 
            cross.draw()
            win.flip()
            core.wait(1)
            current_time=0
            if warunek[r]==0:
                rytm=rytmW[rozne[r][1]]
            if warunek[r]==1:
                rytm=[2,1,2,1,2,1]
            rect.draw()
            win.flip()
            core.wait(0.8)
            for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.6)
                if rytm[i]==1:
                    core.wait(0.3)      
               
            black.draw()
            win.flip()
            core.wait(0.2)
            
            
            resp.draw()
            win.flip()
            core.getTime()
            
            allkeys = None
            
            allkeys = event.waitKeys(maxWait=2,timeStamped=clockRT)
            if allkeys==None:
                rt=2
                od='None'
            if allkeys!=None:
                rt= allkeys[0][1]
                od=allkeys[0][0]
                if warunek[r]==0:
                    if od=='q':
                        tak.draw()
                        win.flip()
                        core.wait(1)
                    if od=='p':
                        nie.draw()
                        win.flip()
                        core.wait(1)
                if warunek[r]==1:
                    if od=='p':
                        tak.draw()
                        win.flip()
                        core.wait(1)
                    if od=='q':
                        nie.draw()
                        win.flip()
                        core.wait(1)
                                
                    
                for thiskey in allkeys:
                    if thiskey == 'escape':
                        core.quit()
            cross.draw()
            win.flip()
            core.wait(2-rt)
           
    

           
#Instrukcjetreningi
i=1 
j=0

p=[1,2,3,4,1,2,3,4,1,2,3,1,2,3,4,1,2,3,4]
clock.reset()
k=0
t=0


cue.setImage("Slajd2.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space','escape'])
for thiskey in allkeys:
    if thiskey == 'escape':
        core.quit()
cue.setImage("Slajd3.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space'])
rytm=[1,1,1,1,1,1,1,1,1]
for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.5)
                if rytm[i]==1:
                    core.wait(0.25) 
cross.draw()
win.flip()
core.wait(1)
cue.setImage("S1.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space'])
rytm=[2,1,2,1,2,1]
for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.6)
                if rytm[i]==1:
                    core.wait(0.3) 
cross.draw()
win.flip()
core.wait(0.2)

cue.setImage("S2.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space'])
rytm=[2,1,2,1,2,1]
for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.6)
                if rytm[i]==1:
                    core.wait(0.3) 
cross.draw()
win.flip()
core.wait(0.2)

for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.6)
                if rytm[i]==1:
                    core.wait(0.3) 
cross.draw()
win.flip()
core.wait(0.2)

for i in range(len(rytm)):
                if i % 2==0:
                    rect.draw()
                    win.flip()
                if i % 2 !=0:    
                    triangle.draw()
                    win.flip()
                if rytm[i]==2:  
                    core.wait(0.6)
                if rytm[i]==1:
                    core.wait(0.3) 
cross.draw()
win.flip()
core.wait(0.2)
cue.setImage("S3.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space'])
ksztalty(1)
ksztalty(2)
ksztalty(3)
cross.draw()
win.flip()
core.wait(1)
cue.setImage("S4.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space'])
sek=[1,2,1,1,1,2,1,1]
triangle.fillColor=[0,0,0]
triangle.lineColor=[0,0,0]
rect.fillColor=[0,0,0]
rect.lineColor=[0,0,0]
cross.draw()
win.flip()
core.wait(1)
current_time=0
c=clock.getTime()
for i in range(0,6):
                    if i % 2==0:
                        rect.draw()
                        win.flip()
                        core.wait(0.4)
                    if i % 2 !=0:    
                        triangle.draw()
                        win.flip()
                        core.wait(0.4)
             
triangle.fillColor=[0.3,0.3,0.3]  
rect.fillColor=[0.3,0.3,0.3]
triangle.lineColor=[0.3,0.3,0.3]  
rect.lineColor=[0.3,0.3,0.3]
for i in range(0,8):
                        if i % 2==0:
                            rect.draw()
                            win.flip()
                            core.wait(0.4)
                        if i % 2 !=0:    
                            triangle.draw()
                            win.flip()
                            core.wait(0.4)                
cross.draw()
win.flip()
core.wait(1) 

cue.setImage("SS1.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space','escape'])
for thiskey in allkeys:
    if thiskey == 'escape':
        core.quit()
kolory(1)
kolory(2)
kolory(0)
cross.draw()
win.flip()
core.wait(1)
cue.setImage("por1.png")
cue.draw()
win.flip()
allkeys = event.waitKeys(keyList=['space','escape'])
cue.setImage("drum1.png")
cue.draw()
win.flip()
core.wait(1)
ksztalty(1)
ksztalty(2)
cue.setImage("licz3.png")
cue.draw()
win.flip()
core.wait(1)
kolory(1)
kolory(2)
cue.setImage("drum1.png")
cue.draw()
win.flip()
core.wait(1)
ksztalty(1)
ksztalty(2)
ksztalty(1)
cue.setImage("licz3.png")
cue.draw()
win.flip()
core.wait(1)

cue.setImage("fin1.png")
cue.draw()
win.flip()

allkeys = event.waitKeys(keyList=['space','escape'])
for thiskey in allkeys:
    if thiskey == 'escape':
        core.quit()