import processing.sound.*;

AudioIn input;
AudioIn input2;
Amplitude rms;
FFT fft;

int scale=1;

float audioIn=0.0;

// Define how many FFT bands we want
int bands = 128;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;