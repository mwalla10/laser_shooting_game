unsigned int T1overflow;
unsigned long T1counts;
unsigned long T1time;
unsigned long Distance;
unsigned int Dcntr=0;
unsigned int points=0;
char txt[16]={0};
void usDelay(unsigned int);
void msDelay(unsigned int);
unsigned char cntr=0;
void init_sonar(void);
void read_sonar(void);
void printdist();

void myDelay(void);
void Rotation120 ()  ;
void Rotation0 ();
void myDelay2(void);
void delay_ms(unsigned int ms);
void delay_us(unsigned int ms);

void interrupt(void){
if(INTCON&0x04){// will get here every 1ms
    TMR0=248;
    Dcntr++;
    if(Dcntr==10000){//after 10s
      Dcntr=0;
      PORTC=PORTC|0x10;
      PORTB=0;
      Lcd_Cmd(_LCD_CLEAR);
      asm sleep;
      PORTC=0;
      PORTA=0;
       Lcd_Cmd( _LCD_TURN_OFF);
       while(1){}
     //cntr++;


    }
  INTCON = INTCON & 0xFB; //clear T0IF
}


 if(PIR1&0x01){//TMR1 ovwerflow

   T1overflow++;

   PIR1=PIR1&0xFE;
 }

 if(INTCON&0x02){//External Interrupt
     //fire up the laser then check if it hit any of the targets
  PORTC = PORTC|0x20;
  delay_ms(100);
  //for target 1
  if(PORTB==0x05 || PORTB==0x04){
   PORTC=0x04;
   read_sonar();
   points = points +100+distance;
   printdist();
   myDelay();
  }
  //for target 2
  if(PORTB==0x02|| PORTB==0x03){
   PORTA = 0x02;
   read_sonar();
   points = points +100+distance;
   printdist();
   myDelay();
  }
  myDelay2();
  PORTC = 0x00;
  PORTA=0;
  // trun off the laser and get back from the interrupt
  INTCON=INTCON&0xFD; //Clear INTF(External Interrupt Flag)
   }


 }

void main() {
  //Initializations
  TRISC=0x00;
  TRISB =0x07;
  PORTB= 0x00;
  PORTC=0x00;
  ADCON1=0x06;//PORTA Digital
  TRISA=0x00;
  TMR0=248;
  Lcd_Init();
  //HL=1;// Capture on rising for the first time
  CCP1CON=0x00;// Disable CCP. Capture on rising for the first time.  Capture on Rising: 0x05, Capture on Falling: 0x04
  OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
  INTCON=0xF0;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
  init_sonar();
  while(1){
    Rotation0 (); //0 Degree
    Rotation120 (); //120 Degree
  }
}


void myDelay(void){
unsigned int j;
unsigned char k;
    for(k=0;k<50;k++){
      for(j=0;j<1000;j++){
        k=k;
        j=j;
      }
    }

}
void myDelay2(void){
unsigned int j;
unsigned char k;
    for(k=0;k<50;k++){
      for(j=0;j<500;j++){
        k=k;
        j=j;
      }
    }

}
void delay_us(unsigned int ms){
unsigned int i;
while(ms--){
for(i=0;i<12;i++) {
asm nop;
}
}
}

void delay_ms(unsigned int ms){
unsigned int i;
while(ms--){
for(i=0;i<238;i++) {
delay_us(1000) ;
}
}
}


void Rotation0 () //0 Degree
{
    unsigned int i;
    for (i=0;i<50;i++)
    {
    PORTC=PORTC|0x80;
        delay_us (600); // pulse of 800us
        PORTC=PORTC&0x7F;
        PORTC=PORTC|0x40;
        delay_us (600);
        PORTC=PORTC&0xBF;
        delay_ms (24);
    }
}



void Rotation120 () //120 Degree
{
    unsigned int i;
    for (i=0;i<50;i++)
    {
        PORTC=PORTC|0x80;
        delay_us (1600); // pulse of 1800us
        PORTC=PORTC&0x7F;
        PORTC=PORTC|0x40;
        delay_us (1600);
        PORTC=PORTC&0xBF;
        delay_ms (24);
    }
}

void read_sonar(void){

    T1overflow=0;
    TMR1H=0;
    TMR1L=0;

    PORTE=0x04;//Trigger the ultrasonic sensor (RE2 connected to trigger)
    Delay_us(10);//keep trigger for 10uS
    PORTE=0x00;//Remove trigger
    while(!(PORTE&0x02));
    T1CON=0x19;//TMR1 ON,  Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
    while(PORTE&0x02);
    T1CON=0x18;//TMR1 OFF,  Fosc/4 (inc 1uS) with 1:1 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
    T1counts=((TMR1H<<8)|TMR1L)+(T1overflow*65536);
       if(TMR1L>100) ;
       T1time=T1counts;//in microseconds
       Distance=((T1time*34)/(1000))/2; //in cm, shift left twice to divide by 2
       //range=high level time(usec)*velocity(340m/sec)/2 >> range=(time*0.034cm/usec)/2
       //time is in usec and distance is in cm so 340m/sec >> 0.034cm/usec
      //divide by 2 since the travelled distance is twice that of the range from the object leaving the sensor then returning when hitting an object)
}

void init_sonar(void){
   T1overflow=0;
    T1counts=0;
    T1time=0;
    Distance=0;
    TMR1H=0;
    TMR1L=0;
    TRISE=0x02; //RE2 for trigger, RE1 for echo
    PORTE=0x00;
    INTCON=INTCON|0xC0;//GIE and PIE
    PIE1=PIE1|0x01;// Enable TMR1 Overflow interrupt

    T1CON=0x18;//TMR1 OFF,  Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
}

sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit ;


void printdist(){

  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Out(1,1,"score=");
  inttostr(points,txt);
   Lcd_Out(1,7,txt);
}