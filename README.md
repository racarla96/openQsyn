# openQsyn
A modern open source toolbox for QFT control synthesis

**Quantitative Feedback Theory (QFT)** is a frequency domain robust control design technique, introduced by [Isaac Horowitz](https://en.wikipedia.org/wiki/Isaac_Horowitz). 
If you were looking for Quantum Field Theory you are in the wrong place!

The goal of this project is to provide a modern and completely free open source toolbox to aid QFT control synthesis. It will replace the very capable, yet obsolete, Qsyn toolbox, developed by Prof. Per-Olof Gutman in the 90s. The development is supported by Prof. Gutman himself, and all resued code is done with his premission. 

## How to use

### Installation
1. Create a folder names e.g **openQsyn** and open git bush
2. Clone the repo by typing: `git clone https://github.com/rubindan/openQsyn`
2. Add  **openQsyn** to your Matlab path
3. Run `oqsyn` to initiate the toolbox

### Demo 
A quick introductory example is found in the live script exmaple.mlx 
This exmaple will guide you through the steps of SISO design: definning a new plant, defining specifications, computaing template and bound, designing a feedback compensator and a pre-filter. 

## Status
Open Qsyn toolbox is under construction, but it can already be used for siso qft design for plants with parametric uncertainty, unstructuerd uncertainty, and uncertain delay. Feel free to open issues in order to report bugs and suggests new features. Just check the isses section and the below to-do list first :). 

### To-Do list:
- qplant:
  - unstructured uncertainty
  - real factored form 
  - import from Robust Control Toolbox
- qtpl:  
  - template union
  - nominal case interoplation 
- qpar:
  - import from Robust Control Toolbox
- qdesign:
  - make template input possible 
  - interpolate nominal if not exist (prompt user?)
- cascade design support
- MIMO design support

## Contact
rubindan115 at gmail dot com
