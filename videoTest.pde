import gohai.glvideo.*;
import processing.serial.*;
import processing.video.*;
import ddf.minim.*;

VideoController videoController;
Movie activeVideo;
int value = 0;

void setup() {
  PApplet parent = this;
	videoController = new VideoController(parent);

	videoController.loadVideo("shameless");

	fullScreen(P2D);
	background(0);
}

void draw() {

	if (activeVideo.available()){
		activeVideo.read();
	}
	image(activeVideo, 0, 0, width, height);
}


void keyPressed(){
  
  switch(key){
  	// skip backward
    case 'w':
  		if(videoController.isVideoPlaying()){
        videoController.backwardVideo();
      }
      break;
  	
    //pause and play video
  	case 'e':
  		if(videoController.isVideoPlaying()){
  			videoController.pauseVideo();
  		} else {
  			videoController.playVideo();
  		}
  		break;

    //skip forward  
  	case 'r':
      if(videoController.isVideoPlaying()){
        videoController.forwardVideo();
      }

  		break;
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

    public void backwardVideo() {
      if(activeVideo != null){
        //backward video 1 sec
        activeVideo.speed(-1);
      }
    }

    public void forwardVideo() {
      if(activeVideo != null){
        //forward video 1 sec
        activeVideo.speed(1);
      }
    }

    /* helper functions */
    boolean isVideoPlaying() {
        return modeVideoPlaying;
    }

}