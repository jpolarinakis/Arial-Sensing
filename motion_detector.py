import argparse
import datetime
import imutils
import time
import cv2
import numpy as np

cap = cv2.VideoCapture('C:/Users/DRizvi/Desktop/basic-motion-detection/example_01.mp4')
iteration = 0
firstFrame = None
while(cap.isOpened()):
    #print("Interation: %d" % iteration)
    #iteration = iteration + 1
    ret, frame = cap.read()
    frame = imutils.resize(frame, width=500)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (21, 21), 0)
    if firstFrame is None:
        firstFrame = gray
        continue
    frameDelta = cv2.absdiff(firstFrame, gray)
    thresh = cv2.threshold(frameDelta, 25, 255, cv2.THRESH_BINARY)[1]
    thresh = cv2.dilate(thresh, None, iterations=2)
    cv2.imshow("Video", frame)
    cv2.imshow("Thresh", thresh)
    cv2.imshow("Frame Delta", frameDelta)
    #cv2.imshow('',gray)
    cv2.waitKey(25)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()

