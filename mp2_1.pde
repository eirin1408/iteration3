/* Raspbian jessi having problems loading albums(arrays) over 4 files. 
Parts of this code is written by Ovar, my brother. 
*/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.sound.*;
import gohai.glvideo.*;
import processing.serial.*;
import processing.video.*;
import java.awt.geom.Point2D;

/* global variables */
Serial serialPort;
String serialInput;
Minim minim;
AudioController audioController;
VideoController videoController;
GLMovie activeVideo;
GLMovie askepottVideo;
GLMovie hermanVideo;
GLMovie annieVideo;
GLMovie havfrueVideo;
GLMovie vol;
//GLMovie olsenVideo;


void setup() {
    PApplet parent = this;
    int baudRate = 9600;
    
    minim = new Minim(parent);

    /* initialize serialport */
    if(!(Serial.list().length > 0)) {
        println("Nothing attached!");
    } else {
        String portName = Serial.list()[0];    //lists connected devices. I'm only using 1 => first in array.
        serialPort = new Serial(parent, portName, baudRate);

    }

    /* initialize audioController */
    audioController = new AudioController();
    videoController = new VideoController(parent);
    
    /* init videos */
    askepottVideo = new GLMovie(this, "video/askepott.m4v");
    hermanVideo = new GLMovie(this, "video/herman.m4v");
    annieVideo = new GLMovie(this, "video/annie.mp4");
    havfrueVideo = new GLMovie(this, "video/lilleHavfruen.m4v");
   // olsenVideo = new GLMovie(this, "video/olsenbandenJrGUV.mp4");
   
   /* init albums */
    
    /* testing ||
    *følgende setning loader og spiller film (på raspbian) uten problem, 
    *men når jeg kommenterer den ut for å benytte meg av serial read og switch case 
    *for loading av film, får jeg følgende error: GLVideo requires the P2D or P3D renderer.
    *P2D setter jeg i size() i setup. Ifølge processing på size() komme på første linje i setup(),
    *samt setup() kjører bare én gang. Hva skjer her? Må switch case flyttes inn i setup()? 
    *Og er det i det hele tatt mulig? ka du tru?
    *
    *For øvrig bruker jeg GLvideo på raspbian, mens jeg fikk 
    *processing sitt video-bibliotek til å fungere på ubuntu. Der funker alt bra :'(
    */
   // videoController.loadVideo("askepott");

    /* draw setup */
  //  size(560, 406, P2D);
    fullScreen(P2D);
 //   background(0);
 //   noStroke();
 //   fill(102);
  //  frameRate(30);
}

void draw() {
  background(0);
  if (videoController.isVideoPlaying()){
    /*if(audioController.isAlbumPlaying()){
      audioController.stopRewAlbum();
    }*/
    if (activeVideo.available()) {
      activeVideo.read();
    }
    //inn i if-statement
    image(activeVideo, 0, 0, width, height);
  }
}

void serialEvent(Serial serialPort){
    if (serialPort.available() > 0) {  // If data is available,
        serialInput = serialPort.readStringUntil('\n');   // read it and store it in serialInput
        
        if(serialInput == null) {
            return;
        }
        if(serialInput != null) {
        serialInput = trim(serialInput);
        println(serialInput);
        }
        
        switch (serialInput) {
          
            // beethoven sym9
            case "04E45D31742380":
                audioController.loadAlbum("symphony");
                break;

            // La Dolche
            case "04E45C31742380":
              videoController.stopCurrentMPlaying();
              audioController.stopCurrentAFromPlaying();
              
              audioController.loadAlbum("ladolche");
              break;

            case "04E46C31742380":
              videoController.stopCurrentMPlaying();
              audioController.stopCurrentAFromPlaying();
              
              videoController.loadVideo("askepott"); //size: 1280, 544
              break;

            case "04329639742380":
              videoController.stopCurrentMPlaying();
              audioController.stopCurrentAFromPlaying();
              
              videoController.loadVideo("herman");
              break;
                
            case "04329739742380":
              videoController.stopCurrentMPlaying();
              audioController.stopCurrentAFromPlaying();
              
              videoController.loadVideo("annie");
              break;
            
            case "04E46D31742380":
              videoController.stopCurrentMPlaying();
              audioController.stopCurrentAFromPlaying();
              
              videoController.loadVideo("havfruen");
              break;

            case "pauseStopp":
                //pause movie
                if(videoController.isVideoPlaying()){
                    videoController.pauseVideo();
                } else {
                  videoController.playVideo();
                }
                if(audioController.isAlbumPlaying()) {
                    audioController.pauseSong();
                } else {
                    audioController.playSong();
                }
                break;

            case "fremover":
            if(audioController.isAlbumPlaying()){
                audioController.nextSong();
                println("fremover");
            }
                
            if(videoController.isVideoPlaying()){
              videoController.fastForward();
            }
            break;
            
            case "bakover":
                audioController.prevSong();
                println("bakover");
                
                if(videoController.isVideoPlaying()){
                    videoController.fastBackwards();
                }
                break;
                
              /*  case "604275A3":
                  videoController.stopCurrentMPlaying();
                  audioController.stopCurrentAFromPlaying();
                  setup();
                  
                  break; */
        }
    }
}

