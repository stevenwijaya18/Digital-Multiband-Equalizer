# Real-Time Multiband Equalizer using MATLAB

This project implements a real-time multiband audio equalizer using a software-based approach in MATLAB. It is designed to process audio signals with low latency using a serial hybrid filter architecture, making it suitable for direct instrument input, such as an electric guitar.

## 🚀 Key Features
* **Low Latency:** Uses ASIO4ALL to achieve 2.9ms – 6.5ms processing delay.
* **Hybrid Filtering:**
    * **Stage 1:** 64th-order FIR filter for tone shaping (Rock, Jazz, Pop).
    * **Stage 2:** 4th-order Butterworth IIR filter (8kHz cutoff) for noise reduction.
* **Presets:** Includes Rock, Jazz, Pop, and Flat profiles.
* **Visuals:** Auto-generates Magnitude and Phase response plots.
* **Clipping Protection:** Hard limiter at ±0.99 to prevent digital distortion.

## 📐 Mathematical Model

### Stage 1: FIR Filter (Tone Shaping)
Implemented using a parallel method to combine multiple band-pass responses. The difference equation is:
$$y[n] = \sum_{k=0}^{64} b_k x[n-k]$$

### Stage 2: IIR Filter (Noise Cleaning)
A recursive 4th-order Butterworth filter ensuring a maximally flat passband. The transfer function in the $z$-domain is:
$$H(z) = \frac{b_0 + b_1 z^{-1} + b_2 z^{-2} + b_3 z^{-3} + b_4 z^{-4}}{1 + a_1 z^{-1} + a_2 z^{-2} + a_3 z^{-3} + a_4 z^{-4}}$$

## 🛠️ Setup & Requirements

### Software
* MATLAB (Audio & DSP System Toolboxes)
* ASIO4ALL v2 Driver

### Hardware
* Laptop & USB Audio Interface
* Electric Guitar & 6.5mm Instrument Cables
* Headphones or Amplifier

## 📖 How to Use

1. **Connect:** Plug your instrument into the interface and the interface into your laptop.
2. **Driver:** Set **ASIO4ALL** as the default driver in your MATLAB settings.
3. **Run:** Open and run the main MATLAB script.
4. **Select:** When prompted in the CLI, type a preset: `Rock`, `Jazz`, `Pop`, or `Flat`.
5. **Stop:** Press `Ctrl+C` in the Command Window to safely release the audio drivers.