//___________________________________________________________________________
//An immortal object with gravity in space that pulses to incoming RMS data |
//```````````````````````````````````````````````````````````````````````````
public class AmpSquare extends AmpShape
{
  public AmpSquare(float min_size, float revolve_radius, PVector velocity, PVector location, PVector revolve_point,
                   color inner_color, color outer_color, boolean screen_bounded, int start_freq_band, 
                   int end_freq_band, boolean use_weighted, int stroke_width)
  {
    super(min_size, revolve_radius, velocity, location, revolve_point,
          inner_color,  outer_color, screen_bounded, start_freq_band, 
          end_freq_band, use_weighted, stroke_width);
  }
  
  void draw()
  {
    if (screen_bounded)
      check_screen_collision();
      
    //Draw Amp Circle
    stroke(color(outer_color));
    strokeWeight(4);
    fill(color(outer_color));
    square(location.x-outer_size/2,location.y-outer_size/2,outer_size);

    //Draw Amp Ring
    fill(color(inner_color));
    noStroke();
    square(location.x-inner_size/2,location.y-inner_size/2,inner_size);
  }
}
