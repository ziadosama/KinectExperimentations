
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
import spout.*;

Spout spout;

Kinect kinect;
ArrayList <SkeletonData> bodies;


PShader edges;  


void kinectSetup()
{
  colorMode(HSB);
  background(0);
  kinect = new Kinect(this);
  smooth();
  bodies = new ArrayList<SkeletonData>();
  spout =new Spout(this);
  spout.createSender("kinectSpout");
}

void kinectDraw()
{
  noStroke();
  noFill();
   
  
  
  spout.sendTexture();

}
void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}