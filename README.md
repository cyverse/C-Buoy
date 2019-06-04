# Check dscheck
Description: This program will perform a series of short network connections between your system and a CyVerse server to determine if there might be potential connectivity issues to the CyVerse Data Store. 

To make this program executable, run the following commnand on your terminal: chmod +x <filename>
  
The first thing that this program checks is whether your sytem has a 'curl' or 'wget' installed or not. If neither command is installed, it will prompt the you to install either one of the two commands and exits the program. If one (or both) of the two commands is installed, the program will continue executing and begin the tests.

These tests will identify if a connection problem exist betweeen your system and the ports available. If a connection problem is detected, the testing stops immediately and reports an error message that lets you know which port is having an issue connecting to your system. If there is no error detected, the program displays a success message.

Note: If the tests begin to slow down over time, then your internet provider may be throttling connections.
