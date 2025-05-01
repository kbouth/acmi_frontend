ACMI Frontend Platform 

Gateware for ACMI Frontend.  Uses custom Artix board as the hardware platform.   Communicates with withe ACMI backend hardware via fiber.  Responsible for all ACMI related safety tasks 

Uses the DESY FWK FPGA Firmware Framework https://fpgafw.pages.desy.de/docs-pub/fwk/index.html

Clone with --recurse-submodules to get the FWK repos

git clone --recurse-submodules git@github.com:kbouth/acmi_frontend.git

Setup Environment: make env (first time only)

To build firmware make cfg=hw project (Sets up project)

make cfg=hw gui (Open in Vivado)

make cfg=hw build (Builds bit file)


