/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 7/2/2013
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <stdio.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>

#define BUZZER PORTD.0
#define RELAY1 PORTD.1
#define RELAY2 PORTD.2

unsigned char kata1[16], kata2[16];
unsigned char nomorPin[]="1234";
unsigned int panjangPin;

unsigned int countSalah = 0;

// Declare your global variables here
char password[5];
int counter=0;
void scanKeypad() {
   lcd_gotoxy(0,1);
   lcd_puts("PIN : "); 
   PORTC=0b01111111;  
   delay_ms(30);  
   if(PINC.0==0) {          
      password[counter]='A';          
      lcd_gotoxy(counter+6,1);        
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');
      counter++;    
      BUZZER=1;  
      delay_ms(100);   
      BUZZER=0; 
   }
   if(PINC.1==0) {                  
      password[counter]='3';    
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*'); 
      counter++;     
      BUZZER=1;  
      delay_ms(100);  
      BUZZER=0; 
   }
   if(PINC.2==0) {              
      password[counter]='2';       
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');
      counter++;      
      BUZZER=1;  
      delay_ms(100);
      BUZZER=0; 
   }
   if(PINC.3==0) {           
      password[counter]='1';     
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');   
      counter++; 
      BUZZER=1;  
      delay_ms(100);  
      BUZZER=0; 
   }              
   PORTC=0b10111111;  
   delay_ms(30);  
   if(PINC.0==0) {  
      password[counter]='B'; 
      lcd_gotoxy(counter+6,1);         
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');    
      counter++;      
      BUZZER=1;  
      delay_ms(100);    
      BUZZER=0; 
   }
   if(PINC.1==0) {    
      password[counter]='6'; 
      lcd_gotoxy(counter+6,1);     
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');
      counter++;     
      BUZZER=1;  
      delay_ms(100);      
      BUZZER=0; 
   }
   if(PINC.2==0) { 
      password[counter]='5'; 
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');   
      counter++;  
      BUZZER=1;  
      delay_ms(100); 
      BUZZER=0; 
   }
   if(PINC.3==0) { 
      password[counter]='4';      
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');   
      counter++;    
      BUZZER=1;  
      delay_ms(100);  
      BUZZER=0; 
   }      
   PORTC=0b11011111;  
   delay_ms(30);  
   if(PINC.0==0) {  
      password[counter]='C';     
      lcd_gotoxy(counter+6,1);     
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');  
      counter++;    
      BUZZER=1;  
      delay_ms(100);  
      BUZZER=0; 
   }
   if(PINC.1==0) {    
      password[counter]='9'; 
      lcd_gotoxy(counter+6,1);     
      lcd_putchar(password[counter]);  
      //lcd_putchar('*'); 
      counter++;   
      BUZZER=1;  
      delay_ms(100); 
      BUZZER=0; 
   }
   if(PINC.2==0) { 
      password[counter]='8'; 
      lcd_gotoxy(counter+6,1);  
      lcd_putchar(password[counter]);  
      //lcd_putchar('*'); 
      counter++; 
      BUZZER=1;  
      delay_ms(100);  
      BUZZER=0; 
   }
   if(PINC.3==0) { 
      password[counter]='7';  
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');  
      counter++;  
      BUZZER=1;  
      delay_ms(100); 
      BUZZER=0; 
   }  
   PORTC=0b11101111;  
   delay_ms(30);  
   if(PINC.0==0) {  
      password[counter]='D';   
      lcd_gotoxy(counter+6,1);      
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');   
      counter++;  
      BUZZER=1;  
      delay_ms(100);  
      BUZZER=0; 
   }
   if(PINC.1==0) {    
      password[counter]='#';    
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');  
      counter++;   
      BUZZER=1;  
      delay_ms(100); 
      BUZZER=0; 
   }
   if(PINC.2==0) { 
      password[counter]='0';     
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');
      counter++;  
      BUZZER=1;  
      delay_ms(100); 
      BUZZER=0; 
   }
   if(PINC.3==0) { 
      password[counter]='*';      
      lcd_gotoxy(counter+6,1); 
      lcd_putchar(password[counter]);  
      //lcd_putchar('*');
      counter++; 
      BUZZER=1;  
      delay_ms(100); 
      BUZZER=0;  
   }                       
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0xFF;
DDRC=0xF0;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0x07;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);

panjangPin = strlen(nomorPin);

counter = 0;
while (1)
      {
      // Place your code here     
      lcd_clear();          
      lcd_gotoxy(0,0);  
      lcd_puts("Masukkan PIN");
      while(counter<panjangPin) {
         scanKeypad();
      }           
      password[panjangPin+1]='\0'; 
      lcd_clear();    
      if(strcmp(nomorPin,password)==0) {  
         RELAY1 = 1;
         RELAY2 = 1;  
         lcd_gotoxy(0,0); 
         lcd_puts("Password Benar     ");      
         countSalah = 0;    
      } 
      else{        
         RELAY1 = 0;
         RELAY2 = 0;   
         lcd_gotoxy(0,0); 
         lcd_puts("Password Salah    ");    
         countSalah++;
      }  
      counter = 0;     
      if(countSalah>=3) { 
         while(1) {
            BUZZER=1;
         }
      }     
      delay_ms(5000);  
      RELAY1 = 0;
      RELAY2 = 0;    
      }
}