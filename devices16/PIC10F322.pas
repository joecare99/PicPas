unit PIC10F322;

// Define hardware
{$SET PIC_MODEL    = 'PIC10F322'}
{$SET PIC_MAXFREQ  = 16000000}
{$SET PIC_NPINS    = 6}
{$SET PIC_NUMBANKS = 1}
{$SET PIC_NUMPAGES = 1}
{$SET PIC_MAXFLASH = 512}

interface
var
  INDF                : byte absolute $0000;
  TMR0                : byte absolute $0001;
  PCL                 : byte absolute $0002;
  STATUS              : byte absolute $0003;
  STATUS_IRP          : bit  absolute STATUS.7;
  STATUS_RP1          : bit  absolute STATUS.6;
  STATUS_RP0          : bit  absolute STATUS.5;
  STATUS_nTO          : bit  absolute STATUS.4;
  STATUS_nPD          : bit  absolute STATUS.3;
  STATUS_Z            : bit  absolute STATUS.2;
  STATUS_DC           : bit  absolute STATUS.1;
  STATUS_C            : bit  absolute STATUS.0;
  FSR                 : byte absolute $0004;
  PORTA               : byte absolute $0005;
  PORTA_RA3           : bit  absolute PORTA.3;
  PORTA_RA2           : bit  absolute PORTA.2;
  PORTA_RA1           : bit  absolute PORTA.1;
  PORTA_RA0           : bit  absolute PORTA.0;
  TRISA               : byte absolute $0006;
  TRISA_TRISA2        : bit  absolute TRISA.2;
  TRISA_TRISA1        : bit  absolute TRISA.1;
  TRISA_TRISA0        : bit  absolute TRISA.0;
  LATA                : byte absolute $0007;
  LATA_LATA2          : bit  absolute LATA.2;
  LATA_LATA1          : bit  absolute LATA.1;
  LATA_LATA0          : bit  absolute LATA.0;
  ANSELA              : byte absolute $0008;
  ANSELA_ANSA2        : bit  absolute ANSELA.2;
  ANSELA_ANSA1        : bit  absolute ANSELA.1;
  ANSELA_ANSA0        : bit  absolute ANSELA.0;
  WPUA                : byte absolute $0009;
  WPUA_WPUA3          : bit  absolute WPUA.3;
  WPUA_WPUA2          : bit  absolute WPUA.2;
  WPUA_WPUA1          : bit  absolute WPUA.1;
  WPUA_WPUA0          : bit  absolute WPUA.0;
  PCLATH              : byte absolute $000A;
  PCLATH_PCLH0        : bit  absolute PCLATH.0;
  INTCON              : byte absolute $000B;
  INTCON_GIE          : bit  absolute INTCON.7;
  INTCON_PEIE         : bit  absolute INTCON.6;
  INTCON_TMR0IE       : bit  absolute INTCON.5;
  INTCON_INTE         : bit  absolute INTCON.4;
  INTCON_IOCIE        : bit  absolute INTCON.3;
  INTCON_TMR0IF       : bit  absolute INTCON.2;
  INTCON_INTF         : bit  absolute INTCON.1;
  INTCON_IOCIF        : bit  absolute INTCON.0;
  PIR1                : byte absolute $000C;
  PIR1_ADIF           : bit  absolute PIR1.6;
  PIR1_NCO1IF         : bit  absolute PIR1.4;
  PIR1_CLC1IF         : bit  absolute PIR1.3;
  PIR1_TMR2IF         : bit  absolute PIR1.1;
  PIE1                : byte absolute $000D;
  PIE1_ADIE           : bit  absolute PIE1.6;
  PIE1_NCO1IE         : bit  absolute PIE1.4;
  PIE1_CLC1IE         : bit  absolute PIE1.3;
  PIE1_TMR2IE         : bit  absolute PIE1.1;
  OPTION_REG          : byte absolute $000E;
  OPTION_REG_nWPUEN   : bit  absolute OPTION_REG.7;
  OPTION_REG_INTEDG   : bit  absolute OPTION_REG.6;
  OPTION_REG_T0CS     : bit  absolute OPTION_REG.5;
  OPTION_REG_T0SE     : bit  absolute OPTION_REG.4;
  OPTION_REG_PSA      : bit  absolute OPTION_REG.3;
  OPTION_REG_PS2      : bit  absolute OPTION_REG.2;
  OPTION_REG_PS1      : bit  absolute OPTION_REG.1;
  OPTION_REG_PS0      : bit  absolute OPTION_REG.0;
  PCON                : byte absolute $000F;
  PCON_nPOR           : bit  absolute PCON.1;
  PCON_nBOR           : bit  absolute PCON.0;
  OSCCON              : byte absolute $0010;
  OSCCON_IRCF2        : bit  absolute OSCCON.6;
  OSCCON_IRCF1        : bit  absolute OSCCON.5;
  OSCCON_IRCF0        : bit  absolute OSCCON.4;
  OSCCON_HFIOFR       : bit  absolute OSCCON.3;
  OSCCON_LFIOFR       : bit  absolute OSCCON.1;
  OSCCON_HFIOFS       : bit  absolute OSCCON.0;
  TMR2                : byte absolute $0011;
  PR2                 : byte absolute $0012;
  T2CON               : byte absolute $0013;
  T2CON_TOUTPS3       : bit  absolute T2CON.6;
  T2CON_TOUTPS2       : bit  absolute T2CON.5;
  T2CON_TOUTPS1       : bit  absolute T2CON.4;
  T2CON_TOUTPS0       : bit  absolute T2CON.3;
  T2CON_TMR2ON        : bit  absolute T2CON.2;
  T2CON_T2CKPS1       : bit  absolute T2CON.1;
  T2CON_T2CKPS0       : bit  absolute T2CON.0;
  PWM1DCL             : byte absolute $0014;
  PWM1DCL_PWM1DCL1    : bit  absolute PWM1DCL.7;
  PWM1DCL_PWM1DCL0    : bit  absolute PWM1DCL.6;
  PWM1DCH             : byte absolute $0015;
  PWM1CON             : byte absolute $0016;
  PWM1CON_PWM1EN      : bit  absolute PWM1CON.7;
  PWM1CON_PWM1OE      : bit  absolute PWM1CON.6;
  PWM1CON_PWM1OUT     : bit  absolute PWM1CON.5;
  PWM1CON_PWM1POL     : bit  absolute PWM1CON.4;
  PWM2DCL             : byte absolute $0017;
  PWM2DCL_PWM2DCL1    : bit  absolute PWM2DCL.7;
  PWM2DCL_PWM2DCL0    : bit  absolute PWM2DCL.6;
  PWM2DCH             : byte absolute $0018;
  PWM2CON             : byte absolute $0019;
  PWM2CON_PWM2EN      : bit  absolute PWM2CON.7;
  PWM2CON_PWM2OE      : bit  absolute PWM2CON.6;
  PWM2CON_PWM2OUT     : bit  absolute PWM2CON.5;
  PWM2CON_PWM2POL     : bit  absolute PWM2CON.4;
  IOCAP               : byte absolute $001A;
  IOCAP_IOCAP3        : bit  absolute IOCAP.3;
  IOCAP_IOCAP2        : bit  absolute IOCAP.2;
  IOCAP_IOCAP1        : bit  absolute IOCAP.1;
  IOCAP_IOCAP0        : bit  absolute IOCAP.0;
  IOCAN               : byte absolute $001B;
  IOCAN_IOCAN3        : bit  absolute IOCAN.3;
  IOCAN_IOCAN2        : bit  absolute IOCAN.2;
  IOCAN_IOCAN1        : bit  absolute IOCAN.1;
  IOCAN_IOCAN0        : bit  absolute IOCAN.0;
  IOCAF               : byte absolute $001C;
  IOCAF_IOCAF3        : bit  absolute IOCAF.3;
  IOCAF_IOCAF2        : bit  absolute IOCAF.2;
  IOCAF_IOCAF1        : bit  absolute IOCAF.1;
  IOCAF_IOCAF0        : bit  absolute IOCAF.0;
  FVRCON              : byte absolute $001D;
  FVRCON_FVREN        : bit  absolute FVRCON.7;
  FVRCON_FVRRDY       : bit  absolute FVRCON.6;
  FVRCON_TSEN         : bit  absolute FVRCON.5;
  FVRCON_TSRNG        : bit  absolute FVRCON.4;
  FVRCON_ADFVR1       : bit  absolute FVRCON.1;
  FVRCON_ADFVR0       : bit  absolute FVRCON.0;
  ADRES               : byte absolute $001E;
  ADCON               : byte absolute $001F;
  ADCON_ADCS2         : bit  absolute ADCON.7;
  ADCON_ADCS1         : bit  absolute ADCON.6;
  ADCON_ADCS0         : bit  absolute ADCON.5;
  ADCON_CHS2          : bit  absolute ADCON.4;
  ADCON_CHS1          : bit  absolute ADCON.3;
  ADCON_CHS0          : bit  absolute ADCON.2;
  ADCON_GO_nDONE      : bit  absolute ADCON.1;
  ADCON_ADON          : bit  absolute ADCON.0;
  PMADRL              : byte absolute $0020;
  PMADRH              : byte absolute $0021;
  PMADRH_PMADR8       : bit  absolute PMADRH.0;
  PMDATL              : byte absolute $0022;
  PMDATH              : byte absolute $0023;
  PMDATH_PMDATH5      : bit  absolute PMDATH.5;
  PMDATH_PMDATH4      : bit  absolute PMDATH.4;
  PMDATH_PMDATH3      : bit  absolute PMDATH.3;
  PMDATH_PMDATH2      : bit  absolute PMDATH.2;
  PMDATH_PMDATH1      : bit  absolute PMDATH.1;
  PMDATH_PMDATH0      : bit  absolute PMDATH.0;
  PMCON1              : byte absolute $0024;
  PMCON1_CFGS         : bit  absolute PMCON1.6;
  PMCON1_LWLO         : bit  absolute PMCON1.5;
  PMCON1_FREE         : bit  absolute PMCON1.4;
  PMCON1_WRERR        : bit  absolute PMCON1.3;
  PMCON1_WREN         : bit  absolute PMCON1.2;
  PMCON1_WR           : bit  absolute PMCON1.1;
  PMCON1_RD           : bit  absolute PMCON1.0;
  PMCON2              : byte absolute $0025;
  CLKRCON             : byte absolute $0026;
  CLKRCON_CLKROE      : bit  absolute CLKRCON.6;
  NCO1ACCL            : byte absolute $0027;
  NCO1ACCL_NCO1ACC7   : bit  absolute NCO1ACCL.7;
  NCO1ACCL_NCO1ACC6   : bit  absolute NCO1ACCL.6;
  NCO1ACCL_NCO1ACC5   : bit  absolute NCO1ACCL.5;
  NCO1ACCL_NCO1ACC4   : bit  absolute NCO1ACCL.4;
  NCO1ACCL_NCO1ACC3   : bit  absolute NCO1ACCL.3;
  NCO1ACCL_NCO1ACC2   : bit  absolute NCO1ACCL.2;
  NCO1ACCL_NCO1ACC1   : bit  absolute NCO1ACCL.1;
  NCO1ACCL_NCO1ACC0   : bit  absolute NCO1ACCL.0;
  NCO1ACCH            : byte absolute $0028;
  NCO1ACCH_NCO1ACC15  : bit  absolute NCO1ACCH.7;
  NCO1ACCH_NCO1ACC14  : bit  absolute NCO1ACCH.6;
  NCO1ACCH_NCO1ACC13  : bit  absolute NCO1ACCH.5;
  NCO1ACCH_NCO1ACC12  : bit  absolute NCO1ACCH.4;
  NCO1ACCH_NCO1ACC11  : bit  absolute NCO1ACCH.3;
  NCO1ACCH_NCO1ACC10  : bit  absolute NCO1ACCH.2;
  NCO1ACCH_NCO1ACC9   : bit  absolute NCO1ACCH.1;
  NCO1ACCH_NCO1ACC8   : bit  absolute NCO1ACCH.0;
  NCO1ACCU            : byte absolute $0029;
  NCO1ACCU_NCO1ACC19  : bit  absolute NCO1ACCU.3;
  NCO1ACCU_NCO1ACC18  : bit  absolute NCO1ACCU.2;
  NCO1ACCU_NCO1ACC17  : bit  absolute NCO1ACCU.1;
  NCO1ACCU_NCO1ACC16  : bit  absolute NCO1ACCU.0;
  NCO1INCL            : byte absolute $002A;
  NCO1INCL_NCO1INC7   : bit  absolute NCO1INCL.7;
  NCO1INCL_NCO1INC6   : bit  absolute NCO1INCL.6;
  NCO1INCL_NCO1INC5   : bit  absolute NCO1INCL.5;
  NCO1INCL_NCO1INC4   : bit  absolute NCO1INCL.4;
  NCO1INCL_NCO1INC3   : bit  absolute NCO1INCL.3;
  NCO1INCL_NCO1INC2   : bit  absolute NCO1INCL.2;
  NCO1INCL_NCO1INC1   : bit  absolute NCO1INCL.1;
  NCO1INCL_NCO1INC0   : bit  absolute NCO1INCL.0;
  NCO1INCH            : byte absolute $002B;
  NCO1INCH_NCO1INC15  : bit  absolute NCO1INCH.7;
  NCO1INCH_NCO1INC14  : bit  absolute NCO1INCH.6;
  NCO1INCH_NCO1INC13  : bit  absolute NCO1INCH.5;
  NCO1INCH_NCO1INC12  : bit  absolute NCO1INCH.4;
  NCO1INCH_NCO1INC11  : bit  absolute NCO1INCH.3;
  NCO1INCH_NCO1INC10  : bit  absolute NCO1INCH.2;
  NCO1INCH_NCO1INC9   : bit  absolute NCO1INCH.1;
  NCO1INCH_NCO1INC8   : bit  absolute NCO1INCH.0;
  NCO1INCU            : byte absolute $002C;
  NCO1CON             : byte absolute $002D;
  NCO1CON_N1EN        : bit  absolute NCO1CON.7;
  NCO1CON_N1OE        : bit  absolute NCO1CON.6;
  NCO1CON_N1OUT       : bit  absolute NCO1CON.5;
  NCO1CON_N1POL       : bit  absolute NCO1CON.4;
  NCO1CON_N1PFM       : bit  absolute NCO1CON.0;
  NCO1CLK             : byte absolute $002E;
  NCO1CLK_N1PWS2      : bit  absolute NCO1CLK.7;
  NCO1CLK_N1PWS1      : bit  absolute NCO1CLK.6;
  NCO1CLK_N1PWS0      : bit  absolute NCO1CLK.5;
  NCO1CLK_N1CKS3      : bit  absolute NCO1CLK.3;
  NCO1CLK_N1CKS2      : bit  absolute NCO1CLK.2;
  NCO1CLK_N1CKS1      : bit  absolute NCO1CLK.1;
  NCO1CLK_N1CKS0      : bit  absolute NCO1CLK.0;
  WDTCON              : byte absolute $0030;
  WDTCON_WDTPS4       : bit  absolute WDTCON.5;
  WDTCON_WDTPS3       : bit  absolute WDTCON.4;
  WDTCON_WDTPS2       : bit  absolute WDTCON.3;
  WDTCON_WDTPS1       : bit  absolute WDTCON.2;
  WDTCON_WDTPS0       : bit  absolute WDTCON.1;
  WDTCON_SWDTEN       : bit  absolute WDTCON.0;
  CLC1CON             : byte absolute $0031;
  CLC1CON_LC1EN       : bit  absolute CLC1CON.7;
  CLC1CON_LC1OE       : bit  absolute CLC1CON.6;
  CLC1CON_LC1OUT      : bit  absolute CLC1CON.5;
  CLC1CON_LC1INTP     : bit  absolute CLC1CON.4;
  CLC1CON_LC1INTN     : bit  absolute CLC1CON.3;
  CLC1CON_LC1MODE2    : bit  absolute CLC1CON.2;
  CLC1CON_LC1MODE1    : bit  absolute CLC1CON.1;
  CLC1CON_LC1MODE0    : bit  absolute CLC1CON.0;
  CLC1SEL0            : byte absolute $0032;
  CLC1SEL0_LC1D2S2    : bit  absolute CLC1SEL0.6;
  CLC1SEL0_LC1D2S1    : bit  absolute CLC1SEL0.5;
  CLC1SEL0_LC1D2S0    : bit  absolute CLC1SEL0.4;
  CLC1SEL0_LC1D1S2    : bit  absolute CLC1SEL0.2;
  CLC1SEL0_LC1D1S1    : bit  absolute CLC1SEL0.1;
  CLC1SEL0_LC1D1S0    : bit  absolute CLC1SEL0.0;
  CLC1SEL1            : byte absolute $0033;
  CLC1SEL1_LC1D4S2    : bit  absolute CLC1SEL1.6;
  CLC1SEL1_LC1D4S1    : bit  absolute CLC1SEL1.5;
  CLC1SEL1_LC1D4S0    : bit  absolute CLC1SEL1.4;
  CLC1SEL1_LC1D3S2    : bit  absolute CLC1SEL1.2;
  CLC1SEL1_LC1D3S1    : bit  absolute CLC1SEL1.1;
  CLC1SEL1_LC1D3S0    : bit  absolute CLC1SEL1.0;
  CLC1POL             : byte absolute $0034;
  CLC1POL_LC1POL      : bit  absolute CLC1POL.7;
  CLC1POL_LC1G4POL    : bit  absolute CLC1POL.3;
  CLC1POL_LC1G3POL    : bit  absolute CLC1POL.2;
  CLC1POL_LC1G2POL    : bit  absolute CLC1POL.1;
  CLC1POL_LC1G1POL    : bit  absolute CLC1POL.0;
  CLC1GLS0            : byte absolute $0035;
  CLC1GLS0_LC1G1D4T   : bit  absolute CLC1GLS0.7;
  CLC1GLS0_LC1G1D4N   : bit  absolute CLC1GLS0.6;
  CLC1GLS0_LC1G1D3T   : bit  absolute CLC1GLS0.5;
  CLC1GLS0_LC1G1D3N   : bit  absolute CLC1GLS0.4;
  CLC1GLS0_LC1G1D2T   : bit  absolute CLC1GLS0.3;
  CLC1GLS0_LC1G1D2N   : bit  absolute CLC1GLS0.2;
  CLC1GLS0_LC1G1D1T   : bit  absolute CLC1GLS0.1;
  CLC1GLS0_LC1G1D1N   : bit  absolute CLC1GLS0.0;
  CLC1GLS1            : byte absolute $0036;
  CLC1GLS1_LC1G2D4T   : bit  absolute CLC1GLS1.7;
  CLC1GLS1_LC1G2D4N   : bit  absolute CLC1GLS1.6;
  CLC1GLS1_LC1G2D3T   : bit  absolute CLC1GLS1.5;
  CLC1GLS1_LC1G2D3N   : bit  absolute CLC1GLS1.4;
  CLC1GLS1_LC1G2D2T   : bit  absolute CLC1GLS1.3;
  CLC1GLS1_LC1G2D2N   : bit  absolute CLC1GLS1.2;
  CLC1GLS1_LC1G2D1T   : bit  absolute CLC1GLS1.1;
  CLC1GLS1_LC1G2D1N   : bit  absolute CLC1GLS1.0;
  CLC1GLS2            : byte absolute $0037;
  CLC1GLS2_LC1G3D4T   : bit  absolute CLC1GLS2.7;
  CLC1GLS2_LC1G3D4N   : bit  absolute CLC1GLS2.6;
  CLC1GLS2_LC1G3D3T   : bit  absolute CLC1GLS2.5;
  CLC1GLS2_LC1G3D3N   : bit  absolute CLC1GLS2.4;
  CLC1GLS2_LC1G3D2T   : bit  absolute CLC1GLS2.3;
  CLC1GLS2_LC1G3D2N   : bit  absolute CLC1GLS2.2;
  CLC1GLS2_LC1G3D1T   : bit  absolute CLC1GLS2.1;
  CLC1GLS2_LC1G3D1N   : bit  absolute CLC1GLS2.0;
  CLC1GLS3            : byte absolute $0038;
  CLC1GLS3_LC1G4D4T   : bit  absolute CLC1GLS3.7;
  CLC1GLS3_LC1G4D4N   : bit  absolute CLC1GLS3.6;
  CLC1GLS3_LC1G4D3T   : bit  absolute CLC1GLS3.5;
  CLC1GLS3_LC1G4D3N   : bit  absolute CLC1GLS3.4;
  CLC1GLS3_LC1G4D2T   : bit  absolute CLC1GLS3.3;
  CLC1GLS3_LC1G4D2N   : bit  absolute CLC1GLS3.2;
  CLC1GLS3_LC1G4D1T   : bit  absolute CLC1GLS3.1;
  CLC1GLS3_LC1G4D1N   : bit  absolute CLC1GLS3.0;
  CWG1CON0            : byte absolute $0039;
  CWG1CON0_G1EN       : bit  absolute CWG1CON0.7;
  CWG1CON0_G1OEB      : bit  absolute CWG1CON0.6;
  CWG1CON0_G1OEA      : bit  absolute CWG1CON0.5;
  CWG1CON0_G1POLB     : bit  absolute CWG1CON0.4;
  CWG1CON0_G1POLA     : bit  absolute CWG1CON0.3;
  CWG1CON0_G1CS0      : bit  absolute CWG1CON0.0;
  CWG1CON1            : byte absolute $003A;
  CWG1CON1_G1ASDLB1   : bit  absolute CWG1CON1.7;
  CWG1CON1_G1ASDLB0   : bit  absolute CWG1CON1.6;
  CWG1CON1_G1ASDLA1   : bit  absolute CWG1CON1.5;
  CWG1CON1_G1ASDLA0   : bit  absolute CWG1CON1.4;
  CWG1CON1_G1IS1      : bit  absolute CWG1CON1.1;
  CWG1CON1_G1IS0      : bit  absolute CWG1CON1.0;
  CWG1CON2            : byte absolute $003B;
  CWG1CON2_G1ASE      : bit  absolute CWG1CON2.7;
  CWG1CON2_G1ARSEN    : bit  absolute CWG1CON2.6;
  CWG1CON2_G1ASDSCLC1 : bit  absolute CWG1CON2.1;
  CWG1CON2_G1ASDSFLT  : bit  absolute CWG1CON2.0;
  CWG1DBR             : byte absolute $003C;
  CWG1DBR_CWG1DBR5    : bit  absolute CWG1DBR.5;
  CWG1DBR_CWG1DBR4    : bit  absolute CWG1DBR.4;
  CWG1DBR_CWG1DBR3    : bit  absolute CWG1DBR.3;
  CWG1DBR_CWG1DBR2    : bit  absolute CWG1DBR.2;
  CWG1DBR_CWG1DBR1    : bit  absolute CWG1DBR.1;
  CWG1DBR_CWG1DBR0    : bit  absolute CWG1DBR.0;
  CWG1DBF             : byte absolute $003D;
  CWG1DBF_CWG1DBF5    : bit  absolute CWG1DBF.5;
  CWG1DBF_CWG1DBF4    : bit  absolute CWG1DBF.4;
  CWG1DBF_CWG1DBF3    : bit  absolute CWG1DBF.3;
  CWG1DBF_CWG1DBF2    : bit  absolute CWG1DBF.2;
  CWG1DBF_CWG1DBF1    : bit  absolute CWG1DBF.1;
  CWG1DBF_CWG1DBF0    : bit  absolute CWG1DBF.0;
  VREGCON             : byte absolute $003E;
  VREGCON_VREGPM1     : bit  absolute VREGCON.1;
  VREGCON_VREGPM0     : bit  absolute VREGCON.0;
  BORCON              : byte absolute $003F;
  BORCON_SBOREN       : bit  absolute BORCON.7;
  BORCON_BORFS        : bit  absolute BORCON.6;
  BORCON_BORRDY       : bit  absolute BORCON.0;


  // -- Define RAM state values --

  {$CLEAR_STATE_RAM}

  {$SET_STATE_RAM '000-02E:SFR'}            // Bank 0 : INDF, TMR0, PCL, STATUS, FSR, PORTA, TRISA, LATA, ANSELA, WPUA, PCLATH, INTCON, PIR1, PIE1, OPTION_REG, PCON, OSCCON, TMR2, PR2, T2CON, PWM1DCL, PWM1DCH, PWM1CON, PWM2DCL, PWM2DCH, PWM2CON, IOCAP, IOCAN, IOCAF, FVRCON, ADRES, ADCON, PMADRL, PMADRH, PMDATL, PMDATH, PMCON1, PMCON2, CLKRCON, NCO1ACCL, NCO1ACCH, NCO1ACCU, NCO1INCL, NCO1INCH, NCO1INCU, NCO1CON, NCO1CLK
  {$SET_STATE_RAM '030-03F:SFR'}            // Bank 0 : WDTCON, CLC1CON, CLC1SEL0, CLC1SEL1, CLC1POL, CLC1GLS0, CLC1GLS1, CLC1GLS2, CLC1GLS3, CWG1CON0, CWG1CON1, CWG1CON2, CWG1DBR, CWG1DBF, VREGCON, BORCON
  {$SET_STATE_RAM '040-07F:GPR'}           


  // -- Un-implemented fields --

  {$SET_UNIMP_BITS '005:0F'} // PORTA bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '006:0F'} // TRISA bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '007:07'} // LATA bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '008:07'} // ANSELA bits 7,6,5,4,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '009:0F'} // WPUA bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00A:01'} // PCLATH bits 7,6,5,4,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00C:5A'} // PIR1 bits 7,5,2,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00D:5A'} // PIE1 bits 7,5,2,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00F:03'} // PCON bits 7,6,5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '010:7B'} // OSCCON bits 7,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '013:7F'} // T2CON bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '014:C0'} // PWM1DCL bits 5,4,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '016:F0'} // PWM1CON bits 3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '017:C0'} // PWM2DCL bits 5,4,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '019:F0'} // PWM2CON bits 3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01A:0F'} // IOCAP bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01B:0F'} // IOCAN bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01C:0F'} // IOCAF bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01D:F3'} // FVRCON bits 3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '021:01'} // PMADRH bits 7,6,5,4,3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '023:3F'} // PMDATH bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '026:40'} // CLKRCON bits 7,5,4,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '029:0F'} // NCO1ACCU bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '02C:00'} // NCO1INCU bits 7,6,5,4,3,2,1,0 un-implemented (read as 0)
  {$SET_UNIMP_BITS '02D:F1'} // NCO1CON bits 3,2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '02E:E3'} // NCO1CLK bits 4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '030:3F'} // WDTCON bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '032:77'} // CLC1SEL0 bits 7,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '033:77'} // CLC1SEL1 bits 7,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '034:8F'} // CLC1POL bits 6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '039:F9'} // CWG1CON0 bits 2,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '03A:F3'} // CWG1CON1 bits 3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '03B:C3'} // CWG1CON2 bits 5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '03C:3F'} // CWG1DBR bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '03D:3F'} // CWG1DBF bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '03E:03'} // VREGCON bits 7,6,5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '03F:C1'} // BORCON bits 5,4,3,2,1 un-implemented (read as 0)

  {$SET_UNIMP_BITS1 '024:80'} // PMCON1 bit 7 un-implemented (read as 1)


  // -- PIN mapping --

  // Pin  1 : RA0/PWM1/CLC1IN1/CWG1A/AN0/ICSPDAT
  // Pin  2 : RA1/PWM2/CLC1/CWG1B/AN1/CLKIN/ICSPCLK/NCO1CLK
  // Pin  3 : RA2/INT/T0CKI/NCO1/CLC1IN2/CLKR/AN2/CWG1FLT
  // Pin  4 : RA3/MCLR/VPP
  // Pin  5 : VDD
  // Pin  6 : VSS


  // -- RAM to PIN mapping --

  {$MAP_RAM_TO_PIN '005:0-1,1-2,2-3,3-4'} // PORTA


  // -- Bits Configuration --

  // FOSC : Oscillator Selection bits
  {$define _FOSC_INTOSC  = $3FFE}  // INTOSC oscillator: CLKIN function disabled
  {$define _FOSC_EC      = $3FFF}  // EC: CLKIN function enabled

  // BOREN : Brown-out Reset Enable
  {$define _BOREN_ON     = $3FFF}  // Brown-out Reset enabled
  {$define _BOREN_NSLEEP = $3FFD}  // Brown-out Reset enabled while running and disabled in Sleep
  {$define _BOREN_SBODEN = $3FFB}  // Brown-out Reset controlled by the SBOREN bit in the BORCON register
  {$define _BOREN_OFF    = $3FF9}  // Brown-out Reset disabled

  // WDTE : Watchdog Timer Enable
  {$define _WDTE_ON      = $3FFF}  // WDT enabled
  {$define _WDTE_NSLEEP  = $3FF7}  // WDT enabled while running and disabled in Sleep
  {$define _WDTE_SWDTEN  = $3FEF}  // WDT controlled by the SWDTEN bit in the WDTCON register
  {$define _WDTE_OFF     = $3FE7}  // WDT disabled

  // PWRTE : Power-up Timer Enable bit
  {$define _PWRTE_OFF    = $3FFF}  // PWRT disabled
  {$define _PWRTE_ON     = $3FDF}  // PWRT enabled

  // MCLRE : MCLR Pin Function Select bit
  {$define _MCLRE_ON     = $3FFF}  // MCLR pin function is MCLR
  {$define _MCLRE_OFF    = $3FBF}  // MCLR pin function is digital input, MCLR internally tied to VDD

  // CP : Code Protection bit
  {$define _CP_OFF       = $3FFF}  // Program memory code protection is disabled
  {$define _CP_ON        = $3F7F}  // Program memory code protection is enabled

  // LVP : Low-Voltage Programming Enable
  {$define _LVP_ON       = $3FFF}  // Low-voltage programming enabled
  {$define _LVP_OFF      = $3EFF}  // High-voltage on MCLR/VPP must be used for programming

  // LPBOR : Brown-out Reset Selection bits
  {$define _LPBOR_ON     = $3FFF}  // BOR enabled
  {$define _LPBOR_OFF    = $3DFF}  // BOR disabled

  // BORV : Brown-out Reset Voltage Selection
  {$define _BORV_LO      = $3FFF}  // Brown-out Reset Voltage (Vbor), low trip point selected.
  {$define _BORV_HI      = $3BFF}  // Brown-out Reset Voltage (Vbor), high trip point selected.

  // WRT : Flash Memory Self-Write Protection
  {$define _WRT_OFF      = $3FFF}  // Write protection off
  {$define _WRT_BOOT     = $37FF}  // 000h to 07Fh write protected, 080h to 1FFh may be modified by PMCON control
  {$define _WRT_HALF     = $2FFF}  // 000h to 0FFh write protected, 100h to 1FFh may be modified by PMCON control
  {$define _WRT_ALL      = $27FF}  // 000h to 1FFh write protected, no addresses may be modified by PMCON control

implementation
end.
