void newtxt(){
  /* Just making an even spacing between letters based on screensize */
  float kx = width/9; // based on the first row, 7 characters + 1 space on each side
  float ky = height/5; // based on the number of rows + 1 empty row above and one below
  
  /* Then we have the constants for nudging each line of the message to the right */
  /* These variables are declared in the preferences, so we can modify them from XML */
  /* int nudgeFirstLine, int nudgeSecondLine, int nudgeThirdLine */
  
  message.add( new Letter( 't', new PVector( nudgeFirstLine + (kx + letterspacing) , ky + nudgeY ) ) );
  message.add( new Letter( 'h', new PVector( nudgeFirstLine + 2*(kx + letterspacing), ky + nudgeY ) ) );
  message.add( new Letter( 'i', new PVector( nudgeFirstLine + 3*(kx + letterspacing), ky + nudgeY ) ) );
  message.add( new Letter( 'n', new PVector( nudgeFirstLine + 4*(kx + letterspacing)-(kx + letterspacing)/3, ky + nudgeY ) ) );
  message.add( new Letter( 'k', new PVector( nudgeFirstLine + 5*(kx + letterspacing)-(kx + letterspacing)/3, ky + nudgeY ) ) );
  message.add( new Letter( 'i', new PVector( nudgeFirstLine + 6*(kx + letterspacing)-(kx + letterspacing)/3, ky + nudgeY ) ) );
  message.add( new Letter( 'n', new PVector( nudgeFirstLine + 7*(kx + letterspacing)-2*(kx + letterspacing)/3, ky + nudgeY ) ) );
  message.add( new Letter( 'g', new PVector( nudgeFirstLine + 8*(kx + letterspacing)-2*(kx + letterspacing)/3, ky + nudgeY ) ) );

  message.add( new Letter( 'o', new PVector( nudgeSecondLine + width/2 - (kx + letterspacing)/2, 2*ky + nudgeY ) ) );
  message.add( new Letter( 'f', new PVector( nudgeSecondLine + width/2 + (kx + letterspacing)/2, 2*ky + nudgeY ) ) );

  message.add( new Letter( 'd', new PVector( nudgeThirdLine + (kx + letterspacing), 3*ky + nudgeY ) ) );
  message.add( new Letter( 'a', new PVector( nudgeThirdLine + 2*(kx + letterspacing), 3*ky + nudgeY ) ) );
  message.add( new Letter( 'l', new PVector( nudgeThirdLine + 3*(kx + letterspacing), 3*ky + nudgeY ) ) );
  message.add( new Letter( 'l', new PVector( nudgeThirdLine + 4*(kx + letterspacing), 3*ky + nudgeY ) ) );
  message.add( new Letter( 'i', new PVector( nudgeThirdLine + 5*(kx + letterspacing), 3*ky + nudgeY ) ) );
  message.add( new Letter( 'p', new PVector( nudgeThirdLine + 6*(kx + letterspacing)-(kx + letterspacing)/3, 3*ky + nudgeY ) ) );
  message.add( new Letter( 'u', new PVector( nudgeThirdLine + 7*(kx + letterspacing)-(kx + letterspacing)/3, 3*ky + nudgeY ) ) );
  message.add( new Letter( 'r', new PVector( nudgeThirdLine + 8*(kx + letterspacing)-(kx + letterspacing)/3, 3*ky + nudgeY ) ) );

}


