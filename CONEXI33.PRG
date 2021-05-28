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
USE RSTOCK INDEX RST_CLA1
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
        STORE 0 TO HOJA, TP, TF
        DO WHILE .NOT. EOF() 
                IF LIN = 22
                        STORE LINEA TO BUSCO
                        SELECT 2
                        SEEK BUSCO
                        RESTORE SCREEN FROM PANTVTA
                        SET COLOR TO N/BG
                        HOJA=HOJA + 1
                        @ 2,6 SAY "L¡nea:"
                        @ 2,9 SAY NUMERO
                        @ 2,16 SAY NOMBRE
                        @ 2,60 SAY "Pagina N§"
                        @ 2,70 SAY HOJA PICTURE "9999"
                        @ 23,61 SAY TP PICTURE "#,###,###.##"
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
                        SET COLOR TO W/B
                        @ LIN,7 SAY NUMERO
                        @ LIN,22 SAY NOMBRE
                        @ LIN,53 SAY RCANT PICTURE "###,###"
                        @ LIN,61 SAY PRECIO PICTURE "#,###,###.##"
                        LIN = LIN + 1
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
                IF RLIN = 9999
                                IF LINEA <> FHB
                                SET COLOR TO R/BG
                                STORE " " TO FH
                                @ 23,6 CLEAR TO 23,51
                                @ 23,6 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET FH
                                READ
                                STORE 0 TO HOJA, TP
                                STORE 22 TO LIN
                ENDIF
        ENDIF
    ENDDO
SET COLOR TO R/BG
STORE " " TO FH
@ 23,6 CLEAR TO 23,51
@ 23,6 SAY "PARA CONTINUAR DIGITE TECLA <=ENTER=> " GET FH
READ
SET COLOR TO R/BG
STORE " " TO FH
@ 23,6 CLEAR TO 23,51
@ 23,6 SAY "PARA FINALIZAR DIGITE TECLA <=ENTER=> " GET FH
READ
CASE PMENU = 2
SET DEVICE TO PRINTER
@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
@ 2,1 SAY CHR(18)
@ 2,19 SAY CHR(14)+"LISTADO DE EXISTENCIAS"
STORE 1 TO HOJA
@ 4,62 SAY "Pagina N§"
@ 4,72 SAY HOJA PICTURE "9999"
@ 5,1 SAY REPLICATE("-",80)
@ 6,8 SAY "CODIGO"
@ 6,30 SAY "DESCRIPCION"
@ 6,55 SAY "CANT."
@ 6,68 SAY "PRECIO"
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
STORE LINEA TO BUSCO
SELECT 2
SEEK BUSCO
@ LIN,4 SAY CHR(14)+NOMBRE
LIN = LIN + 1
SELECT 1
STORE 0 TO FHA, FHB
STORE 0 TO TP, TF
DO WHILE .NOT. EOF() 
FHB = LINEA
STORE NUMERO TO RCODIGO
SELECT 4
SEEK RCODIGO
IF .NOT. EOF()
STORE EX_FISICA TO RCANT
SELECT 1
@ LIN,4 SAY NUMERO
@ LIN,21 SAY NOMBRE
@ LIN,54 SAY RCANT PICTURE "###,###"
@ LIN,64 SAY PRECIO PICTURE "#,###,###.##"
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
IF RLIN = 9999
IF LINEA <> FHB
STORE 0 TO TP
@ LIN, 1 SAY " "
LIN = LIN + 1
STORE LINEA TO BUSCO
SELECT 2
SEEK BUSCO
@ LIN,4 SAY CHR(14)+NOMBRE
LIN = LIN + 1
SELECT 1
ENDIF
ENDIF
IF LIN > 66
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
STORE 8 TO LIN
ENDIF
ENDDO
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
