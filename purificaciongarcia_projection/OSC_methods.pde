
/* Start - OSC function declaration */
OscMessage lastMessage;

void oscEvent( OscMessage msg ){

  /* Start - Gamuza control */
  if( lastMessage == null ){
    lastMessage = msg;
  }
  if( !msg.checkAddrPattern( "/oscCFG/Geom0" ) ){
    if( msg.checkAddrPattern( "/oscCFB/Blob0" ) ) {
      if( msg.checkTypetag( "fffff" ) ) {
        //println( msg.typetag() + "   1");
        // This runs the flocking
        FLOCK = false;

        mousePosition.set( msg.get(0).floatValue()*width, msg.get(1).floatValue()*height, 0.0f); 
      }
    }
    else if( msg.checkAddrPattern( "/oscCFB/BlobNUM" ) && lastMessage.checkAddrPattern( "/oscCFB/BlobNUM" )  ){
      FLOCK = true;
    }
    lastMessage = msg;
  }
  /* End - Gamuza control */

  /* Start - iPhone control */
  if( iphone != 0 ){
    if( (msg.addrPattern()).indexOf( "/mrmr tactile3D" ) == 0 ){
      // This moves the mouse position
      if( msg.checkTypetag( "fff" ) ){
        FLOCK = false;

        mousePosition.set( msg.get(0).floatValue()*width, msg.get(1).floatValue()*height, 0.0f); 
      }
      lastMessage = msg;
    }
    else if( (msg.addrPattern()).indexOf( "/mrmr tactilezone" ) == 0 && (lastMessage.addrPattern()).indexOf( "/mrmr tactile3D" ) == -1 ){
      FLOCK = true;
      lastMessage = msg;
    }
  }
  /* End - MrMr control */
}
/* End - OSC function declaration */
























