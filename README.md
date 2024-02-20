# Saturn moon tours using MATLAB
This folder contains AUTOMATE toolbox (MATLAB-based) for designing moon tours in Saturn system. This folder is the result of a collection of papers and theses. The main references are: Strange et al. [[1]](#1), Takubo et al. [[2]](#2), and Bellome [[3]](#3).

The corresponding Python implementation can be found in ESA's MIDAS tool at:

```bash
https://midas.io.esa.int/midas/api_reference/generated/midas.design.tour.html
```

## Installation & Requirements

To work with AUTOMATE, one can simply clone the repository in the local machine:

```bash
git clone "https://github.com/andreabellome/saturn_moon_tours"
```

To run a full exploration of Saturn system, the following recommended system requirements:
+ CPU quad-core from 2.6 GHz to 3.6 GHz
+ RAM minimum 16 GB

Python implementation requires less strict requirements, but it also takes more computational time for a full Saturn exploration

## References
<a id="1">[1]</a> 
Strange, N. J., Campagnola, S., & Russell R. P. (2010). 
*Leveraging flybys of low mass moons to enable an Enceladus orbiter*.
Advances in the Astronautical Sciences. https://www.researchgate.net/publication/242103688_Leveraging_flybys_of_low_mass_moons_to_enable_an_Enceladus_orbiter.

<a id="2">[2]</a> 
Takubo, Y., Landau, D., & Brian, A. (2022). 
*Automated Tour Design in the Saturnian System*.
33rd AAS/AIAA Space Flight Mechanics Meeting, Austin, TX, 2023 . https://arxiv.org/abs/2210.14996.

<a id="3">[3]</a> 
Bellome, A. (2023). 
Trajectory Design of Multi-Target Missions via Graph Transcription and Dynamic Programming.
Ph.D. Thesis, Cranfield University. (text upon request)
