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
USE ARTICULO INDEX ART_NUM, ART_LIN
SELECT 2
USE LINEAS INDEX LIN_NUM, LIN_NOM
SELECT 3
USE TRABAJO1 INDEX TRA_NUM
SELECT 4
USE MSTOCK INDEX MST_CLA2
SELECT 4
STORE "" TO POS
STORE 83 TO JJ
DO WHILE JJ = 83
SET COLOR TO W/N
RESTORE SCREEN FROM PANT1
campos[1]="NUMERO"
campos[2]="NOMBRE"
SET COLOR TO W+/RB
@ 2,32 SAY "CONSULTA DE VENTAS"
SET COLOR TO W/B
@ 8,14 CLEAR TO 12,66
@ 7,14,13,66 BOX &caja9
@ 8,18 SAY "C�digo L�nea:"
@ 10,18 SAY "Desde Fecha(dd/mm/aaaa):"
@ 12,18 SAY "Hasta Fecha(dd/mm/aaaa):"
STORE SPACE(18) TO TEMP
SELECT 2

STORE CTOD("01/01/2000") TO DESDEF
STORE CTOD("31/12/2030") TO HASTAF
STORE SPACE(30) TO RCLI
@ 8,33 GET RCLI
READ
IF LASTKEY() = 27
        EXIT
ENDIF
SAVE SCREEN TO MP1
SELECT 2
SET ORDER TO 2
SET EXACT OFF
SEEK RTRIM(RCLI)
IF EOF()
GO TOP
ENDIF
SET EXACT ON
KEYBOARD CHR(4)
SET COLOR TO W/R
@ 4,30 CLEAR TO 21,71
@ 4,30,21,71 BOX &caja9
DBEDIT(5,31,20,71,campos,"finc")
RESTORE SCREEN FROM MP1
SET COLOR TO W/B
@ 8,33 SAY SPACE(30)
IF LASTKEY() = 13
RCLI = NUMERO
ENDIF
IF LASTKEY() = 27
STORE 0 TO RCLI
@ 8,33 GET RCLI PICTURE "####"
READ
ENDIF
@ 8,33 SAY RCLI
SET ORDER TO 1
STORE RCLI TO RLIN
IF RCLI <> 9999
SEEK RCLI
IF EOF()
LOOP
ENDIF
IF .NOT. EOF()
STORE NUMERO TO RLIN
@ 8,39 SAY ALLTRIM(NOMBRE)
ENDIF
ENDIF
@ 10,44 GET DESDEF
@ 12,44 GET HASTAF
READ
IF HASTAF < DESDEF
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
SET COLOR TO W+/RB
@ 23,2 CLEAR TO 23,78
@ 23,25 SAY "E S T O Y   P R O C E S A N D O"
SELECT 3
GO TOP
DO WHILE .NOT. EOF()
RLOCK()
        REPLACE CANTIDAD WITH 0, VALOR WITH 0
UNLOCK
SKIP
ENDDO
STORE RLIN TO BUSCO
SELECT 4
STORE SPACE(8) TO BUSCAR
BUSCAR = STR(YEAR(DESDEF),4) + STR(MONTH(DESDEF),2) + STR(DAY(DESDEF),2)
SEEK BUSCAR
DO WHILE EOF()
DESDEF = DESDEF + 1
IF DESDEF > HASTAF
EXIT
ENDIF
BUSCAR = STR(YEAR(DESDEF),4) + STR(MONTH(DESDEF),2) + STR(DAY(DESDEF),2)
SEEK BUSCAR
ENDDO
DO WHILE .NOT. EOF() .AND. FECHA <= HASTAF
        STORE PRODUCTO TO RCODIGO
        SELECT 1
        SET ORDER TO 1
        SEEK RCODIGO
        STORE LINEA TO PLINEA
        SELECT 4
        IF BUSCO = 9999 .OR. PLINEA = BUSCO
                IF TMOV = 2 .OR. TMOV = 5
                        STORE CANT TO RCANT
                        STORE (PVENTA * CANT) TO RVALOR
                        STORE PRODUCTO TO CLAVE
                        STORE TMOV TO RTMOV
                SELECT 3
                SEEK CLAVE
                IF EOF()
                        RLOCK()
                        APPEND BLANK
                                REPLACE PRODUCTO WITH CLAVE, CANTIDAD WITH 0, VALOR WITH 0
                                UNLOCK
                ENDIF
                IF .NOT. EOF()
                        RLOCK()
                        IF RTMOV = 5
                                REPLACE CANTIDAD WITH CANTIDAD + RCANT, VALOR WITH VALOR + RVALOR
                        ELSE
                                REPLACE CANTIDAD WITH CANTIDAD - RCANT, VALOR WITH VALOR - RVALOR
                        ENDIF
                        UNLOCK
                ENDIF
