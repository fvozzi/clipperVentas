SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE ON
SET CENTURY ON
SET DATE BRITISH
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
PUBLIC SUBTOTAL
DECLARE campos[2]
SELECT 1
USE ARTICULO INDEX ART_NUM, ART_LIN
SELECT 2
USE LINEAS INDEX LIN_NUM, LIN_NOM
SELECT 3
USE TRABAJO1 INDEX TRA_NUM
SELECT 4
USE RSTOCK INDEX RST_CLA1
SELECT 5
USE NUMEROS
*** ALMACENA LA TEMPORADA ACTIVA EN TEMP ***
STORE TEMPORA TO TEMP
SELECT 4
STORE 83 TO JJ
DO WHILE JJ = 83
SET COLOR TO W/N
RESTORE SCREEN FROM PANT1
SET COLOR TO W+/RB
@ 2,32 SAY "CONSULTA DE EXISTENCIAS"
SET COLOR TO W/B
@ 8,14 CLEAR TO 8,66
@ 7,14,9,66 BOX &caja9
@ 8,15 SAY "C¢digo L¡nea:"
STORE SPACE(30) TO RCLI
@ 8,29 GET RCLI 
READ
IF LASTKEY()= 27
        EXIT
ENDIF
campos[1]="NUMERO"
campos[2]="NOMBRE"
    IF LASTKEY() = 18
        SAVE SCREEN TO MP1
        SELECT 2
        GO TOP
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
        @ 8,29 SAY SPACE(30)
        IF LASTKEY() = 13
                RCLI = STR(NUMERO)
        ENDIF
        IF LASTKEY() = 27
                STORE SPACE(30) TO RCLI //STORE 0 TO RCLI
                @ 8,33 GET RCLI //PICTURE "####"
                READ
        ENDIF
      ENDIF
        SELECT 2
        GO TOP
        SET ORDER TO 2
        SET EXACT OFF
        SEEK RTRIM(RCLI)
        IF EOF()
        GO TOP
        ENDIF
        SET EXACT ON
        
@ 8,29 SAY RCLI
SET ORDER TO 1
STORE VAL(RCLI) TO RLIN
IF VAL(RCLI) <> 9999
        SEEK VAL(RCLI)
IF EOF()
        LOOP
ENDIF
IF .NOT. EOF()
        STORE NUMERO TO RLIN
        @ 8,36 SAY NOMBRE
ENDIF
ENDIF
IF VAL(RCLI) = 9999
        STORE VAL(RCLI) TO RLIN
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
        STORE 0 TO HOJA, TP, TF ,TCANT
        DO WHILE .NOT. EOF() 
                IF LIN = 22
                        STORE LINEA TO BUSCO
                        SELECT 2
                        SEEK BUSCO
                        RESTORE SCREEN FROM COMPRA // ERA PANTVTA
                        SET COLOR TO W+/R
                        @ 1,29 SAY "CONSULTA DE EXISTENCIAS"
                        SET COLOR TO W/B
                        SET COLOR TO N/BG
                        HOJA=HOJA + 1
                        @ 2,6 SAY "L¡nea:"
                        IF RLIN = 9999
                                @ 2,13 SAY "9999 GENERAL"
                             ELSE
                                @ 2,13 SAY NUMERO
                                @ 2,19 SAY NOMBRE
                        ENDIF
                        @ 2,60 SAY "Pagina N§"
                        @ 2,70 SAY HOJA PICTURE "9999"
                        STORE 6 TO LIN
                        SELECT 1
                ENDIF
                STORE NUMERO TO RCODIGO
                SELECT 4
                SEEK RCODIGO
                IF .NOT. EOF()
                        STORE EX_FISICA TO RCANT
                        STORE PRODUCTO TO CLAVE
                        SELECT 1
                        IF TEMPORA = TEMP .OR. RCANT <> 0
                                IF RCANT >= 0
                                        SET COLOR TO W/B
                                ELSE
                                        SET COLOR TO W/R
                                ENDIF
                                @ LIN,2 SAY RCANT PICTURE "####"
                                @ LIN,8 SAY NOMBRE
                                @ LIN,40 SAY ALLTRIM(NUMERO)
                                @ LIN,52 SAY (PRECOMP * 0.9) PICTURE "#,###,###.##"
                                SUBTOTAL = (PRECOMP * 0.9) * RCANT
                                @ LIN,66 SAY SUBTOTAL PICTURE "#,###,###.##"
                                LIN = LIN + 1
                                SET COLOR TO W/B
                                TP = TP + SUBTOTAL
                                TCANT = TCANT + RCANT
                                @ 23, 5 CLEAR TO 23,55
                                @ 23, 66 SAY TP PICTURE "#,###,###.##"
                                @ 23, 1 SAY TCANT PICTURE "###,###"
                                
                        ENDIF
                ENDIF
                SELECT 1
                STORE LINEA TO FHB
                SKIP
                IF LIN = 22 .OR. EOF() .OR. (RLIN <> 9999 .AND. RLIN <> LINEA)
                        SET COLOR TO R/BG
                        STORE " " TO FH
                        @ 24,8 CLEAR TO 24,51
                        @ 24,8 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET FH
                        READ
                ENDIF
                IF RLIN <> 9999
                        IF RLIN <> LINEA
                                EXIT
                        ENDIF
                ENDIF
    ENDDO
