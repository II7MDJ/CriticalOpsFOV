For the new Auto Lipo for iOS 5 - 9+ to work, you must supply a cracked and thinned binary.

Simply add the thinned binary to the critfov/autolipo/Binary/ folder and fill in the critfov/autolipo/postinst file.

The binary will automatically get added to /var/mobile/Binary/ and compiled with your .deb. 

To include Auto Lipo to your Project, edit critfov/Makefile and remove the # from there.
The autolipo folder contains two Auto Lipo postinst files. One works with LipoARM64 and the other works via thinned binary only. You can choose which one you would like to use in your hack.

If you need any more help or have any questions, PM DiDA.