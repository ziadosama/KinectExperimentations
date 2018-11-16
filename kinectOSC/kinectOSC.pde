import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Kinect kinect;
ArrayList <SkeletonData> bodies;


PShader edges;  

void setup()
{
  size(1280, 960, P2D);
  colorMode(HSB);
  frameRate(25);
  background(0);
  kinect = new Kinect(this);
  smooth();
  oscSetup();
  bodies = new ArrayList<SkeletonData>();
  edges = loadShader("data/glsl.frag");
  edges.set("resolution", float(width), float(height));
}

void draw()
{
  scale(2);
  edges.set("time", millis() / 1000.0);
  noStroke();
  resetShader();
  noFill();
  fill(0, 5);
  filter(DILATE);
  rect(0, 0, width, height);
  shader(edges);



  for (int i=0; i<bodies.size (); i++) 
  {
    drawSkeleton(bodies.get(i));
  }
}


void drawSkeleton(SkeletonData _s) 
{
  // Right Arm
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_HAND_RIGHT, "/rightArm" );
    
  // Left Arm
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
    Kinect.NUI_SKELETON_POSITION_HAND_LEFT, "/leftArm");

  // Left Leg
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT, 
    Kinect.NUI_SKELETON_POSITION_FOOT_LEFT, "/leftLeg");

  // Right Leg
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT, "/rightLeg");
}

void DrawBone(SkeletonData _s, int _j1, int _j2, String str) 
{
  // if(frameCount%5==0)
  // fill(random(255), random(255), random(255));
  strokeWeight(50);
  stroke(50);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
      oscSend(norm(_s.skeletonPositions[_j2].x, 0,1), norm(_s.skeletonPositions[_j2].y, 0, 1), str);
      line(_s.skeletonPositions[_j1].x*width/2, 
    _s.skeletonPositions[_j1].y*height/2, 
    _s.skeletonPositions[_j2].x*width/2, 
    _s.skeletonPositions[_j2].y*height/2);
  }
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