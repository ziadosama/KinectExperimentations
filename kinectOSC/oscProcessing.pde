


void oscSetup() {
  oscP5 = new OscP5(this,10000);
  myRemoteLocation = new NetAddress("192.168.1.3", 10000);
}

void oscSend(float x, float y, String joint) {
  OscMessage myMessage = new OscMessage(joint+"x");
  myMessage.add(x); /* add an int to the osc message */
  OscMessage myMessage2 = new OscMessage(joint+"y");
  myMessage2.add(y); /* add an int to the osc message */
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
  oscP5.send(myMessage2, myRemoteLocation);
}