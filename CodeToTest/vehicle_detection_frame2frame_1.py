# -*- coding: utf-8 -*-

import cv2
import time
import imutils
#print(cv2.__version__)


def withinRange(X1,X2,Y1,Y2):
    MAX_X_DIFF = 65
    MAX_Y_DIFF = 25
    if((abs(X1-X2) < MAX_X_DIFF) and (abs(Y1-Y2) < MAX_Y_DIFF)):
        return True
    else:
        return False

def CarListLength()
    return CarList.__len__()

class Car(object):

    def __init__(self, x, y, w, h, frame, found, active):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.frame = frame
        self.found = found
        self.active = active
        
    def Update(self, x, y, w, h, frame, found, active):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.frame = frame
        self.found = found
        self.active = active

    def getX(self):
        return self.x
    def getY(self):
        return self.y
    def getW(self):
        return self.w
    def getH(self):
        return self.h
    def getFrame(self):
        return self.frame
    def getFound(self):
        return self.found
    def getActive(self):
        return self.active

    def setActive(self, active):
        self.active = active
    def setFound(self, found):
        self.found = found
    def setFrame(self, frame):
        self.frame = frame


STARTX_LEFT = 80
STARTX_RIGHT = 720
missingFrame = 0
CarList = []
Frame = 0


cascade_src = 'cascade13.xml' #Path to Haar Cascade Model
video_src = 'dataset/vid1_clip.mp4' #Path to video file

cap = cv2.VideoCapture(video_src) #Load video file
car_cascade = cv2.CascadeClassifier(cascade_src) #Load Haar Cascade Model


while True:
    ret, img = cap.read()
    Frame += 1
            
    #Handle empty frame or end of video feed    
    if (type(img) == type(None)):
        missingFrame += 1
        if(missingFrame<100):
            print "MISSING FRAME"
        elif(missingFrame > 500):
            cv2.destroyAllWindows()
            break

    #Downsample video and begin processing frame by frame
    elif(((Frame%6) == 0) and (Frame>11)):
        missingFrame = 0
        resize = imutils.resize(img, width = 800) #resize image
        gray = cv2.cvtColor(resize, cv2.COLOR_BGR2GRAY) #convert to grayscale
        cars = car_cascade.detectMultiScale(gray) #Use model to detect location of cars
        cars = list(cars) #convert from array to list format

        for carobjects in CarList:
            setFound(carobjects, False)

        for (x,y,w,h) in cars:

            #Remove car detected twice (two bounding boxes for one car)
            carDuplicate = 0
            for (x2,y2,w2,h2) in cars:
                if((x2>x) and (x2<(x+w)) and (y2>y) and (y2<(y+h))):
                    cv2.waitKey()
                    del cars[carDuplicate]
                    break
                if((x>x2) and (x<(x2+w2)) and (y>y2) and (y<(y2+h2))):
                    cv2.waitKey()
                    del cars[carDuplicate]
                    break
                carDuplicate+=1

            cv2.rectangle(resize,(x,y),(x+w,y+h),(0,0,255),2) #Display bounding box on image at car's location



            if(Frame == 12):
                detectedCar = Car(x, y, w, h, Frame, True, True)
                CarList.append(detectedCar)
            else:
                Found = False
                for prevCar in CarList:
                    if(withinRange(prevCar.getX(), x, prevCar.getY(), y)):
                        if(getActive(prevCar) == True):
                            print "FOUND BETWEEN FRAMES!!!"
                            print "X: "+ str(prevCar.getX()) + " -> " + str(x)
                            print "Y: " + str(prevCar.getY()) + " -> " + str(y)
                            prevCar.Update(x,y,w,h,Frame, True, True)
                            Found = True
                            break
                if(Found != True):
                    if((x<STARTX_LEFT) or (x>STARTX_RIGHT)):
                        newCar = Car(x, y, w, h, Frame, True, True)
                        CarList.append(newCar)
                        print "New Car not found in Frame"
                        print "New Car X: " + str(newCar.getX())
                        print "New Car Y: " + str(newCar.getY())




        print "Num of Cars: " + str(CarListLength())
        cv2.imshow('video', resize)

        #cv2.waitKey()
        if cv2.waitKey(33) == 27:
            break

cv2.destroyAllWindows()
