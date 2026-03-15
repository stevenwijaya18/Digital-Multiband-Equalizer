# Real-Time Multiband Equalizer Berbasis MATLAB

This project implements a real-time multiband audio equalizer using a software-based approach in MATLAB. It is designed to process audio signals with low latency using a serial hybrid filter architecture, making it suitable for direct instrument input, such as an electric guitar.

---

## 📑 Features

* **Low-Latency Audio Streaming:** Utilizes the ASIO protocol (ASIO4ALL v2) to bypass the standard operating system audio mixer, achieving a theoretical base latency of around 2.9 ms to 6.5 ms.
* **Hybrid Filter Architecture:** * **Stage 1 (Tone Shaping):** A Finite Impulse Response (FIR) filter (order $N=64$) designed using a parallel method to combine multiple band-pass responses.
    * **Stage 2 (Noise Cleaning):** An Infinite Impulse Response (IIR) Butterworth Low-Pass filter (order 4) with an 8 kHz cut-off frequency to limit bandwidth and reduce high-frequency digital noise.
* **Built-in Genre Presets:** Includes dynamically calculated filter coefficients for Rock, Jazz, Pop, and Flat profiles.
* **Real-Time Visualizations:** Automatically generates and saves Magnitude and Phase Response plots for the selected active preset.
* **Clipping Protection:** Includes a hard limiter threshold at ±0.99 to prevent audio clipping before reaching the output driver.

---

## 🛠️ Prerequisites

To run this system, you will need the following software and hardware setups:

### Software
* **MATLAB** (with Audio System Toolbox and DSP System Toolbox).
* **ASIO4ALL v2 Driver** installed on your system.

### Hardware
* **Laptop** for processing.
* **Audio Interface** (e.g., Guitar Pedal with USB capability).
* **Electric Guitar** or any analog audio source.
* **Amplifier/Speakers** or Headphones.
* **6.5mm Instrument Cables** and a USB cable.

---

## 🚀 How to Run

1.  **Hardware Setup:** Connect your instrument to the audio interface input, connect the audio interface to the laptop via USB, and route the laptop's audio output to your amplifier or headphones.
2.  **Configure ASIO:** Ensure ASIO4ALL is selected as the primary driver for both input and output in your system settings.
3.  **Execute the Script:** Run the provided MATLAB script (`main.m` or equivalent). 
4.  **Select a Preset:** The Command Line Interface (CLI) will prompt you to type a mode:
    * `Rock`: Scooped mid-range, boosted bass and treble for high energy.
    * `Jazz`: Smooth high-frequency roll-off for a warm tone.
    * `Pop`: Boosted mid-range for clarity and articulation.
    * `Flat`: Unaltered bypass mode.
5.  **Play:** The script will enter an infinite loop, processing your audio in real-time. 
6.  **Stop:** Press `Ctrl+C` in the MATLAB Command Window to safely release the audio drivers and terminate the program.