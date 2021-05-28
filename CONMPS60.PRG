SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE ON
SET DATE BRITISH
SET CENTURY ON
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
USE NUMEROS
STORE RTRIM(NOMBRE) TO QNOM
STORE RTRIM(DOMICILIO) + " - " TO QDOM
QDOM = QDOM + RTRIM(LOCALIDAD)
STORE 83 TO JJ
STORE "" TO POS
DO WHILE JJ = 83
SET COLOR TO W/N
RESTORE SCREEN FROM PANT1
SET COLOR TO W+/RB
@ 2,6 SAY "           CONSULTA DE MOVIMIENTOS DE CUENTAS CORRIENTES"
SET COLOR TO W/B
@ 8,14 CLEAR TO 14,66
@ 7,14,15,66 BOX &caja9
@ 8,18 SAY "N£mero de Cuenta:"
@ 10,18 SAY "Desde Fecha(dd/mm/aaaa):"
@ 12,18 SAY "Hasta Fecha(dd/mm/aaaa):"
@ 14,18 SAY "Completo(S/N):"
STORE SPACE(6) TO RCLI
STORE CTOD("01/01/1992") TO DESDE
STORE CTOD("31/12/2030") TO HASTA
STORE "S" TO RPAR
STORE SPACE(6) TO RCLI
DO WHILE RCLI = "      "
        STORE SPACE(6) TO RCLI
        @ 8,42 GET RCLI
        READ
        IF LASTKEY() = 27
                CLOSE ALL
                RETURN
                JJ = 0
        ENDIF
        SELECT 1
        IF LASTKEY() = 18
                SAVE SCREEN TO MP1
                SEEK RCLI
                SET ORDER TO 2
                STORE 0 TO CONTROL
                ******** LA MANTIENE ABIERTA HASTA QUE PRESIONAMOS ESC *******
                DO WHILE EOF() .AND. CONTROL = 0
                        STORE 0 TO CONTROL
                        GO TOP
                        KEYBOARD CHR(4)
                        SET COLOR TO W/R
                        @ 4,30 CLEAR TO 21,70
                        @ 4,30,21,71 BOX &caja9
                        DBEDIT(5,31,20,70,campos,"arts")
                        ******* RESETA EL CONTADOR DE BUSQUEDA **************
                        IF LEN(POS)>= 1
                                POS = ""
                        ENDIF

                        RESTORE SCREEN FROM MP1
                        SET COLOR TO W/B
                        IF LASTKEY() = 13
                                STORE STR(NUMERO,6) TO RCLI
                        ENDIF
                        IF LASTKEY() = 27
                                STORE 1 TO CONTROL
                                STORE SPACE(6) TO RCLI
                                
                        ENDIF
                ENDDO
                RESTORE SCREEN FROM MP1
        ENDIF
ENDDO
@ 8,42 SAY RCLI
SET ORDER TO 1
SEEK VAL(RCLI)
IF EOF()
        LOOP
ENDIF
@ 10,44 GET DESDE
@ 12,44 GET HASTA
@ 14,33 GET RPAR
READ
IF .NOT. EOF()
STORE NUMERO TO RCLI
STORE NOMBRE TO RNOMBRE
ENDIF
IF HASTA < DESDE 
LOOP
ENDIF
IF RPAR <> "N" .AND. RPAR <> "S"
        LOOP
ENDIF
STORE 1 TO VMENU
SET COLOR TO W+/RB
@ 23,14 PROMPT "CONTINUAR"
@ 23,37 PROMPT "CORREGIR"
@ 23,58 PROMPT "FINALIZAR"
MENU TO VMENU
IF VMENU = 3
STORE 84 TO JJ
EXIT
ENDIF
IF VMENU = 2
LOOP
ENDIF
IF VMENU = 1
RESTORE SCREEN FROM PANTCC
SET COLOR TO W/R
STORE 1 TO HOJA
@ 4,8 SAY "Nombre:    "+NOMBRE
@ 4,59 SAY "Cta. N§"
@ 4,67 SAY RCLI PICTURE "999999"
@ 5,8 SAY "Domicilio: "+DOMICILIO
@ 5,59 SAY "Pagina N§"
@ 5,69 SAY HOJA PICTURE "9999"
@ 6,8 SAY "Localidad: "+LOCALIDAD
@ 6,53 SAY "Telefono:"
@ 6,63 SAY TELEFONO
STORE 10 TO LIN
SET COLOR TO W/N
SELECT 2
GO TOP
STORE 0 TO SL, FL
STORE STR(RCLI,6) TO BUSCAR 
SEEK BUSCAR

