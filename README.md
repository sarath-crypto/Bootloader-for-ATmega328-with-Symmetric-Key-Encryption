This project address bootloader with encryption feature.
The encrypted application firmware is uploaded via serial port communictaion to the atmega328 , bootloader and encryption key is burned via USBasp  into Atmega328
encryption of application is done by encryptor.cpp
uploading of encrypted hex firwmware application via bootloader done using uploader.cpp via serial port
bootloader send messages for 10 seconds waiting for any firmware upload by user upon powerup/reset, if no response it will start execution already stored appplictaion.
