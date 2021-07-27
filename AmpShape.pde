//___________________________________________________________________________
//An immortal object with gravity in space that pulses to incoming RMS data |
//```````````````````````````````````````````````````````````````````````````
public class AmpShape
{
  boolean screen_bounded;
  boolean use_weighted;
  float minimum_size;
  float shrink_rate;
  
  public float inner_size;
  public float outer_size;
  
  int start_freq_band;
  int end_freq_band;
  
  color inner_color;
  color outer_color;
  int stroke_width;
  
  public float revolve_radius;
  float initial_revolve_radius;
    
  public PVector velocity;
  public PVector location = new PVector(0,0);
  public PVector revolve_point;
  
  public AmpShape(float min_size, float revolve_radius, PVector velocity, PVector location, PVector revolve_point,
                   color inner_color, color outer_color, 
                   boolean screen_bounded, int start_freq_band, 
                   int end_freq_band, boolean use_weighted,int stroke_width)
  {
    minimum_size = min_size;
    shrink_rate = 0.2;
    inner_size = outer_size = minimum_size;
    
    this.inner_color = inner_color;
    this.outer_color = outer_color;
    this.stroke_width = stroke_width;
    
    this.start_freq_band = start_freq_band;
    this.end_freq_band = end_freq_band;
    
    //Initial shape physics
    initial_revolve_radius = revolve_radius;
    this.revolve_radius = revolve_radius;
    this.velocity = velocity;
    this.location.x = revolve_radius*location.x;
    this.location.y = revolve_radius*location.y;
    this.revolve_point = revolve_point;
    
    this.screen_bounded = screen_bounded;
    this.use_weighted = use_weighted;
  }  
  
  void shrink_amp()
  {
    if (outer_size > minimum_size)
      outer_size -= shrink_rate;
    if (revolve_radius > initial_revolve_radius)
    {
      revolve_radius -= shrink_rate;
    }
  }
  
  void check_screen_collision()
  {
    if ((location.x > width - outer_size/2) || (location.x < outer_size/2)) 
    {
      if(location.x > width - outer_size/2)
        location.x = width - outer_size/2;
      else
        location.x = outer_size/2;
      velocity.x = velocity.x * -0.95;
    }
    
    if (location.y > height - outer_size/2 || location.y < outer_size/2) 
    {
      if (location.y > height - outer_size/2)
        location.y = height - outer_size/2;
      else
        location.y = outer_size/2;
      velocity.y = velocity.y * -0.95; 
    }
  }
  
  void analyze()
  {
    //Shrink outer shape
    shrink_amp();
    
    //Set amp shape size
    float spectrum_avg = 0;
    for (int i = start_freq_band; i < end_freq_band; i++)
    {
      if (use_weighted)
        spectrum_avg += spectrum_sum_weighted[i];
      else
        spectrum_avg += spectrum_sum[i];
    }
    spectrum_avg /= (end_freq_band-start_freq_band);
    inner_size = (spectrum_avg * 2000) + minimum_size;
    
    //Check amp shape against minimum size. Increase size of outer shape to match inner shape if it's bigger.
    if (inner_size < minimum_size)
      inner_size = minimum_size;
    
    if (inner_size > outer_size-stroke_width)
      outer_size = inner_size+stroke_width;
      
    if (spectrum_avg * 500 + initial_revolve_radius > revolve_radius)
      revolve_radius = spectrum_avg * 500 + initial_revolve_radius;
    
    // Add velocity to the location.
    location.add(velocity);
    // Add gravity to velocity
    velocity.add(gravity);
  }
  
  void set_location(PVector change)
  {
    location = change;
  }
  
  void move(PVector change)
  {
    location.x += change.x;
    location.y += change.y;
  }
  
  void revolve(float theta)
  {
    location.x = revolve_point.x + revolve_radius*cos(theta);
    location.y = revolve_point.y + revolve_radius*sin(theta);
  }
  
  void set_revolve_point(float x, float y)
  {
    revolve_point.x = x;
    revolve_point.y = y;
  }
  
  void set_velocity(PVector change)
  {
    velocity = change;
  }
  
  void accel(PVector change)
  {
    velocity.x += change.x;
    velocity.y += change.y;
  }
  
  void draw()
  {
    if (screen_bounded)
      check_screen_collision();
  }
}
