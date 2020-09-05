unit PIC12F635;

// Define hardware
{$SET PIC_MODEL    = 'PIC12F635'}
{$SET PIC_MAXFREQ  = 20000000}
{$SET PIC_NPINS    = 8}
{$SET PIC_NUMBANKS = 4}
{$SET PIC_NUMPAGES = 1}
{$SET PIC_MAXFLASH = 1024}

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
  GPIO              : byte absolute $0005;
  GPIO_GP5          : bit  absolute GPIO.5;
  GPIO_GP4          : bit  absolute GPIO.4;
  GPIO_GP3          : bit  absolute GPIO.3;
  GPIO_GP2          : bit  absolute GPIO.2;
  GPIO_GP1          : bit  absolute GPIO.1;
  GPIO_GP0          : bit  absolute GPIO.0;
  PCLATH            : byte absolute $000A;
  PCLATH_PCLATH4    : bit  absolute PCLATH.4;
  PCLATH_PCLATH3    : bit  absolute PCLATH.3;
  PCLATH_PCLATH2    : bit  absolute PCLATH.2;
  PCLATH_PCLATH1    : bit  absolute PCLATH.1;
  PCLATH_PCLATH0    : bit  absolute PCLATH.0;
  INTCON            : byte absolute $000B;
  INTCON_GIE        : bit  absolute INTCON.7;
  INTCON_PEIE       : bit  absolute INTCON.6;
  INTCON_T0IE       : bit  absolute INTCON.5;
  INTCON_INTE       : bit  absolute INTCON.4;
  INTCON_RAIE       : bit  absolute INTCON.3;
  INTCON_T0IF       : bit  absolute INTCON.2;
  INTCON_INTF       : bit  absolute INTCON.1;
  INTCON_RAIF       : bit  absolute INTCON.0;
  PIR1              : byte absolute $000C;
  PIR1_EEIF         : bit  absolute PIR1.7;
  PIR1_LVDIF        : bit  absolute PIR1.6;
  PIR1_CRIF         : bit  absolute PIR1.5;
  PIR1_C1IF         : bit  absolute PIR1.3;
  PIR1_OSFIF        : bit  absolute PIR1.2;
  PIR1_TMR1IF       : bit  absolute PIR1.0;
  TMR1L             : byte absolute $000E;
  TMR1H             : byte absolute $000F;
  T1CON             : byte absolute $0010;
  T1CON_T1GINV      : bit  absolute T1CON.7;
  T1CON_TMR1GE      : bit  absolute T1CON.6;
  T1CON_T1CKPS1     : bit  absolute T1CON.5;
  T1CON_T1CKPS0     : bit  absolute T1CON.4;
  T1CON_T1OSCEN     : bit  absolute T1CON.3;
  T1CON_nT1SYNC     : bit  absolute T1CON.2;
  T1CON_TMR1CS      : bit  absolute T1CON.1;
  T1CON_TMR1ON      : bit  absolute T1CON.0;
  WDTCON            : byte absolute $0018;
  WDTCON_WDTPS3     : bit  absolute WDTCON.4;
  WDTCON_WDTPS2     : bit  absolute WDTCON.3;
  WDTCON_WDTPS1     : bit  absolute WDTCON.2;
  WDTCON_WDTPS0     : bit  absolute WDTCON.1;
  WDTCON_SWDTEN     : bit  absolute WDTCON.0;
  CMCON0            : byte absolute $0019;
  CMCON0_COUT       : bit  absolute CMCON0.6;
  CMCON0_CINV       : bit  absolute CMCON0.4;
  CMCON0_CIS        : bit  absolute CMCON0.3;
  CMCON0_CM2        : bit  absolute CMCON0.2;
  CMCON0_CM1        : bit  absolute CMCON0.1;
  CMCON0_CM0        : bit  absolute CMCON0.0;
  CMCON1            : byte absolute $001A;
  CMCON1_T1GSS      : bit  absolute CMCON1.1;
  CMCON1_CMSYNC     : bit  absolute CMCON1.0;
  OPTION_REG        : byte absolute $0081;
  OPTION_REG_nRAPU  : bit  absolute OPTION_REG.7;
  OPTION_REG_INTEDG : bit  absolute OPTION_REG.6;
  OPTION_REG_T0CS   : bit  absolute OPTION_REG.5;
  OPTION_REG_T0SE   : bit  absolute OPTION_REG.4;
  OPTION_REG_PSA    : bit  absolute OPTION_REG.3;
  OPTION_REG_PS2    : bit  absolute OPTION_REG.2;
  OPTION_REG_PS1    : bit  absolute OPTION_REG.1;
  OPTION_REG_PS0    : bit  absolute OPTION_REG.0;
  TRISIO            : byte absolute $0085;
  TRISIO_TRISIO5    : bit  absolute TRISIO.5;
  TRISIO_TRISIO4    : bit  absolute TRISIO.4;
  TRISIO_TRISIO3    : bit  absolute TRISIO.3;
  TRISIO_TRISIO2    : bit  absolute TRISIO.2;
  TRISIO_TRISIO1    : bit  absolute TRISIO.1;
  TRISIO_TRISIO0    : bit  absolute TRISIO.0;
  PIE1              : byte absolute $008C;
  PIE1_EEIE         : bit  absolute PIE1.7;
  PIE1_LVDIE        : bit  absolute PIE1.6;
  PIE1_CRIE         : bit  absolute PIE1.5;
  PIE1_C1IE         : bit  absolute PIE1.3;
  PIE1_OSFIE        : bit  absolute PIE1.2;
  PIE1_TMR1IE       : bit  absolute PIE1.0;
  PCON              : byte absolute $008E;
  PCON_ULPWUE       : bit  absolute PCON.5;
  PCON_SBOREN       : bit  absolute PCON.4;
  PCON_nWUR         : bit  absolute PCON.3;
  PCON_nPOR         : bit  absolute PCON.1;
  PCON_nBOR         : bit  absolute PCON.0;
  OSCCON            : byte absolute $008F;
  OSCCON_IRCF2      : bit  absolute OSCCON.6;
  OSCCON_IRCF1      : bit  absolute OSCCON.5;
  OSCCON_IRCF0      : bit  absolute OSCCON.4;
  OSCCON_OSTS       : bit  absolute OSCCON.3;
  OSCCON_HTS        : bit  absolute OSCCON.2;
  OSCCON_LTS        : bit  absolute OSCCON.1;
  OSCCON_SCS        : bit  absolute OSCCON.0;
  OSCTUNE           : byte absolute $0090;
  OSCTUNE_TUN4      : bit  absolute OSCTUNE.4;
  OSCTUNE_TUN3      : bit  absolute OSCTUNE.3;
  OSCTUNE_TUN2      : bit  absolute OSCTUNE.2;
  OSCTUNE_TUN1      : bit  absolute OSCTUNE.1;
  OSCTUNE_TUN0      : bit  absolute OSCTUNE.0;
  LVDCON            : byte absolute $0094;
  LVDCON_IRVST      : bit  absolute LVDCON.5;
  LVDCON_LVDEN      : bit  absolute LVDCON.4;
  LVDCON_LVDL2      : bit  absolute LVDCON.2;
  LVDCON_LVDL1      : bit  absolute LVDCON.1;
  LVDCON_LVDL0      : bit  absolute LVDCON.0;
  WPUDA             : byte absolute $0095;
  WPUDA_WPUDA5      : bit  absolute WPUDA.5;
  WPUDA_WPUDA4      : bit  absolute WPUDA.4;
  WPUDA_WPUDA2      : bit  absolute WPUDA.2;
  WPUDA_WPUDA1      : bit  absolute WPUDA.1;
  WPUDA_WPUDA0      : bit  absolute WPUDA.0;
  IOCA              : byte absolute $0096;
  IOCA_IOCA5        : bit  absolute IOCA.5;
  IOCA_IOCA4        : bit  absolute IOCA.4;
  IOCA_IOCA3        : bit  absolute IOCA.3;
  IOCA_IOCA2        : bit  absolute IOCA.2;
  IOCA_IOCA1        : bit  absolute IOCA.1;
  IOCA_IOCA0        : bit  absolute IOCA.0;
  WDA               : byte absolute $0097;
  WDA_WDA5          : bit  absolute WDA.5;
  WDA_WDA4          : bit  absolute WDA.4;
  WDA_WDA2          : bit  absolute WDA.2;
  WDA_WDA1          : bit  absolute WDA.1;
  WDA_WDA0          : bit  absolute WDA.0;
  VRCON             : byte absolute $0099;
  VRCON_VREN        : bit  absolute VRCON.7;
  VRCON_VRR         : bit  absolute VRCON.5;
  VRCON_VR3         : bit  absolute VRCON.3;
  VRCON_VR2         : bit  absolute VRCON.2;
  VRCON_VR1         : bit  absolute VRCON.1;
  VRCON_VR0         : bit  absolute VRCON.0;
  EEDAT             : byte absolute $009A;
  EEADR             : byte absolute $009B;
  EECON1            : byte absolute $009C;
  EECON1_WRERR      : bit  absolute EECON1.3;
  EECON1_WREN       : bit  absolute EECON1.2;
  EECON1_WR         : bit  absolute EECON1.1;
  EECON1_RD         : bit  absolute EECON1.0;
  EECON2            : byte absolute $009D;
  CRCON             : byte absolute $0110;
  CRCON_GO_nDONE    : bit  absolute CRCON.7;
  CRCON_ENC_nDEC    : bit  absolute CRCON.6;
  CRCON_CRREG1      : bit  absolute CRCON.1;
  CRCON_CRREG0      : bit  absolute CRCON.0;
  CRDAT0            : byte absolute $0111;
  CRDAT1            : byte absolute $0112;
  CRDAT2            : byte absolute $0113;
  CRDAT3            : byte absolute $0114;


  // -- Define RAM state values --

  {$CLEAR_STATE_RAM}

  {$SET_STATE_RAM '000-000:SFR:ALLMAPPED'}  // Banks 0-3 : INDF
  {$SET_STATE_RAM '001-001:SFR:ALL'}        // Bank 0 : TMR0
                                            // Bank 1 : OPTION_REG
                                            // Bank 2 : TMR0
                                            // Bank 3 : OPTION_REG
  {$SET_STATE_RAM '002-004:SFR:ALLMAPPED'}  // Banks 0-3 : PCL, STATUS, FSR
  {$SET_STATE_RAM '005-005:SFR:ALL'}        // Bank 0 : GPIO
                                            // Bank 1 : TRISIO
                                            // Bank 2 : GPIO
                                            // Bank 3 : TRISIO
  {$SET_STATE_RAM '00A-00B:SFR:ALLMAPPED'}  // Banks 0-3 : PCLATH, INTCON
  {$SET_STATE_RAM '00C-00C:SFR'}            // Bank 0 : PIR1
  {$SET_STATE_RAM '00E-010:SFR'}            // Bank 0 : TMR1L, TMR1H, T1CON
  {$SET_STATE_RAM '018-01A:SFR'}            // Bank 0 : WDTCON, CMCON0, CMCON1
  {$SET_STATE_RAM '040-06F:GPR'}           
  {$SET_STATE_RAM '070-07F:GPR:ALLMAPPED'} 
  {$SET_STATE_RAM '08C-08C:SFR'}            // Bank 1 : PIE1
  {$SET_STATE_RAM '08E-090:SFR'}            // Bank 1 : PCON, OSCCON, OSCTUNE
  {$SET_STATE_RAM '094-097:SFR'}            // Bank 1 : LVDCON, WPUDA, IOCA, WDA
  {$SET_STATE_RAM '099-09D:SFR'}            // Bank 1 : VRCON, EEDAT, EEADR, EECON1, EECON2
  {$SET_STATE_RAM '110-114:SFR'}            // Bank 2 : CRCON, CRDAT0, CRDAT1, CRDAT2, CRDAT3


  // -- Define mapped RAM --

  {$SET_MAPPED_RAM '101-101:bnk0'} // maps to TMR0 (bank 0)
  {$SET_MAPPED_RAM '105-105:bnk0'} // maps to GPIO (bank 0)
  {$SET_MAPPED_RAM '181-181:bnk1'} // maps to OPTION_REG (bank 1)
  {$SET_MAPPED_RAM '185-185:bnk1'} // maps to TRISIO (bank 1)


  // -- Un-implemented fields --

  {$SET_UNIMP_BITS '005:3F'} // GPIO bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00A:1F'} // PCLATH bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '00C:ED'} // PIR1 bits 4,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '018:1F'} // WDTCON bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '019:5F'} // CMCON0 bits 7,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '01A:03'} // CMCON1 bits 7,6,5,4,3,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '085:3F'} // TRISIO bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '08C:ED'} // PIE1 bits 4,1 un-implemented (read as 0)
  {$SET_UNIMP_BITS '08E:3B'} // PCON bits 7,6,2 un-implemented (read as 0)
  {$SET_UNIMP_BITS '08F:7F'} // OSCCON bit 7 un-implemented (read as 0)
  {$SET_UNIMP_BITS '090:1F'} // OSCTUNE bits 7,6,5 un-implemented (read as 0)
  {$SET_UNIMP_BITS '094:37'} // LVDCON bits 7,6,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '095:37'} // WPUDA bits 7,6,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '096:3F'} // IOCA bits 7,6 un-implemented (read as 0)
  {$SET_UNIMP_BITS '097:37'} // WDA bits 7,6,3 un-implemented (read as 0)
  {$SET_UNIMP_BITS '099:AF'} // VRCON bits 6,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '09C:0F'} // EECON1 bits 7,6,5,4 un-implemented (read as 0)
  {$SET_UNIMP_BITS '110:C3'} // CRCON bits 5,4,3,2 un-implemented (read as 0)


  // -- PIN mapping --

  // Pin  1 : Vdd
  // Pin  2 : GP5/T1CKI/OSC1/CLKIN
  // Pin  3 : GP4/T1G/OSC2/CLKOUT
  // Pin  4 : GP3/MCLR/Vpp
  // Pin  5 : GP2/T0CKI/INT/C1OUT
  // Pin  6 : GP1/C1IN-/ICSPCLK
  // Pin  7 : GP0/C1IN+/ICSPDAT/ULPWU
  // Pin  8 : Vss


  // -- RAM to PIN mapping --

  {$MAP_RAM_TO_PIN '005:0-7,1-6,2-5,3-4,4-3,5-2'} // GPIO


  // -- Bits Configuration --

  // FOSC : Oscillator Selection bits
  {$define _FOSC_EXTRCCLK  = $3FFF}  // RC oscillator: CLKOUT function on RA4/T1G/OSC2/CLKOUT pin, RC on RA5/T1CKI/OSC1/CLKIN
  {$define _FOSC_EXTRCIO   = $3FFE}  // RCIO oscillator: I/O function on RA4/T1G/OSC2/CLKOUT pin, RC on RA5/T1CKI/OSC1/CLKIN
  {$define _FOSC_INTOSCCLK = $3FFD}  // INTOSC oscillator: CLKOUT function on RA4/T1G/OSC2/CLKOUT pin, I/O function on RA5/T1CKI/OSC1/CLKIN
  {$define _FOSC_INTOSCIO  = $3FFC}  // INTOSCIO oscillator: I/O function on RA4/T1G/OSC2/CLKOUT pin, I/O function on RA5/T1CKI/OSC1/CLKIN
  {$define _FOSC_EC        = $3FFB}  // EC: I/O function on RA4/T1G/OSC2/CLKOUT, CLKIN on RA5/T1CKI/OSC1/CLKIN
  {$define _FOSC_HS        = $3FFA}  // HS oscillator: High-speed crystal/resonator on RA5/T1CKI/OSC1/CLKIN and RA4/T1G/OSC2/CLKOUT
  {$define _FOSC_XT        = $3FF9}  // XT oscillator: Crystal/resonator on RA5/T1CKI/OSC1/CLKIN and RA4/T1G/OSC2/CLKOUT
  {$define _FOSC_LP        = $3FF8}  // LP oscillator: Low-power crystal on RA5/T1CKI/OSC1/CLKIN and RA4/T1G/OSC2/CLKOUT

  // WDTE : Watchdog Timer Enable bit
  {$define _WDTE_ON        = $3FFF}  // WDT enabled
  {$define _WDTE_OFF       = $3FF7}  // WDT disabled and can be enabled by SWDTEN bit of the WDTCON register

  // PWRTE : Power-up Timer Enable bit
  {$define _PWRTE_OFF      = $3FFF}  // PWRT disabled
  {$define _PWRTE_ON       = $3FEF}  // PWRT enabled

  // MCLRE : MCLR pin function select bit
  {$define _MCLRE_ON       = $3FFF}  // MCLR pin is MCLR function and weak internal pull-up is enabled
  {$define _MCLRE_OFF      = $3FDF}  // MCLR pin function is alternate function, MCLR function is internally disabled

  // CP : Code Protection bit
  {$define _CP_OFF         = $3FFF}  // Program memory is not code protected
  {$define _CP_ON          = $3FBF}  // Program memory is external read and write-protected

  // CPD : Data Code Protection bit
  {$define _CPD_OFF        = $3FFF}  // Data memory is not code protected
  {$define _CPD_ON         = $3F7F}  // Data memory is external read protected

  // BOREN : Brown-out Reset Selection bits
  {$define _BOREN_ON       = $3FFF}  // BOD enabled and SBOdEN bit disabled
  {$define _BOREN_NSLEEP   = $3EFF}  // BOD enabled while running and disabled in Sleep. SBODEN bit disabled.
  {$define _BOREN_SBODEN   = $3DFF}  // SBODEN controls BOD function
  {$define _BOREN_OFF      = $3CFF}  // BOD and SBODEN disabled

  // IESO : Internal-External Switchover bit
  {$define _IESO_ON        = $3FFF}  // Internal External Switchover mode enabled
  {$define _IESO_OFF       = $3BFF}  // Internal External Switchover mode disabled

  // FCMEN : Fail-Safe Clock Monitor Enable bit
  {$define _FCMEN_ON       = $3FFF}  // Fail-Safe Clock Monitor enabled
  {$define _FCMEN_OFF      = $37FF}  // Fail-Safe Clock Monitor disabled

  // WURE : Wake-Up Reset Enable bit
  {$define _WURE_OFF       = $3FFF}  // Standard wake-up and continue enabled
  {$define _WURE_ON        = $2FFF}  // Wake-up and Reset enabled

implementation
end.
