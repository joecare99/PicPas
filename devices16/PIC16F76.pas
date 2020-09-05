unit PIC16F76;

// Define hardware
{$SET PIC_MODEL    = 'PIC16F76'}
{$SET PIC_MAXFREQ  = 20000000}
{$SET PIC_NPINS    = 28}
{$SET PIC_NUMBANKS = 4}
{$SET PIC_NUMPAGES = 4}
{$SET PIC_MAXFLASH = 8192}

interface
var
  INDF              : byte absolute $0000;
  TMR0              : byte absolute $0001;
  PCL               : byte absolute $0002;
  STATUS            : byte absolute $0003;
  STATUS_IRP        : bit  absolute STATUS.7;
  STATUS_RP1        : bit  absolute STATUS.6;
  STATUS_RP0        : bit  absolute STATUS.5;
  STATUS_nTO        : bit  absolute STATUS.4;
  STATUS_nPD        : bit  absolute STATUS.3;
  STATUS_Z          : bit  absolute STATUS.2;
  STATUS_DC         : bit  absolute STATUS.1;
  STATUS_C          : bit  absolute STATUS.0;
  FSR               : byte absolute $0004;
  PORTA             : byte absolute $0005;
  PORTA_RA5         : bit  absolute PORTA.5;
  PORTA_RA4         : bit  absolute PORTA.4;
  PORTA_RA3         : bit  absolute PORTA.3;
  PORTA_RA2         : bit  absolute PORTA.2;
  PORTA_RA1         : bit  absolute PORTA.1;
  PORTA_RA0         : bit  absolute PORTA.0;
  PORTB             : byte absolute $0006;
  PORTB_RB7         : bit  absolute PORTB.7;
  PORTB_RB6         : bit  absolute PORTB.6;
  PORTB_RB5         : bit  absolute PORTB.5;
  PORTB_RB4         : bit  absolute PORTB.4;
  PORTB_RB3         : bit  absolute PORTB.3;
  PORTB_RB2         : bit  absolute PORTB.2;
  PORTB_RB1         : bit  absolute PORTB.1;
  PORTB_RB0         : bit  absolute PORTB.0;
  PORTC             : byte absolute $0007;
  PORTC_RC7         : bit  absolute PORTC.7;
  PORTC_RC6         : bit  absolute PORTC.6;
  PORTC_RC5         : bit  absolute PORTC.5;
  PORTC_RC4         : bit  absolute PORTC.4;
  PORTC_RC3         : bit  absolute PORTC.3;
  PORTC_RC2         : bit  absolute PORTC.2;
  PORTC_RC1         : bit  absolute PORTC.1;
  PORTC_RC0         : bit  absolute PORTC.0;
  PCLATH            : byte absolute $000A;
  PCLATH_PCLATH4    : bit  absolute PCLATH.4;
  PCLATH_PCLATH3    : bit  absolute PCLATH.3;
  PCLATH_PCLATH2    : bit  absolute PCLATH.2;
  PCLATH_PCLATH1    : bit  absolute PCLATH.1;
  PCLATH_PCLATH0    : bit  absolute PCLATH.0;
  INTCON            : byte absolute $000B;
  INTCON_GIE        : bit  absolute INTCON.7;
  INTCON_PEIE       : bit  absolute INTCON.6;
  INTCON_TMR0IE     : bit  absolute INTCON.5;
  INTCON_INTE       : bit  absolute INTCON.4;
  INTCON_RBIE       : bit  absolute INTCON.3;
  INTCON_TMR0IF     : bit  absolute INTCON.2;
  INTCON_INTF       : bit  absolute INTCON.1;
  INTCON_RBIF       : bit  absolute INTCON.0;
  PIR1              : byte absolute $000C;
  PIR1_ADIF         : bit  absolute PIR1.6;
  PIR1_RCIF         : bit  absolute PIR1.5;
  PIR1_TXIF         : bit  absolute PIR1.4;
  PIR1_SSPIF        : bit  absolute PIR1.3;
  PIR1_CCP1IF       : bit  absolute PIR1.2;
  PIR1_TMR2IF       : bit  absolute PIR1.1;
  PIR1_TMR1IF       : bit  absolute PIR1.0;
  PIR2              : byte absolute $000D;
  PIR2_CCP2IF       : bit  absolute PIR2.0;
  TMR1L             : byte absolute $000E;
  TMR1H             : byte absolute $000F;
  T1CON             : byte absolute $0010;
  T1CON_T1CKPS1     : bit  absolute T1CON.5;
  T1CON_T1CKPS0     : bit  absolute T1CON.4;
  T1CON_T1OSCEN     : bit  absolute T1CON.3;
  T1CON_nT1SYNC     : bit  absolute T1CON.2;
  T1CON_TMR1CS      : bit  absolute T1CON.1;
  T1CON_TMR1ON      : bit  absolute T1CON.0;
  TMR2              : byte absolute $0011;
  T2CON             : byte absolute $0012;
  T2CON_TOUTPS3     : bit  absolute T2CON.6;
  T2CON_TOUTPS2     : bit  absolute T2CON.5;
  T2CON_TOUTPS1     : bit  absolute T2CON.4;
  T2CON_TOUTPS0     : bit  absolute T2CON.3;
  T2CON_TMR2ON      : bit  absolute T2CON.2;
  T2CON_T2CKPS1     : bit  absolute T2CON.1;
  T2CON_T2CKPS0     : bit  absolute T2CON.0;
  SSPBUF            : byte absolute $0013;
  SSPCON            : byte absolute $0014;
  SSPCON_WCOL       : bit  absolute SSPCON.7;
  SSPCON_SSPOV      : bit  absolute SSPCON.6;
  SSPCON_SSPEN      : bit  absolute SSPCON.5;
  SSPCON_CKP        : bit  absolute SSPCON.4;
  SSPCON_SSPM3      : bit  absolute SSPCON.3;
  SSPCON_SSPM2      : bit  absolute SSPCON.2;
  SSPCON_SSPM1      : bit  absolute SSPCON.1;
  SSPCON_SSPM0      : bit  absolute SSPCON.0;
  CCPR1L            : byte absolute $0015;
  CCPR1H            : byte absolute $0016;
  CCP1CON           : byte absolute $0017;
  CCP1CON_CCP1X     : bit  absolute CCP1CON.5;
  CCP1CON_CCP1Y     : bit  absolute CCP1CON.4;
  CCP1CON_CCP1M3    : bit  absolute CCP1CON.3;
  CCP1CON_CCP1M2    : bit  absolute CCP1CON.2;
  CCP1CON_CCP1M1    : bit  absolute CCP1CON.1;
  CCP1CON_CCP1M0    : bit  absolute CCP1CON.0;
  RCSTA             : byte absolute $0018;
  RCSTA_SPEN        : bit  absolute RCSTA.7;
  RCSTA_RX9         : bit  absolute RCSTA.6;
  RCSTA_SREN        : bit  absolute RCSTA.5;
  RCSTA_CREN        : bit  absolute RCSTA.4;
  RCSTA_FERR        : bit  absolute RCSTA.2;
  RCSTA_OERR        : bit  absolute RCSTA.1;
  RCSTA_RX9D        : bit  absolute RCSTA.0;
  TXREG             : byte absolute $0019;
  RCREG             : byte absolute $001A;
  CCPR2L            : byte absolute $001B;
  CCPR2H            : byte absolute $001C;
  CCP2CON           : byte absolute $001D;
  CCP2CON_CCP2X     : bit  absolute CCP2CON.5;
  CCP2CON_CCP2Y     : bit  absolute CCP2CON.4;
  CCP2CON_CCP2M3    : bit  absolute CCP2CON.3;
  CCP2CON_CCP2M2    : bit  absolute CCP2CON.2;
  CCP2CON_CCP2M1    : bit  absolute CCP2CON.1;
  CCP2CON_CCP2M0    : bit  absolute CCP2CON.0;
  ADRES             : byte absolute $001E;
  ADCON0            : byte absolute $001F;
  ADCON0_ADCS1      : bit  absolute ADCON0.7;
  ADCON0_ADCS0      : bit  absolute ADCON0.6;
  ADCON0_CHS2       : bit  absolute ADCON0.5;
  ADCON0_CHS1       : bit  absolute ADCON0.4;
  ADCON0_CHS0       : bit  absolute ADCON0.3;
  ADCON0_GO_nDONE   : bit  absolute ADCON0.2;
  ADCON0_ADON       : bit  absolute ADCON0.0;
  OPTION_REG        : byte absolute $0081;
  OPTION_REG_nRBPU  : bit  absolute OPTION_REG.7;
  OPTION_REG_INTEDG : bit  absolute OPTION_REG.6;
  OPTION_REG_T0CS   : bit  absolute OPTION_REG.5;
  OPTION_REG_T0SE   : bit  absolute OPTION_REG.4;
  OPTION_REG_PSA    : bit  absolute OPTION_REG.3;
  OPTION_REG_PS2    : bit  absolute OPTION_REG.2;
  OPTION_REG_PS1    : bit  absolute OPTION_REG.1;
  OPTION_REG_PS0    : bit  absolute OPTION_REG.0;
  TRISA             : byte absolute $0085;
  TRISA_TRISA5      : bit  absolute TRISA.5;
  TRISA_TRISA4      : bit  absolute TRISA.4;
  TRISA_TRISA3      : bit  absolute TRISA.3;
  TRISA_TRISA2      : bit  absolute TRISA.2;
  TRISA_TRISA1      : bit  absolute TRISA.1;
  TRISA_TRISA0      : bit  absolute TRISA.0;
  TRISB             : byte absolute $0086;
  TRISB_TRISB7      : bit  absolute TRISB.7;
  TRISB_TRISB6      : bit  absolute TRISB.6;
  TRISB_TRISB5      : bit  absolute TRISB.5;
  TRISB_TRISB4      : bit  absolute TRISB.4;
  TRISB_TRISB3      : bit  absolute TRISB.3;
  TRISB_TRISB2      : bit  absolute TRISB.2;
  TRISB_TRISB1      : bit  absolute TRISB.1;
  TRISB_TRISB0      : bit  absolute TRISB.0;
  TRISC             : byte absolute $0087;
  TRISC_TRISC7      : bit  absolute TRISC.7;
  TRISC_TRISC6      : bit  absolute TRISC.6;
  TRISC_TRISC5      : bit  absolute TRISC.5;
  TRISC_TRISC4      : bit  absolute TRISC.4;
  TRISC_TRISC3      : bit  absolute TRISC.3;
  TRISC_TRISC2      : bit  absolute TRISC.2;
  TRISC_TRISC1      : bit  absolute TRISC.1;
  TRISC_TRISC0      : bit  absolute TRISC.0;
  PIE1              : byte absolute $008C;
  PIE1_ADIE         : bit  absolute PIE1.6;
  PIE1_RCIE         : bit  absolute PIE1.5;
  PIE1_TXIE         : bit  absolute PIE1.4;
  PIE1_SSPIE        : bit  absolute PIE1.3;
  PIE1_CCP1IE       : bit  absolute PIE1.2;
  PIE1_TMR2IE       : bit  absolute PIE1.1;
  PIE1_TMR1IE       : bit  absolute PIE1.0;
  PIE2              : byte absolute $008D;
  PIE2_CCP2IE       : bit  absolute PIE2.0;
  PCON              : byte absolute $008E;
  PCON_nPOR         : bit  absolute PCON.1;
  PCON_nBOR         : bit  absolute PCON.0;
  PR2               : byte absolute $0092;
  SSPADD            : byte absolute $0093;
  SSPSTAT           : byte absolute $0094;
  SSPSTAT_SMP       : bit  absolute SSPSTAT.7;
  SSPSTAT_CKE       : bit  absolute SSPSTAT.6;
  SSPSTAT_D_nA      : bit  absolute SSPSTAT.5;
  SSPSTAT_P         : bit  absolute SSPSTAT.4;
  SSPSTAT_S         : bit  absolute SSPSTAT.3;
  SSPSTAT_R_nW      : bit  absolute SSPSTAT.2;
  SSPSTAT_UA        : bit  absolute SSPSTAT.1;
  SSPSTAT_BF        : bit  absolute SSPSTAT.0;
  TXSTA             : byte absolute $0098;
  TXSTA_CSRC        : bit  absolute TXSTA.7;
  TXSTA_TX9         : bit  absolute TXSTA.6;
  TXSTA_TXEN        : bit  absolute TXSTA.5;
  TXSTA_SYNC        : bit  absolute TXSTA.4;
  TXSTA_BRGH        : bit  absolute TXSTA.2;
  TXSTA_TRMT        : bit  absolute TXSTA.1;
  TXSTA_TX9D        : bit  absolute TXSTA.0;
  SPBRG             : byte absolute $0099;
  ADCON1            : byte absolute $009F;
  ADCON1_PCFG2      : bit  absolute ADCON1.2;
  ADCON1_PCFG1      : bit  absolute ADCON1.1;
  ADCON1_PCFG0      : bit  absolute ADCON1.0;
  PMDATA            : byte absolute $010C;
  PMADR             : byte absolute $010D;
  PMDATH            : byte absolute $010E;
  PMDATH_PMDATH5    : bit  absolute PMDATH.5;
  PMDATH_PMDATH4    : bit  absolute PMDATH.4;
  PMDATH_PMDATH3    : bit  absolute PMDATH.3;
  PMDATH_PMDATH2    : bit  absolute PMDATH.2;
  PMDATH_PMDATH1    : bit  absolute PMDATH.1;
  PMDATH_PMDATH0    : bit  absolute PMDATH.0;
  PMADRH            : byte absolute $010F;
  PMADRH_PMADRH4    : bit  absolute PMADRH.4;
  PMADRH_PMADRH3    : bit  absolute PMADRH.3;
  PMADRH_PMADRH2    : bit  absolute PMADRH.2;
  PMADRH_PMADRH1    : bit  absolute PMADRH.1;
  PMADRH_PMADRH0    : bit  absolute PMADRH.0;
  PMCON1            : byte absolute $018C;
  PMCON1_RD         : bit  absolute PMCON1.0;


  // -- Define RAM state values --

  {$CLEAR_STATE_RAM}

  {$SET_STATE_RAM '000-000:SFR:ALLMAPPED'}  // Banks 0-3 : INDF
  {$SET_STATE_RAM '001-001:SFR:ALL'}        // Bank 0 : TMR0
                                            // Bank 1 : OPTION_REG
                                            // Bank 2 : TMR0
                                            // Bank 3 : OPTION_REG
  {$SET_STATE_RAM '002-004:SFR:ALLMAPPED'}  // Banks 0-3 : PCL, STATUS, FSR
  {$SET_STATE_RAM '005-005:SFR'}            // Bank 0 : PORTA
  {$SET_STATE_RAM '006-006:SFR:ALL'}        // Bank 0 : PORTB
                                            // Bank 1 : TRISB
                                            // Bank 2 : PORTB
                                            // Bank 3 : TRISB
  {$SET_STATE_RAM '007-007:SFR'}            // Bank 0 : PORTC
  {$SET_STATE_RAM '00A-00B:SFR:ALLMAPPED'}  // Banks 0-3 : PCLATH, INTCON
  {$SET_STATE_RAM '00C-00C:SFR:ALL'}        // Bank 0 : PIR1
                                            // Bank 1 : PIE1
                                            // Bank 2 : PMDATA
                                            // Bank 3 : PMCON1
  {$SET_STATE_RAM '00D-01F:SFR'}            // Bank 0 : PIR2, TMR1L, TMR1H, T1CON, TMR2, T2CON, SSPBUF, SSPCON, CCPR1L, CCPR1H, CCP1CON, RCSTA, TXREG, RCREG, CCPR2L, CCPR2H, CCP2CON, ADRES, ADCON0
  {$SET_STATE_RAM '020-06F:GPR:ALL'}       
  {$SET_STATE_RAM '070-07F:GPR:ALLMAPPED'} 
  {$SET_STATE_RAM '085-085:SFR'}            // Bank 1 : TRISA
  {$SET_STATE_RAM '087-087:SFR'}            // Bank 1 : TRISC
  {$SET_STATE_RAM '08D-08E:SFR'}            // Bank 1 : PIE2, PCON
  {$SET_STATE_RAM '092-094:SFR'}            // Bank 1 : PR2, SSPADD, SSPSTAT
  {$SET_STATE_RAM '098-099:SFR'}            // Bank 1 : TXSTA, SPBRG
  {$SET_STATE_RAM '09F-09F:SFR'}            // Bank 1 : ADCON1
  {$SET_STATE_RAM '10D-10F:SFR'}            // Bank 2 : PMADR, PMDATH, PMADRH
  {$SET_STATE_RAM '110-11F:GPR'}           
  {$SET_STATE_RAM '190-19F:GPR'}           


  // -- Define mapped RAM --

  {$SET_MAPPED_RAM '101-101:bnk0'} // maps to TMR0 (bank 0)
  {$SET_MAPPED_RAM '106-106:bnk0'} // maps to PORTB (bank 0)
  {$SET_MAPPED_RAM '181-181:bnk1'} // maps to OPTION_REG (bank 1)
  {$SET_MAPPED_RAM '186-186:bnk1'} // maps to TRISB (bank 1)


  // -- Un-implemented fields --

  {$SET_UNIMP_BITS '005:3F'} // PORTA bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00A:1F'} // PCLATH bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00C:7F'} // PIR1 bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00D:01'} // PIR2 bits 7,6,5,4,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '010:3F'} // T1CON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '012:7F'} // T2CON bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '017:3F'} // CCP1CON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '018:F7'} // RCSTA bit 3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01D:3F'} // CCP2CON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01F:FD'} // ADCON0 bit 1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '085:3F'} // TRISA bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '08C:7F'} // PIE1 bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '08D:01'} // PIE2 bits 7,6,5,4,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '08E:03'} // PCON bits 7,6,5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '098:F7'} // TXSTA bit 3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '09F:07'} // ADCON1 bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '10E:3F'} // PMDATH bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '10F:1F'} // PMADRH bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '18C:81'} // PMCON1 bits 6,5,4,3,2,1 un-implemented (read as 0)


  // -- PIN mapping --

  // Pin  1 : MCLR/Vpp
  // Pin  2 : RA0/AN0
  // Pin  3 : RA1/AN1
  // Pin  4 : RA2/AN2
  // Pin  5 : RA3/AN3/Vref
  // Pin  6 : RA4/T0CKI
  // Pin  7 : RA5/SS/AN4
  // Pin  8 : Vss
  // Pin  9 : OSC1/CLKI
  // Pin 10 : OSC2/CLKO
  // Pin 11 : RC0/T1OSO/T1CKI
  // Pin 12 : RC1/T1OSI/CCP2
  // Pin 13 : RC2/CCP1
  // Pin 14 : RC3/SCK/SCL
  // Pin 15 : RC4/SDI/SDA
  // Pin 16 : RC5/SDO
  // Pin 17 : RC6/TX/CK
  // Pin 18 : RC7/RX/DT
  // Pin 19 : Vss
  // Pin 20 : Vdd
  // Pin 21 : RB0/INT
  // Pin 22 : RB1
  // Pin 23 : RB2
  // Pin 24 : RB3/PGM
  // Pin 25 : RB4
  // Pin 26 : RB5
  // Pin 27 : RB6/PGC
  // Pin 28 : RB7/PGD


  // -- RAM to PIN mapping --

  {$MAP_RAM_TO_PIN '005:0-2,1-3,2-4,3-5,4-6,5-7'} // PORTA
  {$MAP_RAM_TO_PIN '006:0-21,1-22,2-23,3-24,4-25,5-26,6-27,7-28'} // PORTB
  {$MAP_RAM_TO_PIN '007:0-11,1-12,2-13,3-14,4-15,5-16,6-17,7-18'} // PORTC


  // -- Bits Configuration --

  // FOSC : Oscillator Selection bits
  {$define _FOSC_RC   = $3FFF}  // RC oscillator
  {$define _FOSC_HS   = $3FFE}  // HS oscillator
  {$define _FOSC_XT   = $3FFD}  // XT oscillator
  {$define _FOSC_LP   = $3FFC}  // LP oscillator

  // WDTE : Watchdog Timer Enable bit
  {$define _WDTE_ON   = $3FFF}  // WDT enabled
  {$define _WDTE_OFF  = $3FFB}  // WDT disabled

  // PWRTE : Power-up Timer Enable bit
  {$define _PWRTE_OFF = $3FFF}  // PWRT disabled
  {$define _PWRTE_ON  = $3FF7}  // PWRT enabled

  // CP : FLASH Program Memory Code Protection bit
  {$define _CP_OFF    = $3FFF}  // Code protection off
  {$define _CP_ON     = $3FEF}  // All Memory locations code protected

  // BOREN : Brown-out Reset Enable bit
  {$define _BOREN_ON  = $3FFF}  // BOR enabled
  {$define _BOREN_OFF = $3FBF}  // BOR disabled

implementation
end.
