/**
 *
 * @sketch PG_projection
 * @version 2010-05-08
 * @author  Andreas Göransson, a.goransson@1scale1.com
 * Using "Flocking", by Daniel Shiffman.
 * Exhibition for Purification Garcia "Thinking of Dallipur" exhibition, 2010
 * 
 * Copyright (C) 2010 1scale1 HB
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */

/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 */
 
class Led{

  PVector origin;

  /* Start - BOID variables */
  private PVector pos;
  private PVector vel;
  private PVector acc;


  /* End - BOID variables */

  /* Start - Jitter variables */
  float xoff = 0.0f;
  float yoff = 0.0f;
  float xincrement; 
  float yincrement;
  float x_noise;
  float y_noise;
  /* End - Jitter variables */

  float maxReturnVelocity;

  Led( PVector _letterPos, float _x, float _y ){
    origin = new PVector( _letterPos.x + _x, _letterPos.y + _y );

    /* Start - BOID initialization */
    pos = origin.get();
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    /* End - BOID initialization */

    /* Start - Randomize jitter variables */
    xincrement = random(0.005,0.009); 
    yincrement = random(0.005,0.009);
    /* End - Randomize jitter variables */

    maxReturnVelocity = random( 3, 5 );
  }

  void paint(GLGraphicsOffScreen _glg1){
    _glg1.pushMatrix();
    _glg1.translate( pos.x, pos.y );
    _glg1.fill( 255 );
    _glg1.image( bg, 0, 0 );
    _glg1.popMatrix();
  }

  void run() {
    // Get a vector towards the origin
    PVector vel4 = new PVector( (origin.x - pos.x), (origin.y - pos.y) );

    vel4.div( amountOfJitter );
    // Here we want to limit the Led to a max velocity, but it's random within a range so all Led's are not moving the same speed
    vel4.limit( maxReturnVelocity );
    pos.add( vel4 );

    /* Always make them jitter */
    // Get a noise value based on xoff and scale it according to the window's width
    x_noise = (0.5 - noise(xoff)) * amountOfJitter;
    y_noise = (0.5 - noise(yoff)) * amountOfJitter;

    //PVector target = new PVector( (origin.x-(pos.x-x_noise)), (origin.y-(pos.y-y_noise)) );
    PVector jitterTarget = new PVector();

    jitterTarget.set( origin.x + x_noise, origin.y + y_noise, 0.0f );

    PVector jitterVel = new PVector( jitterTarget.x - pos.x, jitterTarget.y - pos.y );

    jitterVel.limit(1);

    pos.add( jitterVel );

    // With each cycle, increment xoff
    xoff += xincrement;
    yoff += yincrement;
  }

  /* Start - BOID methods */
  void run( ArrayList letters ) {
    /* Run the boids code if the bag is showing... */

    flock( letters );
    update();
    borders();

    // With each cycle, increment xoff
    xoff += xincrement;
    yoff += yincrement;
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList letters) {
    for( int i = 0; i < letters.size(); i++ ){
      ArrayList boids = ((Letter)letters.get(i)).getList();

      PVector sep = separate(boids);   // Separation
      PVector ali = align(boids);      // Alignment
      PVector coh = cohesion(boids);   // Cohesion
      // Arbitrarily weight these forces
      sep.mult(2.0);
      ali.mult(1.0);
      coh.mult(1.0);
      // Add the force vectors to acceleration
      acc.add(sep);
      acc.add(ali);
      acc.add(coh);
    }
  }

  // Method to update location
  void update() {

    for( int i = 0; i < nbrOfSeeks; i++ )
      seek( mousePosition );


    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    pos.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  void seek(PVector target) {
    acc.add(steer(target,false));
  }

  void arrive(PVector target) {
    acc.add(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = target.sub(target,pos);  // A vector pointing from the location to the target
    float d2 = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d2 > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d2 < 100.0)) 
        desired.mult(maxspeed*(d2/100.0)); // This damping is somewhat arbitrary
      else 
        desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new PVector(0,0);
    }
    return steer;
  }

  // Wraparound
  void borders() {
    if (pos.x < -(d*2)) pos.x = width+(d);
    if (pos.y < -(d*2)) pos.y = height+(d);
    if (pos.x > width+(d)) pos.x = -(d*2);
    if (pos.y > height+(d)) pos.y = -(d*2);
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList boids) {
    PVector sum = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Led other = (Led) boids.get(i);
      float d2 = pos.dist(other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d2 > 0) && (d2 < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = pos.sub(pos,other.pos);
        diff.normalize();
        diff.div(d2);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div((float)count);
    }
    return sum;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList boids) {

    PVector sum = new PVector(0,0,0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Led other = (Led) boids.get(i);
      float d2 = pos.dist(other.pos);
      if ((d2 > 0) && (d2 < neighbordist)) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.limit(maxforce);
    }
    return sum;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList boids) {
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Led other = (Led) boids.get(i);
      float d2 = pos.dist(other.pos);
      if ((d2 > 0) && (d2 < neighbordist)) {
        sum.add(other.pos); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
  /* End - BOID methods */

  float getX(){
    return pos.x;
  }

  float getY(){
    return pos.y;
  }
}



















