CASE PMENU = 2
STORE 0 TO TP,TCANT
SET DEVICE TO PRINTER
@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
@ 2,1 SAY CHR(18)
@ 2,19 SAY CHR(14)+"LISTADO DE EXISTENCIAS"
STORE 1 TO HOJA
@ 4,62 SAY "Pagina N§"
@ 4,72 SAY HOJA PICTURE "9999"
@ 5,1 SAY REPLICATE("-",80)
@ 6,3 SAY "CANT."
@ 6,19 SAY "DESCRIPCION"
@ 6,45 SAY "CODIGO"
@ 6,58 SAY "VALOR"
@ 6,68 SAY "SUBTOTAL"
@ 7,1 SAY REPLICATE("-",80)
@ 7,79 SAY CHR(27)+CHR(120)+"0"
STORE 8 TO LIN
STORE STR(RLIN,4) TO BUSCAR
SELECT 1
SET ORDER TO 2
IF RLIN <> 9999
SEEK BUSCAR
ELSE
GO TOP
ENDIF
STORE LINEA TO BUSCO
//SELECT 2
//SEEK BUSCO
//@ LIN,4 SAY CHR(14)+NOMBRE
//LIN = LIN + 1
//SELECT 1
//STORE 0 TO FHA, FHB
//STORE 0 TO TP, TF
DO WHILE .NOT. EOF() 
FHB = LINEA
STORE NUMERO TO RCODIGO
SELECT 4
SEEK RCODIGO
IF .NOT. EOF()
STORE EX_FISICA TO RCANT
SELECT 1
@ LIN,2 SAY RCANT PICTURE "####"
@ LIN,11 SAY NOMBRE
@ LIN,44 SAY NUMERO

*** IMPRIME EL PRECIO UNITARIO DE COMPRA ***
@ LIN,52 SAY (PRECOMP * 0.9) PICTURE "#,###,###.##"
STORE ((PRECOMP * 0.9) * RCANT) TO SUBTOTAL

*** IMPRIME EL SUBTOTAL ***
@ LIN,64 SAY SUBTOTAL PICTURE "#,###,###.##"
TP = TP + SUBTOTAL
TCANT = TCANT + RCANT
LIN = LIN + 1
STORE LINEA TO FHA
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
//STORE 0 TO TP
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
IF LIN > 61
        @ 2,1 SAY CHR(18)
        @ 2,19 SAY CHR(14)+"LISTADO DE EXISTENCIAS"
        HOJA=HOJA + 1
        @ 4,62 SAY "Pagina N§"
        @ 4,72 SAY HOJA PICTURE "9999"
        @ 5,1 SAY REPLICATE("-",80)
        @ 6,8 SAY "CODIGO"
        @ 6,30 SAY "DESCRIPCION"
        @ 6,55 SAY "CANT."
        @ 6,68 SAY "PRECIO"
        @ 7,1 SAY REPLICATE("-",80)
        @ 7,79 SAY CHR(27)+CHR(120)+"0"
        STORE 8 TO LIN
ENDIF
ENDDO
@LIN,1 SAY REPLICATE("-",5)
@LIN,62 SAY REPLICATE("-",14)
LIN = LIN + 1
@ LIN, 2 SAY TCANT PICTURE "####"
@ LIN, 54 SAY "TOTAL ->"
@ LIN, 64 SAY TP PICTURE "#,###,###.##"
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
