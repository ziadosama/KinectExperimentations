import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList <SkeletonData> bodies;


float kinectX,kinectY;

void kinectSetup()
{
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();
}

void kinectDraw()
{
  
  for (int i=0; i<bodies.size (); i++) 
  {
    drawSkeleton(bodies.get(i));
    drawPosition(bodies.get(i));
  }
}

void drawPosition(SkeletonData _s) 
{
  noStroke();
  String s1 = str(_s.dwTrackingID);
}

void drawSkeleton(SkeletonData _s) 
{
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);
}

void DrawBone(SkeletonData _s, int _j1, int _j2) 
{
 // if(frameCount%5==0)
   // fill(random(255), random(255), random(255));
   strokeWeight(40);
   stroke(40);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
      
    kinectX=_s.skeletonPositions[_j2].x*width/2; 
    kinectY=_s.skeletonPositions[_j2].y*height/2;
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