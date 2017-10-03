
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _panjangPin=R4
	.DEF _countSalah=R6
	.DEF _counter=R8
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x31,0x32,0x33,0x34
_0x71:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x50,0x49,0x4E,0x20,0x3A,0x20,0x0,0x4D
	.DB  0x61,0x73,0x75,0x6B,0x6B,0x61,0x6E,0x20
	.DB  0x50,0x49,0x4E,0x0,0x50,0x61,0x73,0x73
	.DB  0x77,0x6F,0x72,0x64,0x20,0x42,0x65,0x6E
	.DB  0x61,0x72,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x50,0x61,0x73,0x73,0x77,0x6F,0x72,0x64
	.DB  0x20,0x53,0x61,0x6C,0x61,0x68,0x20,0x20
	.DB  0x20,0x20,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _nomorPin
	.DW  _0x3*2

	.DW  0x07
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x0D
	.DW  _0x58
	.DW  _0x0*2+7

	.DW  0x14
	.DW  _0x58+13
	.DW  _0x0*2+20

	.DW  0x13
	.DW  _0x58+33
	.DW  _0x0*2+40

	.DW  0x04
	.DW  0x06
	.DW  _0x71*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 7/2/2013
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <alcd.h>
;#include <delay.h>
;#include <string.h>
;
;#define BUZZER PORTD.0
;#define RELAY1 PORTD.1
;#define RELAY2 PORTD.2
;
;unsigned char kata1[16], kata2[16];
;unsigned char nomorPin[]="1234";

	.DSEG
