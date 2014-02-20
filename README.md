PSP-Display-Driver
==================

![PSP display driver](http://www.dgkelectronics.com/blog/wp-content/uploads/2014/02/psp_display_driver_working.jpg)

This VHDL is for my PlayStation Portable display driver project: 
http://www.dgkelectronics.com/fpga-based-playstation-portable-display-driver/

It includes a testbench for ModelSim and can drive a LQ043T3DX02 display from 
Sharp.

Currently there is no data bus or framebuffer implemented. It has a process 
(called *data_gen*) that runs runs a neat sprite demo made by my friend mankeli.
