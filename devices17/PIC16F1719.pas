unit PIC16F1719;

// Define hardware
{$SET PIC_MODEL    = 'PIC16F1719'}
{$SET PIC_MAXFREQ  = 32000000}
{$SET PIC_NPINS    = 40}
{$SET PIC_NUMBANKS = 32}
{$SET PIC_NUMPAGES = 8}
{$SET PIC_MAXFLASH = 16384}

interface
var
  INDF0                    : byte absolute $0000;
  INDF1                    : byte absolute $0001;
  PCL                      : byte absolute $0002;
  STATUS                   : byte absolute $0003;
  STATUS_nTO               : bit  absolute STATUS.4;
  STATUS_nPD               : bit  absolute STATUS.3;
  STATUS_Z                 : bit  absolute STATUS.2;
  STATUS_DC                : bit  absolute STATUS.1;
  STATUS_C                 : bit  absolute STATUS.0;
  FSR0L                    : byte absolute $0004;
  FSR0H                    : byte absolute $0005;
  FSR1L                    : byte absolute $0006;
  FSR1H                    : byte absolute $0007;
  BSR                      : byte absolute $0008;
  BSR_BSR4                 : bit  absolute BSR.4;
  BSR_BSR3                 : bit  absolute BSR.3;
  BSR_BSR2                 : bit  absolute BSR.2;
  BSR_BSR1                 : bit  absolute BSR.1;
  BSR_BSR0                 : bit  absolute BSR.0;
  WREG                     : byte absolute $0009;
  PCLATH                   : byte absolute $000A;
  PCLATH_PCLATH6           : bit  absolute PCLATH.6;
  PCLATH_PCLATH5           : bit  absolute PCLATH.5;
  PCLATH_PCLATH4           : bit  absolute PCLATH.4;
  PCLATH_PCLATH3           : bit  absolute PCLATH.3;
  PCLATH_PCLATH2           : bit  absolute PCLATH.2;
  PCLATH_PCLATH1           : bit  absolute PCLATH.1;
  PCLATH_PCLATH0           : bit  absolute PCLATH.0;
  INTCON                   : byte absolute $000B;
  INTCON_GIE               : bit  absolute INTCON.7;
  INTCON_PEIE              : bit  absolute INTCON.6;
  INTCON_TMR0IE            : bit  absolute INTCON.5;
  INTCON_INTE              : bit  absolute INTCON.4;
  INTCON_IOCIE             : bit  absolute INTCON.3;
  INTCON_TMR0IF            : bit  absolute INTCON.2;
  INTCON_INTF              : bit  absolute INTCON.1;
  INTCON_IOCIF             : bit  absolute INTCON.0;
  PORTA                    : byte absolute $000C;
  PORTA_RA7                : bit  absolute PORTA.7;
  PORTA_RA6                : bit  absolute PORTA.6;
  PORTA_RA5                : bit  absolute PORTA.5;
  PORTA_RA4                : bit  absolute PORTA.4;
  PORTA_RA3                : bit  absolute PORTA.3;
  PORTA_RA2                : bit  absolute PORTA.2;
  PORTA_RA1                : bit  absolute PORTA.1;
  PORTA_RA0                : bit  absolute PORTA.0;
  PORTB                    : byte absolute $000D;
  PORTB_RB7                : bit  absolute PORTB.7;
  PORTB_RB6                : bit  absolute PORTB.6;
  PORTB_RB5                : bit  absolute PORTB.5;
  PORTB_RB4                : bit  absolute PORTB.4;
  PORTB_RB3                : bit  absolute PORTB.3;
  PORTB_RB2                : bit  absolute PORTB.2;
  PORTB_RB1                : bit  absolute PORTB.1;
  PORTB_RB0                : bit  absolute PORTB.0;
  PORTC                    : byte absolute $000E;
  PORTC_RC7                : bit  absolute PORTC.7;
  PORTC_RC6                : bit  absolute PORTC.6;
  PORTC_RC5                : bit  absolute PORTC.5;
  PORTC_RC4                : bit  absolute PORTC.4;
  PORTC_RC3                : bit  absolute PORTC.3;
  PORTC_RC2                : bit  absolute PORTC.2;
  PORTC_RC1                : bit  absolute PORTC.1;
  PORTC_RC0                : bit  absolute PORTC.0;
  PORTD                    : byte absolute $000F;
  PORTD_RD7                : bit  absolute PORTD.7;
  PORTD_RD6                : bit  absolute PORTD.6;
  PORTD_RD5                : bit  absolute PORTD.5;
  PORTD_RD4                : bit  absolute PORTD.4;
  PORTD_RD3                : bit  absolute PORTD.3;
  PORTD_RD2                : bit  absolute PORTD.2;
  PORTD_RD1                : bit  absolute PORTD.1;
  PORTD_RD0                : bit  absolute PORTD.0;
  PORTE                    : byte absolute $0010;
  PORTE_RE3                : bit  absolute PORTE.3;
  PORTE_RE2                : bit  absolute PORTE.2;
  PORTE_RE1                : bit  absolute PORTE.1;
  PORTE_RE0                : bit  absolute PORTE.0;
  PIR1                     : byte absolute $0011;
  PIR1_TMR1GIF             : bit  absolute PIR1.7;
  PIR1_ADIF                : bit  absolute PIR1.6;
  PIR1_RCIF                : bit  absolute PIR1.5;
  PIR1_TXIF                : bit  absolute PIR1.4;
  PIR1_SSP1IF              : bit  absolute PIR1.3;
  PIR1_CCP1IF              : bit  absolute PIR1.2;
  PIR1_TMR2IF              : bit  absolute PIR1.1;
  PIR1_TMR1IF              : bit  absolute PIR1.0;
  PIR2                     : byte absolute $0012;
  PIR2_OSFIF               : bit  absolute PIR2.7;
  PIR2_C2IF                : bit  absolute PIR2.6;
  PIR2_C1IF                : bit  absolute PIR2.5;
  PIR2_BCL1IF              : bit  absolute PIR2.3;
  PIR2_TMR6IF              : bit  absolute PIR2.2;
  PIR2_TMR4IF              : bit  absolute PIR2.1;
  PIR2_CCP2IF              : bit  absolute PIR2.0;
  PIR3                     : byte absolute $0013;
  PIR3_NCOIF               : bit  absolute PIR3.6;
  PIR3_COGIF               : bit  absolute PIR3.5;
  PIR3_ZCDIF               : bit  absolute PIR3.4;
  PIR3_CLC4IF              : bit  absolute PIR3.3;
  PIR3_CLC3IF              : bit  absolute PIR3.2;
  PIR3_CLC2IF              : bit  absolute PIR3.1;
  PIR3_CLC1IF              : bit  absolute PIR3.0;
  TMR0                     : byte absolute $0015;
  TMR1L                    : byte absolute $0016;
  TMR1H                    : byte absolute $0017;
  T1CON                    : byte absolute $0018;
  T1CON_TMR1CS1            : bit  absolute T1CON.7;
  T1CON_TMR1CS0            : bit  absolute T1CON.6;
  T1CON_T1CKPS1            : bit  absolute T1CON.5;
  T1CON_T1CKPS0            : bit  absolute T1CON.4;
  T1CON_T1OSCEN            : bit  absolute T1CON.3;
  T1CON_nT1SYNC            : bit  absolute T1CON.2;
  T1CON_TMR1ON             : bit  absolute T1CON.0;
  T1GCON                   : byte absolute $0019;
  T1GCON_TMR1GE            : bit  absolute T1GCON.7;
  T1GCON_T1GPOL            : bit  absolute T1GCON.6;
  T1GCON_T1GTM             : bit  absolute T1GCON.5;
  T1GCON_T1GSPM            : bit  absolute T1GCON.4;
  T1GCON_T1GGO_nDONE       : bit  absolute T1GCON.3;
  T1GCON_T1GVAL            : bit  absolute T1GCON.2;
  T1GCON_T1GSS1            : bit  absolute T1GCON.1;
  T1GCON_T1GSS0            : bit  absolute T1GCON.0;
  TMR2                     : byte absolute $001A;
  PR2                      : byte absolute $001B;
  T2CON                    : byte absolute $001C;
  T2CON_T2OUTPS3           : bit  absolute T2CON.6;
  T2CON_T2OUTPS2           : bit  absolute T2CON.5;
  T2CON_T2OUTPS1           : bit  absolute T2CON.4;
  T2CON_T2OUTPS0           : bit  absolute T2CON.3;
  T2CON_TMR2ON             : bit  absolute T2CON.2;
  T2CON_T2CKPS1            : bit  absolute T2CON.1;
  T2CON_T2CKPS0            : bit  absolute T2CON.0;
  TRISA                    : byte absolute $008C;
  TRISA_TRISA7             : bit  absolute TRISA.7;
  TRISA_TRISA6             : bit  absolute TRISA.6;
  TRISA_TRISA5             : bit  absolute TRISA.5;
  TRISA_TRISA4             : bit  absolute TRISA.4;
  TRISA_TRISA3             : bit  absolute TRISA.3;
  TRISA_TRISA2             : bit  absolute TRISA.2;
  TRISA_TRISA1             : bit  absolute TRISA.1;
  TRISA_TRISA0             : bit  absolute TRISA.0;
  TRISB                    : byte absolute $008D;
  TRISB_TRISB7             : bit  absolute TRISB.7;
  TRISB_TRISB6             : bit  absolute TRISB.6;
  TRISB_TRISB5             : bit  absolute TRISB.5;
  TRISB_TRISB4             : bit  absolute TRISB.4;
  TRISB_TRISB3             : bit  absolute TRISB.3;
  TRISB_TRISB2             : bit  absolute TRISB.2;
  TRISB_TRISB1             : bit  absolute TRISB.1;
  TRISB_TRISB0             : bit  absolute TRISB.0;
  TRISC                    : byte absolute $008E;
  TRISC_TRISC7             : bit  absolute TRISC.7;
  TRISC_TRISC6             : bit  absolute TRISC.6;
  TRISC_TRISC5             : bit  absolute TRISC.5;
  TRISC_TRISC4             : bit  absolute TRISC.4;
  TRISC_TRISC3             : bit  absolute TRISC.3;
  TRISC_TRISC2             : bit  absolute TRISC.2;
  TRISC_TRISC1             : bit  absolute TRISC.1;
  TRISC_TRISC0             : bit  absolute TRISC.0;
  TRISD                    : byte absolute $008F;
  TRISD_TRISD7             : bit  absolute TRISD.7;
  TRISD_TRISD6             : bit  absolute TRISD.6;
  TRISD_TRISD5             : bit  absolute TRISD.5;
  TRISD_TRISD4             : bit  absolute TRISD.4;
  TRISD_TRISD3             : bit  absolute TRISD.3;
  TRISD_TRISD2             : bit  absolute TRISD.2;
  TRISD_TRISD1             : bit  absolute TRISD.1;
  TRISD_TRISD0             : bit  absolute TRISD.0;
  TRISE                    : byte absolute $0090;
  TRISE_TRISE3             : bit  absolute TRISE.3;
  TRISE_TRISE2             : bit  absolute TRISE.2;
  TRISE_TRISE1             : bit  absolute TRISE.1;
  TRISE_TRISE0             : bit  absolute TRISE.0;
  PIE1                     : byte absolute $0091;
  PIE1_TMR1GIE             : bit  absolute PIE1.7;
  PIE1_ADIE                : bit  absolute PIE1.6;
  PIE1_RCIE                : bit  absolute PIE1.5;
  PIE1_TXIE                : bit  absolute PIE1.4;
  PIE1_SSP1IE              : bit  absolute PIE1.3;
  PIE1_CCP1IE              : bit  absolute PIE1.2;
  PIE1_TMR2IE              : bit  absolute PIE1.1;
  PIE1_TMR1IE              : bit  absolute PIE1.0;
  PIE2                     : byte absolute $0092;
  PIE2_OSFIE               : bit  absolute PIE2.7;
  PIE2_C2IE                : bit  absolute PIE2.6;
  PIE2_C1IE                : bit  absolute PIE2.5;
  PIE2_BCL1IE              : bit  absolute PIE2.3;
  PIE2_TMR6IE              : bit  absolute PIE2.2;
  PIE2_TMR4IE              : bit  absolute PIE2.1;
  PIE2_CCP2IE              : bit  absolute PIE2.0;
  PIE3                     : byte absolute $0093;
  PIE3_NCOIE               : bit  absolute PIE3.6;
  PIE3_COGIE               : bit  absolute PIE3.5;
  PIE3_ZCDIE               : bit  absolute PIE3.4;
  PIE3_CLC4IE              : bit  absolute PIE3.3;
  PIE3_CLC3IE              : bit  absolute PIE3.2;
  PIE3_CLC2IE              : bit  absolute PIE3.1;
  PIE3_CLC1IE              : bit  absolute PIE3.0;
  OPTION_REG               : byte absolute $0095;
  OPTION_REG_nWPUEN        : bit  absolute OPTION_REG.7;
  OPTION_REG_INTEDG        : bit  absolute OPTION_REG.6;
  OPTION_REG_TMR0CS        : bit  absolute OPTION_REG.5;
  OPTION_REG_TMR0SE        : bit  absolute OPTION_REG.4;
  OPTION_REG_PSA           : bit  absolute OPTION_REG.3;
  OPTION_REG_PS2           : bit  absolute OPTION_REG.2;
  OPTION_REG_PS1           : bit  absolute OPTION_REG.1;
  OPTION_REG_PS0           : bit  absolute OPTION_REG.0;
  PCON                     : byte absolute $0096;
  PCON_STKOVF              : bit  absolute PCON.7;
  PCON_STKUNF              : bit  absolute PCON.6;
  PCON_nRWDT               : bit  absolute PCON.4;
  PCON_nRMCLR              : bit  absolute PCON.3;
  PCON_nRI                 : bit  absolute PCON.2;
  PCON_nPOR                : bit  absolute PCON.1;
  PCON_nBOR                : bit  absolute PCON.0;
  WDTCON                   : byte absolute $0097;
  WDTCON_WDTPS4            : bit  absolute WDTCON.5;
  WDTCON_WDTPS3            : bit  absolute WDTCON.4;
  WDTCON_WDTPS2            : bit  absolute WDTCON.3;
  WDTCON_WDTPS1            : bit  absolute WDTCON.2;
  WDTCON_WDTPS0            : bit  absolute WDTCON.1;
  WDTCON_SWDTEN            : bit  absolute WDTCON.0;
  OSCTUNE                  : byte absolute $0098;
  OSCTUNE_TUN5             : bit  absolute OSCTUNE.5;
  OSCTUNE_TUN4             : bit  absolute OSCTUNE.4;
  OSCTUNE_TUN3             : bit  absolute OSCTUNE.3;
  OSCTUNE_TUN2             : bit  absolute OSCTUNE.2;
  OSCTUNE_TUN1             : bit  absolute OSCTUNE.1;
  OSCTUNE_TUN0             : bit  absolute OSCTUNE.0;
  OSCCON                   : byte absolute $0099;
  OSCCON_SPLLEN            : bit  absolute OSCCON.7;
  OSCCON_IRCF3             : bit  absolute OSCCON.6;
  OSCCON_IRCF2             : bit  absolute OSCCON.5;
  OSCCON_IRCF1             : bit  absolute OSCCON.4;
  OSCCON_IRCF0             : bit  absolute OSCCON.3;
  OSCCON_SCS1              : bit  absolute OSCCON.1;
  OSCCON_SCS0              : bit  absolute OSCCON.0;
  OSCSTAT                  : byte absolute $009A;
  OSCSTAT_SOSCR            : bit  absolute OSCSTAT.7;
  OSCSTAT_PLLR             : bit  absolute OSCSTAT.6;
  OSCSTAT_OSTS             : bit  absolute OSCSTAT.5;
  OSCSTAT_HFIOFR           : bit  absolute OSCSTAT.4;
  OSCSTAT_HFIOFL           : bit  absolute OSCSTAT.3;
  OSCSTAT_MFIOFR           : bit  absolute OSCSTAT.2;
  OSCSTAT_LFIOFR           : bit  absolute OSCSTAT.1;
  OSCSTAT_HFIOFS           : bit  absolute OSCSTAT.0;
  ADRESL                   : byte absolute $009B;
  ADRESH                   : byte absolute $009C;
  ADCON0                   : byte absolute $009D;
  ADCON0_CHS4              : bit  absolute ADCON0.6;
  ADCON0_CHS3              : bit  absolute ADCON0.5;
  ADCON0_CHS2              : bit  absolute ADCON0.4;
  ADCON0_CHS1              : bit  absolute ADCON0.3;
  ADCON0_CHS0              : bit  absolute ADCON0.2;
  ADCON0_GO_nDONE          : bit  absolute ADCON0.1;
  ADCON0_ADON              : bit  absolute ADCON0.0;
  ADCON1                   : byte absolute $009E;
  ADCON1_ADFM              : bit  absolute ADCON1.7;
  ADCON1_ADCS2             : bit  absolute ADCON1.6;
  ADCON1_ADCS1             : bit  absolute ADCON1.5;
  ADCON1_ADCS0             : bit  absolute ADCON1.4;
  ADCON1_ADNREF            : bit  absolute ADCON1.2;
  ADCON1_ADPREF1           : bit  absolute ADCON1.1;
  ADCON1_ADPREF0           : bit  absolute ADCON1.0;
  ADCON2                   : byte absolute $009F;
  ADCON2_TRIGSEL3          : bit  absolute ADCON2.7;
  ADCON2_TRIGSEL2          : bit  absolute ADCON2.6;
  ADCON2_TRIGSEL1          : bit  absolute ADCON2.5;
  ADCON2_TRIGSEL0          : bit  absolute ADCON2.4;
  LATA                     : byte absolute $010C;
  LATA_LATA7               : bit  absolute LATA.7;
  LATA_LATA6               : bit  absolute LATA.6;
  LATA_LATA5               : bit  absolute LATA.5;
  LATA_LATA4               : bit  absolute LATA.4;
  LATA_LATA3               : bit  absolute LATA.3;
  LATA_LATA2               : bit  absolute LATA.2;
  LATA_LATA1               : bit  absolute LATA.1;
  LATA_LATA0               : bit  absolute LATA.0;
  LATB                     : byte absolute $010D;
  LATB_LATB7               : bit  absolute LATB.7;
  LATB_LATB6               : bit  absolute LATB.6;
  LATB_LATB5               : bit  absolute LATB.5;
  LATB_LATB4               : bit  absolute LATB.4;
  LATB_LATB3               : bit  absolute LATB.3;
  LATB_LATB2               : bit  absolute LATB.2;
  LATB_LATB1               : bit  absolute LATB.1;
  LATB_LATB0               : bit  absolute LATB.0;
  LATC                     : byte absolute $010E;
  LATC_LATC7               : bit  absolute LATC.7;
  LATC_LATC6               : bit  absolute LATC.6;
  LATC_LATC5               : bit  absolute LATC.5;
  LATC_LATC4               : bit  absolute LATC.4;
  LATC_LATC3               : bit  absolute LATC.3;
  LATC_LATC2               : bit  absolute LATC.2;
  LATC_LATC1               : bit  absolute LATC.1;
  LATC_LATC0               : bit  absolute LATC.0;
  LATD                     : byte absolute $010F;
  LATD_LATD7               : bit  absolute LATD.7;
  LATD_LATD6               : bit  absolute LATD.6;
  LATD_LATD5               : bit  absolute LATD.5;
  LATD_LATD4               : bit  absolute LATD.4;
  LATD_LATD3               : bit  absolute LATD.3;
  LATD_LATD2               : bit  absolute LATD.2;
  LATD_LATD1               : bit  absolute LATD.1;
  LATD_LATD0               : bit  absolute LATD.0;
  LATE                     : byte absolute $0110;
  LATE_LATE2               : bit  absolute LATE.2;
  LATE_LATE1               : bit  absolute LATE.1;
  LATE_LATE0               : bit  absolute LATE.0;
  CM1CON0                  : byte absolute $0111;
  CM1CON0_C1ON             : bit  absolute CM1CON0.7;
  CM1CON0_C1OUT            : bit  absolute CM1CON0.6;
  CM1CON0_C1POL            : bit  absolute CM1CON0.4;
  CM1CON0_C1ZLF            : bit  absolute CM1CON0.3;
  CM1CON0_C1SP             : bit  absolute CM1CON0.2;
  CM1CON0_C1HYS            : bit  absolute CM1CON0.1;
  CM1CON0_C1SYNC           : bit  absolute CM1CON0.0;
  CM1CON1                  : byte absolute $0112;
  CM1CON1_C1INTP           : bit  absolute CM1CON1.7;
  CM1CON1_C1INTN           : bit  absolute CM1CON1.6;
  CM1CON1_C1PCH2           : bit  absolute CM1CON1.5;
  CM1CON1_C1PCH1           : bit  absolute CM1CON1.4;
  CM1CON1_C1PCH0           : bit  absolute CM1CON1.3;
  CM1CON1_C1NCH2           : bit  absolute CM1CON1.2;
  CM1CON1_C1NCH1           : bit  absolute CM1CON1.1;
  CM1CON1_C1NCH0           : bit  absolute CM1CON1.0;
  CM2CON0                  : byte absolute $0113;
  CM2CON0_C2ON             : bit  absolute CM2CON0.7;
  CM2CON0_C2OUT            : bit  absolute CM2CON0.6;
  CM2CON0_C2POL            : bit  absolute CM2CON0.4;
  CM2CON0_C2ZLF            : bit  absolute CM2CON0.3;
  CM2CON0_C2SP             : bit  absolute CM2CON0.2;
  CM2CON0_C2HYS            : bit  absolute CM2CON0.1;
  CM2CON0_C2SYNC           : bit  absolute CM2CON0.0;
  CM2CON1                  : byte absolute $0114;
  CM2CON1_C2INTP           : bit  absolute CM2CON1.7;
  CM2CON1_C2INTN           : bit  absolute CM2CON1.6;
  CM2CON1_C2PCH2           : bit  absolute CM2CON1.5;
  CM2CON1_C2PCH1           : bit  absolute CM2CON1.4;
  CM2CON1_C2PCH0           : bit  absolute CM2CON1.3;
  CM2CON1_C2NCH2           : bit  absolute CM2CON1.2;
  CM2CON1_C2NCH1           : bit  absolute CM2CON1.1;
  CM2CON1_C2NCH0           : bit  absolute CM2CON1.0;
  CMOUT                    : byte absolute $0115;
  CMOUT_MC2OUT             : bit  absolute CMOUT.1;
  CMOUT_MC1OUT             : bit  absolute CMOUT.0;
  BORCON                   : byte absolute $0116;
  BORCON_SBOREN            : bit  absolute BORCON.7;
  BORCON_BORFS             : bit  absolute BORCON.6;
  BORCON_BORRDY            : bit  absolute BORCON.0;
  FVRCON                   : byte absolute $0117;
  FVRCON_FVREN             : bit  absolute FVRCON.7;
  FVRCON_FVRRDY            : bit  absolute FVRCON.6;
  FVRCON_TSEN              : bit  absolute FVRCON.5;
  FVRCON_TSRNG             : bit  absolute FVRCON.4;
  FVRCON_CDAFVR1           : bit  absolute FVRCON.3;
  FVRCON_CDAFVR0           : bit  absolute FVRCON.2;
  FVRCON_ADFVR1            : bit  absolute FVRCON.1;
  FVRCON_ADFVR0            : bit  absolute FVRCON.0;
  DAC1CON0                 : byte absolute $0118;
  DAC1CON0_DAC1EN          : bit  absolute DAC1CON0.7;
  DAC1CON0_DAC1OE1         : bit  absolute DAC1CON0.5;
  DAC1CON0_DAC1OE2         : bit  absolute DAC1CON0.4;
  DAC1CON0_DAC1PSS1        : bit  absolute DAC1CON0.3;
  DAC1CON0_DAC1PSS0        : bit  absolute DAC1CON0.2;
  DAC1CON0_DAC1NSS         : bit  absolute DAC1CON0.0;
  DAC1CON1                 : byte absolute $0119;
  DAC2CON0                 : byte absolute $011A;
  DAC2CON0_EN              : bit  absolute DAC2CON0.7;
  DAC2CON0_OE1             : bit  absolute DAC2CON0.5;
  DAC2CON0_OE2             : bit  absolute DAC2CON0.4;
  DAC2CON0_PSS1            : bit  absolute DAC2CON0.3;
  DAC2CON0_PSS0            : bit  absolute DAC2CON0.2;
  DAC2CON0_NSS             : bit  absolute DAC2CON0.0;
  DAC2REF                  : byte absolute $011B;
  DAC2REF_DACR4            : bit  absolute DAC2REF.4;
  DAC2REF_DACR3            : bit  absolute DAC2REF.3;
  DAC2REF_DACR2            : bit  absolute DAC2REF.2;
  DAC2REF_DACR1            : bit  absolute DAC2REF.1;
  DAC2REF_DACR0            : bit  absolute DAC2REF.0;
  ZCD1CON                  : byte absolute $011C;
  ZCD1CON_ZCD1EN           : bit  absolute ZCD1CON.7;
  ZCD1CON_ZCD1OUT          : bit  absolute ZCD1CON.5;
  ZCD1CON_ZCD1POL          : bit  absolute ZCD1CON.4;
  ZCD1CON_ZCD1INTP         : bit  absolute ZCD1CON.1;
  ZCD1CON_ZCD1INTN         : bit  absolute ZCD1CON.0;
  ANSELA                   : byte absolute $018C;
  ANSELA_ANSA5             : bit  absolute ANSELA.5;
  ANSELA_ANSA4             : bit  absolute ANSELA.4;
  ANSELA_ANSA3             : bit  absolute ANSELA.3;
  ANSELA_ANSA2             : bit  absolute ANSELA.2;
  ANSELA_ANSA1             : bit  absolute ANSELA.1;
  ANSELA_ANSA0             : bit  absolute ANSELA.0;
  ANSELB                   : byte absolute $018D;
  ANSELB_ANSB5             : bit  absolute ANSELB.5;
  ANSELB_ANSB4             : bit  absolute ANSELB.4;
  ANSELB_ANSB3             : bit  absolute ANSELB.3;
  ANSELB_ANSB2             : bit  absolute ANSELB.2;
  ANSELB_ANSB1             : bit  absolute ANSELB.1;
  ANSELB_ANSB0             : bit  absolute ANSELB.0;
  ANSELC                   : byte absolute $018E;
  ANSELC_ANSC7             : bit  absolute ANSELC.7;
  ANSELC_ANSC6             : bit  absolute ANSELC.6;
  ANSELC_ANSC5             : bit  absolute ANSELC.5;
  ANSELC_ANSC4             : bit  absolute ANSELC.4;
  ANSELC_ANSC3             : bit  absolute ANSELC.3;
  ANSELC_ANSC2             : bit  absolute ANSELC.2;
  ANSELD                   : byte absolute $018F;
  ANSELD_ANSD7             : bit  absolute ANSELD.7;
  ANSELD_ANSD6             : bit  absolute ANSELD.6;
  ANSELD_ANSD5             : bit  absolute ANSELD.5;
  ANSELD_ANSD4             : bit  absolute ANSELD.4;
  ANSELD_ANSD3             : bit  absolute ANSELD.3;
  ANSELD_ANSD2             : bit  absolute ANSELD.2;
  ANSELD_ANSD1             : bit  absolute ANSELD.1;
  ANSELD_ANSD0             : bit  absolute ANSELD.0;
  ANSELE                   : byte absolute $0190;
  ANSELE_ANSE2             : bit  absolute ANSELE.2;
  ANSELE_ANSE1             : bit  absolute ANSELE.1;
  ANSELE_ANSE0             : bit  absolute ANSELE.0;
  PMADRL                   : byte absolute $0191;
  PMADRH                   : byte absolute $0192;
  PMADRH_PMADRH6           : bit  absolute PMADRH.6;
  PMADRH_PMADRH5           : bit  absolute PMADRH.5;
  PMADRH_PMADRH4           : bit  absolute PMADRH.4;
  PMADRH_PMADRH3           : bit  absolute PMADRH.3;
  PMADRH_PMADRH2           : bit  absolute PMADRH.2;
  PMADRH_PMADRH1           : bit  absolute PMADRH.1;
  PMADRH_PMADRH0           : bit  absolute PMADRH.0;
  PMDATL                   : byte absolute $0193;
  PMDATH                   : byte absolute $0194;
  PMDATH_PMDATH5           : bit  absolute PMDATH.5;
  PMDATH_PMDATH4           : bit  absolute PMDATH.4;
  PMDATH_PMDATH3           : bit  absolute PMDATH.3;
  PMDATH_PMDATH2           : bit  absolute PMDATH.2;
  PMDATH_PMDATH1           : bit  absolute PMDATH.1;
  PMDATH_PMDATH0           : bit  absolute PMDATH.0;
  PMCON1                   : byte absolute $0195;
  PMCON1_CFGS              : bit  absolute PMCON1.6;
  PMCON1_LWLO              : bit  absolute PMCON1.5;
  PMCON1_FREE              : bit  absolute PMCON1.4;
  PMCON1_WRERR             : bit  absolute PMCON1.3;
  PMCON1_WREN              : bit  absolute PMCON1.2;
  PMCON1_WR                : bit  absolute PMCON1.1;
  PMCON1_RD                : bit  absolute PMCON1.0;
  PMCON2                   : byte absolute $0196;
  VREGCON                  : byte absolute $0197;
  VREGCON_VREGPM           : bit  absolute VREGCON.1;
  VREGCON_Reserved         : bit  absolute VREGCON.0;
  RC1REG                   : byte absolute $0199;
  TX1REG                   : byte absolute $019A;
  SP1BRGL                  : byte absolute $019B;
  SP1BRGH                  : byte absolute $019C;
  RC1STA                   : byte absolute $019D;
  RC1STA_SPEN              : bit  absolute RC1STA.7;
  RC1STA_RX9               : bit  absolute RC1STA.6;
  RC1STA_SREN              : bit  absolute RC1STA.5;
  RC1STA_CREN              : bit  absolute RC1STA.4;
  RC1STA_ADDEN             : bit  absolute RC1STA.3;
  RC1STA_FERR              : bit  absolute RC1STA.2;
  RC1STA_OERR              : bit  absolute RC1STA.1;
  RC1STA_RX9D              : bit  absolute RC1STA.0;
  TX1STA                   : byte absolute $019E;
  TX1STA_CSRC              : bit  absolute TX1STA.7;
  TX1STA_TX9               : bit  absolute TX1STA.6;
  TX1STA_TXEN              : bit  absolute TX1STA.5;
  TX1STA_SYNC              : bit  absolute TX1STA.4;
  TX1STA_SENDB             : bit  absolute TX1STA.3;
  TX1STA_BRGH              : bit  absolute TX1STA.2;
  TX1STA_TRMT              : bit  absolute TX1STA.1;
  TX1STA_TX9D              : bit  absolute TX1STA.0;
  BAUD1CON                 : byte absolute $019F;
  BAUD1CON_ABDOVF          : bit  absolute BAUD1CON.7;
  BAUD1CON_RCIDL           : bit  absolute BAUD1CON.6;
  BAUD1CON_SCKP            : bit  absolute BAUD1CON.4;
  BAUD1CON_BRG16           : bit  absolute BAUD1CON.3;
  BAUD1CON_WUE             : bit  absolute BAUD1CON.1;
  BAUD1CON_ABDEN           : bit  absolute BAUD1CON.0;
  WPUA                     : byte absolute $020C;
  WPUA_WPUA7               : bit  absolute WPUA.7;
  WPUA_WPUA6               : bit  absolute WPUA.6;
  WPUA_WPUA5               : bit  absolute WPUA.5;
  WPUA_WPUA4               : bit  absolute WPUA.4;
  WPUA_WPUA3               : bit  absolute WPUA.3;
  WPUA_WPUA2               : bit  absolute WPUA.2;
  WPUA_WPUA1               : bit  absolute WPUA.1;
  WPUA_WPUA0               : bit  absolute WPUA.0;
  WPUB                     : byte absolute $020D;
  WPUB_WPUB7               : bit  absolute WPUB.7;
  WPUB_WPUB6               : bit  absolute WPUB.6;
  WPUB_WPUB5               : bit  absolute WPUB.5;
  WPUB_WPUB4               : bit  absolute WPUB.4;
  WPUB_WPUB3               : bit  absolute WPUB.3;
  WPUB_WPUB2               : bit  absolute WPUB.2;
  WPUB_WPUB1               : bit  absolute WPUB.1;
  WPUB_WPUB0               : bit  absolute WPUB.0;
  WPUC                     : byte absolute $020E;
  WPUC_WPUC7               : bit  absolute WPUC.7;
  WPUC_WPUC6               : bit  absolute WPUC.6;
  WPUC_WPUC5               : bit  absolute WPUC.5;
  WPUC_WPUC4               : bit  absolute WPUC.4;
  WPUC_WPUC3               : bit  absolute WPUC.3;
  WPUC_WPUC2               : bit  absolute WPUC.2;
  WPUC_WPUC1               : bit  absolute WPUC.1;
  WPUC_WPUC0               : bit  absolute WPUC.0;
  WPUD                     : byte absolute $020F;
  WPUD_WPUD7               : bit  absolute WPUD.7;
  WPUD_WPUD6               : bit  absolute WPUD.6;
  WPUD_WPUD5               : bit  absolute WPUD.5;
  WPUD_WPUD4               : bit  absolute WPUD.4;
  WPUD_WPUD3               : bit  absolute WPUD.3;
  WPUD_WPUD2               : bit  absolute WPUD.2;
  WPUD_WPUD1               : bit  absolute WPUD.1;
  WPUD_WPUD0               : bit  absolute WPUD.0;
  WPUE                     : byte absolute $0210;
  WPUE_WPUE3               : bit  absolute WPUE.3;
  WPUE_WPUE2               : bit  absolute WPUE.2;
  WPUE_WPUE1               : bit  absolute WPUE.1;
  WPUE_WPUE0               : bit  absolute WPUE.0;
  SSP1BUF                  : byte absolute $0211;
  SSP1BUF_SSP1BUF7         : bit  absolute SSP1BUF.7;
  SSP1BUF_SSP1BUF6         : bit  absolute SSP1BUF.6;
  SSP1BUF_SSP1BUF5         : bit  absolute SSP1BUF.5;
  SSP1BUF_SSP1BUF4         : bit  absolute SSP1BUF.4;
  SSP1BUF_SSP1BUF3         : bit  absolute SSP1BUF.3;
  SSP1BUF_SSP1BUF2         : bit  absolute SSP1BUF.2;
  SSP1BUF_SSP1BUF1         : bit  absolute SSP1BUF.1;
  SSP1BUF_SSP1BUF0         : bit  absolute SSP1BUF.0;
  SSP1ADD                  : byte absolute $0212;
  SSP1ADD_SSP1ADD7         : bit  absolute SSP1ADD.7;
  SSP1ADD_SSP1ADD6         : bit  absolute SSP1ADD.6;
  SSP1ADD_SSP1ADD5         : bit  absolute SSP1ADD.5;
  SSP1ADD_SSP1ADD4         : bit  absolute SSP1ADD.4;
  SSP1ADD_SSP1ADD3         : bit  absolute SSP1ADD.3;
  SSP1ADD_SSP1ADD2         : bit  absolute SSP1ADD.2;
  SSP1ADD_SSP1ADD1         : bit  absolute SSP1ADD.1;
  SSP1ADD_SSP1ADD0         : bit  absolute SSP1ADD.0;
  SSP1MSK                  : byte absolute $0213;
  SSP1MSK_SSP1MSK7         : bit  absolute SSP1MSK.7;
  SSP1MSK_SSP1MSK6         : bit  absolute SSP1MSK.6;
  SSP1MSK_SSP1MSK5         : bit  absolute SSP1MSK.5;
  SSP1MSK_SSP1MSK4         : bit  absolute SSP1MSK.4;
  SSP1MSK_SSP1MSK3         : bit  absolute SSP1MSK.3;
  SSP1MSK_SSP1MSK2         : bit  absolute SSP1MSK.2;
  SSP1MSK_SSP1MSK1         : bit  absolute SSP1MSK.1;
  SSP1MSK_SSP1MSK0         : bit  absolute SSP1MSK.0;
  SSP1STAT                 : byte absolute $0214;
  SSP1STAT_SMP             : bit  absolute SSP1STAT.7;
  SSP1STAT_CKE             : bit  absolute SSP1STAT.6;
  SSP1STAT_D_nA            : bit  absolute SSP1STAT.5;
  SSP1STAT_P               : bit  absolute SSP1STAT.4;
  SSP1STAT_S               : bit  absolute SSP1STAT.3;
  SSP1STAT_R_nW            : bit  absolute SSP1STAT.2;
  SSP1STAT_UA              : bit  absolute SSP1STAT.1;
  SSP1STAT_BF              : bit  absolute SSP1STAT.0;
  SSP1CON1                 : byte absolute $0215;
  SSP1CON1_WCOL            : bit  absolute SSP1CON1.7;
  SSP1CON1_SSPOV           : bit  absolute SSP1CON1.6;
  SSP1CON1_SSPEN           : bit  absolute SSP1CON1.5;
  SSP1CON1_CKP             : bit  absolute SSP1CON1.4;
  SSP1CON1_SSPM3           : bit  absolute SSP1CON1.3;
  SSP1CON1_SSPM2           : bit  absolute SSP1CON1.2;
  SSP1CON1_SSPM1           : bit  absolute SSP1CON1.1;
  SSP1CON1_SSPM0           : bit  absolute SSP1CON1.0;
  SSP1CON2                 : byte absolute $0216;
  SSP1CON2_GCEN            : bit  absolute SSP1CON2.7;
  SSP1CON2_ACKSTAT         : bit  absolute SSP1CON2.6;
  SSP1CON2_ACKDT           : bit  absolute SSP1CON2.5;
  SSP1CON2_ACKEN           : bit  absolute SSP1CON2.4;
  SSP1CON2_RCEN            : bit  absolute SSP1CON2.3;
  SSP1CON2_PEN             : bit  absolute SSP1CON2.2;
  SSP1CON2_RSEN            : bit  absolute SSP1CON2.1;
  SSP1CON2_SEN             : bit  absolute SSP1CON2.0;
  SSP1CON3                 : byte absolute $0217;
  SSP1CON3_ACKTIM          : bit  absolute SSP1CON3.7;
  SSP1CON3_PCIE            : bit  absolute SSP1CON3.6;
  SSP1CON3_SCIE            : bit  absolute SSP1CON3.5;
  SSP1CON3_BOEN            : bit  absolute SSP1CON3.4;
  SSP1CON3_SDAHT           : bit  absolute SSP1CON3.3;
  SSP1CON3_SBCDE           : bit  absolute SSP1CON3.2;
  SSP1CON3_AHEN            : bit  absolute SSP1CON3.1;
  SSP1CON3_DHEN            : bit  absolute SSP1CON3.0;
  ODCONA                   : byte absolute $028C;
  ODCONA_ODA7              : bit  absolute ODCONA.7;
  ODCONA_ODA6              : bit  absolute ODCONA.6;
  ODCONA_ODA5              : bit  absolute ODCONA.5;
  ODCONA_ODA4              : bit  absolute ODCONA.4;
  ODCONA_ODA3              : bit  absolute ODCONA.3;
  ODCONA_ODA2              : bit  absolute ODCONA.2;
  ODCONA_ODA1              : bit  absolute ODCONA.1;
  ODCONA_ODA0              : bit  absolute ODCONA.0;
  ODCONB                   : byte absolute $028D;
  ODCONB_ODB7              : bit  absolute ODCONB.7;
  ODCONB_ODB6              : bit  absolute ODCONB.6;
  ODCONB_ODB5              : bit  absolute ODCONB.5;
  ODCONB_ODB4              : bit  absolute ODCONB.4;
  ODCONB_ODB3              : bit  absolute ODCONB.3;
  ODCONB_ODB2              : bit  absolute ODCONB.2;
  ODCONB_ODB1              : bit  absolute ODCONB.1;
  ODCONB_ODB0              : bit  absolute ODCONB.0;
  ODCONC                   : byte absolute $028E;
  ODCONC_ODC7              : bit  absolute ODCONC.7;
  ODCONC_ODC6              : bit  absolute ODCONC.6;
  ODCONC_ODC5              : bit  absolute ODCONC.5;
  ODCONC_ODC4              : bit  absolute ODCONC.4;
  ODCONC_ODC3              : bit  absolute ODCONC.3;
  ODCONC_ODC2              : bit  absolute ODCONC.2;
  ODCONC_ODC1              : bit  absolute ODCONC.1;
  ODCONC_ODC0              : bit  absolute ODCONC.0;
  ODCOND                   : byte absolute $028F;
  ODCOND_ODD7              : bit  absolute ODCOND.7;
  ODCOND_ODD6              : bit  absolute ODCOND.6;
  ODCOND_ODD5              : bit  absolute ODCOND.5;
  ODCOND_ODD4              : bit  absolute ODCOND.4;
  ODCOND_ODD3              : bit  absolute ODCOND.3;
  ODCOND_ODD2              : bit  absolute ODCOND.2;
  ODCOND_ODD1              : bit  absolute ODCOND.1;
  ODCOND_ODD0              : bit  absolute ODCOND.0;
  ODCONE                   : byte absolute $0290;
  ODCONE_ODE2              : bit  absolute ODCONE.2;
  ODCONE_ODE1              : bit  absolute ODCONE.1;
  ODCONE_ODE0              : bit  absolute ODCONE.0;
  CCPR1L                   : byte absolute $0291;
  CCPR1H                   : byte absolute $0292;
  CCP1CON                  : byte absolute $0293;
  CCP1CON_DC1B1            : bit  absolute CCP1CON.5;
  CCP1CON_DC1B0            : bit  absolute CCP1CON.4;
  CCP1CON_CCP1M3           : bit  absolute CCP1CON.3;
  CCP1CON_CCP1M2           : bit  absolute CCP1CON.2;
  CCP1CON_CCP1M1           : bit  absolute CCP1CON.1;
  CCP1CON_CCP1M0           : bit  absolute CCP1CON.0;
  CCPR2L                   : byte absolute $0298;
  CCPR2H                   : byte absolute $0299;
  CCP2CON                  : byte absolute $029A;
  CCP2CON_DC2B1            : bit  absolute CCP2CON.5;
  CCP2CON_DC2B0            : bit  absolute CCP2CON.4;
  CCP2CON_CCP2M3           : bit  absolute CCP2CON.3;
  CCP2CON_CCP2M2           : bit  absolute CCP2CON.2;
  CCP2CON_CCP2M1           : bit  absolute CCP2CON.1;
  CCP2CON_CCP2M0           : bit  absolute CCP2CON.0;
  CCPTMRS                  : byte absolute $029E;
  CCPTMRS_P4TSEL1          : bit  absolute CCPTMRS.7;
  CCPTMRS_P4TSEL0          : bit  absolute CCPTMRS.6;
  CCPTMRS_P3TSEL1          : bit  absolute CCPTMRS.5;
  CCPTMRS_P3TSEL0          : bit  absolute CCPTMRS.4;
  CCPTMRS_C2TSEL1          : bit  absolute CCPTMRS.3;
  CCPTMRS_C2TSEL0          : bit  absolute CCPTMRS.2;
  CCPTMRS_C1TSEL1          : bit  absolute CCPTMRS.1;
  CCPTMRS_C1TSEL0          : bit  absolute CCPTMRS.0;
  SLRCONA                  : byte absolute $030C;
  SLRCONA_SLRA7            : bit  absolute SLRCONA.7;
  SLRCONA_SLRA6            : bit  absolute SLRCONA.6;
  SLRCONA_SLRA5            : bit  absolute SLRCONA.5;
  SLRCONA_SLRA4            : bit  absolute SLRCONA.4;
  SLRCONA_SLRA3            : bit  absolute SLRCONA.3;
  SLRCONA_SLRA2            : bit  absolute SLRCONA.2;
  SLRCONA_SLRA1            : bit  absolute SLRCONA.1;
  SLRCONA_SLRA0            : bit  absolute SLRCONA.0;
  SLRCONB                  : byte absolute $030D;
  SLRCONB_SLRB7            : bit  absolute SLRCONB.7;
  SLRCONB_SLRB6            : bit  absolute SLRCONB.6;
  SLRCONB_SLRB5            : bit  absolute SLRCONB.5;
  SLRCONB_SLRB4            : bit  absolute SLRCONB.4;
  SLRCONB_SLRB3            : bit  absolute SLRCONB.3;
  SLRCONB_SLRB2            : bit  absolute SLRCONB.2;
  SLRCONB_SLRB1            : bit  absolute SLRCONB.1;
  SLRCONB_SLRB0            : bit  absolute SLRCONB.0;
  SLRCONC                  : byte absolute $030E;
  SLRCONC_SLRC7            : bit  absolute SLRCONC.7;
  SLRCONC_SLRC6            : bit  absolute SLRCONC.6;
  SLRCONC_SLRC5            : bit  absolute SLRCONC.5;
  SLRCONC_SLRC4            : bit  absolute SLRCONC.4;
  SLRCONC_SLRC3            : bit  absolute SLRCONC.3;
  SLRCONC_SLRC2            : bit  absolute SLRCONC.2;
  SLRCONC_SLRC1            : bit  absolute SLRCONC.1;
  SLRCONC_SLRC0            : bit  absolute SLRCONC.0;
  SLRCOND                  : byte absolute $030F;
  SLRCOND_SLRD7            : bit  absolute SLRCOND.7;
  SLRCOND_SLRD6            : bit  absolute SLRCOND.6;
  SLRCOND_SLRD5            : bit  absolute SLRCOND.5;
  SLRCOND_SLRD4            : bit  absolute SLRCOND.4;
  SLRCOND_SLRD3            : bit  absolute SLRCOND.3;
  SLRCOND_SLRD2            : bit  absolute SLRCOND.2;
  SLRCOND_SLRD1            : bit  absolute SLRCOND.1;
  SLRCOND_SLRD0            : bit  absolute SLRCOND.0;
  SLRCONE                  : byte absolute $0310;
  SLRCONE_SLRE2            : bit  absolute SLRCONE.2;
  SLRCONE_SLRE1            : bit  absolute SLRCONE.1;
  SLRCONE_SLRE0            : bit  absolute SLRCONE.0;
  INLVLA                   : byte absolute $038C;
  INLVLA_INLVLA7           : bit  absolute INLVLA.7;
  INLVLA_INLVLA6           : bit  absolute INLVLA.6;
  INLVLA_INLVLA5           : bit  absolute INLVLA.5;
  INLVLA_INLVLA4           : bit  absolute INLVLA.4;
  INLVLA_INLVLA3           : bit  absolute INLVLA.3;
  INLVLA_INLVLA2           : bit  absolute INLVLA.2;
  INLVLA_INLVLA1           : bit  absolute INLVLA.1;
  INLVLA_INLVLA0           : bit  absolute INLVLA.0;
  INLVLB                   : byte absolute $038D;
  INLVLB_INLVLB7           : bit  absolute INLVLB.7;
  INLVLB_INLVLB6           : bit  absolute INLVLB.6;
  INLVLB_INLVLB5           : bit  absolute INLVLB.5;
  INLVLB_INLVLB4           : bit  absolute INLVLB.4;
  INLVLB_INLVLB3           : bit  absolute INLVLB.3;
  INLVLB_INLVLB2           : bit  absolute INLVLB.2;
  INLVLB_INLVLB1           : bit  absolute INLVLB.1;
  INLVLB_INLVLB0           : bit  absolute INLVLB.0;
  INLVLC                   : byte absolute $038E;
  INLVLC_INLVLC7           : bit  absolute INLVLC.7;
  INLVLC_INLVLC6           : bit  absolute INLVLC.6;
  INLVLC_INLVLC5           : bit  absolute INLVLC.5;
  INLVLC_INLVLC4           : bit  absolute INLVLC.4;
  INLVLC_INLVLC3           : bit  absolute INLVLC.3;
  INLVLC_INLVLC2           : bit  absolute INLVLC.2;
  INLVLC_INLVLC1           : bit  absolute INLVLC.1;
  INLVLC_INLVLC0           : bit  absolute INLVLC.0;
  INLVLD                   : byte absolute $038F;
  INLVLD_INLVLD7           : bit  absolute INLVLD.7;
  INLVLD_INLVLD6           : bit  absolute INLVLD.6;
  INLVLD_INLVLD5           : bit  absolute INLVLD.5;
  INLVLD_INLVLD4           : bit  absolute INLVLD.4;
  INLVLD_INLVLD3           : bit  absolute INLVLD.3;
  INLVLD_INLVLD2           : bit  absolute INLVLD.2;
  INLVLD_INLVLD1           : bit  absolute INLVLD.1;
  INLVLD_INLVLD0           : bit  absolute INLVLD.0;
  INLVLE                   : byte absolute $0390;
  INLVLE_INLVLE3           : bit  absolute INLVLE.3;
  INLVLE_INLVLE2           : bit  absolute INLVLE.2;
  INLVLE_INLVLE1           : bit  absolute INLVLE.1;
  INLVLE_INLVLE0           : bit  absolute INLVLE.0;
  IOCAP                    : byte absolute $0391;
  IOCAP_IOCAP7             : bit  absolute IOCAP.7;
  IOCAP_IOCAP6             : bit  absolute IOCAP.6;
  IOCAP_IOCAP5             : bit  absolute IOCAP.5;
  IOCAP_IOCAP4             : bit  absolute IOCAP.4;
  IOCAP_IOCAP3             : bit  absolute IOCAP.3;
  IOCAP_IOCAP2             : bit  absolute IOCAP.2;
  IOCAP_IOCAP1             : bit  absolute IOCAP.1;
  IOCAP_IOCAP0             : bit  absolute IOCAP.0;
  IOCAN                    : byte absolute $0392;
  IOCAN_IOCAN7             : bit  absolute IOCAN.7;
  IOCAN_IOCAN6             : bit  absolute IOCAN.6;
  IOCAN_IOCAN5             : bit  absolute IOCAN.5;
  IOCAN_IOCAN4             : bit  absolute IOCAN.4;
  IOCAN_IOCAN3             : bit  absolute IOCAN.3;
  IOCAN_IOCAN2             : bit  absolute IOCAN.2;
  IOCAN_IOCAN1             : bit  absolute IOCAN.1;
  IOCAN_IOCAN0             : bit  absolute IOCAN.0;
  IOCAF                    : byte absolute $0393;
  IOCAF_IOCAF7             : bit  absolute IOCAF.7;
  IOCAF_IOCAF6             : bit  absolute IOCAF.6;
  IOCAF_IOCAF5             : bit  absolute IOCAF.5;
  IOCAF_IOCAF4             : bit  absolute IOCAF.4;
  IOCAF_IOCAF3             : bit  absolute IOCAF.3;
  IOCAF_IOCAF2             : bit  absolute IOCAF.2;
  IOCAF_IOCAF1             : bit  absolute IOCAF.1;
  IOCAF_IOCAF0             : bit  absolute IOCAF.0;
  IOCBP                    : byte absolute $0394;
  IOCBP_IOCBP7             : bit  absolute IOCBP.7;
  IOCBP_IOCBP6             : bit  absolute IOCBP.6;
  IOCBP_IOCBP5             : bit  absolute IOCBP.5;
  IOCBP_IOCBP4             : bit  absolute IOCBP.4;
  IOCBP_IOCBP3             : bit  absolute IOCBP.3;
  IOCBP_IOCBP2             : bit  absolute IOCBP.2;
  IOCBP_IOCBP1             : bit  absolute IOCBP.1;
  IOCBP_IOCBP0             : bit  absolute IOCBP.0;
  IOCBN                    : byte absolute $0395;
  IOCBN_IOCBN7             : bit  absolute IOCBN.7;
  IOCBN_IOCBN6             : bit  absolute IOCBN.6;
  IOCBN_IOCBN5             : bit  absolute IOCBN.5;
  IOCBN_IOCBN4             : bit  absolute IOCBN.4;
  IOCBN_IOCBN3             : bit  absolute IOCBN.3;
  IOCBN_IOCBN2             : bit  absolute IOCBN.2;
  IOCBN_IOCBN1             : bit  absolute IOCBN.1;
  IOCBN_IOCBN0             : bit  absolute IOCBN.0;
  IOCBF                    : byte absolute $0396;
  IOCBF_IOCBF7             : bit  absolute IOCBF.7;
  IOCBF_IOCBF6             : bit  absolute IOCBF.6;
  IOCBF_IOCBF5             : bit  absolute IOCBF.5;
  IOCBF_IOCBF4             : bit  absolute IOCBF.4;
  IOCBF_IOCBF3             : bit  absolute IOCBF.3;
  IOCBF_IOCBF2             : bit  absolute IOCBF.2;
  IOCBF_IOCBF1             : bit  absolute IOCBF.1;
  IOCBF_IOCBF0             : bit  absolute IOCBF.0;
  IOCCP                    : byte absolute $0397;
  IOCCP_IOCCP7             : bit  absolute IOCCP.7;
  IOCCP_IOCCP6             : bit  absolute IOCCP.6;
  IOCCP_IOCCP5             : bit  absolute IOCCP.5;
  IOCCP_IOCCP4             : bit  absolute IOCCP.4;
  IOCCP_IOCCP3             : bit  absolute IOCCP.3;
  IOCCP_IOCCP2             : bit  absolute IOCCP.2;
  IOCCP_IOCCP1             : bit  absolute IOCCP.1;
  IOCCP_IOCCP0             : bit  absolute IOCCP.0;
  IOCCN                    : byte absolute $0398;
  IOCCN_IOCCN7             : bit  absolute IOCCN.7;
  IOCCN_IOCCN6             : bit  absolute IOCCN.6;
  IOCCN_IOCCN5             : bit  absolute IOCCN.5;
  IOCCN_IOCCN4             : bit  absolute IOCCN.4;
  IOCCN_IOCCN3             : bit  absolute IOCCN.3;
  IOCCN_IOCCN2             : bit  absolute IOCCN.2;
  IOCCN_IOCCN1             : bit  absolute IOCCN.1;
  IOCCN_IOCCN0             : bit  absolute IOCCN.0;
  IOCCF                    : byte absolute $0399;
  IOCCF_IOCCF7             : bit  absolute IOCCF.7;
  IOCCF_IOCCF6             : bit  absolute IOCCF.6;
  IOCCF_IOCCF5             : bit  absolute IOCCF.5;
  IOCCF_IOCCF4             : bit  absolute IOCCF.4;
  IOCCF_IOCCF3             : bit  absolute IOCCF.3;
  IOCCF_IOCCF2             : bit  absolute IOCCF.2;
  IOCCF_IOCCF1             : bit  absolute IOCCF.1;
  IOCCF_IOCCF0             : bit  absolute IOCCF.0;
  IOCEP                    : byte absolute $039D;
  IOCEP_IOCEP3             : bit  absolute IOCEP.3;
  IOCEN                    : byte absolute $039E;
  IOCEN_IOCEN3             : bit  absolute IOCEN.3;
  IOCEF                    : byte absolute $039F;
  IOCEF_IOCEF3             : bit  absolute IOCEF.3;
  TMR4                     : byte absolute $0415;
  PR4                      : byte absolute $0416;
  T4CON                    : byte absolute $0417;
  T4CON_T4OUTPS3           : bit  absolute T4CON.6;
  T4CON_T4OUTPS2           : bit  absolute T4CON.5;
  T4CON_T4OUTPS1           : bit  absolute T4CON.4;
  T4CON_T4OUTPS0           : bit  absolute T4CON.3;
  T4CON_TMR4ON             : bit  absolute T4CON.2;
  T4CON_T4CKPS1            : bit  absolute T4CON.1;
  T4CON_T4CKPS0            : bit  absolute T4CON.0;
  TMR6                     : byte absolute $041C;
  PR6                      : byte absolute $041D;
  T6CON                    : byte absolute $041E;
  T6CON_T6OUTPS3           : bit  absolute T6CON.6;
  T6CON_T6OUTPS2           : bit  absolute T6CON.5;
  T6CON_T6OUTPS1           : bit  absolute T6CON.4;
  T6CON_T6OUTPS0           : bit  absolute T6CON.3;
  T6CON_TMR6ON             : bit  absolute T6CON.2;
  T6CON_T6CKPS1            : bit  absolute T6CON.1;
  T6CON_T6CKPS0            : bit  absolute T6CON.0;
  NCO1ACCL                 : byte absolute $0498;
  NCO1ACCL_NCO1ACC7        : bit  absolute NCO1ACCL.7;
  NCO1ACCL_NCO1ACC6        : bit  absolute NCO1ACCL.6;
  NCO1ACCL_NCO1ACC5        : bit  absolute NCO1ACCL.5;
  NCO1ACCL_NCO1ACC4        : bit  absolute NCO1ACCL.4;
  NCO1ACCL_NCO1ACC3        : bit  absolute NCO1ACCL.3;
  NCO1ACCL_NCO1ACC2        : bit  absolute NCO1ACCL.2;
  NCO1ACCL_NCO1ACC1        : bit  absolute NCO1ACCL.1;
  NCO1ACCL_NCO1ACC0        : bit  absolute NCO1ACCL.0;
  NCO1ACCH                 : byte absolute $0499;
  NCO1ACCH_NCO1ACC15       : bit  absolute NCO1ACCH.7;
  NCO1ACCH_NCO1ACC14       : bit  absolute NCO1ACCH.6;
  NCO1ACCH_NCO1ACC13       : bit  absolute NCO1ACCH.5;
  NCO1ACCH_NCO1ACC12       : bit  absolute NCO1ACCH.4;
  NCO1ACCH_NCO1ACC11       : bit  absolute NCO1ACCH.3;
  NCO1ACCH_NCO1ACC10       : bit  absolute NCO1ACCH.2;
  NCO1ACCH_NCO1ACC9        : bit  absolute NCO1ACCH.1;
  NCO1ACCH_NCO1ACC8        : bit  absolute NCO1ACCH.0;
  NCO1ACCU                 : byte absolute $049A;
  NCO1ACCU_NCO1ACC19       : bit  absolute NCO1ACCU.3;
  NCO1ACCU_NCO1ACC18       : bit  absolute NCO1ACCU.2;
  NCO1ACCU_NCO1ACC17       : bit  absolute NCO1ACCU.1;
  NCO1ACCU_NCO1ACC16       : bit  absolute NCO1ACCU.0;
  NCO1INCL                 : byte absolute $049B;
  NCO1INCL_NCO1INC7        : bit  absolute NCO1INCL.7;
  NCO1INCL_NCO1INC6        : bit  absolute NCO1INCL.6;
  NCO1INCL_NCO1INC5        : bit  absolute NCO1INCL.5;
  NCO1INCL_NCO1INC4        : bit  absolute NCO1INCL.4;
  NCO1INCL_NCO1INC3        : bit  absolute NCO1INCL.3;
  NCO1INCL_NCO1INC2        : bit  absolute NCO1INCL.2;
  NCO1INCL_NCO1INC1        : bit  absolute NCO1INCL.1;
  NCO1INCL_NCO1INC0        : bit  absolute NCO1INCL.0;
  NCO1INCH                 : byte absolute $049C;
  NCO1INCH_NCO1INC15       : bit  absolute NCO1INCH.7;
  NCO1INCH_NCO1INC14       : bit  absolute NCO1INCH.6;
  NCO1INCH_NCO1INC13       : bit  absolute NCO1INCH.5;
  NCO1INCH_NCO1INC12       : bit  absolute NCO1INCH.4;
  NCO1INCH_NCO1INC11       : bit  absolute NCO1INCH.3;
  NCO1INCH_NCO1INC10       : bit  absolute NCO1INCH.2;
  NCO1INCH_NCO1INC9        : bit  absolute NCO1INCH.1;
  NCO1INCH_NCO1INC8        : bit  absolute NCO1INCH.0;
  NCO1INCU                 : byte absolute $049D;
  NCO1INCU_NCO1INC19       : bit  absolute NCO1INCU.3;
  NCO1INCU_NCO1INC18       : bit  absolute NCO1INCU.2;
  NCO1INCU_NCO1INC17       : bit  absolute NCO1INCU.1;
  NCO1INCU_NCO1INC16       : bit  absolute NCO1INCU.0;
  NCO1CON                  : byte absolute $049E;
  NCO1CON_N1EN             : bit  absolute NCO1CON.7;
  NCO1CON_N1OUT            : bit  absolute NCO1CON.5;
  NCO1CON_N1POL            : bit  absolute NCO1CON.4;
  NCO1CON_N1PFM            : bit  absolute NCO1CON.0;
  NCO1CLK                  : byte absolute $049F;
  NCO1CLK_N1PWS2           : bit  absolute NCO1CLK.7;
  NCO1CLK_N1PWS1           : bit  absolute NCO1CLK.6;
  NCO1CLK_N1PWS0           : bit  absolute NCO1CLK.5;
  NCO1CLK_N1CKS1           : bit  absolute NCO1CLK.1;
  NCO1CLK_N1CKS0           : bit  absolute NCO1CLK.0;
  OPA1CON                  : byte absolute $0511;
  OPA1CON_OPA1EN           : bit  absolute OPA1CON.7;
  OPA1CON_OPA1SP           : bit  absolute OPA1CON.6;
  OPA1CON_OPA1UG           : bit  absolute OPA1CON.4;
  OPA1CON_OPA1PCH1         : bit  absolute OPA1CON.1;
  OPA1CON_OPA1PCH0         : bit  absolute OPA1CON.0;
  OPA2CON                  : byte absolute $0515;
  OPA2CON_OPA2EN           : bit  absolute OPA2CON.7;
  OPA2CON_OPA2SP           : bit  absolute OPA2CON.6;
  OPA2CON_OPA2UG           : bit  absolute OPA2CON.4;
  OPA2CON_OPA2PCH1         : bit  absolute OPA2CON.1;
  OPA2CON_OPA2PCH0         : bit  absolute OPA2CON.0;
  PWM3DCL                  : byte absolute $0617;
  PWM3DCL_PWM3DCL1         : bit  absolute PWM3DCL.7;
  PWM3DCL_PWM3DCL0         : bit  absolute PWM3DCL.6;
  PWM3DCH                  : byte absolute $0618;
  PWM3CON                  : byte absolute $0619;
  PWM3CON_PWM3EN           : bit  absolute PWM3CON.7;
  PWM3CON_PWM3OUT          : bit  absolute PWM3CON.5;
  PWM3CON_PWM3POL          : bit  absolute PWM3CON.4;
  PWM4DCL                  : byte absolute $061A;
  PWM4DCL_PWM4DCL1         : bit  absolute PWM4DCL.7;
  PWM4DCL_PWM4DCL0         : bit  absolute PWM4DCL.6;
  PWM4DCH                  : byte absolute $061B;
  PWM4CON                  : byte absolute $061C;
  PWM4CON_PWM4EN           : bit  absolute PWM4CON.7;
  PWM4CON_PWM4OUT          : bit  absolute PWM4CON.5;
  PWM4CON_PWM4POL          : bit  absolute PWM4CON.4;
  COG1PHR                  : byte absolute $0691;
  COG1PHR_G1PHR5           : bit  absolute COG1PHR.5;
  COG1PHR_G1PHR4           : bit  absolute COG1PHR.4;
  COG1PHR_G1PHR3           : bit  absolute COG1PHR.3;
  COG1PHR_G1PHR2           : bit  absolute COG1PHR.2;
  COG1PHR_G1PHR1           : bit  absolute COG1PHR.1;
  COG1PHR_G1PHR0           : bit  absolute COG1PHR.0;
  COG1PHF                  : byte absolute $0692;
  COG1PHF_G1PHF5           : bit  absolute COG1PHF.5;
  COG1PHF_G1PHF4           : bit  absolute COG1PHF.4;
  COG1PHF_G1PHF3           : bit  absolute COG1PHF.3;
  COG1PHF_G1PHF2           : bit  absolute COG1PHF.2;
  COG1PHF_G1PHF1           : bit  absolute COG1PHF.1;
  COG1PHF_G1PHF0           : bit  absolute COG1PHF.0;
  COG1BLKR                 : byte absolute $0693;
  COG1BLKR_G1BLKR5         : bit  absolute COG1BLKR.5;
  COG1BLKR_G1BLKR4         : bit  absolute COG1BLKR.4;
  COG1BLKR_G1BLKR3         : bit  absolute COG1BLKR.3;
  COG1BLKR_G1BLKR2         : bit  absolute COG1BLKR.2;
  COG1BLKR_G1BLKR1         : bit  absolute COG1BLKR.1;
  COG1BLKR_G1BLKR0         : bit  absolute COG1BLKR.0;
  COG1BLKF                 : byte absolute $0694;
  COG1BLKF_G1BLKF5         : bit  absolute COG1BLKF.5;
  COG1BLKF_G1BLKF4         : bit  absolute COG1BLKF.4;
  COG1BLKF_G1BLKF3         : bit  absolute COG1BLKF.3;
  COG1BLKF_G1BLKF2         : bit  absolute COG1BLKF.2;
  COG1BLKF_G1BLKF1         : bit  absolute COG1BLKF.1;
  COG1BLKF_G1BLKF0         : bit  absolute COG1BLKF.0;
  COG1DBR                  : byte absolute $0695;
  COG1DBR_G1DBR5           : bit  absolute COG1DBR.5;
  COG1DBR_G1DBR4           : bit  absolute COG1DBR.4;
  COG1DBR_G1DBR3           : bit  absolute COG1DBR.3;
  COG1DBR_G1DBR2           : bit  absolute COG1DBR.2;
  COG1DBR_G1DBR1           : bit  absolute COG1DBR.1;
  COG1DBR_G1DBR0           : bit  absolute COG1DBR.0;
  COG1DBF                  : byte absolute $0696;
  COG1DBF_G1DBF5           : bit  absolute COG1DBF.5;
  COG1DBF_G1DBF4           : bit  absolute COG1DBF.4;
  COG1DBF_G1DBF3           : bit  absolute COG1DBF.3;
  COG1DBF_G1DBF2           : bit  absolute COG1DBF.2;
  COG1DBF_G1DBF1           : bit  absolute COG1DBF.1;
  COG1DBF_G1DBF0           : bit  absolute COG1DBF.0;
  COG1CON0                 : byte absolute $0697;
  COG1CON0_G1EN            : bit  absolute COG1CON0.7;
  COG1CON0_G1LD            : bit  absolute COG1CON0.6;
  COG1CON0_G1CS1           : bit  absolute COG1CON0.4;
  COG1CON0_G1CS0           : bit  absolute COG1CON0.3;
  COG1CON0_G1MD2           : bit  absolute COG1CON0.2;
  COG1CON0_G1MD1           : bit  absolute COG1CON0.1;
  COG1CON0_G1MD0           : bit  absolute COG1CON0.0;
  COG1CON1                 : byte absolute $0698;
  COG1CON1_G1RDBS          : bit  absolute COG1CON1.7;
  COG1CON1_G1FDBS          : bit  absolute COG1CON1.6;
  COG1CON1_G1POLD          : bit  absolute COG1CON1.3;
  COG1CON1_G1POLC          : bit  absolute COG1CON1.2;
  COG1CON1_G1POLB          : bit  absolute COG1CON1.1;
  COG1CON1_G1POLA          : bit  absolute COG1CON1.0;
  COG1RIS                  : byte absolute $0699;
  COG1RIS_G1RIS7           : bit  absolute COG1RIS.7;
  COG1RIS_G1RIS6           : bit  absolute COG1RIS.6;
  COG1RIS_G1RIS5           : bit  absolute COG1RIS.5;
  COG1RIS_G1RIS4           : bit  absolute COG1RIS.4;
  COG1RIS_G1RIS3           : bit  absolute COG1RIS.3;
  COG1RIS_G1RIS2           : bit  absolute COG1RIS.2;
  COG1RIS_G1RIS1           : bit  absolute COG1RIS.1;
  COG1RIS_G1RIS0           : bit  absolute COG1RIS.0;
  COG1RSIM                 : byte absolute $069A;
  COG1RSIM_G1RSIM7         : bit  absolute COG1RSIM.7;
  COG1RSIM_G1RSIM6         : bit  absolute COG1RSIM.6;
  COG1RSIM_G1RSIM5         : bit  absolute COG1RSIM.5;
  COG1RSIM_G1RSIM4         : bit  absolute COG1RSIM.4;
  COG1RSIM_G1RSIM3         : bit  absolute COG1RSIM.3;
  COG1RSIM_G1RSIM2         : bit  absolute COG1RSIM.2;
  COG1RSIM_G1RSIM1         : bit  absolute COG1RSIM.1;
  COG1RSIM_G1RSIM0         : bit  absolute COG1RSIM.0;
  COG1FIS                  : byte absolute $069B;
  COG1FIS_G1FIS7           : bit  absolute COG1FIS.7;
  COG1FIS_G1FIS6           : bit  absolute COG1FIS.6;
  COG1FIS_G1FIS5           : bit  absolute COG1FIS.5;
  COG1FIS_G1FIS4           : bit  absolute COG1FIS.4;
  COG1FIS_G1FIS3           : bit  absolute COG1FIS.3;
  COG1FIS_G1FIS2           : bit  absolute COG1FIS.2;
  COG1FIS_G1FIS1           : bit  absolute COG1FIS.1;
  COG1FIS_G1FIS0           : bit  absolute COG1FIS.0;
  COG1FSIM                 : byte absolute $069C;
  COG1FSIM_G1FSIM7         : bit  absolute COG1FSIM.7;
  COG1FSIM_G1FSIM6         : bit  absolute COG1FSIM.6;
  COG1FSIM_G1FSIM5         : bit  absolute COG1FSIM.5;
  COG1FSIM_G1FSIM4         : bit  absolute COG1FSIM.4;
  COG1FSIM_G1FSIM3         : bit  absolute COG1FSIM.3;
  COG1FSIM_G1FSIM2         : bit  absolute COG1FSIM.2;
  COG1FSIM_G1FSIM1         : bit  absolute COG1FSIM.1;
  COG1FSIM_G1FSIM0         : bit  absolute COG1FSIM.0;
  COG1ASD0                 : byte absolute $069D;
  COG1ASD0_G1ASE           : bit  absolute COG1ASD0.7;
  COG1ASD0_G1ARSEN         : bit  absolute COG1ASD0.6;
  COG1ASD0_G1ASDBD1        : bit  absolute COG1ASD0.5;
  COG1ASD0_G1ASDBD0        : bit  absolute COG1ASD0.4;
  COG1ASD0_G1ASDAC1        : bit  absolute COG1ASD0.3;
  COG1ASD0_G1ASDAC0        : bit  absolute COG1ASD0.2;
  COG1ASD1                 : byte absolute $069E;
  COG1ASD1_G1AS3E          : bit  absolute COG1ASD1.3;
  COG1ASD1_G1AS2E          : bit  absolute COG1ASD1.2;
  COG1ASD1_G1AS1E          : bit  absolute COG1ASD1.1;
  COG1ASD1_G1AS0E          : bit  absolute COG1ASD1.0;
  COG1STR                  : byte absolute $069F;
  COG1STR_G1SDATD          : bit  absolute COG1STR.7;
  COG1STR_G1SDATC          : bit  absolute COG1STR.6;
  COG1STR_G1SDATB          : bit  absolute COG1STR.5;
  COG1STR_G1SDATA          : bit  absolute COG1STR.4;
  COG1STR_G1STRD           : bit  absolute COG1STR.3;
  COG1STR_G1STRC           : bit  absolute COG1STR.2;
  COG1STR_G1STRB           : bit  absolute COG1STR.1;
  COG1STR_G1STRA           : bit  absolute COG1STR.0;
  PPSLOCK                  : byte absolute $0E0F;
  PPSLOCK_PPSLOCKED        : bit  absolute PPSLOCK.0;
  INTPPS                   : byte absolute $0E10;
  INTPPS_INTPPS4           : bit  absolute INTPPS.4;
  INTPPS_INTPPS3           : bit  absolute INTPPS.3;
  INTPPS_INTPPS2           : bit  absolute INTPPS.2;
  INTPPS_INTPPS1           : bit  absolute INTPPS.1;
  INTPPS_INTPPS0           : bit  absolute INTPPS.0;
  T0CKIPPS                 : byte absolute $0E11;
  T0CKIPPS_T0CKIPPS4       : bit  absolute T0CKIPPS.4;
  T0CKIPPS_T0CKIPPS3       : bit  absolute T0CKIPPS.3;
  T0CKIPPS_T0CKIPPS2       : bit  absolute T0CKIPPS.2;
  T0CKIPPS_T0CKIPPS1       : bit  absolute T0CKIPPS.1;
  T0CKIPPS_T0CKIPPS0       : bit  absolute T0CKIPPS.0;
  T1CKIPPS                 : byte absolute $0E12;
  T1CKIPPS_T1CKIPPS4       : bit  absolute T1CKIPPS.4;
  T1CKIPPS_T1CKIPPS3       : bit  absolute T1CKIPPS.3;
  T1CKIPPS_T1CKIPPS2       : bit  absolute T1CKIPPS.2;
  T1CKIPPS_T1CKIPPS1       : bit  absolute T1CKIPPS.1;
  T1CKIPPS_T1CKIPPS0       : bit  absolute T1CKIPPS.0;
  T1GPPS                   : byte absolute $0E13;
  T1GPPS_T1GPPS4           : bit  absolute T1GPPS.4;
  T1GPPS_T1GPPS3           : bit  absolute T1GPPS.3;
  T1GPPS_T1GPPS2           : bit  absolute T1GPPS.2;
  T1GPPS_T1GPPS1           : bit  absolute T1GPPS.1;
  T1GPPS_T1GPPS0           : bit  absolute T1GPPS.0;
  CCP1PPS                  : byte absolute $0E14;
  CCP1PPS_CCP1PPS4         : bit  absolute CCP1PPS.4;
  CCP1PPS_CCP1PPS3         : bit  absolute CCP1PPS.3;
  CCP1PPS_CCP1PPS2         : bit  absolute CCP1PPS.2;
  CCP1PPS_CCP1PPS1         : bit  absolute CCP1PPS.1;
  CCP1PPS_CCP1PPS0         : bit  absolute CCP1PPS.0;
  CCP2PPS                  : byte absolute $0E15;
  CCP2PPS_CCP2PPS4         : bit  absolute CCP2PPS.4;
  CCP2PPS_CCP2PPS3         : bit  absolute CCP2PPS.3;
  CCP2PPS_CCP2PPS2         : bit  absolute CCP2PPS.2;
  CCP2PPS_CCP2PPS1         : bit  absolute CCP2PPS.1;
  CCP2PPS_CCP2PPS0         : bit  absolute CCP2PPS.0;
  COGINPPS                 : byte absolute $0E17;
  COGINPPS_COGINPPS4       : bit  absolute COGINPPS.4;
  COGINPPS_COGINPPS3       : bit  absolute COGINPPS.3;
  COGINPPS_COGINPPS2       : bit  absolute COGINPPS.2;
  COGINPPS_COGINPPS1       : bit  absolute COGINPPS.1;
  COGINPPS_COGINPPS0       : bit  absolute COGINPPS.0;
  SSPCLKPPS                : byte absolute $0E20;
  SSPCLKPPS_SSPCLKPPS4     : bit  absolute SSPCLKPPS.4;
  SSPCLKPPS_SSPCLKPPS3     : bit  absolute SSPCLKPPS.3;
  SSPCLKPPS_SSPCLKPPS2     : bit  absolute SSPCLKPPS.2;
  SSPCLKPPS_SSPCLKPPS1     : bit  absolute SSPCLKPPS.1;
  SSPCLKPPS_SSPCLKPPS0     : bit  absolute SSPCLKPPS.0;
  SSPDATPPS                : byte absolute $0E21;
  SSPDATPPS_SSPDATPPS4     : bit  absolute SSPDATPPS.4;
  SSPDATPPS_SSPDATPPS3     : bit  absolute SSPDATPPS.3;
  SSPDATPPS_SSPDATPPS2     : bit  absolute SSPDATPPS.2;
  SSPDATPPS_SSPDATPPS1     : bit  absolute SSPDATPPS.1;
  SSPDATPPS_SSPDATPPS0     : bit  absolute SSPDATPPS.0;
  SSPSSPPS                 : byte absolute $0E22;
  SSPSSPPS_SSPSSPPS4       : bit  absolute SSPSSPPS.4;
  SSPSSPPS_SSPSSPPS3       : bit  absolute SSPSSPPS.3;
  SSPSSPPS_SSPSSPPS2       : bit  absolute SSPSSPPS.2;
  SSPSSPPS_SSPSSPPS1       : bit  absolute SSPSSPPS.1;
  SSPSSPPS_SSPSSPPS0       : bit  absolute SSPSSPPS.0;
  RXPPS                    : byte absolute $0E24;
  RXPPS_RXPPS4             : bit  absolute RXPPS.4;
  RXPPS_RXPPS3             : bit  absolute RXPPS.3;
  RXPPS_RXPPS2             : bit  absolute RXPPS.2;
  RXPPS_RXPPS1             : bit  absolute RXPPS.1;
  RXPPS_RXPPS0             : bit  absolute RXPPS.0;
  CKPPS                    : byte absolute $0E25;
  CKPPS_CKPPS4             : bit  absolute CKPPS.4;
  CKPPS_CKPPS3             : bit  absolute CKPPS.3;
  CKPPS_CKPPS2             : bit  absolute CKPPS.2;
  CKPPS_CKPPS1             : bit  absolute CKPPS.1;
  CKPPS_CKPPS0             : bit  absolute CKPPS.0;
  CLCIN0PPS                : byte absolute $0E28;
  CLCIN0PPS_CLCIN0PPS4     : bit  absolute CLCIN0PPS.4;
  CLCIN0PPS_CLCIN0PPS3     : bit  absolute CLCIN0PPS.3;
  CLCIN0PPS_CLCIN0PPS2     : bit  absolute CLCIN0PPS.2;
  CLCIN0PPS_CLCIN0PPS1     : bit  absolute CLCIN0PPS.1;
  CLCIN0PPS_CLCIN0PPS0     : bit  absolute CLCIN0PPS.0;
  CLCIN1PPS                : byte absolute $0E29;
  CLCIN1PPS_CLCIN1PPS4     : bit  absolute CLCIN1PPS.4;
  CLCIN1PPS_CLCIN1PPS3     : bit  absolute CLCIN1PPS.3;
  CLCIN1PPS_CLCIN1PPS2     : bit  absolute CLCIN1PPS.2;
  CLCIN1PPS_CLCIN1PPS1     : bit  absolute CLCIN1PPS.1;
  CLCIN1PPS_CLCIN1PPS0     : bit  absolute CLCIN1PPS.0;
  CLCIN2PPS                : byte absolute $0E2A;
  CLCIN2PPS_CLCIN2PPS4     : bit  absolute CLCIN2PPS.4;
  CLCIN2PPS_CLCIN2PPS3     : bit  absolute CLCIN2PPS.3;
  CLCIN2PPS_CLCIN2PPS2     : bit  absolute CLCIN2PPS.2;
  CLCIN2PPS_CLCIN2PPS1     : bit  absolute CLCIN2PPS.1;
  CLCIN2PPS_CLCIN2PPS0     : bit  absolute CLCIN2PPS.0;
  CLCIN3PPS                : byte absolute $0E2B;
  CLCIN3PPS_CLCIN3PPS4     : bit  absolute CLCIN3PPS.4;
  CLCIN3PPS_CLCIN3PPS3     : bit  absolute CLCIN3PPS.3;
  CLCIN3PPS_CLCIN3PPS2     : bit  absolute CLCIN3PPS.2;
  CLCIN3PPS_CLCIN3PPS1     : bit  absolute CLCIN3PPS.1;
  CLCIN3PPS_CLCIN3PPS0     : bit  absolute CLCIN3PPS.0;
  RA0PPS                   : byte absolute $0E90;
  RA0PPS_RA0PPS4           : bit  absolute RA0PPS.4;
  RA0PPS_RA0PPS3           : bit  absolute RA0PPS.3;
  RA0PPS_RA0PPS2           : bit  absolute RA0PPS.2;
  RA0PPS_RA0PPS1           : bit  absolute RA0PPS.1;
  RA0PPS_RA0PPS0           : bit  absolute RA0PPS.0;
  RA1PPS                   : byte absolute $0E91;
  RA1PPS_RA1PPS4           : bit  absolute RA1PPS.4;
  RA1PPS_RA1PPS3           : bit  absolute RA1PPS.3;
  RA1PPS_RA1PPS2           : bit  absolute RA1PPS.2;
  RA1PPS_RA1PPS1           : bit  absolute RA1PPS.1;
  RA1PPS_RA1PPS0           : bit  absolute RA1PPS.0;
  RA2PPS                   : byte absolute $0E92;
  RA2PPS_RA2PPS4           : bit  absolute RA2PPS.4;
  RA2PPS_RA2PPS3           : bit  absolute RA2PPS.3;
  RA2PPS_RA2PPS2           : bit  absolute RA2PPS.2;
  RA2PPS_RA2PPS1           : bit  absolute RA2PPS.1;
  RA2PPS_RA2PPS0           : bit  absolute RA2PPS.0;
  RA3PPS                   : byte absolute $0E93;
  RA3PPS_RA3PPS4           : bit  absolute RA3PPS.4;
  RA3PPS_RA3PPS3           : bit  absolute RA3PPS.3;
  RA3PPS_RA3PPS2           : bit  absolute RA3PPS.2;
  RA3PPS_RA3PPS1           : bit  absolute RA3PPS.1;
  RA3PPS_RA3PPS0           : bit  absolute RA3PPS.0;
  RA4PPS                   : byte absolute $0E94;
  RA4PPS_RA4PPS4           : bit  absolute RA4PPS.4;
  RA4PPS_RA4PPS3           : bit  absolute RA4PPS.3;
  RA4PPS_RA4PPS2           : bit  absolute RA4PPS.2;
  RA4PPS_RA4PPS1           : bit  absolute RA4PPS.1;
  RA4PPS_RA4PPS0           : bit  absolute RA4PPS.0;
  RA5PPS                   : byte absolute $0E95;
  RA5PPS_RA5PPS4           : bit  absolute RA5PPS.4;
  RA5PPS_RA5PPS3           : bit  absolute RA5PPS.3;
  RA5PPS_RA5PPS2           : bit  absolute RA5PPS.2;
  RA5PPS_RA5PPS1           : bit  absolute RA5PPS.1;
  RA5PPS_RA5PPS0           : bit  absolute RA5PPS.0;
  RA6PPS                   : byte absolute $0E96;
  RA6PPS_RA6PPS4           : bit  absolute RA6PPS.4;
  RA6PPS_RA6PPS3           : bit  absolute RA6PPS.3;
  RA6PPS_RA6PPS2           : bit  absolute RA6PPS.2;
  RA6PPS_RA6PPS1           : bit  absolute RA6PPS.1;
  RA6PPS_RA6PPS0           : bit  absolute RA6PPS.0;
  RA7PPS                   : byte absolute $0E97;
  RA7PPS_RA7PPS4           : bit  absolute RA7PPS.4;
  RA7PPS_RA7PPS3           : bit  absolute RA7PPS.3;
  RA7PPS_RA7PPS2           : bit  absolute RA7PPS.2;
  RA7PPS_RA7PPS1           : bit  absolute RA7PPS.1;
  RA7PPS_RA7PPS0           : bit  absolute RA7PPS.0;
  RB0PPS                   : byte absolute $0E98;
  RB0PPS_RB0PPS4           : bit  absolute RB0PPS.4;
  RB0PPS_RB0PPS3           : bit  absolute RB0PPS.3;
  RB0PPS_RB0PPS2           : bit  absolute RB0PPS.2;
  RB0PPS_RB0PPS1           : bit  absolute RB0PPS.1;
  RB0PPS_RB0PPS0           : bit  absolute RB0PPS.0;
  RB1PPS                   : byte absolute $0E99;
  RB1PPS_RB1PPS4           : bit  absolute RB1PPS.4;
  RB1PPS_RB1PPS3           : bit  absolute RB1PPS.3;
  RB1PPS_RB1PPS2           : bit  absolute RB1PPS.2;
  RB1PPS_RB1PPS1           : bit  absolute RB1PPS.1;
  RB1PPS_RB1PPS0           : bit  absolute RB1PPS.0;
  RB2PPS                   : byte absolute $0E9A;
  RB2PPS_RB2PPS4           : bit  absolute RB2PPS.4;
  RB2PPS_RB2PPS3           : bit  absolute RB2PPS.3;
  RB2PPS_RB2PPS2           : bit  absolute RB2PPS.2;
  RB2PPS_RB2PPS1           : bit  absolute RB2PPS.1;
  RB2PPS_RB2PPS0           : bit  absolute RB2PPS.0;
  RB3PPS                   : byte absolute $0E9B;
  RB3PPS_RB3PPS4           : bit  absolute RB3PPS.4;
  RB3PPS_RB3PPS3           : bit  absolute RB3PPS.3;
  RB3PPS_RB3PPS2           : bit  absolute RB3PPS.2;
  RB3PPS_RB3PPS1           : bit  absolute RB3PPS.1;
  RB3PPS_RB3PPS0           : bit  absolute RB3PPS.0;
  RB4PPS                   : byte absolute $0E9C;
  RB4PPS_RB4PPS4           : bit  absolute RB4PPS.4;
  RB4PPS_RB4PPS3           : bit  absolute RB4PPS.3;
  RB4PPS_RB4PPS2           : bit  absolute RB4PPS.2;
  RB4PPS_RB4PPS1           : bit  absolute RB4PPS.1;
  RB4PPS_RB4PPS0           : bit  absolute RB4PPS.0;
  RB5PPS                   : byte absolute $0E9D;
  RB5PPS_RB5PPS4           : bit  absolute RB5PPS.4;
  RB5PPS_RB5PPS3           : bit  absolute RB5PPS.3;
  RB5PPS_RB5PPS2           : bit  absolute RB5PPS.2;
  RB5PPS_RB5PPS1           : bit  absolute RB5PPS.1;
  RB5PPS_RB5PPS0           : bit  absolute RB5PPS.0;
  RB6PPS                   : byte absolute $0E9E;
  RB6PPS_RB6PPS4           : bit  absolute RB6PPS.4;
  RB6PPS_RB6PPS3           : bit  absolute RB6PPS.3;
  RB6PPS_RB6PPS2           : bit  absolute RB6PPS.2;
  RB6PPS_RB6PPS1           : bit  absolute RB6PPS.1;
  RB6PPS_RB6PPS0           : bit  absolute RB6PPS.0;
  RB7PPS                   : byte absolute $0E9F;
  RB7PPS_RB7PPS4           : bit  absolute RB7PPS.4;
  RB7PPS_RB7PPS3           : bit  absolute RB7PPS.3;
  RB7PPS_RB7PPS2           : bit  absolute RB7PPS.2;
  RB7PPS_RB7PPS1           : bit  absolute RB7PPS.1;
  RB7PPS_RB7PPS0           : bit  absolute RB7PPS.0;
  RC0PPS                   : byte absolute $0EA0;
  RC0PPS_RC0PPS4           : bit  absolute RC0PPS.4;
  RC0PPS_RC0PPS3           : bit  absolute RC0PPS.3;
  RC0PPS_RC0PPS2           : bit  absolute RC0PPS.2;
  RC0PPS_RC0PPS1           : bit  absolute RC0PPS.1;
  RC0PPS_RC0PPS0           : bit  absolute RC0PPS.0;
  RC1PPS                   : byte absolute $0EA1;
  RC1PPS_RC1PPS4           : bit  absolute RC1PPS.4;
  RC1PPS_RC1PPS3           : bit  absolute RC1PPS.3;
  RC1PPS_RC1PPS2           : bit  absolute RC1PPS.2;
  RC1PPS_RC1PPS1           : bit  absolute RC1PPS.1;
  RC1PPS_RC1PPS0           : bit  absolute RC1PPS.0;
  RC2PPS                   : byte absolute $0EA2;
  RC2PPS_RC2PPS4           : bit  absolute RC2PPS.4;
  RC2PPS_RC2PPS3           : bit  absolute RC2PPS.3;
  RC2PPS_RC2PPS2           : bit  absolute RC2PPS.2;
  RC2PPS_RC2PPS1           : bit  absolute RC2PPS.1;
  RC2PPS_RC2PPS0           : bit  absolute RC2PPS.0;
  RC3PPS                   : byte absolute $0EA3;
  RC3PPS_RC3PPS4           : bit  absolute RC3PPS.4;
  RC3PPS_RC3PPS3           : bit  absolute RC3PPS.3;
  RC3PPS_RC3PPS2           : bit  absolute RC3PPS.2;
  RC3PPS_RC3PPS1           : bit  absolute RC3PPS.1;
  RC3PPS_RC3PPS0           : bit  absolute RC3PPS.0;
  RC4PPS                   : byte absolute $0EA4;
  RC4PPS_RC4PPS4           : bit  absolute RC4PPS.4;
  RC4PPS_RC4PPS3           : bit  absolute RC4PPS.3;
  RC4PPS_RC4PPS2           : bit  absolute RC4PPS.2;
  RC4PPS_RC4PPS1           : bit  absolute RC4PPS.1;
  RC4PPS_RC4PPS0           : bit  absolute RC4PPS.0;
  RC5PPS                   : byte absolute $0EA5;
  RC5PPS_RC5PPS4           : bit  absolute RC5PPS.4;
  RC5PPS_RC5PPS3           : bit  absolute RC5PPS.3;
  RC5PPS_RC5PPS2           : bit  absolute RC5PPS.2;
  RC5PPS_RC5PPS1           : bit  absolute RC5PPS.1;
  RC5PPS_RC5PPS0           : bit  absolute RC5PPS.0;
  RC6PPS                   : byte absolute $0EA6;
  RC6PPS_RC6PPS4           : bit  absolute RC6PPS.4;
  RC6PPS_RC6PPS3           : bit  absolute RC6PPS.3;
  RC6PPS_RC6PPS2           : bit  absolute RC6PPS.2;
  RC6PPS_RC6PPS1           : bit  absolute RC6PPS.1;
  RC6PPS_RC6PPS0           : bit  absolute RC6PPS.0;
  RC7PPS                   : byte absolute $0EA7;
  RC7PPS_RC7PPS4           : bit  absolute RC7PPS.4;
  RC7PPS_RC7PPS3           : bit  absolute RC7PPS.3;
  RC7PPS_RC7PPS2           : bit  absolute RC7PPS.2;
  RC7PPS_RC7PPS1           : bit  absolute RC7PPS.1;
  RC7PPS_RC7PPS0           : bit  absolute RC7PPS.0;
  RD0PPS                   : byte absolute $0EA8;
  RD0PPS_RD0PPS4           : bit  absolute RD0PPS.4;
  RD0PPS_RD0PPS3           : bit  absolute RD0PPS.3;
  RD0PPS_RD0PPS2           : bit  absolute RD0PPS.2;
  RD0PPS_RD0PPS1           : bit  absolute RD0PPS.1;
  RD0PPS_RD0PPS0           : bit  absolute RD0PPS.0;
  RD1PPS                   : byte absolute $0EA9;
  RD1PPS_RD1PPS4           : bit  absolute RD1PPS.4;
  RD1PPS_RD1PPS3           : bit  absolute RD1PPS.3;
  RD1PPS_RD1PPS2           : bit  absolute RD1PPS.2;
  RD1PPS_RD1PPS1           : bit  absolute RD1PPS.1;
  RD1PPS_RD1PPS0           : bit  absolute RD1PPS.0;
  RD2PPS                   : byte absolute $0EAA;
  RD2PPS_RD2PPS4           : bit  absolute RD2PPS.4;
  RD2PPS_RD2PPS3           : bit  absolute RD2PPS.3;
  RD2PPS_RD2PPS2           : bit  absolute RD2PPS.2;
  RD2PPS_RD2PPS1           : bit  absolute RD2PPS.1;
  RD2PPS_RD2PPS0           : bit  absolute RD2PPS.0;
  RD3PPS                   : byte absolute $0EAB;
  RD3PPS_RD3PPS4           : bit  absolute RD3PPS.4;
  RD3PPS_RD3PPS3           : bit  absolute RD3PPS.3;
  RD3PPS_RD3PPS2           : bit  absolute RD3PPS.2;
  RD3PPS_RD3PPS1           : bit  absolute RD3PPS.1;
  RD3PPS_RD3PPS0           : bit  absolute RD3PPS.0;
  RD4PPS                   : byte absolute $0EAC;
  RD4PPS_RD4PPS4           : bit  absolute RD4PPS.4;
  RD4PPS_RD4PPS3           : bit  absolute RD4PPS.3;
  RD4PPS_RD4PPS2           : bit  absolute RD4PPS.2;
  RD4PPS_RD4PPS1           : bit  absolute RD4PPS.1;
  RD4PPS_RD4PPS0           : bit  absolute RD4PPS.0;
  RD5PPS                   : byte absolute $0EAD;
  RD5PPS_RD5PPS4           : bit  absolute RD5PPS.4;
  RD5PPS_RD5PPS3           : bit  absolute RD5PPS.3;
  RD5PPS_RD5PPS2           : bit  absolute RD5PPS.2;
  RD5PPS_RD5PPS1           : bit  absolute RD5PPS.1;
  RD5PPS_RD5PPS0           : bit  absolute RD5PPS.0;
  RD6PPS                   : byte absolute $0EAE;
  RD6PPS_RD6PPS4           : bit  absolute RD6PPS.4;
  RD6PPS_RD6PPS3           : bit  absolute RD6PPS.3;
  RD6PPS_RD6PPS2           : bit  absolute RD6PPS.2;
  RD6PPS_RD6PPS1           : bit  absolute RD6PPS.1;
  RD6PPS_RD6PPS0           : bit  absolute RD6PPS.0;
  RD7PPS                   : byte absolute $0EAF;
  RD7PPS_RD7PPS4           : bit  absolute RD7PPS.4;
  RD7PPS_RD7PPS3           : bit  absolute RD7PPS.3;
  RD7PPS_RD7PPS2           : bit  absolute RD7PPS.2;
  RD7PPS_RD7PPS1           : bit  absolute RD7PPS.1;
  RD7PPS_RD7PPS0           : bit  absolute RD7PPS.0;
  RE0PPS                   : byte absolute $0EB0;
  RE0PPS_RE0PPS4           : bit  absolute RE0PPS.4;
  RE0PPS_RE0PPS3           : bit  absolute RE0PPS.3;
  RE0PPS_RE0PPS2           : bit  absolute RE0PPS.2;
  RE0PPS_RE0PPS1           : bit  absolute RE0PPS.1;
  RE0PPS_RE0PPS0           : bit  absolute RE0PPS.0;
  RE1PPS                   : byte absolute $0EB1;
  RE1PPS_RE1PPS4           : bit  absolute RE1PPS.4;
  RE1PPS_RE1PPS3           : bit  absolute RE1PPS.3;
  RE1PPS_RE1PPS2           : bit  absolute RE1PPS.2;
  RE1PPS_RE1PPS1           : bit  absolute RE1PPS.1;
  RE1PPS_RE1PPS0           : bit  absolute RE1PPS.0;
  RE2PPS                   : byte absolute $0EB2;
  RE2PPS_RE2PPS4           : bit  absolute RE2PPS.4;
  RE2PPS_RE2PPS3           : bit  absolute RE2PPS.3;
  RE2PPS_RE2PPS2           : bit  absolute RE2PPS.2;
  RE2PPS_RE2PPS1           : bit  absolute RE2PPS.1;
  RE2PPS_RE2PPS0           : bit  absolute RE2PPS.0;
  CLCDATA                  : byte absolute $0F0F;
  CLCDATA_MLC4OUT          : bit  absolute CLCDATA.3;
  CLCDATA_MLC3OUT          : bit  absolute CLCDATA.2;
  CLCDATA_MLC2OUT          : bit  absolute CLCDATA.1;
  CLCDATA_MLC1OUT          : bit  absolute CLCDATA.0;
  CLC1CON                  : byte absolute $0F10;
  CLC1CON_LC1EN            : bit  absolute CLC1CON.7;
  CLC1CON_LC1OUT           : bit  absolute CLC1CON.5;
  CLC1CON_LC1INTP          : bit  absolute CLC1CON.4;
  CLC1CON_LC1INTN          : bit  absolute CLC1CON.3;
  CLC1CON_LC1MODE2         : bit  absolute CLC1CON.2;
  CLC1CON_LC1MODE1         : bit  absolute CLC1CON.1;
  CLC1CON_LC1MODE0         : bit  absolute CLC1CON.0;
  CLC1POL                  : byte absolute $0F11;
  CLC1POL_LC1POL           : bit  absolute CLC1POL.7;
  CLC1POL_LC1G4POL         : bit  absolute CLC1POL.3;
  CLC1POL_LC1G3POL         : bit  absolute CLC1POL.2;
  CLC1POL_LC1G2POL         : bit  absolute CLC1POL.1;
  CLC1POL_LC1G1POL         : bit  absolute CLC1POL.0;
  CLC1SEL0                 : byte absolute $0F12;
  CLC1SEL0_LC1D1S4         : bit  absolute CLC1SEL0.4;
  CLC1SEL0_LC1D1S3         : bit  absolute CLC1SEL0.3;
  CLC1SEL0_LC1D1S2         : bit  absolute CLC1SEL0.2;
  CLC1SEL0_LC1D1S1         : bit  absolute CLC1SEL0.1;
  CLC1SEL0_LC1D1S0         : bit  absolute CLC1SEL0.0;
  CLC1SEL1                 : byte absolute $0F13;
  CLC1SEL1_LC1D2S4         : bit  absolute CLC1SEL1.4;
  CLC1SEL1_LC1D2S3         : bit  absolute CLC1SEL1.3;
  CLC1SEL1_LC1D2S2         : bit  absolute CLC1SEL1.2;
  CLC1SEL1_LC1D2S1         : bit  absolute CLC1SEL1.1;
  CLC1SEL1_LC1D2S0         : bit  absolute CLC1SEL1.0;
  CLC1SEL2                 : byte absolute $0F14;
  CLC1SEL2_LC1D3S4         : bit  absolute CLC1SEL2.4;
  CLC1SEL2_LC1D3S3         : bit  absolute CLC1SEL2.3;
  CLC1SEL2_LC1D3S2         : bit  absolute CLC1SEL2.2;
  CLC1SEL2_LC1D3S1         : bit  absolute CLC1SEL2.1;
  CLC1SEL2_LC1D3S0         : bit  absolute CLC1SEL2.0;
  CLC1SEL3                 : byte absolute $0F15;
  CLC1SEL3_LC1D4S4         : bit  absolute CLC1SEL3.4;
  CLC1SEL3_LC1D4S3         : bit  absolute CLC1SEL3.3;
  CLC1SEL3_LC1D4S2         : bit  absolute CLC1SEL3.2;
  CLC1SEL3_LC1D4S1         : bit  absolute CLC1SEL3.1;
  CLC1SEL3_LC1D4S0         : bit  absolute CLC1SEL3.0;
  CLC1GLS0                 : byte absolute $0F16;
  CLC1GLS0_LC1G1D4T        : bit  absolute CLC1GLS0.7;
  CLC1GLS0_LC1G1D4N        : bit  absolute CLC1GLS0.6;
  CLC1GLS0_LC1G1D3T        : bit  absolute CLC1GLS0.5;
  CLC1GLS0_LC1G1D3N        : bit  absolute CLC1GLS0.4;
  CLC1GLS0_LC1G1D2T        : bit  absolute CLC1GLS0.3;
  CLC1GLS0_LC1G1D2N        : bit  absolute CLC1GLS0.2;
  CLC1GLS0_LC1G1D1T        : bit  absolute CLC1GLS0.1;
  CLC1GLS0_LC1G1D1N        : bit  absolute CLC1GLS0.0;
  CLC1GLS1                 : byte absolute $0F17;
  CLC1GLS1_LC1G2D4T        : bit  absolute CLC1GLS1.7;
  CLC1GLS1_LC1G2D4N        : bit  absolute CLC1GLS1.6;
  CLC1GLS1_LC1G2D3T        : bit  absolute CLC1GLS1.5;
  CLC1GLS1_LC1G2D3N        : bit  absolute CLC1GLS1.4;
  CLC1GLS1_LC1G2D2T        : bit  absolute CLC1GLS1.3;
  CLC1GLS1_LC1G2D2N        : bit  absolute CLC1GLS1.2;
  CLC1GLS1_LC1G2D1T        : bit  absolute CLC1GLS1.1;
  CLC1GLS1_LC1G2D1N        : bit  absolute CLC1GLS1.0;
  CLC1GLS2                 : byte absolute $0F18;
  CLC1GLS2_LC1G3D4T        : bit  absolute CLC1GLS2.7;
  CLC1GLS2_LC1G3D4N        : bit  absolute CLC1GLS2.6;
  CLC1GLS2_LC1G3D3T        : bit  absolute CLC1GLS2.5;
  CLC1GLS2_LC1G3D3N        : bit  absolute CLC1GLS2.4;
  CLC1GLS2_LC1G3D2T        : bit  absolute CLC1GLS2.3;
  CLC1GLS2_LC1G3D2N        : bit  absolute CLC1GLS2.2;
  CLC1GLS2_LC1G3D1T        : bit  absolute CLC1GLS2.1;
  CLC1GLS2_LC1G3D1N        : bit  absolute CLC1GLS2.0;
  CLC1GLS3                 : byte absolute $0F19;
  CLC1GLS3_LC1G4D4T        : bit  absolute CLC1GLS3.7;
  CLC1GLS3_LC1G4D4N        : bit  absolute CLC1GLS3.6;
  CLC1GLS3_LC1G4D3T        : bit  absolute CLC1GLS3.5;
  CLC1GLS3_LC1G4D3N        : bit  absolute CLC1GLS3.4;
  CLC1GLS3_LC1G4D2T        : bit  absolute CLC1GLS3.3;
  CLC1GLS3_LC1G4D2N        : bit  absolute CLC1GLS3.2;
  CLC1GLS3_LC1G4D1T        : bit  absolute CLC1GLS3.1;
  CLC1GLS3_LC1G4D1N        : bit  absolute CLC1GLS3.0;
  CLC2CON                  : byte absolute $0F1A;
  CLC2CON_LC2EN            : bit  absolute CLC2CON.7;
  CLC2CON_LC2OUT           : bit  absolute CLC2CON.5;
  CLC2CON_LC2INTP          : bit  absolute CLC2CON.4;
  CLC2CON_LC2INTN          : bit  absolute CLC2CON.3;
  CLC2CON_LC2MODE2         : bit  absolute CLC2CON.2;
  CLC2CON_LC2MODE1         : bit  absolute CLC2CON.1;
  CLC2CON_LC2MODE0         : bit  absolute CLC2CON.0;
  CLC2POL                  : byte absolute $0F1B;
  CLC2POL_LC2POL           : bit  absolute CLC2POL.7;
  CLC2POL_LC2G4POL         : bit  absolute CLC2POL.3;
  CLC2POL_LC2G3POL         : bit  absolute CLC2POL.2;
  CLC2POL_LC2G2POL         : bit  absolute CLC2POL.1;
  CLC2POL_LC2G1POL         : bit  absolute CLC2POL.0;
  CLC2SEL0                 : byte absolute $0F1C;
  CLC2SEL0_LC2D1S4         : bit  absolute CLC2SEL0.4;
  CLC2SEL0_LC2D1S3         : bit  absolute CLC2SEL0.3;
  CLC2SEL0_LC2D1S2         : bit  absolute CLC2SEL0.2;
  CLC2SEL0_LC2D1S1         : bit  absolute CLC2SEL0.1;
  CLC2SEL0_LC2D1S0         : bit  absolute CLC2SEL0.0;
  CLC2SEL1                 : byte absolute $0F1D;
  CLC2SEL1_LC2D2S4         : bit  absolute CLC2SEL1.4;
  CLC2SEL1_LC2D2S3         : bit  absolute CLC2SEL1.3;
  CLC2SEL1_LC2D2S2         : bit  absolute CLC2SEL1.2;
  CLC2SEL1_LC2D2S1         : bit  absolute CLC2SEL1.1;
  CLC2SEL1_LC2D2S0         : bit  absolute CLC2SEL1.0;
  CLC2SEL2                 : byte absolute $0F1E;
  CLC2SEL2_LC2D3S4         : bit  absolute CLC2SEL2.4;
  CLC2SEL2_LC2D3S3         : bit  absolute CLC2SEL2.3;
  CLC2SEL2_LC2D3S2         : bit  absolute CLC2SEL2.2;
  CLC2SEL2_LC2D3S1         : bit  absolute CLC2SEL2.1;
  CLC2SEL2_LC2D3S0         : bit  absolute CLC2SEL2.0;
  CLC2SEL3                 : byte absolute $0F1F;
  CLC2SEL3_LC2D4S4         : bit  absolute CLC2SEL3.4;
  CLC2SEL3_LC2D4S3         : bit  absolute CLC2SEL3.3;
  CLC2SEL3_LC2D4S2         : bit  absolute CLC2SEL3.2;
  CLC2SEL3_LC2D4S1         : bit  absolute CLC2SEL3.1;
  CLC2SEL3_LC2D4S0         : bit  absolute CLC2SEL3.0;
  CLC2GLS0                 : byte absolute $0F20;
  CLC2GLS0_LC2G1D4T        : bit  absolute CLC2GLS0.7;
  CLC2GLS0_LC2G1D4N        : bit  absolute CLC2GLS0.6;
  CLC2GLS0_LC2G1D3T        : bit  absolute CLC2GLS0.5;
  CLC2GLS0_LC2G1D3N        : bit  absolute CLC2GLS0.4;
  CLC2GLS0_LC2G1D2T        : bit  absolute CLC2GLS0.3;
  CLC2GLS0_LC2G1D2N        : bit  absolute CLC2GLS0.2;
  CLC2GLS0_LC2G1D1T        : bit  absolute CLC2GLS0.1;
  CLC2GLS0_LC2G1D1N        : bit  absolute CLC2GLS0.0;
  CLC2GLS1                 : byte absolute $0F21;
  CLC2GLS1_LC2G2D4T        : bit  absolute CLC2GLS1.7;
  CLC2GLS1_LC2G2D4N        : bit  absolute CLC2GLS1.6;
  CLC2GLS1_LC2G2D3T        : bit  absolute CLC2GLS1.5;
  CLC2GLS1_LC2G2D3N        : bit  absolute CLC2GLS1.4;
  CLC2GLS1_LC2G2D2T        : bit  absolute CLC2GLS1.3;
  CLC2GLS1_LC2G2D2N        : bit  absolute CLC2GLS1.2;
  CLC2GLS1_LC2G2D1T        : bit  absolute CLC2GLS1.1;
  CLC2GLS1_LC2G2D1N        : bit  absolute CLC2GLS1.0;
  CLC2GLS2                 : byte absolute $0F22;
  CLC2GLS2_LC2G3D4T        : bit  absolute CLC2GLS2.7;
  CLC2GLS2_LC2G3D4N        : bit  absolute CLC2GLS2.6;
  CLC2GLS2_LC2G3D3T        : bit  absolute CLC2GLS2.5;
  CLC2GLS2_LC2G3D3N        : bit  absolute CLC2GLS2.4;
  CLC2GLS2_LC2G3D2T        : bit  absolute CLC2GLS2.3;
  CLC2GLS2_LC2G3D2N        : bit  absolute CLC2GLS2.2;
  CLC2GLS2_LC2G3D1T        : bit  absolute CLC2GLS2.1;
  CLC2GLS2_LC2G3D1N        : bit  absolute CLC2GLS2.0;
  CLC2GLS3                 : byte absolute $0F23;
  CLC2GLS3_LC2G4D4T        : bit  absolute CLC2GLS3.7;
  CLC2GLS3_LC2G4D4N        : bit  absolute CLC2GLS3.6;
  CLC2GLS3_LC2G4D3T        : bit  absolute CLC2GLS3.5;
  CLC2GLS3_LC2G4D3N        : bit  absolute CLC2GLS3.4;
  CLC2GLS3_LC2G4D2T        : bit  absolute CLC2GLS3.3;
  CLC2GLS3_LC2G4D2N        : bit  absolute CLC2GLS3.2;
  CLC2GLS3_LC2G4D1T        : bit  absolute CLC2GLS3.1;
  CLC2GLS3_LC2G4D1N        : bit  absolute CLC2GLS3.0;
  CLC3CON                  : byte absolute $0F24;
  CLC3CON_LC3EN            : bit  absolute CLC3CON.7;
  CLC3CON_LC3OUT           : bit  absolute CLC3CON.5;
  CLC3CON_LC3INTP          : bit  absolute CLC3CON.4;
  CLC3CON_LC3INTN          : bit  absolute CLC3CON.3;
  CLC3CON_LC3MODE2         : bit  absolute CLC3CON.2;
  CLC3CON_LC3MODE1         : bit  absolute CLC3CON.1;
  CLC3CON_LC3MODE0         : bit  absolute CLC3CON.0;
  CLC3POL                  : byte absolute $0F25;
  CLC3POL_LC3POL           : bit  absolute CLC3POL.7;
  CLC3POL_LC3G4POL         : bit  absolute CLC3POL.3;
  CLC3POL_LC3G3POL         : bit  absolute CLC3POL.2;
  CLC3POL_LC3G2POL         : bit  absolute CLC3POL.1;
  CLC3POL_LC3G1POL         : bit  absolute CLC3POL.0;
  CLC3SEL0                 : byte absolute $0F26;
  CLC3SEL0_LC3D1S4         : bit  absolute CLC3SEL0.4;
  CLC3SEL0_LC3D1S3         : bit  absolute CLC3SEL0.3;
  CLC3SEL0_LC3D1S2         : bit  absolute CLC3SEL0.2;
  CLC3SEL0_LC3D1S1         : bit  absolute CLC3SEL0.1;
  CLC3SEL0_LC3D1S0         : bit  absolute CLC3SEL0.0;
  CLC3SEL1                 : byte absolute $0F27;
  CLC3SEL1_LC3D2S4         : bit  absolute CLC3SEL1.4;
  CLC3SEL1_LC3D2S3         : bit  absolute CLC3SEL1.3;
  CLC3SEL1_LC3D2S2         : bit  absolute CLC3SEL1.2;
  CLC3SEL1_LC3D2S1         : bit  absolute CLC3SEL1.1;
  CLC3SEL1_LC3D2S0         : bit  absolute CLC3SEL1.0;
  CLC3SEL2                 : byte absolute $0F28;
  CLC3SEL2_LC3D3S4         : bit  absolute CLC3SEL2.4;
  CLC3SEL2_LC3D3S3         : bit  absolute CLC3SEL2.3;
  CLC3SEL2_LC3D3S2         : bit  absolute CLC3SEL2.2;
  CLC3SEL2_LC3D3S1         : bit  absolute CLC3SEL2.1;
  CLC3SEL2_LC3D3S0         : bit  absolute CLC3SEL2.0;
  CLC3SEL3                 : byte absolute $0F29;
  CLC3SEL3_LC3D4S4         : bit  absolute CLC3SEL3.4;
  CLC3SEL3_LC3D4S3         : bit  absolute CLC3SEL3.3;
  CLC3SEL3_LC3D4S2         : bit  absolute CLC3SEL3.2;
  CLC3SEL3_LC3D4S1         : bit  absolute CLC3SEL3.1;
  CLC3SEL3_LC3D4S0         : bit  absolute CLC3SEL3.0;
  CLC3GLS0                 : byte absolute $0F2A;
  CLC3GLS0_LC3G1D4T        : bit  absolute CLC3GLS0.7;
  CLC3GLS0_LC3G1D4N        : bit  absolute CLC3GLS0.6;
  CLC3GLS0_LC3G1D3T        : bit  absolute CLC3GLS0.5;
  CLC3GLS0_LC3G1D3N        : bit  absolute CLC3GLS0.4;
  CLC3GLS0_LC3G1D2T        : bit  absolute CLC3GLS0.3;
  CLC3GLS0_LC3G1D2N        : bit  absolute CLC3GLS0.2;
  CLC3GLS0_LC3G1D1T        : bit  absolute CLC3GLS0.1;
  CLC3GLS0_LC3G1D1N        : bit  absolute CLC3GLS0.0;
  CLC3GLS1                 : byte absolute $0F2B;
  CLC3GLS1_LC3G2D4T        : bit  absolute CLC3GLS1.7;
  CLC3GLS1_LC3G2D4N        : bit  absolute CLC3GLS1.6;
  CLC3GLS1_LC3G2D3T        : bit  absolute CLC3GLS1.5;
  CLC3GLS1_LC3G2D3N        : bit  absolute CLC3GLS1.4;
  CLC3GLS1_LC3G2D2T        : bit  absolute CLC3GLS1.3;
  CLC3GLS1_LC3G2D2N        : bit  absolute CLC3GLS1.2;
  CLC3GLS1_LC3G2D1T        : bit  absolute CLC3GLS1.1;
  CLC3GLS1_LC3G2D1N        : bit  absolute CLC3GLS1.0;
  CLC3GLS2                 : byte absolute $0F2C;
  CLC3GLS2_LC3G3D4T        : bit  absolute CLC3GLS2.7;
  CLC3GLS2_LC3G3D4N        : bit  absolute CLC3GLS2.6;
  CLC3GLS2_LC3G3D3T        : bit  absolute CLC3GLS2.5;
  CLC3GLS2_LC3G3D3N        : bit  absolute CLC3GLS2.4;
  CLC3GLS2_LC3G3D2T        : bit  absolute CLC3GLS2.3;
  CLC3GLS2_LC3G3D2N        : bit  absolute CLC3GLS2.2;
  CLC3GLS2_LC3G3D1T        : bit  absolute CLC3GLS2.1;
  CLC3GLS2_LC3G3D1N        : bit  absolute CLC3GLS2.0;
  CLC3GLS3                 : byte absolute $0F2D;
  CLC3GLS3_LC3G4D4T        : bit  absolute CLC3GLS3.7;
  CLC3GLS3_LC3G4D4N        : bit  absolute CLC3GLS3.6;
  CLC3GLS3_LC3G4D3T        : bit  absolute CLC3GLS3.5;
  CLC3GLS3_LC3G4D3N        : bit  absolute CLC3GLS3.4;
  CLC3GLS3_LC3G4D2T        : bit  absolute CLC3GLS3.3;
  CLC3GLS3_LC3G4D2N        : bit  absolute CLC3GLS3.2;
  CLC3GLS3_LC3G4D1T        : bit  absolute CLC3GLS3.1;
  CLC3GLS3_LC3G4D1N        : bit  absolute CLC3GLS3.0;
  CLC4CON                  : byte absolute $0F2E;
  CLC4CON_LC4EN            : bit  absolute CLC4CON.7;
  CLC4CON_LC4OUT           : bit  absolute CLC4CON.5;
  CLC4CON_LC4INTP          : bit  absolute CLC4CON.4;
  CLC4CON_LC4INTN          : bit  absolute CLC4CON.3;
  CLC4CON_LC4MODE2         : bit  absolute CLC4CON.2;
  CLC4CON_LC4MODE1         : bit  absolute CLC4CON.1;
  CLC4CON_LC4MODE0         : bit  absolute CLC4CON.0;
  CLC4POL                  : byte absolute $0F2F;
  CLC4POL_LC4POL           : bit  absolute CLC4POL.7;
  CLC4POL_LC4G4POL         : bit  absolute CLC4POL.3;
  CLC4POL_LC4G3POL         : bit  absolute CLC4POL.2;
  CLC4POL_LC4G2POL         : bit  absolute CLC4POL.1;
  CLC4POL_LC4G1POL         : bit  absolute CLC4POL.0;
  CLC4SEL0                 : byte absolute $0F30;
  CLC4SEL0_LC4D1S4         : bit  absolute CLC4SEL0.4;
  CLC4SEL0_LC4D1S3         : bit  absolute CLC4SEL0.3;
  CLC4SEL0_LC4D1S2         : bit  absolute CLC4SEL0.2;
  CLC4SEL0_LC4D1S1         : bit  absolute CLC4SEL0.1;
  CLC4SEL0_LC4D1S0         : bit  absolute CLC4SEL0.0;
  CLC4SEL1                 : byte absolute $0F31;
  CLC4SEL1_LC4D2S4         : bit  absolute CLC4SEL1.4;
  CLC4SEL1_LC4D2S3         : bit  absolute CLC4SEL1.3;
  CLC4SEL1_LC4D2S2         : bit  absolute CLC4SEL1.2;
  CLC4SEL1_LC4D2S1         : bit  absolute CLC4SEL1.1;
  CLC4SEL1_LC4D2S0         : bit  absolute CLC4SEL1.0;
  CLC4SEL2                 : byte absolute $0F32;
  CLC4SEL2_LC4D3S4         : bit  absolute CLC4SEL2.4;
  CLC4SEL2_LC4D3S3         : bit  absolute CLC4SEL2.3;
  CLC4SEL2_LC4D3S2         : bit  absolute CLC4SEL2.2;
  CLC4SEL2_LC4D3S1         : bit  absolute CLC4SEL2.1;
  CLC4SEL2_LC4D3S0         : bit  absolute CLC4SEL2.0;
  CLC4SEL3                 : byte absolute $0F33;
  CLC4SEL3_LC4D4S4         : bit  absolute CLC4SEL3.4;
  CLC4SEL3_LC4D4S3         : bit  absolute CLC4SEL3.3;
  CLC4SEL3_LC4D4S2         : bit  absolute CLC4SEL3.2;
  CLC4SEL3_LC4D4S1         : bit  absolute CLC4SEL3.1;
  CLC4SEL3_LC4D4S0         : bit  absolute CLC4SEL3.0;
  CLC4GLS0                 : byte absolute $0F34;
  CLC4GLS0_LC4G1D4T        : bit  absolute CLC4GLS0.7;
  CLC4GLS0_LC4G1D4N        : bit  absolute CLC4GLS0.6;
  CLC4GLS0_LC4G1D3T        : bit  absolute CLC4GLS0.5;
  CLC4GLS0_LC4G1D3N        : bit  absolute CLC4GLS0.4;
  CLC4GLS0_LC4G1D2T        : bit  absolute CLC4GLS0.3;
  CLC4GLS0_LC4G1D2N        : bit  absolute CLC4GLS0.2;
  CLC4GLS0_LC4G1D1T        : bit  absolute CLC4GLS0.1;
  CLC4GLS0_LC4G1D1N        : bit  absolute CLC4GLS0.0;
  CLC4GLS1                 : byte absolute $0F35;
  CLC4GLS1_LC4G2D4T        : bit  absolute CLC4GLS1.7;
  CLC4GLS1_LC4G2D4N        : bit  absolute CLC4GLS1.6;
  CLC4GLS1_LC4G2D3T        : bit  absolute CLC4GLS1.5;
  CLC4GLS1_LC4G2D3N        : bit  absolute CLC4GLS1.4;
  CLC4GLS1_LC4G2D2T        : bit  absolute CLC4GLS1.3;
  CLC4GLS1_LC4G2D2N        : bit  absolute CLC4GLS1.2;
  CLC4GLS1_LC4G2D1T        : bit  absolute CLC4GLS1.1;
  CLC4GLS1_LC4G2D1N        : bit  absolute CLC4GLS1.0;
  CLC4GLS2                 : byte absolute $0F36;
  CLC4GLS2_LC4G3D4T        : bit  absolute CLC4GLS2.7;
  CLC4GLS2_LC4G3D4N        : bit  absolute CLC4GLS2.6;
  CLC4GLS2_LC4G3D3T        : bit  absolute CLC4GLS2.5;
  CLC4GLS2_LC4G3D3N        : bit  absolute CLC4GLS2.4;
  CLC4GLS2_LC4G3D2T        : bit  absolute CLC4GLS2.3;
  CLC4GLS2_LC4G3D2N        : bit  absolute CLC4GLS2.2;
  CLC4GLS2_LC4G3D1T        : bit  absolute CLC4GLS2.1;
  CLC4GLS2_LC4G3D1N        : bit  absolute CLC4GLS2.0;
  CLC4GLS3                 : byte absolute $0F37;
  CLC4GLS3_LC4G4D4T        : bit  absolute CLC4GLS3.7;
  CLC4GLS3_LC4G4D4N        : bit  absolute CLC4GLS3.6;
  CLC4GLS3_LC4G4D3T        : bit  absolute CLC4GLS3.5;
  CLC4GLS3_LC4G4D3N        : bit  absolute CLC4GLS3.4;
  CLC4GLS3_LC4G4D2T        : bit  absolute CLC4GLS3.3;
  CLC4GLS3_LC4G4D2N        : bit  absolute CLC4GLS3.2;
  CLC4GLS3_LC4G4D1T        : bit  absolute CLC4GLS3.1;
  CLC4GLS3_LC4G4D1N        : bit  absolute CLC4GLS3.0;
  STATUS_SHAD              : byte absolute $0FE4;
  STATUS_SHAD_Z_SHAD       : bit  absolute STATUS_SHAD.2;
  STATUS_SHAD_DC_SHAD      : bit  absolute STATUS_SHAD.1;
  STATUS_SHAD_C_SHAD       : bit  absolute STATUS_SHAD.0;
  WREG_SHAD                : byte absolute $0FE5;
  BSR_SHAD                 : byte absolute $0FE6;
  BSR_SHAD_BSR_SHAD4       : bit  absolute BSR_SHAD.4;
  BSR_SHAD_BSR_SHAD3       : bit  absolute BSR_SHAD.3;
  BSR_SHAD_BSR_SHAD2       : bit  absolute BSR_SHAD.2;
  BSR_SHAD_BSR_SHAD1       : bit  absolute BSR_SHAD.1;
  BSR_SHAD_BSR_SHAD0       : bit  absolute BSR_SHAD.0;
  PCLATH_SHAD              : byte absolute $0FE7;
  PCLATH_SHAD_PCLATH_SHAD6 : bit  absolute PCLATH_SHAD.6;
  PCLATH_SHAD_PCLATH_SHAD5 : bit  absolute PCLATH_SHAD.5;
  PCLATH_SHAD_PCLATH_SHAD4 : bit  absolute PCLATH_SHAD.4;
  PCLATH_SHAD_PCLATH_SHAD3 : bit  absolute PCLATH_SHAD.3;
  PCLATH_SHAD_PCLATH_SHAD2 : bit  absolute PCLATH_SHAD.2;
  PCLATH_SHAD_PCLATH_SHAD1 : bit  absolute PCLATH_SHAD.1;
  PCLATH_SHAD_PCLATH_SHAD0 : bit  absolute PCLATH_SHAD.0;
  FSR0L_SHAD               : byte absolute $0FE8;
  FSR0H_SHAD               : byte absolute $0FE9;
  FSR1L_SHAD               : byte absolute $0FEA;
  FSR1H_SHAD               : byte absolute $0FEB;
  STKPTR                   : byte absolute $0FED;
  STKPTR_STKPTR4           : bit  absolute STKPTR.4;
  STKPTR_STKPTR3           : bit  absolute STKPTR.3;
  STKPTR_STKPTR2           : bit  absolute STKPTR.2;
  STKPTR_STKPTR1           : bit  absolute STKPTR.1;
  STKPTR_STKPTR0           : bit  absolute STKPTR.0;
  TOSL                     : byte absolute $0FEE;
  TOSH                     : byte absolute $0FEF;
  TOSH_TOSH6               : bit  absolute TOSH.6;
  TOSH_TOSH5               : bit  absolute TOSH.5;
  TOSH_TOSH4               : bit  absolute TOSH.4;
  TOSH_TOSH3               : bit  absolute TOSH.3;
  TOSH_TOSH2               : bit  absolute TOSH.2;
  TOSH_TOSH1               : bit  absolute TOSH.1;
  TOSH_TOSH0               : bit  absolute TOSH.0;


  // -- Define RAM state values --

  {$CLEAR_STATE_RAM}

  {$SET_STATE_RAM '000-00B:SFR:ALLMAPPED'}  // Banks 0-31 : INDF0, INDF1, PCL, STATUS, FSR0L, FSR0H, FSR1L, FSR1H, BSR, WREG, PCLATH, INTCON
  {$SET_STATE_RAM '00C-013:SFR'}            // Bank 0 : PORTA, PORTB, PORTC, PORTD, PORTE, PIR1, PIR2, PIR3
  {$SET_STATE_RAM '015-01C:SFR'}            // Bank 0 : TMR0, TMR1L, TMR1H, T1CON, T1GCON, TMR2, PR2, T2CON
  {$SET_STATE_RAM '020-06F:GPR'}           
  {$SET_STATE_RAM '070-07F:GPR:ALLMAPPED'} 
  {$SET_STATE_RAM '08C-093:SFR'}            // Bank 1 : TRISA, TRISB, TRISC, TRISD, TRISE, PIE1, PIE2, PIE3
  {$SET_STATE_RAM '095-09F:SFR'}            // Bank 1 : OPTION_REG, PCON, WDTCON, OSCTUNE, OSCCON, OSCSTAT, ADRESL, ADRESH, ADCON0, ADCON1, ADCON2
  {$SET_STATE_RAM '0A0-0EF:GPR'}           
  {$SET_STATE_RAM '10C-11C:SFR'}            // Bank 2 : LATA, LATB, LATC, LATD, LATE, CM1CON0, CM1CON1, CM2CON0, CM2CON1, CMOUT, BORCON, FVRCON, DAC1CON0, DAC1CON1, DAC2CON0, DAC2REF, ZCD1CON
  {$SET_STATE_RAM '120-16F:GPR'}           
  {$SET_STATE_RAM '18C-197:SFR'}            // Bank 3 : ANSELA, ANSELB, ANSELC, ANSELD, ANSELE, PMADRL, PMADRH, PMDATL, PMDATH, PMCON1, PMCON2, VREGCON
  {$SET_STATE_RAM '199-19F:SFR'}            // Bank 3 : RC1REG, TX1REG, SP1BRGL, SP1BRGH, RC1STA, TX1STA, BAUD1CON
  {$SET_STATE_RAM '1A0-1EF:GPR'}           
  {$SET_STATE_RAM '20C-217:SFR'}            // Bank 4 : WPUA, WPUB, WPUC, WPUD, WPUE, SSP1BUF, SSP1ADD, SSP1MSK, SSP1STAT, SSP1CON1, SSP1CON2, SSP1CON3
  {$SET_STATE_RAM '220-26F:GPR'}           
  {$SET_STATE_RAM '28C-293:SFR'}            // Bank 5 : ODCONA, ODCONB, ODCONC, ODCOND, ODCONE, CCPR1L, CCPR1H, CCP1CON
  {$SET_STATE_RAM '298-29A:SFR'}            // Bank 5 : CCPR2L, CCPR2H, CCP2CON
  {$SET_STATE_RAM '29E-29E:SFR'}            // Bank 5 : CCPTMRS
  {$SET_STATE_RAM '2A0-2EF:GPR'}           
  {$SET_STATE_RAM '30C-310:SFR'}            // Bank 6 : SLRCONA, SLRCONB, SLRCONC, SLRCOND, SLRCONE
  {$SET_STATE_RAM '320-36F:GPR'}           
  {$SET_STATE_RAM '38C-399:SFR'}            // Bank 7 : INLVLA, INLVLB, INLVLC, INLVLD, INLVLE, IOCAP, IOCAN, IOCAF, IOCBP, IOCBN, IOCBF, IOCCP, IOCCN, IOCCF
  {$SET_STATE_RAM '39D-39F:SFR'}            // Bank 7 : IOCEP, IOCEN, IOCEF
  {$SET_STATE_RAM '3A0-3EF:GPR'}           
  {$SET_STATE_RAM '415-417:SFR'}            // Bank 8 : TMR4, PR4, T4CON
  {$SET_STATE_RAM '41C-41E:SFR'}            // Bank 8 : TMR6, PR6, T6CON
  {$SET_STATE_RAM '420-46F:GPR'}           
  {$SET_STATE_RAM '498-49F:SFR'}            // Bank 9 : NCO1ACCL, NCO1ACCH, NCO1ACCU, NCO1INCL, NCO1INCH, NCO1INCU, NCO1CON, NCO1CLK
  {$SET_STATE_RAM '4A0-4EF:GPR'}           
  {$SET_STATE_RAM '511-511:SFR'}            // Bank 10 : OPA1CON
  {$SET_STATE_RAM '515-515:SFR'}            // Bank 10 : OPA2CON
  {$SET_STATE_RAM '520-56F:GPR'}           
  {$SET_STATE_RAM '5A0-5EF:GPR'}           
  {$SET_STATE_RAM '617-61C:SFR'}            // Bank 12 : PWM3DCL, PWM3DCH, PWM3CON, PWM4DCL, PWM4DCH, PWM4CON
  {$SET_STATE_RAM '620-66F:GPR'}           
  {$SET_STATE_RAM '691-69F:SFR'}            // Bank 13 : COG1PHR, COG1PHF, COG1BLKR, COG1BLKF, COG1DBR, COG1DBF, COG1CON0, COG1CON1, COG1RIS, COG1RSIM, COG1FIS, COG1FSIM, COG1ASD0, COG1ASD1, COG1STR
  {$SET_STATE_RAM '6A0-6EF:GPR'}           
  {$SET_STATE_RAM '720-76F:GPR'}           
  {$SET_STATE_RAM '7A0-7EF:GPR'}           
  {$SET_STATE_RAM '820-86F:GPR'}           
  {$SET_STATE_RAM '8A0-8EF:GPR'}           
  {$SET_STATE_RAM '920-96F:GPR'}           
  {$SET_STATE_RAM '9A0-9EF:GPR'}           
  {$SET_STATE_RAM 'A20-A6F:GPR'}           
  {$SET_STATE_RAM 'AA0-AEF:GPR'}           
  {$SET_STATE_RAM 'B20-B6F:GPR'}           
  {$SET_STATE_RAM 'BA0-BEF:GPR'}           
  {$SET_STATE_RAM 'C20-C6F:GPR'}           
  {$SET_STATE_RAM 'CA0-CBF:GPR'}           
  {$SET_STATE_RAM 'E0F-E15:SFR'}            // Bank 28 : PPSLOCK, INTPPS, T0CKIPPS, T1CKIPPS, T1GPPS, CCP1PPS, CCP2PPS
  {$SET_STATE_RAM 'E17-E17:SFR'}            // Bank 28 : COGINPPS
  {$SET_STATE_RAM 'E20-E22:SFR'}            // Bank 28 : SSPCLKPPS, SSPDATPPS, SSPSSPPS
  {$SET_STATE_RAM 'E24-E25:SFR'}            // Bank 28 : RXPPS, CKPPS
  {$SET_STATE_RAM 'E28-E2B:SFR'}            // Bank 28 : CLCIN0PPS, CLCIN1PPS, CLCIN2PPS, CLCIN3PPS
  {$SET_STATE_RAM 'E90-EB2:SFR'}            // Bank 29 : RA0PPS, RA1PPS, RA2PPS, RA3PPS, RA4PPS, RA5PPS, RA6PPS, RA7PPS, RB0PPS, RB1PPS, RB2PPS, RB3PPS, RB4PPS, RB5PPS, RB6PPS, RB7PPS, RC0PPS, RC1PPS, RC2PPS, RC3PPS, RC4PPS, RC5PPS, RC6PPS, RC7PPS, RD0PPS, RD1PPS, RD2PPS, RD3PPS, RD4PPS, RD5PPS, RD6PPS, RD7PPS, RE0PPS, RE1PPS, RE2PPS
  {$SET_STATE_RAM 'F0F-F37:SFR'}            // Bank 30 : CLCDATA, CLC1CON, CLC1POL, CLC1SEL0, CLC1SEL1, CLC1SEL2, CLC1SEL3, CLC1GLS0, CLC1GLS1, CLC1GLS2, CLC1GLS3, CLC2CON, CLC2POL, CLC2SEL0, CLC2SEL1, CLC2SEL2, CLC2SEL3, CLC2GLS0, CLC2GLS1, CLC2GLS2, CLC2GLS3, CLC3CON, CLC3POL, CLC3SEL0, CLC3SEL1, CLC3SEL2, CLC3SEL3, CLC3GLS0, CLC3GLS1, CLC3GLS2, CLC3GLS3, CLC4CON, CLC4POL, CLC4SEL0, CLC4SEL1, CLC4SEL2, CLC4SEL3, CLC4GLS0, CLC4GLS1, CLC4GLS2, CLC4GLS3
  {$SET_STATE_RAM 'FE4-FEB:SFR'}            // Bank 31 : STATUS_SHAD, WREG_SHAD, BSR_SHAD, PCLATH_SHAD, FSR0L_SHAD, FSR0H_SHAD, FSR1L_SHAD, FSR1H_SHAD
  {$SET_STATE_RAM 'FED-FEF:SFR'}            // Bank 31 : STKPTR, TOSL, TOSH


  // -- Define mapped RAM --




  // -- Un-implemented fields --

  {$SET_UNIMP_BITS '003:1F'} // STATUS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '008:1F'} // BSR bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00A:7F'} // PCLATH bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '010:0F'} // PORTE bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '012:EF'} // PIR2 bit 4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '013:7F'} // PIR3 bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '018:FD'} // T1CON bit 1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01C:7F'} // T2CON bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '090:0F'} // TRISE bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '092:EF'} // PIE2 bit 4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '093:7F'} // PIE3 bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '096:DF'} // PCON bit 5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '097:3F'} // WDTCON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '098:3F'} // OSCTUNE bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '099:FB'} // OSCCON bit 2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '09D:7F'} // ADCON0 bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '09E:F7'} // ADCON1 bit 3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '09F:F0'} // ADCON2 bits 3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '110:07'} // LATE bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '111:DF'} // CM1CON0 bit 5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '113:DF'} // CM2CON0 bit 5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '115:03'} // CMOUT bits 7,6,5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '116:C1'} // BORCON bits 5,4,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '118:BD'} // DAC1CON0 bits 6,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '11A:BD'} // DAC2CON0 bits 6,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '11B:1F'} // DAC2REF bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '11C:B3'} // ZCD1CON bits 6,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '18C:3F'} // ANSELA bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '18D:3F'} // ANSELB bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '18E:FC'} // ANSELC bits 1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '190:07'} // ANSELE bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '194:3F'} // PMDATH bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '195:7F'} // PMCON1 bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '197:03'} // VREGCON bits 7,6,5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '19F:DB'} // BAUD1CON bits 5,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '210:0F'} // WPUE bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '290:07'} // ODCONE bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '293:3F'} // CCP1CON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '29A:3F'} // CCP2CON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '310:07'} // SLRCONE bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '390:0F'} // INLVLE bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '39D:08'} // IOCEP bits 7,6,5,4,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '39E:08'} // IOCEN bits 7,6,5,4,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '39F:08'} // IOCEF bits 7,6,5,4,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '417:7F'} // T4CON bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '41E:7F'} // T6CON bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '49A:0F'} // NCO1ACCU bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '49D:0F'} // NCO1INCU bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '49E:B1'} // NCO1CON bits 6,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '49F:E3'} // NCO1CLK bits 4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '511:D3'} // OPA1CON bits 5,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '515:D3'} // OPA2CON bits 5,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '617:C0'} // PWM3DCL bits 5,4,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '619:B0'} // PWM3CON bits 6,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '61A:C0'} // PWM4DCL bits 5,4,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '61C:B0'} // PWM4CON bits 6,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '691:3F'} // COG1PHR bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '692:3F'} // COG1PHF bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '693:3F'} // COG1BLKR bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '694:3F'} // COG1BLKF bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '695:3F'} // COG1DBR bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '696:3F'} // COG1DBF bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '697:DF'} // COG1CON0 bit 5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '698:CF'} // COG1CON1 bits 5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '69D:FC'} // COG1ASD0 bits 1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '69E:0F'} // COG1ASD1 bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E0F:01'} // PPSLOCK bits 7,6,5,4,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E10:1F'} // INTPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E11:1F'} // T0CKIPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E12:1F'} // T1CKIPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E13:1F'} // T1GPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E14:1F'} // CCP1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E15:1F'} // CCP2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E17:1F'} // COGINPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E20:1F'} // SSPCLKPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E21:1F'} // SSPDATPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E22:1F'} // SSPSSPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E24:1F'} // RXPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E25:1F'} // CKPPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E28:1F'} // CLCIN0PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E29:1F'} // CLCIN1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E2A:1F'} // CLCIN2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E2B:1F'} // CLCIN3PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E90:1F'} // RA0PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E91:1F'} // RA1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E92:1F'} // RA2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E93:1F'} // RA3PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E94:1F'} // RA4PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E95:1F'} // RA5PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E96:1F'} // RA6PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E97:1F'} // RA7PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E98:1F'} // RB0PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E99:1F'} // RB1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E9A:1F'} // RB2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E9B:1F'} // RB3PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E9C:1F'} // RB4PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E9D:1F'} // RB5PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E9E:1F'} // RB6PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'E9F:1F'} // RB7PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA0:1F'} // RC0PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA1:1F'} // RC1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA2:1F'} // RC2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA3:1F'} // RC3PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA4:1F'} // RC4PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA5:1F'} // RC5PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA6:1F'} // RC6PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA7:1F'} // RC7PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA8:1F'} // RD0PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EA9:1F'} // RD1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EAA:1F'} // RD2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EAB:1F'} // RD3PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EAC:1F'} // RD4PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EAD:1F'} // RD5PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EAE:1F'} // RD6PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EAF:1F'} // RD7PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EB0:1F'} // RE0PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EB1:1F'} // RE1PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'EB2:1F'} // RE2PPS bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F0F:0F'} // CLCDATA bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F10:BF'} // CLC1CON bit 6 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F11:8F'} // CLC1POL bits 6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F12:1F'} // CLC1SEL0 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F13:1F'} // CLC1SEL1 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F14:1F'} // CLC1SEL2 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F15:1F'} // CLC1SEL3 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F1A:BF'} // CLC2CON bit 6 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F1B:8F'} // CLC2POL bits 6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F1C:1F'} // CLC2SEL0 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F1D:1F'} // CLC2SEL1 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F1E:1F'} // CLC2SEL2 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F1F:1F'} // CLC2SEL3 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F24:BF'} // CLC3CON bit 6 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F25:8F'} // CLC3POL bits 6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F26:1F'} // CLC3SEL0 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F27:1F'} // CLC3SEL1 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F28:1F'} // CLC3SEL2 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F29:1F'} // CLC3SEL3 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F2E:BF'} // CLC4CON bit 6 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F2F:8F'} // CLC4POL bits 6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F30:1F'} // CLC4SEL0 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F31:1F'} // CLC4SEL1 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F32:1F'} // CLC4SEL2 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'F33:1F'} // CLC4SEL3 bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'FE4:07'} // STATUS_SHAD bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'FE6:1F'} // BSR_SHAD bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'FE7:7F'} // PCLATH_SHAD bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'FED:1F'} // STKPTR bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS 'FEF:7F'} // TOSH bit 7 un-implemented (read as 0)

  {$SET_UNIMP_BITS1 '192:80'} // PMADRH bit 7 un-implemented (read as 1)


  // -- PIN mapping --

  // Pin  1 : RE3/MCLR
  // Pin  2 : RA0/AN0/C1IN0-/C2IN0-
  // Pin  3 : RA1/AN1/C1IN1-/C2IN1-/OPA1OUT
  // Pin  4 : RA2/AN2/Vref-/C1IN0+/C2IN0+/DAC1OUT1
  // Pin  5 : RA3/AN3/Vref+/C1IN1+
  // Pin  6 : RA4/OPA1IN+
  // Pin  7 : RA5/AN4/OPA1IN-/DAC2OUT1
  // Pin  8 : RE0/AN5
  // Pin  9 : RE1/AN6
  // Pin 10 : RE2/AN7
  // Pin 11 : Vdd
  // Pin 12 : Vss
  // Pin 13 : RA7/OSC1/CLKIN
  // Pin 14 : RA6/OSC2/CLKOUT
  // Pin 15 : RC0/SOSCO
  // Pin 16 : RC1/SOSCI
  // Pin 17 : RC2/AN14
  // Pin 18 : RC3/AN15
  // Pin 19 : RD0/AN20
  // Pin 20 : RD1/AN21
  // Pin 21 : RD2/AN22
  // Pin 22 : RD3/AN23
  // Pin 23 : RC4/AN16
  // Pin 24 : RC5/AN17
  // Pin 25 : RC6/AN18
  // Pin 26 : RC7/AN19
  // Pin 27 : RD4/AN24
  // Pin 28 : RD5/AN25
  // Pin 29 : RD6/AN26
  // Pin 30 : RD7/AN27
  // Pin 31 : Vss
  // Pin 32 : Vdd
  // Pin 33 : RB0/AN12/C2IN1+/ZCD
  // Pin 34 : RB1/AN10/C1IN3-/C2IN3-/OPA2OUT
  // Pin 35 : RB2/AN8/OPA2IN-
  // Pin 36 : RB3/AN9/C1IN2-/C2IN2-/OPA2IN+
  // Pin 37 : RB4/AN11
  // Pin 38 : RB5/AN13
  // Pin 39 : RB6/ICSPCLK
  // Pin 40 : RB7/DAC1OUT2/DAC2OUT2/ICSPDAT


  // -- RAM to PIN mapping --

  {$MAP_RAM_TO_PIN '00C:0-2,1-3,2-4,3-5,4-6,5-7,6-14,7-13'} // PORTA
  {$MAP_RAM_TO_PIN '00D:0-33,1-34,2-35,3-36,4-37,5-38,6-39,7-40'} // PORTB
  {$MAP_RAM_TO_PIN '00E:0-15,1-16,2-17,3-18,4-23,5-24,6-25,7-26'} // PORTC
  {$MAP_RAM_TO_PIN '00F:0-19,1-20,2-21,3-22,4-27,5-28,6-29,7-30'} // PORTD
  {$MAP_RAM_TO_PIN '010:0-8,1-9,2-10,3-1'} // PORTE


  // -- Bits Configuration --

  // FOSC : Oscillator Selection Bits
  {$define _FOSC_ECH     = $3FFF}  // ECH, External Clock, High Power Mode (4-20 MHz): device clock supplied to CLKIN pins
  {$define _FOSC_ECM     = $3FFE}  // ECM, External Clock, Medium Power Mode (0.5-4 MHz): device clock supplied to CLKIN pins
  {$define _FOSC_ECL     = $3FFD}  // ECL, External Clock, Low Power Mode (0-0.5 MHz): device clock supplied to CLKIN pins
  {$define _FOSC_INTOSC  = $3FFC}  // INTOSC oscillator: I/O function on CLKIN pin
  {$define _FOSC_EXTRC   = $3FFB}  // EXTRC oscillator: External RC circuit connected to CLKIN pin
  {$define _FOSC_HS      = $3FFA}  // HS Oscillator, High-speed crystal/resonator connected between OSC1 and OSC2 pins
  {$define _FOSC_XT      = $3FF9}  // XT Oscillator, Crystal/resonator connected between OSC1 and OSC2 pins
  {$define _FOSC_LP      = $3FF8}  // LP Oscillator, Low-power crystal connected between OSC1 and OSC2 pins

  // WDTE : Watchdog Timer Enable
  {$define _WDTE_ON      = $3FFF}  // WDT enabled
  {$define _WDTE_NSLEEP  = $3FF7}  // WDT enabled while running and disabled in Sleep
  {$define _WDTE_SWDTEN  = $3FEF}  // WDT controlled by the SWDTEN bit in the WDTCON register
  {$define _WDTE_OFF     = $3FE7}  // WDT disabled

  // PWRTE : Power-up Timer Enable
  {$define _PWRTE_OFF    = $3FFF}  // PWRT disabled
  {$define _PWRTE_ON     = $3FDF}  // PWRT enabled

  // MCLRE : MCLR Pin Function Select
  {$define _MCLRE_ON     = $3FFF}  // MCLR/VPP pin function is MCLR
  {$define _MCLRE_OFF    = $3FBF}  // MCLR/VPP pin function is digital input if LVP bit is also 0.

  // CP : Flash Program Memory Code Protection
  {$define _CP_OFF       = $3FFF}  // Program memory code protection is disabled
  {$define _CP_ON        = $3F7F}  // Program memory code protection is enabled

  // BOREN : Brown-out Reset Enable
  {$define _BOREN_ON     = $3FFF}  // Brown-out Reset enabled
  {$define _BOREN_NSLEEP = $3DFF}  // Brown-out Reset enabled while running and disabled in Sleep
  {$define _BOREN_SBODEN = $3BFF}  // Brown-out Reset controlled by the SBOREN bit in the BORCON register
  {$define _BOREN_OFF    = $39FF}  // Brown-out Reset disabled

  // CLKOUTEN : Clock Out Enable
  {$define _CLKOUTEN_OFF = $3FFF}  // CLKOUT function is disabled. I/O or oscillator function on the CLKOUT pin
  {$define _CLKOUTEN_ON  = $37FF}  // CLKOUT function is enabled on the CLKOUT pin

  // IESO : Internal/External Switchover Mode
  {$define _IESO_ON      = $3FFF}  // Internal/External Switchover Mode is enabled
  {$define _IESO_OFF     = $2FFF}  // Internal/External Switchover Mode is disabled

  // FCMEN : Fail-Safe Clock Monitor Enable
  {$define _FCMEN_ON     = $3FFF}  // Fail-Safe Clock Monitor is enabled
  {$define _FCMEN_OFF    = $1FFF}  // Fail-Safe Clock Monitor is disabled

  // WRT : Flash Memory Self-Write Protection
  {$define _WRT_OFF      = $3FFF}  // Write protection off
  {$define _WRT_BOOT     = $3FFE}  // 0000h to 03FFh write protected, 0400h to 1FFFh may be modified by EECON control
  {$define _WRT_HALF     = $3FFD}  // 0000h to 0FFFh write protected, 1000h to 1FFFh may be modified by EECON control
  {$define _WRT_ALL      = $3FFC}  // 0000h to 1FFFh write protected, no addresses may be modified by EECON control

  // PPS1WAY : Peripheral Pin Select one-way control
  {$define _PPS1WAY_ON   = $3FFF}  // The PPSLOCK bit cannot be cleared once it is set by software
  {$define _PPS1WAY_OFF  = $3FFB}  // The PPSLOCK bit can be set and cleared repeatedly by software

  // ZCDDIS : Zero-cross detect disable
  {$define _ZCDDIS_ON    = $3FFF}  // Zero-cross detect circuit is disabled at POR and can be enabled with ZCDSEN bit.
  {$define _ZCDDIS_OFF   = $3F7F}  // Zero-cross detect circuit is always enabled.

  // PLLEN : Phase Lock Loop enable
  {$define _PLLEN_ON     = $3FFF}  // 4x PLL is always enabled
  {$define _PLLEN_OFF    = $3EFF}  // 4x PLL is enabled when software sets the SPLLEN bit

  // STVREN : Stack Overflow/Underflow Reset Enable
  {$define _STVREN_ON    = $3FFF}  // Stack Overflow or Underflow will cause a Reset
  {$define _STVREN_OFF   = $3DFF}  // Stack Overflow or Underflow will not cause a Reset

  // BORV : Brown-out Reset Voltage Selection
  {$define _BORV_LO      = $3FFF}  // Brown-out Reset Voltage (Vbor), low trip point selected.
  {$define _BORV_HI      = $3BFF}  // Brown-out Reset Voltage (Vbor), high trip point selected.

  // LPBOR : Low-Power Brown Out Reset
  {$define _LPBOR_OFF    = $3FFF}  // Low-Power BOR is disabled
  {$define _LPBOR_ON     = $37FF}  // Low-Power BOR is enabled

  // LVP : Low-Voltage Programming Enable
  {$define _LVP_ON       = $3FFF}  // Low-voltage programming enabled
  {$define _LVP_OFF      = $1FFF}  // High-voltage on MCLR/VPP must be used for programming

implementation
end.
