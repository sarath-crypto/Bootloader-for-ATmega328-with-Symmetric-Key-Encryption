rm  *.elf *.hex *.o
rm tags
ctags -R *

avr-g++ -g -Os -mmcu=atmega328p -c bootloader.cpp 
avr-g++ -g -mmcu=atmega328p -o bootloader.elf  bootloader.o
avr-g++ -g -Wall -Os -mmcu=atmega328 -Wl,-Ttext=0x7000 -o bootloader.elf bootloader.o 
avr-objcopy -j .text -j .data -O ihex bootloader.elf bootloader.hex
nb=$(srec_info bootloader.hex -intel)
nb=$(echo $nb | cut -d ' ' -f 12-)
nb=$((16#$nb))
nb=$((nb-28672))
nb=$((nb+1))
echo $nb"/2048 words" 

avrdude -c usbasp -p m328p -B5
avrdude -c usbasp -p m328p -U hfuse:w:0xD8:m
avrdude -c usbasp -p m328p -U lfuse:w:0xE2:m
avrdude -c usbasp -p m328p -U efuse:w:0xFF:m
avrdude -c usbasp -p m328p -U flash:w:bootloader.hex

srec_cat bootloader.hex -intel -exclude 0x0000 0x3800 -o bootloader.hex -intel

line=$(tail --lines=1 keygen.cfg)
w=( $line )
sn="${w[0]}"
ky="${w[1]}"
vn="${w[2]}"
ts="${w[3]}AB"
echo -n $sn > sig.bin
echo -n $ky | xxd -r -p >> sig.bin
echo -n $vn  >> sig.bin
echo -n $ts | xxd -r -p >> sig.bin
srec_cat sig.bin --binary -o sig.hex -intel
rm sig.bin -f
srec_cat sig.hex -intel -crop 0x000000 0x000020 -offset 0x007FE0 -o sigm.hex -intel
rm sig.hex -f
srec_cat sigm.hex -intel -exclude 0x0000 0x7FE0 -o sige.hex -intel
rm sigm.hex -f
srec_info sige.hex -intel
srec_cat firmw.hex -intel sige.hex -intel -offset -minimum-addr firmw.hex -intel -o fw.hex -intel
srec_info fw.hex -intel
rm sige.hex -f

srec_cat app.hex -intel bootloader.hex -intel -offset -minimum-addr app.hex -intel -o firmw.hex -intel
./encryptor -r firmw.hex efirmw.hex <key>
