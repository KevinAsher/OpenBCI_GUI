////////////////////////////////////////////////////
//
//    W_template.pde (ie "Widget Template")
//
//    This is a Template Widget, intended to be used as a starting point for OpenBCI Community members that want to develop their own custom widgets!
//    Good luck! If you embark on this journey, please let us know. Your contributions are valuable to everyone!
//
//    Created by: Conor Russomanno, November 2016
//
///////////////////////////////////////////////////,
import processing.net.*;
import java.util.Arrays;


class W_Emotion extends Widget {

    //to see all core variables/methods of the Widget class, refer to Widget.pde
    //put your custom variables here...
    Button widgetTemplateButton;



    float paddingRadius;  
    double[] modelFeatures;
    ModelClassifier modelClf;
    int prediction;
    int lastUpdate = 0;

    boolean clientConnected = false;
    Client myClient;

    W_Emotion(PApplet _parent){
        super(_parent); //calls the parent CONSTRUCTOR method of Widget (DON'T REMOVE)


        //This is the protocol for setting up dropdowns.
        //Note that these 3 dropdowns correspond to the 3 global functions below
        //You just need to make sure the "id" (the 1st String) has the same name as the corresponding function
        addDropdown("DropdownSelectStuff", "Drop 1", Arrays.asList("A", "B"), 0);
        // addDropdown("Dropdown2", "Drop 2", Arrays.asList("C", "D", "E"), 1);
        // addDropdown("Dropdown3", "Drop 3", Arrays.asList("F", "G", "H", "I"), 3);

        widgetTemplateButton = new Button (x + w/2, y + h/2, 200, navHeight, "Design Your Own Widget!", 12);
        widgetTemplateButton.setFont(p4, 14);
        widgetTemplateButton.setURL("https://openbci.github.io/Documentation/docs/06Software/01-OpenBCISoftware/GUIWidgets#custom-widget");
        println("Emotion widget configured");


        try {
            modelClf = new ModelClassifier("C:\\Users\\Kevin\\Documents\\Processing\\OpenBCI_GUI\\OpenBCI_GUI\\data.json");
        } catch (FileNotFoundException e) {
            println("Model data file does not exist.");
        }

        /* Connect to the local machine at port 5204
        *  (or whichever port you choose to run the
        *  server on).
        * This example will not run if you haven't
        *  previously started a server on this port.
        */
        // Runtime.getRuntime().exec("python C:\\Users\\Kevin\\Desktop\\facul\\tcc-code\\openbci\\mini_server.py");
        myClient = new Client(ourApplet, "127.0.0.1", 5204); 
    }

    // TODO: add resilience to connections.
    boolean connectSocket() {
        try {
            myClient = new Client(ourApplet, "127.0.0.1", 5204); 
            
            return true;
        } catch (Exception e) {
            return false;   
        }
    }

    void update(){
        super.update(); //calls the parent update() method of Widget (DON'T REMOVE)

        //put your code here...
        //If using a TopNav object, ignore interaction with widget object (ex. widgetTemplateButton)
        if (topNav.configSelector.isVisible || topNav.layoutSelector.isVisible) {
            widgetTemplateButton.setIsActive(false);
            widgetTemplateButton.setIgnoreHover(true);
        } else {
            widgetTemplateButton.setIgnoreHover(false);
        }

        // Prediction:
        // int nFreqBands = 5;
        // int nChannels = 6;
        // double[] features = new double[nChannels*nFreqBands]; 
        
        // // flatten dataProcessing.avgPowerInBins
        // int Nfft = getNfftSafe();
        


        // final int[] processing_band_low_Hz = {
        //     1, 4, 8, 13, 30
        // }; //lower bound for each frequency band of interest (2D classifier only)
        // final int[] processing_band_high_Hz = {
        //     4, 8, 13, 30, 55
        // };  //upper bound for each frequency band of interest
        // float avgPowerInBins[][] = new float[nChannels][processing_band_low_Hz.length];

        // for (int Ichan = 0; Ichan < nChannels; Ichan++) {
        //     for (int i = 0; i < processing_band_low_Hz.length; i++) {
        //         float sum = 0;
        //         // int binNum = 0;
        //         for (int Ibin = 0; Ibin <= Nfft/2; Ibin ++) { // loop over FFT bins
        //             float FFT_freq_Hz = fftBuff[Ichan].indexToFreq(Ibin);   // center frequency of this bin
        //             float psdx = 0;
        //             // if the frequency matches a band
        //             if (FFT_freq_Hz >= processing_band_low_Hz[i] && FFT_freq_Hz < processing_band_high_Hz[i]) {
                        
        //                 psdx = fftBuff[Ichan].getBand(Ibin) * fftBuff[Ichan].getBand(Ibin);
                        
        //                 sum += psdx;
        //                 // binNum ++;
        //             }
        //         }
        //         avgPowerInBins[Ichan][i] = sum;   // total power in a band
        //         // println(i, binNum, sum);
        //     }
        // }


        // for(int channel = 0; channel < nChannels; channel++) {
        //     for (int band = 0; band < nFreqBands; band++) {
                
        //         features[channel*nFreqBands+band] = avgPowerInBins[channel][band];
        //     }
            
        // }

        // printArray(features);
        // prediction = modelClf.predict(features);
        // print(prediction, ", ");
        paddingRadius = max(w*0.05, h*0.05);
        // println("fft value: " + fftBuff[0].getBand(0));

        // float alphaBandIndexLimits = [fftBuff[0].freqToIndex()]

        // Although the variable name is avgPowerInBins, it actually represents the PSD power and NOT the average power 
        // as the variable's name suggests.
        

        // myClient.write(string.yLittleBuff_uV[0][0]));
        if(isRunning) {
            myClient.write(new org.json.JSONArray(yLittleBuff_uV).toString());
        }

        if (myClient.available() > 0) { 
            JSONObject json = parseJSONObject(myClient.readString());
            println(json.getString("message")); 
        }
    }

