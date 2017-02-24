====================
WSPR TX/RX Simulator
====================

:author: Jonathon Cheah, MITRE


.. contents::

Background
==========

The WSPR program (runs in GNU Octave or Matlab) is designed for sending and receiving low-power, ultra-low baud rate transmissions to chart the worldwide propagation paths on popular Amateur Radio bands. 
This program was initially written by Joe Taylor (K1JT), and released in 2008 and is maintained with periodic new releases. 

The proven successful communication construct of WSPR is an interesting case study for an ultra-low baud communication for Matlab analysis environment. 
The elements of this program are also successfully used in Amateur Radio Earth-Moon-Earth bounce communication. 

Programs
========

``wspr_transmit.m`` begins with packing the transmit data; callsign + maidenhead + power. 
The packed data is FEC encoded with Layland-Lushbaugh Polynomials, interleaved and sync sequence added in producing signal.dat. 

``wspr_receive.m`` reverses the process using fano decoder, originally ported from Phil Karn(KA9Q)'s c-code. 

``Signal.dat`` can be used in building simple SDR for personalized wspr beacons. 
Details can be found in the Internet. 

Program execution
=================

1. wspr_transmit .m produces ``signal.dat`` that is the over-the-air channel signal payload. 
2. ``signal.dat`` is used by ``wspr_receive.m`` to recover the original message. 
3. All the intermediate processing values are displayed for analysis. 

Maidenhead locator can be generated using ``maidenhead.m`` to convert from longitude and latitude values.
