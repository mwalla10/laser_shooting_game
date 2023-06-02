
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;laserShooting.c,22 :: 		void interrupt(void){
;laserShooting.c,23 :: 		if(INTCON&0x04){// will get here every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;laserShooting.c,24 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;laserShooting.c,25 :: 		Dcntr++;
	INCF       _Dcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Dcntr+1, 1
;laserShooting.c,26 :: 		if(Dcntr==10000){//after 10s
	MOVF       _Dcntr+1, 0
	XORLW      39
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt60
	MOVLW      16
	XORWF      _Dcntr+0, 0
L__interrupt60:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;laserShooting.c,27 :: 		Dcntr=0;
	CLRF       _Dcntr+0
	CLRF       _Dcntr+1
;laserShooting.c,28 :: 		PORTC=PORTC|0x10;
	BSF        PORTC+0, 4
;laserShooting.c,29 :: 		PORTB=0;
	CLRF       PORTB+0
;laserShooting.c,30 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;laserShooting.c,31 :: 		asm sleep;
	SLEEP
;laserShooting.c,32 :: 		PORTC=0;
	CLRF       PORTC+0
;laserShooting.c,33 :: 		PORTA=0;
	CLRF       PORTA+0
;laserShooting.c,34 :: 		Lcd_Cmd( _LCD_TURN_OFF);
	MOVLW      8
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;laserShooting.c,35 :: 		while(1){}
L_interrupt2:
	GOTO       L_interrupt2
;laserShooting.c,39 :: 		}
L_interrupt1:
;laserShooting.c,40 :: 		INTCON = INTCON & 0xFB; //clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;laserShooting.c,41 :: 		}
L_interrupt0:
;laserShooting.c,44 :: 		if(PIR1&0x01){//TMR1 ovwerflow
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt4
;laserShooting.c,46 :: 		T1overflow++;
	INCF       _T1overflow+0, 1
	BTFSC      STATUS+0, 2
	INCF       _T1overflow+1, 1
;laserShooting.c,48 :: 		PIR1=PIR1&0xFE;
	MOVLW      254
	ANDWF      PIR1+0, 1
;laserShooting.c,49 :: 		}
L_interrupt4:
;laserShooting.c,51 :: 		if(INTCON&0x02){//External Interrupt
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt5
;laserShooting.c,53 :: 		PORTC = PORTC|0x20;
	BSF        PORTC+0, 5
;laserShooting.c,54 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_interrupt6:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt6
	DECFSZ     R12+0, 1
	GOTO       L_interrupt6
	DECFSZ     R11+0, 1
	GOTO       L_interrupt6
	NOP
;laserShooting.c,56 :: 		if(PORTB==0x05 || PORTB==0x04){
	MOVF       PORTB+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt57
	MOVF       PORTB+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt57
	GOTO       L_interrupt9
L__interrupt57:
;laserShooting.c,57 :: 		PORTC=0x04;
	MOVLW      4
	MOVWF      PORTC+0
;laserShooting.c,58 :: 		read_sonar();
	CALL       _read_sonar+0
;laserShooting.c,59 :: 		points = points +100+distance;
	MOVLW      100
	ADDWF      _points+0, 1
	BTFSC      STATUS+0, 0
	INCF       _points+1, 1
	MOVF       _Distance+0, 0
	ADDWF      _points+0, 1
	MOVF       _Distance+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _points+1, 1
;laserShooting.c,60 :: 		printdist();
	CALL       _printdist+0
;laserShooting.c,61 :: 		myDelay();
	CALL       _myDelay+0
;laserShooting.c,62 :: 		}
L_interrupt9:
;laserShooting.c,64 :: 		if(PORTB==0x02|| PORTB==0x03){
	MOVF       PORTB+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt56
	MOVF       PORTB+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt56
	GOTO       L_interrupt12
L__interrupt56:
;laserShooting.c,65 :: 		PORTA = 0x02;
	MOVLW      2
	MOVWF      PORTA+0
;laserShooting.c,66 :: 		read_sonar();
	CALL       _read_sonar+0
;laserShooting.c,67 :: 		points = points +100+distance;
	MOVLW      100
	ADDWF      _points+0, 1
	BTFSC      STATUS+0, 0
	INCF       _points+1, 1
	MOVF       _Distance+0, 0
	ADDWF      _points+0, 1
	MOVF       _Distance+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _points+1, 1
;laserShooting.c,68 :: 		printdist();
	CALL       _printdist+0
;laserShooting.c,69 :: 		myDelay();
	CALL       _myDelay+0
;laserShooting.c,70 :: 		}
L_interrupt12:
;laserShooting.c,71 :: 		myDelay2();
	CALL       _myDelay2+0
;laserShooting.c,72 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;laserShooting.c,73 :: 		PORTA=0;
	CLRF       PORTA+0
;laserShooting.c,75 :: 		INTCON=INTCON&0xFD; //Clear INTF(External Interrupt Flag)
	MOVLW      253
	ANDWF      INTCON+0, 1
;laserShooting.c,76 :: 		}
L_interrupt5:
;laserShooting.c,79 :: 		}
L_end_interrupt:
L__interrupt59:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;laserShooting.c,81 :: 		void main() {
;laserShooting.c,83 :: 		TRISC=0x00;
	CLRF       TRISC+0
;laserShooting.c,84 :: 		TRISB =0x07;
	MOVLW      7
	MOVWF      TRISB+0
;laserShooting.c,85 :: 		PORTB= 0x00;
	CLRF       PORTB+0
;laserShooting.c,86 :: 		PORTC=0x00;
	CLRF       PORTC+0
;laserShooting.c,87 :: 		ADCON1=0x06;//PORTA Digital
	MOVLW      6
	MOVWF      ADCON1+0
;laserShooting.c,88 :: 		TRISA=0x00;
	CLRF       TRISA+0
;laserShooting.c,89 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;laserShooting.c,90 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;laserShooting.c,92 :: 		CCP1CON=0x00;// Disable CCP. Capture on rising for the first time.  Capture on Rising: 0x05, Capture on Falling: 0x04
	CLRF       CCP1CON+0
;laserShooting.c,93 :: 		OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
	MOVLW      135
	MOVWF      OPTION_REG+0
;laserShooting.c,94 :: 		INTCON=0xF0;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
	MOVLW      240
	MOVWF      INTCON+0
;laserShooting.c,95 :: 		init_sonar();
	CALL       _init_sonar+0
;laserShooting.c,96 :: 		while(1){
L_main13:
;laserShooting.c,97 :: 		Rotation0 (); //0 Degree
	CALL       _Rotation0+0
;laserShooting.c,98 :: 		Rotation120 (); //120 Degree
	CALL       _Rotation120+0
;laserShooting.c,99 :: 		}
	GOTO       L_main13
;laserShooting.c,100 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_myDelay:

;laserShooting.c,103 :: 		void myDelay(void){
;laserShooting.c,106 :: 		for(k=0;k<50;k++){
	CLRF       R3+0
L_myDelay15:
	MOVLW      50
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay16
;laserShooting.c,107 :: 		for(j=0;j<1000;j++){
	CLRF       R1+0
	CLRF       R1+1
L_myDelay18:
	MOVLW      3
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay63
	MOVLW      232
	SUBWF      R1+0, 0
L__myDelay63:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay19
;laserShooting.c,108 :: 		k=k;
;laserShooting.c,109 :: 		j=j;
;laserShooting.c,107 :: 		for(j=0;j<1000;j++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;laserShooting.c,110 :: 		}
	GOTO       L_myDelay18
L_myDelay19:
;laserShooting.c,106 :: 		for(k=0;k<50;k++){
	INCF       R3+0, 1
;laserShooting.c,111 :: 		}
	GOTO       L_myDelay15
L_myDelay16:
;laserShooting.c,113 :: 		}
L_end_myDelay:
	RETURN
; end of _myDelay

_myDelay2:

;laserShooting.c,114 :: 		void myDelay2(void){
;laserShooting.c,117 :: 		for(k=0;k<50;k++){
	CLRF       R3+0
L_myDelay221:
	MOVLW      50
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay222
;laserShooting.c,118 :: 		for(j=0;j<500;j++){
	CLRF       R1+0
	CLRF       R1+1
L_myDelay224:
	MOVLW      1
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay265
	MOVLW      244
	SUBWF      R1+0, 0
L__myDelay265:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay225
;laserShooting.c,119 :: 		k=k;
;laserShooting.c,120 :: 		j=j;
;laserShooting.c,118 :: 		for(j=0;j<500;j++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;laserShooting.c,121 :: 		}
	GOTO       L_myDelay224
L_myDelay225:
;laserShooting.c,117 :: 		for(k=0;k<50;k++){
	INCF       R3+0, 1
;laserShooting.c,122 :: 		}
	GOTO       L_myDelay221
L_myDelay222:
;laserShooting.c,124 :: 		}
L_end_myDelay2:
	RETURN
; end of _myDelay2

_delay_us:

;laserShooting.c,125 :: 		void delay_us(unsigned int ms){
;laserShooting.c,127 :: 		while(ms--){
L_delay_us27:
	MOVF       FARG_delay_us_ms+0, 0
	MOVWF      R0+0
	MOVF       FARG_delay_us_ms+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_delay_us_ms+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_delay_us_ms+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_delay_us28
;laserShooting.c,128 :: 		for(i=0;i<12;i++) {
	CLRF       R2+0
	CLRF       R2+1
L_delay_us29:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_us67
	MOVLW      12
	SUBWF      R2+0, 0
L__delay_us67:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_us30
;laserShooting.c,129 :: 		asm nop;
	NOP
;laserShooting.c,128 :: 		for(i=0;i<12;i++) {
	INCF       R2+0, 1
	BTFSC      STATUS+0, 2
	INCF       R2+1, 1
;laserShooting.c,130 :: 		}
	GOTO       L_delay_us29
L_delay_us30:
;laserShooting.c,131 :: 		}
	GOTO       L_delay_us27
L_delay_us28:
;laserShooting.c,132 :: 		}
L_end_delay_us:
	RETURN
; end of _delay_us

_delay_ms:

;laserShooting.c,134 :: 		void delay_ms(unsigned int ms){
;laserShooting.c,136 :: 		while(ms--){
L_delay_ms32:
	MOVF       FARG_delay_ms_ms+0, 0
	MOVWF      R0+0
	MOVF       FARG_delay_ms_ms+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_delay_ms_ms+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_delay_ms_ms+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_delay_ms33
;laserShooting.c,137 :: 		for(i=0;i<238;i++) {
	CLRF       R2+0
	CLRF       R2+1
L_delay_ms34:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_ms69
	MOVLW      238
	SUBWF      R2+0, 0
L__delay_ms69:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_ms35
;laserShooting.c,138 :: 		delay_us(1000) ;
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_delay_ms37:
	DECFSZ     R13+0, 1
	GOTO       L_delay_ms37
	DECFSZ     R12+0, 1
	GOTO       L_delay_ms37
	NOP
	NOP
;laserShooting.c,137 :: 		for(i=0;i<238;i++) {
	INCF       R2+0, 1
	BTFSC      STATUS+0, 2
	INCF       R2+1, 1
;laserShooting.c,139 :: 		}
	GOTO       L_delay_ms34
L_delay_ms35:
;laserShooting.c,140 :: 		}
	GOTO       L_delay_ms32
L_delay_ms33:
;laserShooting.c,141 :: 		}
L_end_delay_ms:
	RETURN
; end of _delay_ms

_Rotation0:

;laserShooting.c,144 :: 		void Rotation0 () //0 Degree
;laserShooting.c,147 :: 		for (i=0;i<50;i++)
	CLRF       R1+0
	CLRF       R1+1
L_Rotation038:
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Rotation071
	MOVLW      50
	SUBWF      R1+0, 0
L__Rotation071:
	BTFSC      STATUS+0, 0
	GOTO       L_Rotation039
;laserShooting.c,149 :: 		PORTC=PORTC|0x80;
	BSF        PORTC+0, 7
;laserShooting.c,150 :: 		delay_us (600); // pulse of 800us
	MOVLW      2
	MOVWF      R12+0
	MOVLW      141
	MOVWF      R13+0
L_Rotation041:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation041
	DECFSZ     R12+0, 1
	GOTO       L_Rotation041
	NOP
	NOP
;laserShooting.c,151 :: 		PORTC=PORTC&0x7F;
	MOVLW      127
	ANDWF      PORTC+0, 1
;laserShooting.c,152 :: 		PORTC=PORTC|0x40;
	BSF        PORTC+0, 6
;laserShooting.c,153 :: 		delay_us (600);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      141
	MOVWF      R13+0
L_Rotation042:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation042
	DECFSZ     R12+0, 1
	GOTO       L_Rotation042
	NOP
	NOP
;laserShooting.c,154 :: 		PORTC=PORTC&0xBF;
	MOVLW      191
	ANDWF      PORTC+0, 1
;laserShooting.c,155 :: 		delay_ms (24);
	MOVLW      63
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_Rotation043:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation043
	DECFSZ     R12+0, 1
	GOTO       L_Rotation043
;laserShooting.c,147 :: 		for (i=0;i<50;i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;laserShooting.c,156 :: 		}
	GOTO       L_Rotation038
L_Rotation039:
;laserShooting.c,157 :: 		}
L_end_Rotation0:
	RETURN
; end of _Rotation0

_Rotation120:

;laserShooting.c,161 :: 		void Rotation120 () //120 Degree
;laserShooting.c,164 :: 		for (i=0;i<50;i++)
	CLRF       R1+0
	CLRF       R1+1
L_Rotation12044:
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Rotation12073
	MOVLW      50
	SUBWF      R1+0, 0
L__Rotation12073:
	BTFSC      STATUS+0, 0
	GOTO       L_Rotation12045
;laserShooting.c,166 :: 		PORTC=PORTC|0x80;
	BSF        PORTC+0, 7
;laserShooting.c,167 :: 		delay_us (1600); // pulse of 1800us
	MOVLW      5
	MOVWF      R12+0
	MOVLW      38
	MOVWF      R13+0
L_Rotation12047:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation12047
	DECFSZ     R12+0, 1
	GOTO       L_Rotation12047
	NOP
;laserShooting.c,168 :: 		PORTC=PORTC&0x7F;
	MOVLW      127
	ANDWF      PORTC+0, 1
;laserShooting.c,169 :: 		PORTC=PORTC|0x40;
	BSF        PORTC+0, 6
;laserShooting.c,170 :: 		delay_us (1600);
	MOVLW      5
	MOVWF      R12+0
	MOVLW      38
	MOVWF      R13+0
L_Rotation12048:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation12048
	DECFSZ     R12+0, 1
	GOTO       L_Rotation12048
	NOP
;laserShooting.c,171 :: 		PORTC=PORTC&0xBF;
	MOVLW      191
	ANDWF      PORTC+0, 1
;laserShooting.c,172 :: 		delay_ms (24);
	MOVLW      63
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_Rotation12049:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation12049
	DECFSZ     R12+0, 1
	GOTO       L_Rotation12049
;laserShooting.c,164 :: 		for (i=0;i<50;i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;laserShooting.c,173 :: 		}
	GOTO       L_Rotation12044
L_Rotation12045:
;laserShooting.c,174 :: 		}
L_end_Rotation120:
	RETURN
; end of _Rotation120

_read_sonar:

;laserShooting.c,176 :: 		void read_sonar(void){
;laserShooting.c,178 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;laserShooting.c,179 :: 		TMR1H=0;
	CLRF       TMR1H+0
;laserShooting.c,180 :: 		TMR1L=0;
	CLRF       TMR1L+0
;laserShooting.c,182 :: 		PORTE=0x04;//Trigger the ultrasonic sensor (RE2 connected to trigger)
	MOVLW      4
	MOVWF      PORTE+0
;laserShooting.c,183 :: 		Delay_us(10);//keep trigger for 10uS
	MOVLW      6
	MOVWF      R13+0
L_read_sonar50:
	DECFSZ     R13+0, 1
	GOTO       L_read_sonar50
	NOP
;laserShooting.c,184 :: 		PORTE=0x00;//Remove trigger
	CLRF       PORTE+0
;laserShooting.c,185 :: 		while(!(PORTE&0x02));
L_read_sonar51:
	BTFSC      PORTE+0, 1
	GOTO       L_read_sonar52
	GOTO       L_read_sonar51
L_read_sonar52:
;laserShooting.c,186 :: 		T1CON=0x19;//TMR1 ON,  Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
	MOVLW      25
	MOVWF      T1CON+0
;laserShooting.c,187 :: 		while(PORTE&0x02);
L_read_sonar53:
	BTFSS      PORTE+0, 1
	GOTO       L_read_sonar54
	GOTO       L_read_sonar53
L_read_sonar54:
;laserShooting.c,188 :: 		T1CON=0x18;//TMR1 OFF,  Fosc/4 (inc 1uS) with 1:1 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
	MOVLW      24
	MOVWF      T1CON+0
;laserShooting.c,189 :: 		T1counts=((TMR1H<<8)|TMR1L)+(T1overflow*65536);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	MOVLW      0
	IORWF      R5+1, 1
	MOVF       _T1overflow+1, 0
	MOVWF      R0+3
	MOVF       _T1overflow+0, 0
	MOVWF      R0+2
	CLRF       R0+0
	CLRF       R0+1
	MOVF       R5+0, 0
	MOVWF      _T1counts+0
	MOVF       R5+1, 0
	MOVWF      _T1counts+1
	CLRF       _T1counts+2
	CLRF       _T1counts+3
	MOVF       R0+0, 0
	ADDWF      _T1counts+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+1, 0
	ADDWF      _T1counts+1, 1
	MOVF       R0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+2, 0
	ADDWF      _T1counts+2, 1
	MOVF       R0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+3, 0
	ADDWF      _T1counts+3, 1
;laserShooting.c,190 :: 		if(TMR1L>100) ;
	MOVF       TMR1L+0, 0
	SUBLW      100
	BTFSC      STATUS+0, 0
	GOTO       L_read_sonar55
L_read_sonar55:
;laserShooting.c,191 :: 		T1time=T1counts;//in microseconds
	MOVF       _T1counts+0, 0
	MOVWF      _T1time+0
	MOVF       _T1counts+1, 0
	MOVWF      _T1time+1
	MOVF       _T1counts+2, 0
	MOVWF      _T1time+2
	MOVF       _T1counts+3, 0
	MOVWF      _T1time+3
;laserShooting.c,192 :: 		Distance=((T1time*34)/(1000))/2; //in cm, shift left twice to divide by 2
	MOVF       _T1counts+0, 0
	MOVWF      R0+0
	MOVF       _T1counts+1, 0
	MOVWF      R0+1
	MOVF       _T1counts+2, 0
	MOVWF      R0+2
	MOVF       _T1counts+3, 0
	MOVWF      R0+3
	MOVLW      34
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
	MOVF       R0+2, 0
	MOVWF      _Distance+2
	MOVF       R0+3, 0
	MOVWF      _Distance+3
	RRF        _Distance+3, 1
	RRF        _Distance+2, 1
	RRF        _Distance+1, 1
	RRF        _Distance+0, 1
	BCF        _Distance+3, 7
;laserShooting.c,196 :: 		}
L_end_read_sonar:
	RETURN
; end of _read_sonar

_init_sonar:

;laserShooting.c,198 :: 		void init_sonar(void){
;laserShooting.c,199 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;laserShooting.c,200 :: 		T1counts=0;
	CLRF       _T1counts+0
	CLRF       _T1counts+1
	CLRF       _T1counts+2
	CLRF       _T1counts+3
;laserShooting.c,201 :: 		T1time=0;
	CLRF       _T1time+0
	CLRF       _T1time+1
	CLRF       _T1time+2
	CLRF       _T1time+3
;laserShooting.c,202 :: 		Distance=0;
	CLRF       _Distance+0
	CLRF       _Distance+1
	CLRF       _Distance+2
	CLRF       _Distance+3
;laserShooting.c,203 :: 		TMR1H=0;
	CLRF       TMR1H+0
;laserShooting.c,204 :: 		TMR1L=0;
	CLRF       TMR1L+0
;laserShooting.c,205 :: 		TRISE=0x02; //RE2 for trigger, RE1 for echo
	MOVLW      2
	MOVWF      TRISE+0
;laserShooting.c,206 :: 		PORTE=0x00;
	CLRF       PORTE+0
;laserShooting.c,207 :: 		INTCON=INTCON|0xC0;//GIE and PIE
	MOVLW      192
	IORWF      INTCON+0, 1
;laserShooting.c,208 :: 		PIE1=PIE1|0x01;// Enable TMR1 Overflow interrupt
	BSF        PIE1+0, 0
;laserShooting.c,210 :: 		T1CON=0x18;//TMR1 OFF,  Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
	MOVLW      24
	MOVWF      T1CON+0
;laserShooting.c,211 :: 		}
L_end_init_sonar:
	RETURN
; end of _init_sonar

_printdist:

;laserShooting.c,228 :: 		void printdist(){
;laserShooting.c,230 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;laserShooting.c,231 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;laserShooting.c,232 :: 		Lcd_Out(1,1,"score=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_laserShooting+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;laserShooting.c,233 :: 		inttostr(points,txt);
	MOVF       _points+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _points+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;laserShooting.c,234 :: 		Lcd_Out(1,7,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;laserShooting.c,235 :: 		}
L_end_printdist:
	RETURN
; end of _printdist
