from Tkinter import *
#import Tkinter.messagebox
def doStuff():
    print "I'm doing stuff!"

app = Tk()
app.title("GUI Example")
app.geometry('400x400')

photo = PhotoImage(file = "test.gif")
label = Label(app, image= photo)
label.pack()

labelText = StringVar()
labelText.set("Click button")
label1 = Label(app, textvariable=labelText, height = 4)
label1.pack()

plabel = Label(image=photo)
plabel.image = photo # keep a reference!
plabel.pack()

button1 = Button(app, text = "Click me!", width = 20, command =doStuff)
button1.pack(side='bottom', padx=15,pady=15)

app.mainloop()


