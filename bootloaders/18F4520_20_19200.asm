	radix DEC
	LIST      P=18F452	; change also: Configure->Select Device from MPLAB
xtal EQU 20000000		; you may want to change: _XT_OSC_1H  _HS_OSC_1H  _HSPLL_OSC_1H
baud EQU 19200			; standard TinyBld baud rates: 115200 or 19200
	; The above 3 lines can be changed and built a bootloader for the desired frequency (and PIC type)
	
	;********************************************************************
	;	Tiny Bootloader		18F series		Size=100words
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;	Modified by Nam Nguyen-Quang for testing different PIC18Fs with tinybldWin.exe v1.9
	;	namqn@yahoo.com
	;********************************************************************

;	This source file is for PIC18F242, 252, 442, 452, 248, 258, 448, 458, 2220, 2320, 
;	4220, 4320, 1220, 1320, 2331, 2431, 4331, 4431, 2439, 2539, 4439, and 4539
	
;	Copy these include files to your project directory (i.e. they are in the same
;	directory with your .asm source file), if necessary

	#include "./icdpictypes.inc"	; Takes care of: #include "p18fxxx.inc",  max_flash, IdTypePIC
	#include "./spbrgselect.inc"	; RoundResult and baud_rate

	#define first_address max_flash-200		;100 words

;	For different PICs, uncomment the appropriate lines of CONFIG directives
;	as indicated, and comment out all the other lines, if necessary
;	For example, the following configuration is for PIC18F4580, with 8 MHz crystal
;	You could find the symbol names for the chip in its include file
;	(in the Microchip\MPASM Suite directory)


;----- CONFIG1H Options -----
;	For 18F242, 248, 252, 258, 442, 448, 452, and 458 (xx2/xx8)
		CONFIG	OSC = HS, OSCS = OFF

;	For 18F1220, 1320, 2220, 2320, 4220, and 4320 (x220/x320)
;		CONFIG	OSC = HS, FSCM = OFF, IESO = OFF
;		CONFIG	OSC = INTIO2, FSCM = OFF, IESO = OFF	; Use internal oscilator, xtal = 8000000

;	For 18F2331, 2431, 4331, and 4431
;		CONFIG	OSC = HS, FCMEN = OFF, IESO = OFF
;		CONFIG	OSC = IRCIO, FCMEN = OFF, IESO = OFF

;	For 18F2439, 2539, 4439, and 4539
;		CONFIG	OSC = HS

;	For 2480, 2580, 4480, and 4580
;		CONFIG	OSC = HS, FCMENB = OFF, IESOB = OFF
;		CONFIG	OSC = IRCIO67, FCMENB = OFF, IESOB = OFF	; Use internal oscilator, xtal = 8000000


;----- CONFIG2L Options -----
;	For 18F242, 248, 252, 258, 442, 448, 452, and 458 (xx2/xx8)
;	For 18F1220, 1320, 2220, 2320, 4220, and 4320 (x220/x320)
;	and for 18F2439, 2539, 4439, and 4539 as well
		CONFIG	PWRT = ON, BOR = ON, BORV = 27

;	For 18F2331, 2431, 4331, and 4431
;		CONFIG	PWRTEN = ON, BOREN = ON, BORV = 27

;	For 2480, 2580, 4480, and 4580
;		CONFIG	PWRT = ON, BOR = BOHW, BORV = 27


;----- CONFIG2H Options -----
;	For all of the chips associated with this source file, except xx31 as follows
		CONFIG	WDT = OFF, WDTPS = 128

;	For 18F2331, 2431, 4331, and 4431
;		CONFIG	WDTEN = OFF, WINEN = OFF, WDPS = 128

;----- CONFIG3L Options -----
;	For 18F2331, 2431, 4331, and 4431
;		CONFIG	T1OSCMX = ON, HPOL = HIGH, LPOL = HIGH, PWMPIN = OFF


;----- CONFIG3H Options -----
;	For 18F242, 252, 442, and 452
		CONFIG	CCP2MUX = OFF

;	For 18F1220, 1320, 2220, 2320, 4220, and 4320
;		CONFIG	MCLRE = ON, PBAD = DIG, CCP2MX = OFF

;	For 18F2331, and 2431
;		CONFIG	MCLRE = ON

;	For 18F4331, and 4431
;		CONFIG	MCLRE = ON, EXCLKMX = RD0, PWM4MX = RD5, SSPMX = RD1, FLTAMX = RD4

;	For 2480, 2580, 4480, and 4580
;		CONFIG	MCLRE = ON, LPT1OSC = OFF, PBADEN = OFF


;----- CONFIG4L Options -----
;	For 18F242, 248, 252, 258, 442, 448, 452, and 458
;	For 18F1220, 1320, 2220, 2320, 4220, and 4320
;	and for 18F2439, 2539, 4439, and 4539 as well
		CONFIG STVR = ON, LVP = OFF, DEBUG = OFF