;unsigned int panjangPin;
;
;unsigned int countSalah = 0;
;
;// Declare your global variables here
;char password[5];
;int counter=0;
;void scanKeypad() {
; 0000 002B void scanKeypad() {

	.CSEG
_scanKeypad:
; 0000 002C    lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x0
; 0000 002D    lcd_puts("PIN : ");
	__POINTW1MN _0x4,0
	CALL SUBOPT_0x1
; 0000 002E    PORTC=0b01111111;
	LDI  R30,LOW(127)
	CALL SUBOPT_0x2
; 0000 002F    delay_ms(30);
; 0000 0030    if(PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x5
; 0000 0031       password[counter]='A';
	CALL SUBOPT_0x3
	LDI  R30,LOW(65)
	CALL SUBOPT_0x4
; 0000 0032       lcd_gotoxy(counter+6,1);
; 0000 0033       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0034       //lcd_putchar('*');
; 0000 0035       counter++;
; 0000 0036       BUZZER=1;
; 0000 0037       delay_ms(100);
; 0000 0038       BUZZER=0;
; 0000 0039    }
; 0000 003A    if(PINC.1==0) {
_0x5:
	SBIC 0x13,1
	RJMP _0xA
; 0000 003B       password[counter]='3';
	CALL SUBOPT_0x3
	LDI  R30,LOW(51)
	CALL SUBOPT_0x4
; 0000 003C       lcd_gotoxy(counter+6,1);
; 0000 003D       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 003E       //lcd_putchar('*');
; 0000 003F       counter++;
; 0000 0040       BUZZER=1;
; 0000 0041       delay_ms(100);
; 0000 0042       BUZZER=0;
; 0000 0043    }
; 0000 0044    if(PINC.2==0) {
_0xA:
	SBIC 0x13,2
	RJMP _0xF
; 0000 0045       password[counter]='2';
	CALL SUBOPT_0x3
	LDI  R30,LOW(50)
	CALL SUBOPT_0x4
; 0000 0046       lcd_gotoxy(counter+6,1);
; 0000 0047       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0048       //lcd_putchar('*');
; 0000 0049       counter++;
; 0000 004A       BUZZER=1;
; 0000 004B       delay_ms(100);
; 0000 004C       BUZZER=0;
; 0000 004D    }
; 0000 004E    if(PINC.3==0) {
_0xF:
	SBIC 0x13,3
	RJMP _0x14
; 0000 004F       password[counter]='1';
	CALL SUBOPT_0x3
	LDI  R30,LOW(49)
	CALL SUBOPT_0x4
; 0000 0050       lcd_gotoxy(counter+6,1);
; 0000 0051       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0052       //lcd_putchar('*');
; 0000 0053       counter++;
; 0000 0054       BUZZER=1;
; 0000 0055       delay_ms(100);
; 0000 0056       BUZZER=0;
; 0000 0057    }
; 0000 0058    PORTC=0b10111111;
_0x14:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x2
; 0000 0059    delay_ms(30);
; 0000 005A    if(PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x19
; 0000 005B       password[counter]='B';
	CALL SUBOPT_0x3
	LDI  R30,LOW(66)
	CALL SUBOPT_0x4
; 0000 005C       lcd_gotoxy(counter+6,1);
; 0000 005D       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 005E       //lcd_putchar('*');
; 0000 005F       counter++;
; 0000 0060       BUZZER=1;
; 0000 0061       delay_ms(100);
; 0000 0062       BUZZER=0;
; 0000 0063    }
; 0000 0064    if(PINC.1==0) {
_0x19:
	SBIC 0x13,1
	RJMP _0x1E
; 0000 0065       password[counter]='6';
	CALL SUBOPT_0x3
	LDI  R30,LOW(54)
	CALL SUBOPT_0x4
; 0000 0066       lcd_gotoxy(counter+6,1);
; 0000 0067       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0068       //lcd_putchar('*');
; 0000 0069       counter++;
; 0000 006A       BUZZER=1;
; 0000 006B       delay_ms(100);
; 0000 006C       BUZZER=0;
; 0000 006D    }
; 0000 006E    if(PINC.2==0) {
_0x1E:
	SBIC 0x13,2
	RJMP _0x23
; 0000 006F       password[counter]='5';
	CALL SUBOPT_0x3
	LDI  R30,LOW(53)
	CALL SUBOPT_0x4
; 0000 0070       lcd_gotoxy(counter+6,1);
; 0000 0071       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0072       //lcd_putchar('*');
; 0000 0073       counter++;
; 0000 0074       BUZZER=1;
; 0000 0075       delay_ms(100);
; 0000 0076       BUZZER=0;
; 0000 0077    }
; 0000 0078    if(PINC.3==0) {
_0x23:
	SBIC 0x13,3
	RJMP _0x28
; 0000 0079       password[counter]='4';
	CALL SUBOPT_0x3
	LDI  R30,LOW(52)
	CALL SUBOPT_0x4
; 0000 007A       lcd_gotoxy(counter+6,1);
; 0000 007B       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 007C       //lcd_putchar('*');
; 0000 007D       counter++;
; 0000 007E       BUZZER=1;
; 0000 007F       delay_ms(100);
; 0000 0080       BUZZER=0;
; 0000 0081    }
; 0000 0082    PORTC=0b11011111;
_0x28:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x2
; 0000 0083    delay_ms(30);
; 0000 0084    if(PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x2D
; 0000 0085       password[counter]='C';
	CALL SUBOPT_0x3
	LDI  R30,LOW(67)
	CALL SUBOPT_0x4
; 0000 0086       lcd_gotoxy(counter+6,1);
; 0000 0087       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0088       //lcd_putchar('*');
; 0000 0089       counter++;
; 0000 008A       BUZZER=1;
; 0000 008B       delay_ms(100);
; 0000 008C       BUZZER=0;
; 0000 008D    }
; 0000 008E    if(PINC.1==0) {
_0x2D:
	SBIC 0x13,1
	RJMP _0x32
; 0000 008F       password[counter]='9';
	CALL SUBOPT_0x3
	LDI  R30,LOW(57)
	CALL SUBOPT_0x4
; 0000 0090       lcd_gotoxy(counter+6,1);
; 0000 0091       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 0092       //lcd_putchar('*');
; 0000 0093       counter++;
; 0000 0094       BUZZER=1;
; 0000 0095       delay_ms(100);
; 0000 0096       BUZZER=0;
; 0000 0097    }
; 0000 0098    if(PINC.2==0) {
_0x32:
	SBIC 0x13,2
	RJMP _0x37
; 0000 0099       password[counter]='8';
	CALL SUBOPT_0x3
	LDI  R30,LOW(56)
	CALL SUBOPT_0x4
; 0000 009A       lcd_gotoxy(counter+6,1);
; 0000 009B       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 009C       //lcd_putchar('*');
; 0000 009D       counter++;
; 0000 009E       BUZZER=1;
; 0000 009F       delay_ms(100);
; 0000 00A0       BUZZER=0;
; 0000 00A1    }
; 0000 00A2    if(PINC.3==0) {
_0x37:
	SBIC 0x13,3
	RJMP _0x3C
; 0000 00A3       password[counter]='7';
	CALL SUBOPT_0x3
	LDI  R30,LOW(55)
	CALL SUBOPT_0x4
; 0000 00A4       lcd_gotoxy(counter+6,1);
; 0000 00A5       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 00A6       //lcd_putchar('*');
; 0000 00A7       counter++;
; 0000 00A8       BUZZER=1;
; 0000 00A9       delay_ms(100);
; 0000 00AA       BUZZER=0;
; 0000 00AB    }
; 0000 00AC    PORTC=0b11101111;
_0x3C:
	LDI  R30,LOW(239)
	CALL SUBOPT_0x2
; 0000 00AD    delay_ms(30);
; 0000 00AE    if(PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x41
; 0000 00AF       password[counter]='D';
	CALL SUBOPT_0x3
	LDI  R30,LOW(68)
	CALL SUBOPT_0x4
; 0000 00B0       lcd_gotoxy(counter+6,1);
; 0000 00B1       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 00B2       //lcd_putchar('*');
; 0000 00B3       counter++;
; 0000 00B4       BUZZER=1;
; 0000 00B5       delay_ms(100);
; 0000 00B6       BUZZER=0;
; 0000 00B7    }
; 0000 00B8    if(PINC.1==0) {
_0x41:
	SBIC 0x13,1
	RJMP _0x46
; 0000 00B9       password[counter]='#';
	CALL SUBOPT_0x3
	LDI  R30,LOW(35)
	CALL SUBOPT_0x4
; 0000 00BA       lcd_gotoxy(counter+6,1);
; 0000 00BB       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 00BC       //lcd_putchar('*');
; 0000 00BD       counter++;
; 0000 00BE       BUZZER=1;
; 0000 00BF       delay_ms(100);
; 0000 00C0       BUZZER=0;
; 0000 00C1    }
; 0000 00C2    if(PINC.2==0) {
_0x46:
	SBIC 0x13,2
	RJMP _0x4B
; 0000 00C3       password[counter]='0';
	CALL SUBOPT_0x3
	LDI  R30,LOW(48)
	CALL SUBOPT_0x4
; 0000 00C4       lcd_gotoxy(counter+6,1);
; 0000 00C5       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 00C6       //lcd_putchar('*');
; 0000 00C7       counter++;
; 0000 00C8       BUZZER=1;
; 0000 00C9       delay_ms(100);
; 0000 00CA       BUZZER=0;
; 0000 00CB    }
; 0000 00CC    if(PINC.3==0) {
_0x4B:
	SBIC 0x13,3
	RJMP _0x50
; 0000 00CD       password[counter]='*';
	CALL SUBOPT_0x3
	LDI  R30,LOW(42)
	CALL SUBOPT_0x4
; 0000 00CE       lcd_gotoxy(counter+6,1);
; 0000 00CF       lcd_putchar(password[counter]);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
; 0000 00D0       //lcd_putchar('*');
; 0000 00D1       counter++;
; 0000 00D2       BUZZER=1;
; 0000 00D3       delay_ms(100);
; 0000 00D4       BUZZER=0;
; 0000 00D5    }
; 0000 00D6 }
_0x50:
	RET

	.DSEG
_0x4:
	.BYTE 0x7
;
;void main(void)
; 0000 00D9 {

	.CSEG
_main:
; 0000 00DA // Declare your local variables here
; 0000 00DB 
; 0000 00DC // Input/Output Ports initialization
; 0000 00DD // Port A initialization
; 0000 00DE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00DF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E0 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00E1 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00E2 
; 0000 00E3 // Port B initialization
; 0000 00E4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E6 PORTB=0x00;
	OUT  0x18,R30
; 0000 00E7 DDRB=0x00;
	OUT  0x17,R30
; 0000 00E8 
; 0000 00E9 // Port C initialization
; 0000 00EA // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00EB // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00EC PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00ED DDRC=0xF0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00EE 
; 0000 00EF // Port D initialization
; 0000 00F0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 00F1 // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
; 0000 00F2 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00F3 DDRD=0x07;
	LDI  R30,LOW(7)
	OUT  0x11,R30
; 0000 00F4 
; 0000 00F5 // Timer/Counter 0 initialization
; 0000 00F6 // Clock source: System Clock
; 0000 00F7 // Clock value: Timer 0 Stopped
; 0000 00F8 // Mode: Normal top=0xFF
; 0000 00F9 // OC0 output: Disconnected
; 0000 00FA TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00FB TCNT0=0x00;
	OUT  0x32,R30
; 0000 00FC OCR0=0x00;
	OUT  0x3C,R30
; 0000 00FD 
; 0000 00FE // Timer/Counter 1 initialization
; 0000 00FF // Clock source: System Clock
; 0000 0100 // Clock value: Timer1 Stopped
; 0000 0101 // Mode: Normal top=0xFFFF
; 0000 0102 // OC1A output: Discon.
; 0000 0103 // OC1B output: Discon.
; 0000 0104 // Noise Canceler: Off
; 0000 0105 // Input Capture on Falling Edge
; 0000 0106 // Timer1 Overflow Interrupt: Off
; 0000 0107 // Input Capture Interrupt: Off
; 0000 0108 // Compare A Match Interrupt: Off
; 0000 0109 // Compare B Match Interrupt: Off
; 0000 010A TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 010B TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 010C TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 010D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 010E ICR1H=0x00;
	OUT  0x27,R30
; 0000 010F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0110 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0111 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0112 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0113 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0114 
; 0000 0115 // Timer/Counter 2 initialization
; 0000 0116 // Clock source: System Clock
; 0000 0117 // Clock value: Timer2 Stopped
; 0000 0118 // Mode: Normal top=0xFF
; 0000 0119 // OC2 output: Disconnected
; 0000 011A ASSR=0x00;
	OUT  0x22,R30
; 0000 011B TCCR2=0x00;
	OUT  0x25,R30
; 0000 011C TCNT2=0x00;
	OUT  0x24,R30
; 0000 011D OCR2=0x00;
	OUT  0x23,R30
; 0000 011E 
; 0000 011F // External Interrupt(s) initialization
; 0000 0120 // INT0: Off
; 0000 0121 // INT1: Off
; 0000 0122 // INT2: Off
; 0000 0123 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0124 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0125 
; 0000 0126 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0127 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0128 
; 0000 0129 // USART initialization
; 0000 012A // USART disabled
; 0000 012B UCSRB=0x00;
	OUT  0xA,R30
; 0000 012C 
; 0000 012D // Analog Comparator initialization
; 0000 012E // Analog Comparator: Off
; 0000 012F // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0130 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0131 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0132 
; 0000 0133 // ADC initialization
; 0000 0134 // ADC disabled
; 0000 0135 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0136 
; 0000 0137 // SPI initialization
; 0000 0138 // SPI disabled
; 0000 0139 SPCR=0x00;
	OUT  0xD,R30
; 0000 013A 
; 0000 013B // TWI initialization
; 0000 013C // TWI disabled
; 0000 013D TWCR=0x00;
	OUT  0x36,R30
; 0000 013E 
; 0000 013F // Alphanumeric LCD initialization
; 0000 0140 // Connections specified in the
; 0000 0141 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0142 // RS - PORTA Bit 0
; 0000 0143 // RD - PORTA Bit 1
; 0000 0144 // EN - PORTA Bit 2
; 0000 0145 // D4 - PORTA Bit 4
; 0000 0146 // D5 - PORTA Bit 5
; 0000 0147 // D6 - PORTA Bit 6
; 0000 0148 // D7 - PORTA Bit 7
; 0000 0149 // Characters/line: 16
; 0000 014A lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 014B 
; 0000 014C panjangPin = strlen(nomorPin);
	LDI  R30,LOW(_nomorPin)
	LDI  R31,HIGH(_nomorPin)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOVW R4,R30
; 0000 014D 
; 0000 014E counter = 0;
	CLR  R8
	CLR  R9
; 0000 014F while (1)
_0x55:
; 0000 0150       {
; 0000 0151       // Place your code here
; 0000 0152       lcd_clear();
	CALL _lcd_clear
; 0000 0153       lcd_gotoxy(0,0);
	CALL SUBOPT_0x6
; 0000 0154       lcd_puts("Masukkan PIN");
	__POINTW1MN _0x58,0
	CALL SUBOPT_0x1
; 0000 0155       while(counter<panjangPin) {
_0x59:
	__CPWRR 8,9,4,5
	BRSH _0x5B
; 0000 0156          scanKeypad();
	RCALL _scanKeypad
; 0000 0157       }
	RJMP _0x59
_0x5B:
; 0000 0158       password[panjangPin+1]='\0';
	MOVW R30,R4
	__ADDW1MN _password,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0159       lcd_clear();
	CALL _lcd_clear
; 0000 015A       if(strcmp(nomorPin,password)==0) {
	LDI  R30,LOW(_nomorPin)
	LDI  R31,HIGH(_nomorPin)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_password)
	LDI  R31,HIGH(_password)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcmp
	CPI  R30,0
	BRNE _0x5C
; 0000 015B          RELAY1 = 1;
	SBI  0x12,1
; 0000 015C          RELAY2 = 1;
	SBI  0x12,2
; 0000 015D          lcd_gotoxy(0,0);
	CALL SUBOPT_0x6
; 0000 015E          lcd_puts("Password Benar     ");
	__POINTW1MN _0x58,13
	CALL SUBOPT_0x1
; 0000 015F          countSalah = 0;
	CLR  R6
	CLR  R7
; 0000 0160       }
; 0000 0161       else{
	RJMP _0x61
_0x5C:
; 0000 0162          RELAY1 = 0;
	CBI  0x12,1
; 0000 0163          RELAY2 = 0;
	CBI  0x12,2
; 0000 0164          lcd_gotoxy(0,0);
	CALL SUBOPT_0x6
; 0000 0165          lcd_puts("Password Salah    ");
	__POINTW1MN _0x58,33
	CALL SUBOPT_0x1
; 0000 0166          countSalah++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0167       }
_0x61:
; 0000 0168       counter = 0;
	CLR  R8
	CLR  R9
; 0000 0169       if(countSalah>=3) {
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x66
; 0000 016A          while(1) {
_0x67:
; 0000 016B             BUZZER=1;
	SBI  0x12,0
; 0000 016C          }
	RJMP _0x67
; 0000 016D       }
; 0000 016E       delay_ms(5000);
_0x66:
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x7
; 0000 016F       RELAY1 = 0;
	CBI  0x12,1
; 0000 0170       RELAY2 = 0;
	CBI  0x12,2
; 0000 0171       }
	RJMP _0x55
; 0000 0172 }
_0x70:
	RJMP _0x70

	.DSEG
_0x58:
	.BYTE 0x34
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x1B,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x1B,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x1B,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x1B,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x1B,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x1B,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x1B,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x1B,7
_0x202000B:
	__DELAY_USB 11
	SBI  0x1B,2
	__DELAY_USB 27
	CBI  0x1B,2
	__DELAY_USB 27
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x8
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x8
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R11,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	CP   R11,R13
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R10
	ST   -Y,R10
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	INC  R11
	SBI  0x1B,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,7
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG
_strcmp:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret

	.CSEG

	.DSEG
_nomorPin:
	.BYTE 0x5
_password:
	.BYTE 0x5
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	OUT  0x15,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	ADD  R26,R8
	ADC  R27,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x4:
	ST   X,R30
	MOV  R30,R8
	SUBI R30,-LOW(6)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:192 WORDS
SUBOPT_0x5:
	LD   R30,X
	ST   -Y,R30
	CALL _lcd_putchar
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBI  0x12,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x12,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
