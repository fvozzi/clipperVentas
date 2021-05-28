SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE ON
SET CENTURY ON
SET DATE BRITISH
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
DECLARE campos[2]
SELECT 1
USE PROVEEDO INDEX PROV_NUM, PROV_NOM
campos[1]="NUMERO"
campos[2]="NOMBRE"
SELECT 2
USE MPROVEED INDEX MPRO_NUM, MPRO_FEC
SELECT 3
USE CONTABLE INDEX CON_NUM
SELECT 4
USE DEUDORES INDEX DEU_NUM
STORE 0 TO RV
STORE 83 TO JJ
DO WHILE JJ = 83
SET COLOR TO W/N
RESTORE SCREEN FROM PANT1
SET COLOR TO W+/RB
@ 2,6 SAY "         INGRESO DE PAGOS A PROVEEDORES"
SET COLOR TO W/B
@ 8,14 CLEAR TO 14,69
@ 7,14,15,69 BOX &caja9
@ 9,18 SAY "Proveedor:"
@ 11,18 SAY "Fecha(dd/mm/aaaa):"
//@ 13,18 SAY "N£mero de Recibo:"
@ 13,18 SAY "Importe:"
STORE SPACE(30) TO RCLI
STORE DATE() TO RVENC
STORE 0 TO RNUM, RVALOR
@ 9,32 GET RCLI
READ
SAVE SCREEN TO MP1
SELECT 1
SET ORDER TO 2
SEEK RTRIM(RCLI)
IF EOF()
GO TOP
ENDIF
KEYBOARD CHR(4)
SET COLOR TO W/R
@ 4,30 CLEAR TO 21,70
@ 4,30,21,71 BOX &caja9
DBEDIT(5,31,20,70,campos,"finc")
RESTORE SCREEN FROM MP1
SET COLOR TO W/B
@ 9,32 SAY SPACE(30)
IF LASTKEY() = 13
STORE STR(NUMERO,6) TO RCLI
ENDIF
IF LASTKEY() = 27
STORE SPACE(6) TO RCLI
@ 9,32 GET RCLI
READ
ENDIF
SET ORDER TO 1
SEEK VAL(RCLI)
IF EOF()
LOOP
ENDIF
IF .NOT. EOF()
STORE NUMERO TO RCLI
STORE NOMBRE TO RNOMBRE
ENDIF
@ 9,32 SAY RCLI
@ 9,39 SAY RNOMBRE
@ 11,37 GET RVENC
//@ 12,36 GET RNUM PICTURE "###,###"
@ 13,27 GET RVALOR PICTURE "###,###.##"
READ
STORE RVENC TO RFECHA
STORE CTOD("01/07/1998") TO DESDE
STORE CTOD("31/12/2020") TO HASTA
@ 11,37 SAY RVENC
//@ 12,36 SAY RNUM PICTURE "###,###"
@ 13,27 SAY RVALOR PICTURE "###,###.##"
STORE RVALOR TO TFAC
STORE 1 TO VMENU
SET COLOR TO W/BR
@23,10 CLEAR TO 23,70
SET COLOR TO W+/RB
@ 23,13 PROMPT "CONTINUAR"
@ 23,37 PROMPT "CORREGIR"
@ 23,60 PROMPT "ANULAR"
MENU TO VMENU
IF VMENU = 2
LOOP
ENDIF
IF VMENU = 1 .AND. VMENU <> 3
        SELECT 2
        GO TOP
        STORE STR(0,6) TO BUSCAR 
        SEEK BUSCAR
        DO WHILE .NOT. EOF() .AND. NUMERO = RCLI .AND. TFAC > 0
                STORE SALDO TO R_IMP
                IF TMOV = 1
                        IF R_IMP > 0
                                RLOCK()
                                IF TFAC > SALDO
                                        TFAC = TFAC - SALDO
                                        REPLACE SALDO WITH 0
                                ENDIF
                                IF TFAC = SALDO
                                        TFAC = TFAC - SALDO
                                        REPLACE SALDO WITH 0
                                ENDIF
                                IF TFAC < SALDO
                                        REPLACE SALDO WITH SALDO - TFAC
                                        TFAC = 0
                                ENDIF
                                UNLOCK
                        ENDIF
                ENDIF
                SKIP
        ENDDO
        RLOCK()
        //STORE "000000" + LTRIM(STR(RNUM)) TO JK
        STORE "PAGO A " + RNOMBRE TO RCBTE
        GO TOP
        APPEND BLANK
        REPLACE NUMERO WITH RCLI, FECHA WITH RFECHA, TMOV WITH 2, CBTE WITH RCBTE, VALOR WITH RVALOR, SALDO WITH TFAC 
        UNLOCK
        SELECT 4
        RLOCK()
        REPLACE SALDO WITH SALDO + RVALOR FOR NUMERO = 0
        UNLOCK
        //SELECT 3
        //STORE 103 TO FH
        //SEEK FH
        //RLOCK()
        //REPLACE DEBITOS WITH DEBITOS + RVALOR
        //UNLOCK
        RV = RV + RVALOR
ENDIF
        SET COLOR TO W/BR
        @23,10 CLEAR TO 23,70
        SET COLOR TO W+/RB
        STORE 1 TO PMENU
        @ 23,20 PROMPT "OTRA COBRANZA"
        @ 23,52 PROMPT "FINALIZAR"
        MENU TO PMENU
        IF PMENU = 2
                STORE 84 TO JJ
                EXIT
        ENDIF

ENDDO
CLOSE ALL
RETURN
