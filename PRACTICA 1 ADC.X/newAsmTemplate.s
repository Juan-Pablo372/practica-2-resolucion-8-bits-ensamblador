PROCESSOR 16F887
#include <xc.inc>
;configuración de los fuses
    CONFIG FOSC=INTRC_NOCLKOUT
    CONFIG WDTE=OFF
    CONFIG PWRTE=ON
    CONFIG MCLRE=OFF
    CONFIG CP=OFF
    CONFIG CPD=OFF
    CONFIG BOREN=OFF
    CONFIG IESO=OFF
    CONFIG FCMEN=OFF
    CONFIG LVP=OFF
    CONFIG DEBUG=ON
    
    
    CONFIG BOR4V=BOR40V
    CONFIG WRT=OFF
PSECT udata
var_1:
    DS 1
var_2:
    DS 1  
tick:
    DS 1
counter:
    DS 1
counter2:
    DS 1
operador:
    DS 1
        
PSECT code
delay:
movlw 0xff
movwf counter
counter_loop:
movlw 0xff
movwf tick
tick_loop:
decfsz tick,f
goto tick_loop
decfsz counter,f
goto counter_loop
return
    
PSECT resetVec,class=CODE,delta=2
resetVec:
goto main
PSECT main,class=CODE,delta=2
main:
BANKSEL ADCON1           ;configuramos el registro ADCON1
movlw 0b10000000
movwf ADCON1
    
BANKSEL ADCON0          ;configuramos el registro ADCON0
movlw 0b10000001
movwf ADCON0
        
BANKSEL OSCCON           ;configuracion del ocilador
movlw 0b01110000
movwf OSCCON   
        
BANKSEL ANSEL           ;activamos el convertidor analogico digital de PORTA
movlw   0b11111111
movwf   ANSEL   
BANKSEL TRISA           ;configuramos PORTA como entrada para leer la señal
movlw   0b11111111
movwf   TRISA
BANKSEL TRISC  
clrf    TRISC           ;configuramos PORTC como salida
BANKSEL PORTC
clrf    PORTC              ;limpiamos PORTC

 
adc:
call delay
bsf ADCON0,1
btfss ADCON0,1           ;Evaluamos el bit 1 del registro ADCON0
goto $-1
BANKSEL ADRESH
movf ADRESH,w            ;Movemos el resultado de la conversion al registro w
movwf PORTC              ;Movemos el resultado de la conversion a PORTC
goto adc
    END resetVec