SELECT 4
ENDIF
ENDIF
SKIP
ENDDO
@ 23,2 CLEAR TO 23,78
STORE 1 TO PMENU
@ 23,19 PROMPT "POR PANTALLA"
@ 23,48 PROMPT "POR IMPRESORA"
MENU TO PMENU
DO CASE
CASE PMENU = 1
STORE STR(RLIN,4) TO BUSCAR
SELECT 1
SET ORDER TO 2
IF RLIN <> 9999
        SEEK BUSCAR
ELSE
        GO TOP
ENDIF
STORE 22 TO LIN
STORE LINEA TO FHA, FHB
STORE 0 TO HOJA, TP, TF
DO WHILE .NOT. EOF() 
        IF LIN = 22
                STORE LINEA TO BUSCO
                SELECT 2
                SEEK BUSCO
                RESTORE SCREEN FROM COMPRA // ERA PANTVTA
                SET COLOR TO W/R
                @ 1,31 SAY "CONSULTA DE COMPRAS"
                SET COLOR TO N/BG
                HOJA=HOJA + 1
                IF DESDEF = HASTAF
                        @1,6 SAY "Fecha:"
                        @1,13 SAY hastaf
                ENDIF
                @ 2,6 SAY "L�nea:"
                IF RLIN = 9999
                        @ 2,13 SAY "9999 GENERAL"
                     ELSE
                        @ 2,13 SAY NUMERO
                        @ 2,19 SAY NOMBRE
                ENDIF
                @ 2,60 SAY "Pagina N�"
                @ 2,70 SAY HOJA PICTURE "9999"
                @ 23,66 SAY TP PICTURE "#,###,###.##"
                STORE 6 TO LIN
                SELECT 1
        ENDIF
        STORE NUMERO TO RCODIGO
        SELECT 3
        SEEK RCODIGO
        IF .NOT. EOF()
                IF CANTIDAD <> 0 .OR. VALOR <> 0
                STORE CANTIDAD TO RCANT
                STORE VALOR TO RVALOR
                STORE PRODUCTO TO CLAVE
                TF = TF + VALOR
                SELECT 1
                SET COLOR TO W/B
                @ LIN,2 SAY RCANT PICTURE "####"
                @ LIN,8 SAY NOMBRE
                @ LIN,40 SAY ALLTRIM(NUMERO)
                STORE ROUND((RVALOR / RCANT),2) TO PUNITARIO
                *** IMPRIME EL PRECIO UNITARIO APROXIMADO ***
                @ LIN,52 SAY PUNITARIO PICTURE "#,###,###.##"
                *** IMPRIME EL SUBTOTAL ***
                @ LIN,66 SAY RVALOR PICTURE "#,###,###.##"
                TP = TP + RVALOR
                @ 23,66 SAY TP PICTURE "#,###,###.##"
                LIN = LIN + 1
        ENDIF
ENDIF
SELECT 1
STORE LINEA TO FHB
SKIP
IF LIN = 22
        SET COLOR TO R/BG
        STORE " " TO FH
        @ 23,6 CLEAR TO 23,51
        @ 23,6 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET FH
        READ
ENDIF
IF RLIN <> 9999
        IF RLIN <> LINEA
                EXIT
        ENDIF
ENDIF
//IF RLIN = 9999
  //      IF LINEA <> FHB
  //      SET COLOR TO R/BG
  //      STORE " " TO FH
  //      @ 23,6 CLEAR TO 23,51
  //      @ 23,6 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET FH
  //      READ
  //      STORE 0 TO HOJA, TP
  //      STORE 22 TO LIN