DO WHILE .NOT. EOF() .AND. NUMERO = RCLI
        IF FECHA > HASTA
                EXIT
        ENDIF
        IF RPAR = "N"
                STORE SALDO TO R_IMP
        ELSE
                STORE VALOR TO R_IMP
        ENDIF
        IF FECHA < DESDE
                IF TMOV = 1
                        SL = SL + R_IMP
                ENDIF
                IF TMOV = 2 .OR. TMOV = 7
                        SL = SL - R_IMP
                ENDIF
        ENDIF
        IF FECHA >= DESDE .AND. FECHA <= HASTA
                IF FL = 0
                        IF SL <> 0
                                @ LIN,19 SAY "SALDO ANTERIOR"
                                @ LIN,62 SAY SL PICTURE "###,###.##"
                                LIN = LIN + 1
                         ENDIF
                STORE 1 TO FL
        ENDIF
        IF R_IMP <> 0
                IF TMOV = 1
                        SL = SL + R_IMP
                ENDIF
                IF TMOV = 2 .OR. TMOV = 7
                        SL = SL - R_IMP
                ENDIF
        @ LIN,8 SAY FECHA
        @ LIN,19 SAY CBTE
IF TMOV = 1
@ LIN,40 SAY R_IMP PICTURE "###,###.##"
ENDIF
IF TMOV = 2 .OR. TMOV = 7
@ LIN,51 SAY R_IMP PICTURE "###,###.##"
ENDIF
@ LIN,62 SAY SL PICTURE "###,###.##"
LIN = LIN + 1
IF LIN = 21
SET COLOR TO W/B
STORE " " TO HH
@ 23,2 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET HH
READ
RESTORE SCREEN FROM PANTCC
SET COLOR TO W/R
HOJA = HOJA + 1
SELECT 1
@ 4,8 SAY "Nombre:    "+NOMBRE
@ 4,59 SAY "Cta. N§"
@ 4,67 SAY RCLI PICTURE "999999"
@ 5,8 SAY "Domicilio: "+DOMICILIO
@ 5,59 SAY "Pagina N§"
@ 5,69 SAY HOJA PICTURE "9999"
@ 6,8 SAY "Localidad: "+LOCALIDAD
@ 6,53 SAY "Telefono:"
@ 6,63 SAY TELEFONO
STORE 10 TO LIN
SET COLOR TO W/N
SELECT 2
ENDIF
ENDIF
ENDIF
SKIP
ENDDO
SET COLOR TO W/B
STORE 1 TO PMENU
@ 23,13 PROMPT "OTRA CONSULTA"
@ 23,38 PROMPT "IMPRIMIR"
@ 23,58 PROMPT "FINALIZAR"
MENU TO PMENU
IF PMENU = 3
STORE 84 TO JJ
EXIT
ENDIF
IF PMENU = 2
STORE LEN(QNOM) * 2 TO RM0
STORE 80 - RM0 TO RM1
RM1 = ROUND((RM1 / 2),0)
STORE 80 - LEN(QDOM) TO RM2
RM2 = ROUND((RM2 / 2),0)
SELECT 1
SET DEVICE TO PRINTER
@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
@ 2,1 SAY CHR(18)
@ 2,RM1 SAY CHR(14)+QNOM 
@ 3,RM2 SAY QDOM
@ 5,24 SAY CHR(14)+"RESUMEN DE CUENTA"
STORE 1 TO HOJA
@ 7,1 SAY "Nombre:    "+NOMBRE
@ 7,67 SAY "Cta. N§"
@ 7,75 SAY RCLI PICTURE "999999"
@ 8,1 SAY "Domicilio: "+DOMICILIO
@ 8,67 SAY "Pagina N§"
@ 8,77 SAY HOJA PICTURE "9999"
@ 9,1 SAY "Localidad: "+LOCALIDAD
@ 9,61 SAY "Telefono:"
@ 9,71 SAY TELEFONO
@ 10,1 SAY REPLICATE("-",80)
@ 11,2 SAY "FECHA"
@ 11,19 SAY "REFERENCIA"
@ 11,42 SAY "DEBITOS"
@ 11,56 SAY "CREDITOS"
@ 11,72 SAY "SALDO"
@ 12,1 SAY REPLICATE("-",80)
STORE 13 TO LIN
SELECT 2
GO TOP
STORE 0 TO SL, FL
STORE STR(RCLI,6) TO BUSCAR 
SEEK BUSCAR
DO WHILE .NOT. EOF() .AND. NUMERO = RCLI
IF FECHA > HASTA
EXIT
ENDIF
IF RPAR = "N"
STORE SALDO TO R_IMP
ELSE
STORE VALOR TO R_IMP
ENDIF
IF FECHA < DESDE
IF TMOV = 1
SL = SL + R_IMP
ENDIF
IF TMOV = 2 .OR. TMOV = 7
SL = SL - R_IMP
ENDIF
ENDIF
IF FECHA >= DESDE .AND. FECHA <= HASTA
IF FL = 0
IF SL <> 0
@ LIN,14 SAY "SALDO ANTERIOR"
@ LIN,70 SAY SL PICTURE "###,###.##"
LIN = LIN + 1
ENDIF
STORE 1 TO FL
ENDIF
IF R_IMP <> 0
IF TMOV = 1
SL = SL + R_IMP
ENDIF
IF TMOV = 2 .OR. TMOV = 7
SL = SL - R_IMP
ENDIF
@ LIN,1 SAY FECHA
@ LIN,14 SAY CBTE
IF TMOV = 1
@ LIN,40 SAY R_IMP PICTURE "###,###.##"
ENDIF
IF TMOV = 2 .OR. TMOV = 7
@ LIN,55 SAY R_IMP PICTURE "###,###.##"
ENDIF
@ LIN,70 SAY SL PICTURE "###,###.##"
LIN = LIN + 1
IF LIN = 68
SELECT 1
@ 1,1 SAY CHR(18)
@ 1,RM1 SAY CHR(14)+QNOM 
@ 2,RM2 SAY QDOM
@ 4,24 SAY CHR(14)+"RESUMEN DE CUENTA"
STORE HOJA + 1 TO HOJA
@ 6,1 SAY "Nombre:    "+NOMBRE
@ 6,67 SAY "Cta. N§"
@ 6,75 SAY RCLI PICTURE "999999"
@ 7,1 SAY "Domicilio: "+DOMICILIO
@ 7,67 SAY "Pagina N§"
@ 7,77 SAY HOJA PICTURE "9999"
@ 8,1 SAY "Localidad: "+LOCALIDAD
@ 8,61 SAY "Telefono:"
@ 8,71 SAY TELEFONO
@ 9,1 SAY REPLICATE("-",80)
@ 10,2 SAY "FECHA"
@ 10,19 SAY "REFERENCIA"
@ 10,42 SAY "DEBITOS"
@ 10,56 SAY "CREDITOS"
@ 10,72 SAY "SALDO"
@ 11,1 SAY REPLICATE("-",80)
STORE 12 TO LIN
SELECT 2
ENDIF
ENDIF
ENDIF
SKIP
ENDDO
EJECT
SET DEVICE TO SCREEN
ENDIF
ENDIF
ENDDO
CLOSE ALL
RETURN
