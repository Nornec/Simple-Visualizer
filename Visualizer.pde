//This sketch is meant to visualize audio data and display it on screen in a stylized way.
import processing.sound.*;

float turntable_accel;
float turntable_direction_factor = -PI;
int random_amount = 1920;
int random_amount_2 = 50;
float turntable_direction_adder = 0.001;
AmpShape single_shape;

void setup()
{
  size(1920,1080);
  frameRate(60);
  draw_background(background_color);
  init_audio();
  set_physics(default_gravity);

  int treble_num_shapes = 50;
  for(int i = 0; i < treble_num_shapes; i += 1)
  {
    treble_amp_shapes.add(new AmpTriangle(
                      50+random(-random_amount,random_amount), //Size
                      190+random(-random_amount,random_amount), // Revolve radius
                      new PVector(), //Initial Velocity
                      new PVector(cos(radians((360/treble_num_shapes)*i))+(width/2),
                                  sin(radians((360/treble_num_shapes)*i))+(height/2)), //Initial location
                      new PVector(width/2+random(-random_amount,random_amount),
                                  height/2 +random(-random_amount,random_amount)), //Revolve point
                      color(20), //Inner color
                      color(bass_color[0],bass_color[1],bass_color[2]), //Outer color
                      false, //Bound to screen?
                      i+20, //Starting freq band
                      i+22, //Ending freq band
                      true, //Use ITUR Weighting?
                      10)); //Stroke width
  }
  int mid_num_shapes = 50;
  for(int i = 0; i < mid_num_shapes; i += 1)
  {
    mid_amp_shapes.add(new AmpCircle(
                      50+random(-random_amount_2,random_amount_2),
                      200+random(-random_amount,random_amount),
                      new PVector(),
                      new PVector(cos(radians((360/mid_num_shapes)*i))+(width/2),sin(radians((360/mid_num_shapes)*i))+(height/2)), 
                      new PVector(width/2+random(-random_amount,random_amount),height/2 +random(-random_amount,random_amount)), 
                      color(0),
                      color(bass_color[0],bass_color[1],bass_color[2]),
                      false,i+15,i+16,true,2));
  }
  int bass_num_shapes = 50;
  for(int i = 0; i < bass_num_shapes; i += 1)
  {
    bass_amp_shapes.add(new AmpSquare(
                      50+random(-random_amount_2,random_amount_2),
                      210+random(-random_amount,random_amount),
                      new PVector(),
                      new PVector(cos(radians((360/bass_num_shapes)*i))+(width/2),sin(radians((360/bass_num_shapes)*i))+(height/2)), 
                      new PVector(width/2+random(-random_amount,random_amount),height/2 +random(-random_amount,random_amount)),
                      color(0),
                      color(bass_color[0]+random(-random_amount_2,random_amount_2),bass_color[1]+random(-random_amount_2,random_amount_2),bass_color[2]+random(-random_amount_2,random_amount_2)),
                      false,i+10,i+11,true,2));
  }
  int extra_shapes = 0;
  for(int i = 0; i < extra_shapes; i += 1)
  {
    extra_amp_shapes.add(new AmpTriangle(
                      50+random(-random_amount_2,random_amount_2),
                      220+random(-random_amount,random_amount),
                      new PVector(),
                      new PVector(cos(radians((360/extra_shapes)*i))+(width/2),sin(radians((360/extra_shapes)*i))+(height/2)), 
                      new PVector(width/2,height/2), 
                      color(0),
                      color(120),
                      false,i+10,i+11,true,10));
  }
  single_shape = new AmpCircle(
                          200,
                          0,
                          new PVector(),
                          new PVector(cos(radians((360)))+(width/2),sin(radians((360)))+(height/2)), 
                          new PVector(width/2,height/2),                          
                          color(0),                         
                          color(extra_color[0],extra_color[1],extra_color[2]),
                          false,1,8,true,2);
}

//Runs continuously to draw one (all) collection(s) of shapes defined above
void draw()
{
  elapsed = millis();
  
  for (AmpShape as : treble_amp_shapes)
    as.analyze();
  for (AmpShape as : mid_amp_shapes)
    as.analyze();
  for (AmpShape as : bass_amp_shapes)
    as.analyze();
  for (AmpShape as : extra_amp_shapes)
    as.analyze();
  single_shape.analyze();
    
  turntable_accel += amplitude_sum/15;
    
  turntable_direction_factor += turntable_direction_adder;
  if (turntable_direction_factor > PI)
    turntable_direction_factor = -PI;

  draw_background(background_color);
  
  single_shape.revolve((turntable_accel/4 - (TWO_PI/treble_amp_shapes.size())));
  single_shape.draw();
  
  for (int i = 0; i < treble_amp_shapes.size(); i++)
  {
    AmpShape as = treble_amp_shapes.get(i);
    //turntable_accel is the speed and direction at which the shapes will move.
    //positive moves clockwise, negative moves counterclockwise
    //It is an acceleration because the shape is always rotating
    
    //Oscillating movement
    as.revolve((turntable_accel/4 + (i*TWO_PI/treble_amp_shapes.size()*sin(turntable_direction_factor)/2)));
    
    //Normal Movement
    //as.revolve((turntable_accel/4 - (i*TWO_PI/treble_amp_shapes.size())));

    as.draw();
  }
  for (int i = 0; i < mid_amp_shapes.size(); i++)
  {
    AmpShape as = mid_amp_shapes.get(i);
    
    //Oscillating Movement
    as.revolve((turntable_accel/4 + (i*TWO_PI/mid_amp_shapes.size()*sin(turntable_direction_factor)/4)));
    
    //Normal movement
    //as.revolve((turntable_accel/2 - (i*TWO_PI/mid_amp_shapes.size())));
    
    as.draw();
  }
  for (int i = 0; i < bass_amp_shapes.size(); i++)
  {
    AmpShape as = bass_amp_shapes.get(i);

    //Oscillating movement
    as.revolve((turntable_accel/4 - (i*TWO_PI/bass_amp_shapes.size()*sin(turntable_direction_factor)/2)));
    
    //Normal movement
    //as.revolve((turntable_accel + (i*TWO_PI/bass_amp_shapes.size())));
    
    as.draw();
  }
  for (int i = 0; i < extra_amp_shapes.size(); i++)
  {
    AmpShape as = extra_amp_shapes.get(i);

    //Oscillating movement
    //as.revolve((turntable_accel/4 - (i*TWO_PI/bass_amp_shapes.size()*sin(turntable_direction_factor))));
    
    //Normal movement
    as.revolve((turntable_accel*2 + (i*TWO_PI/extra_amp_shapes.size())));
    
    as.draw();
  }
  //Get concurrent audio data
  analyze_audio();
}
