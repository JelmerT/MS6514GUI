/* 
GUI for the MS6514 thermometer from Mastech.
2013 jelmer@tiete.be
License: Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) - http://creativecommons.org/licenses/by-sa/3.0/

See README for info.
*/

/*Dropdown list made by Dumle29 (Mikkel Jeppesen) for processing, it uses the ControlP5 library and the processing.Serial library
 */

import controlP5.*;              //import the Serial, and controlP5 libraries.
import processing.serial.*;
import java.io.BufferedWriter;
import java.io.FileWriter;

ControlP5 controlP5;             //Define the variable controlP5 as a ControlP5 type.
DropdownList ports;              //Define the variable ports as a Dropdownlist.
Textarea myTextarea;
Textlabel T1;
Textlabel T2;
Textlabel Time;
Textlabel cfk;
Textlabel hold;
Textlabel t1labelT1;
Textlabel t1labelT2;
Textlabel t1labelT1T2;
Textlabel t1labelT2T1;
Textlabel t2labelT1;
Textlabel t2labelT2;
Textlabel AVG;
Textlabel MAX;
Textlabel MIN;
Textlabel REC;
Chart graph;

boolean export = false;
boolean first = true; //dirtyhack

Serial port;                     //Define the variable port as a Serial object.
int Ss;                          //The dropdown list will return  value
String[] comList ;               //A string to hold the ports in.
boolean serialSet;               //A value to test if we have setup the Serial port.
boolean Comselected = false;     //A value to test if you have chosen a port in the list.
float tien = 10;
String csvString = new String("");
PFont font;

PrintWriter output;
String saveLocation = new String("");