;	For 18F2331, 2431, 4331, and 4431
;		CONFIG	STVREN = ON, LVP = OFF, DEBUG = OFF

;	For 2480, 2580, 4480, and 4580
;		CONFIG	STVREN = ON, LVP = OFF, DEBUG = OFF, XINST = OFF, BBSIZ = 1024


;----------------------------- PROGRAM ---------------------------------
	errorlevel 1, -305			; suppress warning msg that takes f as default
	cblock 0
	crc
	i
	cnt1
	cnt2
	cnt3
	counter_hi
	counter_lo
	flag
	endc
	cblock 10
	buffer:64
	dummy4crc
	endc
	
SendL macro car
	movlw car
	movwf TXREG
	endm
	
;0000000000000000000000000 RESET 00000000000000000000000000

		ORG     0x0000
		GOTO    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;PC_flash:		C1h				U		H		L		x  ...  <64 bytes>   ...  crc	
;PC_eeprom:		C1h			   	40h   EEADR   EEDATA	0		crc					
;PC_cfg			C1h			U OR 80h	H		L		1		byte	crc
;PIC_response:	   type `K`
	
	ORG first_address		;space to deposit first 4 instr. of user prog.
	nop
	nop
	nop
	nop
	org first_address+8
IntrareBootloader
							;init IntOSC, added by Nam Nguyen-Quang
;	movlw 0x70
;	movwf OSCCON
	; the above 2 lines should be commented out for designs not using the internal oscilator
	; or for the chips without the internal oscilator
							;init serial port
	movlw b'00100100'
	movwf TXSTA
	movlw spbrg_value
	movwf SPBRG
	movlw b'10010000'
	movwf RCSTA
							;wait for computer
	rcall Receive			
	sublw 0xC1				;Expect C1h
	bnz way_to_exit
	SendL IdTypePIC			;send PIC type
MainLoop
	SendL 'K'				; "-Everything OK, ready and waiting."
mainl
	clrf crc
	rcall Receive			;Upper
	movwf TBLPTRU
		movwf flag			;(for EEPROM and CFG cases)
	rcall Receive			;Hi
	movwf TBLPTRH
		movwf EEADR			;(for EEPROM case)
	rcall Receive			;Lo
	movwf TBLPTRL
		movwf EEDATA		;(for EEPROM case)

	rcall Receive			;count
	movwf i
	incf i
	lfsr FSR0, (buffer-1)
rcvoct						;read 64+1 bytes
		movwf TABLAT		;prepare for cfg; => store byte before crc
	rcall Receive
	movwf PREINC0
	decfsz i
	bra rcvoct
	
	tstfsz crc				;check crc
	bra ziieroare
		btfss flag,6		;is EEPROM data?
		bra noeeprom
		movlw b'00000100'	;Setup eeprom
		rcall Write
		bra waitwre
noeeprom
		btfss flag,7		;is CFG data?
		bra noconfig
		tblwt*				;write TABLAT(byte before crc) to TBLPTR***
		movlw b'11000100'	;Setup cfg
		rcall Write
		bra waitwre
noconfig
							;write
eraseloop
	movlw	b'10010100'		; Setup erase
	rcall Write
	TBLRD*-					; point to adr-1
	
writebigloop	
	movlw 8					; 8groups
	movwf counter_hi
	lfsr FSR0,buffer
writesloop
	movlw 8					; 8bytes = 4instr
	movwf counter_lo
writebyte
	movf POSTINC0,w			; put 1 byte
	movwf TABLAT
	tblwt+*
	decfsz counter_lo
	bra writebyte
	
	movlw	b'10000100'		; Setup writes
	rcall Write
	decfsz counter_hi
	bra writesloop
waitwre	
	;btfsc EECON1,WR		;for eeprom writes (wait to finish write)
	;bra waitwre			;no need: round trip time with PC bigger than 4ms
	
	bcf EECON1,WREN			;disable writes
	bra MainLoop
	
ziieroare					;CRC failed
	SendL 'N'
	bra mainl
	  
;******** procedures ******************

Write
	movwf EECON1
	movlw 0x55
	movwf EECON2
	movlw 0xAA
	movwf EECON2
	bsf EECON1,WR			;WRITE
	nop
	;nop
	return


Receive
	movlw xtal/2000000+1	; for 20MHz => 11 => 1second delay
							; for 18F2xxx chips, this should be xtal/1000000+1
	movwf cnt1
rpt2						
	clrf cnt2
rpt3
	clrf cnt3
rptc
		btfss PIR1,RCIF			;test RX
		bra notrcv
	    movf RCREG,w			;return read data in W
	    addwf crc,f				;compute crc
		return
notrcv
	decfsz cnt3
	bra rptc
	decfsz cnt2
	bra rpt3
	decfsz cnt1
	bra rpt2
	;timeout:
way_to_exit
	bcf	RCSTA,	SPEN			; deactivate UART
	bra first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.

            END
