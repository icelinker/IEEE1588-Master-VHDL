# Hardware IEEE1588 Master
Test project to host pure hardware (VHDL) IEE1588 Master 

## Aim
Provide a simple, IEEE1588 Master with constant latency timestamp functionality

## Requires

### Firmware
NMEA Parser
```
git clone https://github.com/craighaywood/VHDL-NMEA-Parser
```
1588 Master IP Core  
- Please contact

### Hardware
- [Numato Saturn](http://numato.com/saturn-spartan-6-fpga-development-board-with-ddr-sdram/) (however project can easily be adapted to any FPGA board)
- SIRF based GPS module (although NMEA parser can easily be adapted to other GPS, see NMEA parser project)


## Results
![Wireshark](https://raw.githubusercontent.com/craighaywood/IEEE1588-Master-VHDL/master/data/screenshot.png)
