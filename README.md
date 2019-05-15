# OBootLin  

www.osimplc.com/Downloads/  

**This forked code is a stripped and slightly modified version from Tiny Pic Bootloader for GNU/Linux, Luis Claudio Gamboa fork.**  
It has a modified pictype.py module, with only PIC16F887 and 18F4520 microcontrollers identifiers.  
Also, it has only the firmware for PIC16F887 and 18F4520 microcontrollers, running at 20 MHz on external crystal oscillator.  

# Tiny Pic Bootloader for GNU/Linux, Luis Claudio Gamboa fork  
https://github.com/lcgamboa/tinybldlin  

**This forked code is a modified version to handle different bootloader sizes defined by user in file "modules/pictype.py".**  

Latest commit d7cf21b on Dec 16, 2018  
Conversion to python3  
fork
# Tiny Pic Bootloader for GNU/Linux  
http://tinybldlin.sourceforge.net/  

The original Tiny Pic Bootloader for GNU/Linux was writed by Fernando Juarez V.  
Tiny Pic Bootloader for GNU/Linux is licensed under GPL v2.  

TinybldLin has been writted in python using python-serial module and wxphython; it can be run on any linux distro (and maybe mac) who has installed those dependencies.  
This port pretend to be more than a clone of the original tinybldWin.exe; it pretends, in the future, add new futures and enhaces the original ones.  

Latest version tinybldlin-0.8.1-src.tar.gz. Latest update 2012-11-15.  

# Tiny Pic Bootloader for Windows  
http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm  

Tiny Pic Bootloader for Windows (tinybld) was writed by Claudiu Chiculita.  
Tiny Pic Bootloader for Windows is free (as No Cost) software, but it has not a Free (as Libre) Software license.  

Latest version TinyBld-1_10_6_pc_beta.zip. Latest update 2011-08.  

# Installing ObootLin:  

Required dependencies:  

Arch Linux:  
python  
python-pyserial  
python-wxpython  

Debian, Ubuntu and derivatives:  
python3  
python3-serial  
python3-wxgtk4.0  

# Download OBootLin.zip from OSIMPLC Downloads page  

From www.osimplc.com/Downloads/ , download OBootLin.zip  
Decompress it onto a new directory (preferably aside LDmicro directory).  

# Running OBootLin on GNU/Linux: 

## Connect the OSIMPLC Programming Cable, or a generic USB-TTL adapter.  
In GNU/Linux, virtual USB serial ports will appear as /dev/ttyUSB[0-9].  

Check its assignement:  
[$USER@$hostname ~]$ lsusb  
[$USER@$hostname ~]$ ls -l /dev | grep ttyUSB  
crw-rw----  1 root uucp    188,   0 mar  2 13:13 ttyUSB0  
Note: if another USB-serial adapter is previously connected, this new adapter will be renumbered to /dev/ttyUSB1 and so on.  

VERY IMPORTANT: user must be added to the group that allows USB serial access:  
Arch Linux and others (Fedora, openSUSE): uucp group.  
Debian, Ubuntu and derivatives: dialout and/or plugdev groups.  

## Execute OBootLin:  

Change to OBootLin directory:  
[$USER@$hostname ~]$ cd /home/$USER/../OBootLin/  

[$USER@$hostname ObootLin]$ python3 obootlin.py  

In TinyPICBootloaderLin interface:  

Comm dropdown list: Select 19200 (OBootLin uses 19200 baud for programming). 
 
In Comm field, manually assign /dev/ttyUSB[0-n] port, according OS assignement. 

## Check OSIMPLC communication and identification:  

Press the CheckPIC button, and press and release the RESET button in OSIMPLC while progress bar is running.  
Messages Tab:  
 Connected to /dev/ttyUSB0 at 19200  
 Searching for PIC ...  
 Found:16F 886/887  

## Write Flash: download the user program (machine code) onto OSIMPLC:  

Select .hex file using Browse button.  
Press the Write Flash button, and press and release the RESET button in OSIMPLC while progress bar is running.  
Messages Tab:   
 Connected to /dev/ttyUSB0 at 19200  
 HEX:xx days old,INX32M,16Fcode+cfg,total=xxxx bytes.  
 Searching for PIC ...  
 Found:16F 886/887  
 Write OK at hh:mm time: x.xxx sec  
 
## Using virtual terminal to send and receive data from OSIMPLC:  

In Terminal tab:  
Select data baudrate in using dropdown list.  
NOTE: user program data baudrate can be different to OSIMPLC programming and check baudrate, must be defined in LDmicro MCU parameters menu.  

Opening communication: Press Open button.

Receiving data:
If OSIMPLC is sending data, it be displayed in text field.  
Using Rx dropdown, user can see data as Char (character) or Hex codes.  
Being open the comm port, user can select and copy chunks of the text field contents.  

Sending data:
Using Tx dropdown, user can send data as Char (character).  
User can type chars in Tx text field, or copy/paste from file on it.  
After that, press Send button or Enter in keyboard.  
Other types of data can be sent (char\ , Type, TypEcho).

Closing communication: Press Close button.  








