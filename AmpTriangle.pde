//___________________________________________________________________________
//An immortal object with gravity in space that pulses to incoming RMS data |
//```````````````````````````````````````````````````````````````````````````
public class AmpTriangle extends AmpShape
{
  public AmpTriangle(float min_size, float revolve_radius, PVector velocity, PVector location, PVector revolve_point,
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
      
    PVector oA = new PVector(location.x,location.y-((sqrt(3)/3)*outer_size));
    PVector oB = new PVector(oA.x-(outer_size/2),oA.y+((sqrt(3)/2)*outer_size));
    PVector oC = new PVector(oA.x + (cos(atan2(oB.y-oA.y,oB.x-oA.x)-PI/3) * dist(oA.x,oA.y,oB.x,oB.y)),
                             oA.y + (sin(atan2(oB.y-oA.y,oB.x-oA.x)-PI/3) * dist(oA.x,oA.y,oB.x,oB.y)));
    
    //Draw Outer Shape
    stroke(color(outer_color));
    strokeWeight(4);
    fill(color(outer_color));
    
    triangle(oA.x,oA.y,oB.x,oB.y,oC.x,oC.y);
    
    PVector iA = new PVector(location.x,location.y-((sqrt(3)/3)*inner_size));
    PVector iB = new PVector(iA.x-(inner_size/2),iA.y+((sqrt(3)/2)*inner_size));
    PVector iC = new PVector(iA.x + (cos(atan2(iB.y-iA.y,iB.x-iA.x)-PI/3) * dist(iA.x,iA.y,iB.x,iB.y)),
                             iA.y + (sin(atan2(iB.y-iA.y,iB.x-iA.x)-PI/3) * dist(iA.x,iA.y,iB.x,iB.y)));

    //Draw Inner Shape
    fill(color(inner_color));
    noStroke();  
   
    triangle(iA.x,iA.y,iB.x,iB.y,iC.x,iC.y);
  }
}