    void draw(){
        super.draw(); //calls the parent draw() method of Widget (DON'T REMOVE)


        

        //remember to refer to x,y,w,h which are the positioning variables of the Widget class
        pushStyle();

        //----------------- presettings before drawing Focus Viz --------------
        translate(x, y);
        textAlign(CENTER, CENTER);
        // textFont(myfont);

        //----------------- draw background rectangle and panel -----------------
        fill(#ffffff);
        noStroke();
        rect(0, 0, w, h);

        fill(#f5f5f5);
        noStroke();

        rect(paddingRadius, paddingRadius, w-paddingRadius*2, h-paddingRadius*2);



        //----------------- draw Circle -----------------

        fill(#000000);
        noStroke();
        ellipse(w/4, h/2, w/4, w/4);

        noStroke();
        // draw focus label
        text("focused!", w/4, h/2 + w/8 + 16);
        
        text("Confidence: " + nf(84.123112, 1, 3), w/4, h/2 + w/8 + 32);

        // text("fft value: " + nf(fftBuff[0].getBand(10), 1, 3), w/4, h/2 + w/8 + 48);

        text("Prediction: " + prediction, w/4, h/2 + w/8 + 48);


        translate(-x, -y);
        textAlign(LEFT, BASELINE);
        widgetTemplateButton.draw();
        popStyle();

    }

    void screenResized(){
        super.screenResized(); //calls the parent screenResized() method of Widget (DON'T REMOVE)

        //put your code here...
        widgetTemplateButton.setPos(x + w/2 - widgetTemplateButton.but_dx/2, y + h/2 - widgetTemplateButton.but_dy/2);


    }

    void mousePressed(){
        super.mousePressed(); //calls the parent mousePressed() method of Widget (DON'T REMOVE)

        //put your code here...
        //If using a TopNav object, ignore interaction with widget object (ex. widgetTemplateButton)
        if (!topNav.configSelector.isVisible && !topNav.layoutSelector.isVisible) {
            if(widgetTemplateButton.isMouseHere()){
                widgetTemplateButton.setIsActive(true);
            }
        }
    }

    void mouseReleased(){
        super.mouseReleased(); //calls the parent mouseReleased() method of Widget (DON'T REMOVE)

        //put your code here...
        if(widgetTemplateButton.isActive && widgetTemplateButton.isMouseHere()){
            widgetTemplateButton.goToURL();
        }
        widgetTemplateButton.setIsActive(false);

    }

    //add custom functions here
    void customFunction(){
        //this is a fake function... replace it with something relevant to this widget

    }

};

//These functions need to be global! These functions are activated when an item from the corresponding dropdown is selected
void DropdownSelectStuff(int n){
    println("Item " + (n+1) + " selected from Dropdown 1");
    if(n==0){
        //do this
    } else if(n==1){
        //do this instead
    }

    closeAllDropdowns(); // do this at the end of all widget-activated functions to ensure proper widget interactivity ... we want to make sure a click makes the menu close
}

// void Dropdown2(int n){
//     println("Item " + (n+1) + " selected from Dropdown 2");
//     closeAllDropdowns();
// }

// void Dropdown3(int n){
//     println("Item " + (n+1) + " selected from Dropdown 3");
//     closeAllDropdowns();
// }
