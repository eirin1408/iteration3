import gohai.glvideo.*;
import processing.serial.*;
import processing.video.*;
import ddf.minim.*;


/* global variables */
Serial serialPort;
String serialInput;
Minim minim;
AudioController audioController;
VideoController videoController;

Movie activeVideo;

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


    
    /* testing */
  //  videoController.loadVideo("shameless"); 
   

    /* draw setup */
   // size(1280, 544, P2D);
    fullScreen(P2D);
   // frameRate(30);
    background(0);
}

void draw() {
  if (videoController.isVideoPlaying()){
    if(audioController.isAlbumPlaying()){
      audioController.stopRewAlbum();
    }
  //  if(videoController.isVideoPlaying()){
  //      videoController.stopRewVideo();
  //  }
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

        serialInput = trim(serialInput);

        switch (serialInput) {
            // beethoven sym9
            case "60B916A4":
                audioController.loadAlbum("symphony");
                break;

            // for emma
            case "604275A3":
                audioController.loadAlbum("foremma");
                break;

            // La Dolche
            case "F05BB556":
                audioController.loadAlbum("ladolche");
                break;

            case "D632BBAC":
                videoController.loadVideo("snatched"); //framerate = 24 (I think its 25), size: 1280, 544
                break;

            case "265C9FAC":
                videoController.loadVideo("shameless");
                break;       

            case "pauseStopp":
         //   if(videoController.isVideoPlaying()){
        //    videoController.
              //pauseFilm
            //  audioController.activeAlbum = null;
        //    }
                if(audioController.isAlbumPlaying()) {
                    audioController.pauseSong();
                } else {
                    audioController.playSong();
                }
                break;

            case "fremover":
                audioController.nextSong();
                break;
            
            case "bakover":
                audioController.prevSong();
                break;
        
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
            case "shameless":
                activeVideo = new Movie(appParent, "video/shameless.mkv");
                break;
                
            case "snatched":
              activeVideo = new Movie(appParent, "video/snatched.mp4");
                break;
         }
                
    //    activeVideo = new GLMovie(appParent, "video/Shameless.mkv");
        playVideo();

    }

    public void playVideo() {
        if(activeVideo == null) {
            println("no video!");
            return;
        }
        activeVideo.play();
        //activeVideo.playbin.setVolume(1);
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
         //   pauseVideo();
            activeVideo.stop();
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
            
            case "foremma":
                /* Bon Iver For Emma, Forever Ago */
                activeAlbumMaxTrack = 9;
                activeAlbum = new AudioPlayer[activeAlbumMaxTrack];
                activeAlbum[0] = minim.loadFile("ForEmma/01 Flume.mp3");
                activeAlbum[1] = minim.loadFile("ForEmma/02 Lump Sum.mp3");
                activeAlbum[2] = minim.loadFile("ForEmma/03 Skinny Love.mp3");
                activeAlbum[3] = minim.loadFile("ForEmma/04 The Wolves (Act I and II).mp3");
                activeAlbum[4] = minim.loadFile("ForEmma/05 Blindsided.mp3");
                activeAlbum[5] = minim.loadFile("ForEmma/06 Creature Fear.mp3");
                activeAlbum[6] = minim.loadFile("ForEmma/07 Team.mp3");
                activeAlbum[7] = minim.loadFile("ForEmma/08 For Emma.mp3");
                activeAlbum[8] = minim.loadFile("ForEmma/09 Re Stacks.mp3");
                break;

            case "ladolche":
            /* LaDolche album fra NB's egen samling*/
                activeAlbumMaxTrack = 14;
                activeAlbum = new AudioPlayer[activeAlbumMaxTrack];
                activeAlbum[0] = minim.loadFile("LaDolche/01 Miko Mission-TocTocToc.mp3");
                activeAlbum[1] = minim.loadFile("LaDolche/02 Scotch-Penguin Invasion.mp3");
                activeAlbum[2] = minim.loadFile("LaDolche/03 Ryan Paris - Dolce Vita.mp3");
                activeAlbum[3] = minim.loadFile("LaDolche/04 MY MINE - HYPNOTIC TANGO.mp3");
                activeAlbum[4] = minim.loadFile("LaDolche/05 Scotch - Mirage.mp3");
                activeAlbum[5] = minim.loadFile("LaDolche/06 Brian Ice - Night Girl.mp3");
                activeAlbum[6] = minim.loadFile("LaDolche/07 Camaros Gang - Ali Shuffle.mp3");
                activeAlbum[7] = minim.loadFile("LaDolche/08 Eddy Huntington - USSR.mp3");
                activeAlbum[8] = minim.loadFile("LaDolche/09 Monte Kristo - The girl of Lucifer.mp3");
                activeAlbum[9] = minim.loadFile("LaDolche/10 Mike Mareen - Lady Ecstasy.mp3");
                activeAlbum[10] = minim.loadFile("LaDolche/11 DEN HARROW  -  TASTE OF LOVE.mp3");
                activeAlbum[11] = minim.loadFile("LaDolche/12 Modern Talking - Youre My Heart, Youre My Soul.mp3");
                activeAlbum[12] = minim.loadFile("LaDolche/13 Eddy Huntington - Up And Down.mp3");
                activeAlbum[13] = minim.loadFile("LaDolche/14 Grant Miller - Colder than Ice.mp3");
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
        }
    }

    /* helper functions */
    /* checks if album SHOULD be playing, not if it actually is, for that use minim's isPlaying() */
    public boolean isAlbumPlaying() {
        return modeAlbumPlaying;
    }
} // end audioController