//ENDIF
//ENDIF
ENDDO
SET COLOR TO R/BG
STORE " " TO FH
@ 23,6 CLEAR TO 23,51
@ 23,6 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET FH
READ
SET COLOR TO W/B
//@ 23,61 SAY TF PICTURE "#,###,###.##"
SET COLOR TO R/BG
STORE " " TO FH
@ 23,6 CLEAR TO 23,51
@ 23,6 SAY "PARA FINALIZAR DIGITE TECLA <=ENTER=> " GET FH
READ
CASE PMENU = 2
SET DEVICE TO PRINTER
@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
@ 2,1 SAY CHR(18)
@ 2,24 SAY CHR(14)+"LISTADO DE COMPRAS"
STORE 1 TO HOJA
IF DESDEF = HASTAF
@ 4,4 SAY "Fecha:"
@ 4,11 SAY HASTAF
ENDIF
@ 4,62 SAY "Pagina N�"
@ 4,72 SAY HOJA PICTURE "9999"
@ 5,1 SAY REPLICATE("-",80)
@ 6,3 SAY "CANT."
@ 6,19 SAY "DESCRIPCION"
@ 6,45 SAY "CODIGO"
@ 6,58 SAY "VALOR"
@ 6,68 SAY "SUBTOTAL"
@ 7,1 SAY REPLICATE("-",80)
STORE 8 TO LIN
STORE STR(RLIN,4) TO BUSCAR
SELECT 1
SET ORDER TO 2
IF RLIN <> 9999
SEEK BUSCAR
ELSE
GO TOP
ENDIF
//STORE LINEA TO BUSCO
//SELECT 2
//SEEK BUSCO
//@ LIN,4 SAY CHR(14)+NOMBRE
//LIN = LIN + 1
//SELECT 1
//STORE 0 TO FHA, FHB
STORE 0 TO TP, TF
DO WHILE .NOT. EOF() 
FHB = LINEA
STORE NUMERO TO RCODIGO
SELECT 3
SEEK RCODIGO
IF .NOT. EOF()
IF CANTIDAD <> 0 .OR. VALOR <> 0
STORE CANTIDAD TO RCANT
STORE VALOR TO RVALOR
TF = TF + VALOR
SELECT 1
@ LIN,2 SAY RCANT PICTURE "####"
@ LIN,11 SAY NOMBRE
@ LIN,44 SAY NUMERO
STORE ROUND((RVALOR / RCANT),2) TO PUNITARIO

*** IMPRIME EL PRECIO UNITARIO APROXIMADO ***
@ LIN,52 SAY PUNITARIO PICTURE "#,###,###.##"

*** IMPRIME EL SUBTOTAL ***
@ LIN,64 SAY RVALOR PICTURE "#,###,###.##"
TP = TP + RVALOR
LIN = LIN + 1
STORE LINEA TO FHB
ENDIF
ENDIF
SELECT 1
SKIP
IF RLIN <> 9999
IF RLIN <> LINEA
EXIT
ENDIF
ENDIF
//IF RLIN = 9999
//IF LINEA <> FHB
//@ LIN,63 SAY "--------------"
//LIN = LIN + 1
//@ LIN,51 SAY "Sub-Total ->"
//@ LIN,64 SAY TP PICTURE "#,###,###.##"
//STORE 0 TO TP
//LIN = LIN + 1
//@ LIN, 1 SAY " "
//LIN = LIN + 1
//STORE LINEA TO BUSCO
//SELECT 2
//SEEK BUSCO
//@ LIN,4 SAY CHR(14)+NOMBRE
//LIN = LIN + 1
//SELECT 1
//ENDIF
//ENDIF
IF LIN > 66
@ 2,1 SAY CHR(18)
@ 2,24 SAY CHR(14)+"LISTADO DE VENTAS"
HOJA=HOJA + 1
IF DESDE = HASTA
@ 4,4 SAY "Fecha:"
@ 4,11 SAY HASTA
ENDIF
@ 4,62 SAY "Pagina N�"
@ 4,72 SAY HOJA PICTURE "9999"
@ 5,1 SAY REPLICATE("-",80)
@ 6,3 SAY "CANT."
@ 6,19 SAY "DESCRIPCION"
@ 6,45 SAY "CODIGO"
@ 6,58 SAY "VALOR"
@ 6,68 SAY "SUBTOTAL"
@ 7,1 SAY REPLICATE("-",80)
STORE 8 TO LIN
ENDIF
ENDDO
@ LIN,63 SAY "--------------"
LIN = LIN + 1
@ LIN,57 SAY "Total ->"
@ LIN,64 SAY TP PICTURE "#,###,###.##"
LIN = LIN + 1
//@ LIN,63 SAY "--------------"
//LIN = LIN + 1
//@ LIN,55 SAY "Total ->"
//@ LIN,64 SAY TF PICTURE "#,###,###.##"
//LIN = LIN + 1
//@ LIN,63 SAY "=============="
EJECT
SET DEVICE TO SCREEN
IF RLIN = 9999
STORE 84 TO JJ
ENDIF
ENDCASE
ENDIF
ENDDO
CLOSE ALL
RETURN
