//General definitions
public int background_color = 0;
public int[] mouse_pos = {0,0};

public float elapsed;

public int[] treble_color = {0,200,75};
public int[] mid_color = {75,0,250};
public int[] bass_color = {250,0,70};
public int[] extra_color = {120,239,98};

//Physics
PVector default_gravity = new PVector(0,0);
PVector gravity;

public enum AudioType
{
  sample,
  direct
}

public ArrayList<AmpShape> treble_amp_shapes = new ArrayList<AmpShape>();
public ArrayList<AmpShape> mid_amp_shapes = new ArrayList<AmpShape>();
public ArrayList<AmpShape> bass_amp_shapes = new ArrayList<AmpShape>();
public ArrayList<AmpShape> extra_amp_shapes = new ArrayList<AmpShape>();

//Audio-related Definitions
public double R_itu_1 = 1.246332637532143 * pow(10,-4);

public double R_itu_h1_1 = -4.737338081378384 *pow(10,-24);
public double R_itu_h1_2 = 2.043828333606125 * pow(10,-15);
public double R_itu_h1_3 = -1.363894795463638 * pow(10,-7);

public double R_itu_h2_1 = 1.306612257412824 * pow(10,-19);
public double R_itu_h2_2 = -2.118150887518656 * pow(10,-11);
public double R_itu_h2_3 = 5.559488023498642 * pow(10,-4);

public SoundFile sample;
public AudioIn sound_device;
public int SAMPLE_RATE = 96000;
public int HEARING_LIMIT_FREQ = 96000;

public Amplitude rms;
public FFT fft;
       
public float smoothing_factor = 0.05;  
public int spectrum_bands = 1024;

public float amplitude_sum;
public float[] spectrum_sum = new float[spectrum_bands];
public float[] spectrum_sum_weighted = new float[spectrum_bands];
public float[] freq_boundaries = new float[spectrum_bands];
public double[] ITUR468_amp_modifier = new double[spectrum_bands];
