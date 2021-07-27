public void init_audio()
{
  // Create and patch the rms tracker and FFT analyzer
  rms = new Amplitude(this);
  fft = new FFT(this, spectrum_bands);
  calc_ITUR468(spectrum_bands, SAMPLE_RATE);
  //Display sound devices if looking for a specific input.
  Sound.list();
  
  //Depending on the type of analysis, choose a different audio stream
  //choose_audio_type(AudioType.sample);
  choose_audio_type(AudioType.direct);
}

public void choose_audio_type(AudioType type)
{
  if (type == AudioType.sample)
  {
    System.out.print("Using sample audio for analysis.");
    sample = new SoundFile(this, "input.wav");
    sample.loop();
    rms.input(sample);
    fft.input(sample);
  }
  else if (type == AudioType.direct)
  {
    System.out.print("Using direct audio for analysis.");
    //Will always pick system default device unless a way to pick which device is implemented.
    sound_device = new AudioIn(this,0);
    sound_device.start();
    rms.input(sound_device);
    fft.input(sound_device);
  }
}

public void analyze_audio()
{
  //Get amplitude value
  amplitude_sum += (rms.analyze() - amplitude_sum) * smoothing_factor;
  
  //Get spectrum band value for each band
  fft.analyze(spectrum_sum);
  for (int i = 0; i < spectrum_bands; i++)
  {
    //The subtraction of spectrum sum is for the old value for spectrum_sum.
    // The intention is that spectrum_sum returns to 0 eventually if no audio stream is coming.
    spectrum_sum[i] += (fft.spectrum[i] - spectrum_sum[i]) * smoothing_factor;
    spectrum_sum_weighted[i] = spectrum_sum[i] * (float)ITUR468_amp_modifier[i] * 0.5;
  }
  
}

public void calc_ITUR468(int num_bands, int sample_rate)
{
  float avail_frequency = sample_rate/2;
  float frequency_per_band = avail_frequency/num_bands;
  double[] ITUR468_db_delta = new double[num_bands];
  double h1;
  double h2;
  double R_itu;
  double itu;
  double min_itu = 0;
  double max_itu = 0;
  
  //Calculate ITU for every available frequency of the spectrum
  for (int i = 0; i < num_bands; i++)
  {
    freq_boundaries[i] = (i * frequency_per_band) + frequency_per_band;

    h1 = get_ITUR468_h1(freq_boundaries[i]);
    h2 = get_ITUR468_h2(freq_boundaries[i]);

    R_itu = (R_itu_1 * freq_boundaries[i]) / sqrt(pow((float)h1,2)+pow((float)h2,2));
    itu = 18.2 + (20*(log((float)R_itu)/log(10)));
        
    if(itu > max_itu && freq_boundaries[i] < HEARING_LIMIT_FREQ)
      max_itu = itu;
    if(itu < min_itu && freq_boundaries[i] < HEARING_LIMIT_FREQ)
      min_itu = itu;
      
    ITUR468_db_delta[i] = itu;
  }
  
  for(int i = 0; i < num_bands; i++)
  {
    if (freq_boundaries[i] > HEARING_LIMIT_FREQ)
      ITUR468_amp_modifier[i] = 0;
    else
      ITUR468_amp_modifier[i] = (ITUR468_db_delta[i] + abs((float)min_itu))/(max_itu+abs((float)min_itu));
  }
}

public double get_ITUR468_h1(float freq)
{
  return (R_itu_h1_1*pow(freq,6)) + (R_itu_h1_2*pow(freq,4)) + (R_itu_h1_3*pow(freq,2)) + 1;
}
public double get_ITUR468_h2(float freq)
{
  return (R_itu_h2_1*pow(freq,5)) + (R_itu_h2_2*pow(freq,3)) + (R_itu_h2_3*freq);
}