void setup() {
  font = loadFont("Digital-7Mono-48.vlw");
  size(620, 400);
  controlP5 = new ControlP5(this);

  myTextarea = controlP5.addTextarea("txt")
    .setPosition(10, 362)
      .setSize(500, 28)
        .setFont(createFont("arial", 13))
          .setLineHeight(14)
            .setColor(color(128))
              .setColorBackground(color(255, 100))
                .setColorForeground(color(255, 100));

  T1 = controlP5.addTextlabel("T1")
    .setText("88888")
      .setPosition(5, 45)
        .setColorValue(color(128))
          .setFont(font) //130
            ;

  T2 = controlP5.addTextlabel("T2")
    .setText("88888")
      .setPosition(315, 45)
        .setColorValue(color(128))
          .setFont(font) //130
            ;
  Time = controlP5.addTextlabel("Time")
    .setText("88:88:88")
      .setPosition(10, 145)
        .setColorValue(color(128))
          .setFont(font) //65
            ;

  cfk = controlP5.addTextlabel("cfk")
    .setText("CFK")
      .setPosition(255, 145)
        .setColorValue(color(128))
          .setFont(font)  //30
            ;
  hold = controlP5.addTextlabel("hold")
    .setText("HOLD")
      .setPosition(255, 168)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  t1labelT1 = controlP5.addTextlabel("t1labelT1")
    .setText("T1")
      .setPosition(10, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  t1labelT2 = controlP5.addTextlabel("t1labelT2")
    .setText("T2")
      .setPosition(60, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  t1labelT1T2 = controlP5.addTextlabel("t1labelT1T2")
    .setText("T1-T2")
      .setPosition(105, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  t2labelT1 = controlP5.addTextlabel("t2labelT1")
    .setText("T1")
      .setPosition(355, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  t2labelT2 = controlP5.addTextlabel("t2labelT2")
    .setText("T2")
      .setPosition(405, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  MIN = controlP5.addTextlabel("MIN")
    .setText("MIN")
      .setPosition(455, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  MAX = controlP5.addTextlabel("MAX")
    .setText("MAX")
      .setPosition(505, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  AVG = controlP5.addTextlabel("AVG")
    .setText("AVG")
      .setPosition(555, 30)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  REC = controlP5.addTextlabel("REC")
    .setText("REC")
      .setPosition(405, 168)
        .setColorValue(color(128))
          .setFont(font) //30
            ;
  graph = controlP5.addChart("graph")
    .setPosition(10, 200)
      .setSize(600, 150)
        .setRange(-5, 150)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  controlP5.addButton("Save")
    .setValue(100)
      .setPosition(515, 362)
        .setSize(95, 28)
        .setOff()
          ;

  //Make a dropdown list calle ports. Lets explain the values: ("name", left margin, top margin, width, height (84 here since the boxes have a height of 20, and theres 1 px between each item so 4 items (or scroll bar).
  ports = controlP5.addDropdownList("list-1", 10, 25, 180, 147);
  //Setup the dropdownlist by using a function. This is more pratical if you have several list that needs the same settings.
  customize(ports);

  graph.getColor().setBackground(color(255, 100));
  graph.setStrokeWeight(1.5);

  graph.addDataSet("T1");
  graph.setColors("T1", color(0, 0, 255));
  graph.updateData("T1", -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10);

  graph.addDataSet("T2");
  graph.setColors("T2", color(255, 0, 0));
  graph.updateData("T2", -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) 
  {
    if (theEvent.getController().getName() == "list-1"){
    println(theEvent.getController().getName() + " => " + theEvent.getController().getValue());
    //Store the value of which box was selected, we will use this to acces a string (char array).
    Ss = int(theEvent.getController().getValue());
    //Since the list returns a float, we need to convert it to an int. For that we us the int() function.
    //Ss = int(S);
    //With this code, its a one time setup, so we state that the selection of port has been done. You could modify the code to stop the serial connection and establish a new one.
    Comselected = true;
    println("comselected");
    }
  }
}

//here we setup the dropdown list.
void customize(DropdownList ddl) {
  //Set the background color of the list (you wont see this though).
  ddl.setBackgroundColor(color(200));
  //Set the height of each item when the list is opened.
  ddl.setItemHeight(20);
  //Set the height of the bar itself.
  ddl.setBarHeight(15);
  //Set the lable of the bar when nothing is selected.
  ddl.setCaptionLabel("Select COM port");
  //Set the top margin of the lable.
  ddl.getCaptionLabel().getStyle().marginTop = 3;
  //Set the left margin of the lable.
  ddl.getCaptionLabel().getStyle().marginLeft = 3;
  //Set the top margin of the value selected.
  ddl.getValueLabel().getStyle().marginTop = 3;
  //Store the Serial ports in the string comList (char array).
  comList = port.list();
  //We need to know how many ports there are, to know how many items to add to the list, so we will convert it to a String object (part of a class).
  String comlist = join(comList, ",");
  //We also need how many characters there is in a single port name, we´ll store the chars here for counting later.
  String COMlist = comList[0];
  //Here we count the length of each port name.
  int size2 = COMlist.length();
  //Now we can count how many ports there are, well that is count how many chars there are, so we will divide by the amount of chars per port name.
  int size1 = comlist.length() / size2;
  //Now well add the ports to the list, we use a for loop for that. How many items is determined by the value of size1.
  for (int i=0; i< size1; i++)
  {
    //This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
    ddl.addItem(comList[i], i);
  }
  //Set the color of the background of the items and the bar.
  ddl.setColorBackground(color(60));
  //Set the color of the item your mouse is hovering over.
  ddl.setColorActive(color(255, 128));
}

void startSerial(String[] theport)
{
  println("startserial");
  //When this function is called, we setup the Serial connection with the accuried values. The int Ss acesses the determins where to accsess the char array. 
  port = new Serial(this, theport[Ss], 9600);
  //Since this is a one time setup, we state that we now have set up the connection.
  serialSet = true;
}

void Save(int theValue) {
  if (first == false) //dirtyhack
  selectOutput("Select a file to save to:", "fileSelected");
  else
  first = false;
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } 
  else {
    println("User selected " + selection.getAbsolutePath());
    saveLocation = selection.getAbsolutePath();
    export = true;
    REC.setColorValue(color(255, 0, 0));
  }
}


void draw() {
  //So when we have chosen a Serial port but we havent yet setup the Serial connection. Do this loop
  while (Comselected == true && serialSet == false)
  {
    //Call the startSerial function, sending it the char array (string[]) comList
    startSerial(comList);
  }

  if (serialSet == true) {

    ports.hide();

    while (port.available () > 0) {
      int lf = 10;
      // Expand array size to the number of bytes you expect:
      byte[] inBuffer = new byte[18];
      if (port.readBytesUntil(lf, inBuffer) == 18) {

        //Time
        String hourString = new String("");
        String minString = new String("");
        String secString = new String("");

        if (inBuffer[13]<10) hourString = "0" + inBuffer[13]; 
        else hourString = "" + inBuffer[13];
        if (inBuffer[14]<10) minString = "0" + inBuffer[14]; 
        else minString = "" + inBuffer[14];
        if (inBuffer[15]<10) secString = "0" + inBuffer[15]; 
        else secString = "" + inBuffer[15];

        String timeString = new String( hourString + ":" + minString + ":" + secString);
        Time.setText(timeString);

        csvString = (inBuffer[13] + ":" + inBuffer[14] + ":" + inBuffer[15] + ",");

        //mode bits
        //t2 display
        String t2labelString = new String("");

        switch(int(inBuffer[11]) & 0x0F) {
        case 1: //T1
          switch(int(inBuffer[12])) {
          case 8:
            t2labelString = ("T1");
            t2labelT1.setColorValue(color(255, 0, 0));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 66:
            t2labelString = ("MIN");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(255, 0, 0));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 65:
            t2labelString = ("MAX");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(255, 0, 0));
            AVG.setColorValue(color(128));
            break;
          case 67:
            t2labelString = ("AVG");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(255, 0, 0));
            break;
          case 0 :
            t2labelString = ("MEM");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          default:
            t2labelString = ("?");
            break;
          }
          break;
        case 3: //T2
          switch(int(inBuffer[12])) {
          case 64:
            t2labelString = ("T2");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(255, 0, 0));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 193:
            t2labelString = ("MAX");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(255, 0, 0));
            AVG.setColorValue(color(128));
            break;
          case 194:
            t2labelString = ("MIN");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(255, 0, 0));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 195:
            t2labelString = ("AVG");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(255, 0, 0));
            break;
          case 0 :
            t2labelString = ("MEM");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          default:
            t2labelString = ("?");
            break;
          }
          break;
        case 2: //T1
          switch(int(inBuffer[12])) {
          case 8:
            t2labelString = ("T1");
            t2labelT1.setColorValue(color(255, 0, 0));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 193:
            t2labelString = ("MAX");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(255, 0, 0));
            AVG.setColorValue(color(128));
            break;
          case 194:
            t2labelString = ("MIN");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(255, 0, 0));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 195:
            t2labelString = ("AVG");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(255, 0, 0));
            break;
          case 0 :
            t2labelString = ("MEM");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          default:
            t2labelString = ("?");
            break;
          }
          break;
        case 8: //T2
          switch(int(inBuffer[12])) {
          case 64:
            t2labelString = ("T2");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(255, 0, 0));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 9:
            t2labelString = ("MAX");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(255, 0, 0));
            AVG.setColorValue(color(128));
            break;
          case 10: //BUG IN DEVICE!! doesn't send serial in this mode
            t2labelString = ("MIN");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(255, 0, 0));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          case 11:
            t2labelString = ("AVG");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(255, 0, 0));
            break;
          case 0 :
            t2labelString = ("MEM");
            t2labelT1.setColorValue(color(128));
            t2labelT2.setColorValue(color(128));
            MIN.setColorValue(color(128));
            MAX.setColorValue(color(128));
            AVG.setColorValue(color(128));
            break;
          default:
            t2labelString = ("?");
            break;
          }
          break;  
        default:
          t2labelString = ("?");
          break;
        }
        csvString = (csvString + t2labelString + ",");

        //t1 display
        String t1labelString = new String("");

        switch(int(inBuffer[11]) & 0xF0) {
        case 0: //T1
          t1labelString = ("T1");
          t1labelT1.setColorValue(color(255, 0, 0));
          t1labelT2.setColorValue(color(128));
          t1labelT1T2.setColorValue(color(128));
          break;
        case 64: //T2
          t1labelString = ("T2");
          t1labelT1.setColorValue(color(128));
          t1labelT2.setColorValue(color(255, 0, 0));
          t1labelT1T2.setColorValue(color(128));
          break;
        case 192: //T1-T2
          t1labelString = ("T1-T2");
          t1labelT1.setColorValue(color(128));
          t1labelT2.setColorValue(color(128));
          t1labelT1T2.setColorValue(color(255, 0, 0));
          break;
        default:
          //cfkString = ("?");
          break;
        }
        csvString = (csvString + t1labelString + ",");



        //C or F or K
        String cfkString = new String("");
        switch(int(inBuffer[10]) & 0x0F) {
        case 1: 
          cfkString = ("Celcius");
          break;
        case 2: 
          cfkString = ("Farenheit");
          break;
        case 3: 
          cfkString = ("Kelvin");
          break;
        default:
          cfkString = ("?");
          break;
        }
        cfk.setText(cfkString);

        csvString = (csvString + cfkString + ",");

        //hold
        String holdString = new String("");

        switch(int(inBuffer[10]) & 0xF0) {
        case 128: 
          holdString=("Unhold");
          hold.setColorValue(color(128));

          break;
        case 192: 
          holdString=("Hold");
          hold.setColorValue(color(255, 0, 0));

          break;
        default:
          holdString=("?");
          break;
        }
        csvString = (csvString + holdString + ",");

        //temp1
        float temp1 = ((int(inBuffer[5])*255)+int(inBuffer[6]))/(float(10));
        String strTemp1 = "" + temp1;
        if (temp1 > 200) {
          strTemp1 = "OL";
          graph.push("T1", (-100));
        }
        else graph.push("T1", (temp1));

        csvString = (csvString + strTemp1 + ",");
        T1.setText(strTemp1);


        //temp2
        float temp2 = ((int(inBuffer[7])*255)+int(inBuffer[8]))/(float(10));
        String strTemp2 = "" + temp2;
        if (temp2 > 200) {
          strTemp2 = "OL";
          graph.push("T2", (-100));
        }
        else         graph.push("T2", (temp2));


        csvString = (csvString + strTemp2);
        T2.setText(strTemp2);

        myTextarea.setText(csvString);

        if (export == true) {
          // output = createWriter(saveLocation);
          try
          { 
            output = new PrintWriter(new FileWriter(saveLocation, true));

            output.println(csvString);
          } 
          catch (IOException e) 
          { 
            e.printStackTrace(); // Dump and primitive exception handling...
          }

          if (output != null)
          {
            output.close();
          }
        }
      }
    }
  }
  background(0);
}