public class VideoController {
    private boolean modeVideoPlaying;
    //private String videoPath;
    private PApplet appParent;


    public VideoController(PApplet parent) {
        appParent = parent;
        modeVideoPlaying = false;
    }

    public void loadVideo(String videoName) {
        println(videoName);
        
         switch (videoName.toLowerCase()) {
            case "askepott":
                //activeVideo = new GLMovie(appParent, "video/askepott.mp4");
                activeVideo = askepottVideo;
                break;
                
            case "herman":
              //activeVideo = new GLMovie(appParent, "video/herman.mp4");
              activeVideo = hermanVideo;
              break;
                
            case "annie":
              //activeVideo = new GLMovie(appParent, "video/annie.mp4");
              activeVideo = annieVideo;
              break;
              
            case "havfruen":
            //activeVideo = new GLMovie(appParent, "video/lilleHavfruen.m4v");
            activeVideo = havfrueVideo;
            break;
            
            case "olsen":
            //activeVideo = new GLMovie(appParent, "video/olsenbandenJrGUV.mp4");
//            activeVideo = olsenVideo;
            break;
         }
                
    //    activeVideo = new Movie(appParent, "video/Shameless.mkv");
        playVideo();

    }

    public void playVideo() {
        if(activeVideo == null) {
            println("no video!");
            return;
        }
       
        activeVideo.play();
        modeVideoPlaying = true;  
    }

    public void pauseVideo() {
        if(activeVideo == null) {
            println("no active video...");
            return;
        }
        modeVideoPlaying = false;
        activeVideo.pause();
        return;
    }

    public void stopRewVideo() {
        if(activeVideo != null){
           pauseVideo();
           float time = activeVideo.time();
           time = 0.000;
           activeVideo.jump(time);
           activeVideo = null;
        }
    }
    
    public void fastForward(){
       float sec = second();
       sec = 100.0;
       float time = activeVideo.time();
       time = time+sec;
       activeVideo.jump(time);
    }
    
    public void fastBackwards(){
       float sec = second();
       sec = -100.0;
       float time = activeVideo.time();
       time = time+sec;
       activeVideo.jump(time); 
    }
    
    public void setVolume(String volumeValue){
   //   if(activeVideo != null){
        
        switch (volumeValue.toLowerCase()) {
            case "99":
                activeVideo.volume(1.0);
                break;
        
      }
    }
    
    /*function so that movies does not play on top of each other*/
    public void stopCurrentMPlaying(){
      if(videoController.isVideoPlaying()){
        videoController.stopRewVideo();
      }
      if(modeVideoPlaying == false){
        videoController.stopRewVideo();
      }
    }

    /* helper functions */
    boolean isVideoPlaying() {
        return modeVideoPlaying;
    }

}

public class AudioController {
    private int activeAlbumTrack;
    private int activeAlbumMaxTrack;
    private boolean modeAlbumPlaying;
    public AudioPlayer[] activeAlbum;
    
    public AudioController() {
        activeAlbumTrack = 1;       // start at album track 1, which will be 0 in the array index (see playSong function)
        modeAlbumPlaying = false;
    }

