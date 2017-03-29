# After mission is complete, take CSV file generated from video data and generate readable metrics in new CSV file

import _csv as csv
import math
import datetime

# altitude = vehicle.LocationGlobalRelative[2]
# FOV = altitude * np.tan(94.4/2) * 2
FOV = 500

current_time = datetime.datetime.now()

def dataExport():
    with open('C://Users/Alec/Desktop/Video_Data_Export.csv', 'rb') as columns:
        read = csv.reader(columns)
        position_list = []
        prev_row = []
        current_row = []
        vehicle_number = 1

        # Add code for first frame of data
        first_row = filter(None, read.next())
        num_cars = (len(first_row) - 2) / 2
        for k in range(0, num_cars):
            position_list.append([vehicle_number, first_row[1], first_row[vehicle_number*2], first_row[vehicle_number*2+1]])
            vehicle_number += 1
        prev_row = first_row

        # CSV files force uniform length
        # If second row has 4 columns and the first row only has 2
        # Then the file will automatically add two empty strings to the first row
        # Filter function used to prevent this

        # Code for subsequent frames
        for row in read:
            current_row = filter(None, row)
            if len(current_row) > len(prev_row): # If the length of the row has increased a new car has been added
                iterations = (len(current_row) - len(prev_row)) / 2 # Find out how many new cars have been added
                for j in range(0, iterations):
                    # Add vehicle number, timestamp, x coord, and y coord to a list
                    position_list.append([vehicle_number, row[1], row[vehicle_number*2], row[vehicle_number*2+1]])
                    vehicle_number += 1
            # Check if there are any new dashes in the row
                # For each new dash, append the corresponding time stamp to the position list
            prev_row = current_row

    return position_list

# Takes pos_data from dataExport() and creates new list of lists with velocity
# Currently velocity is calculated in pixels/sec
def velocity_calc(pos_data):
    for car in pos_data:
        # Currently gives distance in pixels. Need to change to give data in feet/meters
        x_dist = car[4] - car[2]
        y_dist = car[5] - car[3]
        total_dist = math.sqrt(x_dist*x_dist + y_dist*y_dist)
        velocity = total_dist / (car[4] - car[1])
        car.append(velocity)

    return pos_data


# Write function for converting list of lists into CSV file
def csvConvert(data):
    with open('C://Users/Alec/Desktop/Velocity_Data.csv', 'ab') as vidprocess:
        process = csv.writer(vidprocess, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for item in data:
            process.writerow(item)
    vidprocess.close()

# print dataExport()
# test = dataExport()
# csvConvert(test)
