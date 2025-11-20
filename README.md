This project address bootloader with encryption feature.
The encrypted application firmware is uploaded via serial port communictaion to the atmega328 , bootloader and encryption key is burned via USBasp  into Atmega328.
Encryption of application is done by encryptor.cpp.
Uploading of encrypted hex firwmware application via bootloader done using uploader.cpp using serial port.
Bootloader send messages for 10 seconds waiting for any firmware upload by user upon powerup/reset, if no response from user bootloader start execution already stored appplictaion.