    /* album functions */
    public void loadAlbum(String albumName) {
        if (albumName == null) {
            return;
        }

        if(activeAlbum != null) {
            pauseSong();
            activeAlbum[activeAlbumTrack-1].rewind();

        }

        activeAlbumTrack = 1;

        switch (albumName.toLowerCase()) {
            case "symphony":
                /* Beethoven sym 9 */
                activeAlbumMaxTrack = 4;
                activeAlbum = new AudioPlayer[activeAlbumMaxTrack];
                activeAlbum[0] = minim.loadFile("Sym9/01 Allegro Ma Non Troppo, Un P.mp3");
                activeAlbum[1] = minim.loadFile("Sym9/02 Molto Vivace - Presto - Mo.mp3");
                activeAlbum[2] = minim.loadFile("Sym9/03 Adagio Molto E Cantabile.mp3");
                activeAlbum[3] = minim.loadFile("Sym9/04 Presto - Allegro Ma Non Tr.mp3");
                break;

            case "ladolche":
            /* LaDolche album fra NB's egen samling*/
                activeAlbumMaxTrack = 4;
                activeAlbum = new AudioPlayer[activeAlbumMaxTrack]; 
                activeAlbum[0] = minim.loadFile("LaDolche/01 Miko Mission-TocTocToc.mp3");
                activeAlbum[1] = minim.loadFile("LaDolche/02 Scotch-Penguin Invasion.mp3");
                activeAlbum[2] = minim.loadFile("LaDolche/03 Ryan Paris - Dolce Vita.mp3");
                activeAlbum[3] = minim.loadFile("LaDolche/04 MY MINE - HYPNOTIC TANGO.mp3");
           /*     activeAlbum[4] = minim.loadFile("LaDolche/05 Scotch-Mirage.mp3");
                activeAlbum[5] = minim.loadFile("LaDolche/06 Brian Ice - Night Girl.mp3");
                activeAlbum[6] = minim.loadFile("LaDolche/07 Camaros Gang - Ali Shuffle.mp3");
                activeAlbum[7] = minim.loadFile("LaDolche/08 Eddy Huntington - USSR.mp3");
                activeAlbum[8] = minim.loadFile("LaDolche/09 Monte Kristo - The girl of Lucifer.mp3");
                activeAlbum[9] = minim.loadFile("LaDolche/10 Mike Mareen - Lady Ecstasy.mp3");
                activeAlbum[10] = minim.loadFile("LaDolche/11 DEN HARROW  -  TASTE OF LOVE.mp3");
                activeAlbum[11] = minim.loadFile("LaDolche/12 Modern Talking - Youre My Heart, Youre My Soul.mp3");
                activeAlbum[12] = minim.loadFile("LaDolche/13 Eddy Huntington - Up And Down.mp3");
                activeAlbum[13] = minim.loadFile("LaDolche/14 Grant Miller - Colder than Ice.mp3"); */
                break;
        }
        playSong();
    }   // end loadAlbum

    /* music control functions, tracknumber is the track on the album */
    public void playSong() {
        if(activeAlbum == null) {
            println("no active album...");
            return;
        }
        modeAlbumPlaying = true;
        activeAlbum[activeAlbumTrack-1].play();

        return;
    }

    public void pauseSong() {
        if(activeAlbum == null) {
            println("no active album...");
            return;
        }
        modeAlbumPlaying = false;
        activeAlbum[activeAlbumTrack-1].pause();
        return;
    }

    public void nextSong() {
        if(activeAlbum == null) {
            println("no active album...");
            return;
        }
       
        /* stop currently playing track, and rewind. Prevents several sound sources */
        activeAlbum[activeAlbumTrack-1].pause();
        activeAlbum[activeAlbumTrack-1].rewind();    
       
        /* if you're at the last track, start from the beginning, if not next track... */
        if(activeAlbumTrack >= activeAlbumMaxTrack){
            activeAlbumTrack = 1;
        } else {
            activeAlbumTrack++;
        }
        
        /* play next track */
        playSong();

        return;
    }

    public void prevSong() {
        if(activeAlbum == null) {
            println("no active album...");
            return;
        }
        /* stop currently playing track, and rewind. Prevents several sound sources */
        activeAlbum[activeAlbumTrack-1].pause();
        activeAlbum[activeAlbumTrack-1].rewind();    
        
        /* if you're at the first track, go to the end, if not prev track... */
        if(activeAlbumTrack <= 1){
            activeAlbumTrack = activeAlbumMaxTrack;
        } else {
            activeAlbumTrack--;
        }      

        /* play next track */
        playSong();

        return;
    }

    public void stopRewAlbum(){
        if(activeAlbum != null) {
            pauseSong();
            activeAlbum[activeAlbumTrack-1].rewind();
            activeAlbum = null;
        }
    }
    
    public void stopCurrentAFromPlaying(){
       if(audioController.isAlbumPlaying()){
         audioController.stopRewAlbum();
       }
    }
/*    
    public void setVolume(String volumeValue){
      if(activeAlbum != null){
        
        switch (volumeValue.toLowerCase()) {
            case "99":
                volume();
                break;
        }
      }
    } */
    
   /* Lag volum funksjon. Her fra GLvideo bibl.:  
   
   *  Changes the volume of the video's audio track, if there is one.
   *  @param vol (0.0 is mute, 1.0 is 100%)

  public void volume(float vol) {
    if (handle != 0) {
      if (!gstreamer_setVolume(handle, vol)) {
        System.err.println("Cannot set volume to to " + vol);
      }
    }
  }
 */

    /* helper functions */
    /* checks if album SHOULD be playing, not if it actually is, for that use minim's isPlaying() */
    public boolean isAlbumPlaying() {
        return modeAlbumPlaying;
    }
} // end audioController
