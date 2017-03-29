# Takes list of car positions from Haar Cascade and generates CSV file in real time
# This CSV file will be evaluated by data processing team

import _csv as csv
import datetime

frame_number = 0
frame_length = .04167

# Passed from video processing team
car_list = [0, 0]

# Need to add date and time to first line
def csvExport(in_list):
    with open('C://Users/Alec/Desktop/Video_Data_export.csv', 'ab') as vidprocess:
        global frame_number
        global frame_length
        process = csv.writer(vidprocess, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        write_list = [frame_number, frame_number * frame_length]
        for k in range(0, len(in_list)):
            write_list.append(in_list[k])
        process.writerow(write_list)
        frame_number += 1
    vidprocess.close()

# Basic test code
csvExport(car_list)
car_list.append(100)
car_list.append(200)
csvExport(car_list)
