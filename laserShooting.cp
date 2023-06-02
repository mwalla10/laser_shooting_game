#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EASYPIC7/laserShooter/laserShooting.c"
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
void Rotation120 () ;
void Rotation0 ();
void myDelay2(void);
void delay_ms(unsigned int ms);
void delay_us(unsigned int ms);

void interrupt(void){
if(INTCON&0x04){
 TMR0=248;
 Dcntr++;
 if(Dcntr==10000){
 Dcntr=0;
 PORTC=PORTC|0x10;
 PORTB=0;
 Lcd_Cmd(_LCD_CLEAR);
 asm sleep;
 PORTC=0;
 PORTA=0;
 Lcd_Cmd( _LCD_TURN_OFF);
 while(1){}



 }
 INTCON = INTCON & 0xFB;
}


 if(PIR1&0x01){

 T1overflow++;

 PIR1=PIR1&0xFE;
 }

 if(INTCON&0x02){

 PORTC = PORTC|0x20;
 delay_ms(100);

 if(PORTB==0x05 || PORTB==0x04){
 PORTC=0x04;
 read_sonar();
 points = points +100+distance;
 printdist();
 myDelay();
 }

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

 INTCON=INTCON&0xFD;
 }


 }

void main() {

 TRISC=0x00;
 TRISB =0x07;
 PORTB= 0x00;
 PORTC=0x00;
 ADCON1=0x06;
 TRISA=0x00;
 TMR0=248;
 Lcd_Init();

 CCP1CON=0x00;
 OPTION_REG = 0x87;
 INTCON=0xF0;
 init_sonar();
 while(1){
 Rotation0 ();
 Rotation120 ();
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


void Rotation0 ()
{
 unsigned int i;
 for (i=0;i<50;i++)
 {
 PORTC=PORTC|0x80;
 delay_us (600);
 PORTC=PORTC&0x7F;
 PORTC=PORTC|0x40;
 delay_us (600);
 PORTC=PORTC&0xBF;
 delay_ms (24);
 }
}



void Rotation120 ()
{
 unsigned int i;
 for (i=0;i<50;i++)
 {
 PORTC=PORTC|0x80;
 delay_us (1600);
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

 PORTE=0x04;
 Delay_us(10);
 PORTE=0x00;
 while(!(PORTE&0x02));
 T1CON=0x19;
 while(PORTE&0x02);
 T1CON=0x18;
 T1counts=((TMR1H<<8)|TMR1L)+(T1overflow*65536);
 if(TMR1L>100) ;
 T1time=T1counts;
 Distance=((T1time*34)/(1000))/2;



}

void init_sonar(void){
 T1overflow=0;
 T1counts=0;
 T1time=0;
 Distance=0;
 TMR1H=0;
 TMR1L=0;
 TRISE=0x02;
 PORTE=0x00;
 INTCON=INTCON|0xC0;
 PIE1=PIE1|0x01;

 T1CON=0x18;
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
