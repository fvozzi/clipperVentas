SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE ON
SET DATE BRITISH
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
DECLARE campos[2]
campos[1]="NOMBRE"
campos[2]="NUMERO"
USE NUMEROS
STORE RTRIM(NOMBRE) TO QNOM
STORE RTRIM(DOMICILIO) + " - " TO QDOM
QDOM = QDOM + RTRIM(LOCALIDAD)
USE PROVEEDO INDEX PROV_NOM, PROV_NUM
STORE 83 TO JJ
DO WHILE JJ = 83
SET COLOR TO W/N
RESTORE SCREEN FROM PANT1
SET COLOR TO W+/RB
@ 2,31 SAY "CONSULTA DE SALDOS"
SET COLOR TO W/B
@ 8,14 CLEAR TO 13,66
@ 7,14,14,66 BOX &caja9
@ 8,18 SAY "Saldos en cero(S/N):"
@10,18 SAY "Desde Letra:"
@12,18 SAY "Hasta Letra:"
STORE " " TO RPARC
STORE "A" TO DESDE
STORE "Z" TO HASTA
@10,36 SAY DESDE 
@12,36 SAY HASTA 
@ 8,39 GET RPARC VALID(RPARC$"SN")
READ
@10,36 GET DESDE
READ
@12,36 GET HASTA
READ
IF LASTKEY() = 27
        RETURN
        JJ = 0
ENDIF
@10,36 SAY DESDE
@12,36 SAY HASTA
IF (DESDE < "A" .OR. HASTA > "Z") .OR. DESDE > HASTA
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
@ 23,2 CLEAR TO 23,78
STORE 1 TO PMENU
@ 23,19 PROMPT "POR PANTALLA"
@ 23,48 PROMPT "POR IMPRESORA"
MENU TO PMENU
DO CASE
CASE PMENU = 1
SET ORDER TO 1
GO TOP
STORE 22 TO LIN
STORE 0 TO TP, HOJA
STORE DESDE TO MOVER
     LOCATE FOR LEFT(NOMBRE,1)=DESDE
        DO WHILE .NOT. FOUND() .AND. ASC(DESDE) < 255
                DESDE = CHR(ASC(DESDE) + 1)
                LOCATE FOR LEFT(NOMBRE,1)=DESDE
        ENDDO
        IF FOUND()
                DO WHILE .NOT. EOF() .AND. LEFT(NOMBRE,1) <= HASTA
                        IF LIN = 22
                                RESTORE SCREEN FROM PANTSAL
                                SET COLOR TO N/BG
                                HOJA=HOJA + 1
                                @ 2,51 SAY "Pagina N§"
                                @ 2,61 SAY HOJA PICTURE "9999"
                                @ 23,39 SAY "Sub-Total =>"
                                STORE 6 TO LIN
                        ENDIF
                        SET COLOR TO W/B
                IF RPARC <> "N" .OR. (RPARC = "N" .AND. SALDO <> 0)
                        @ LIN,14 SAY NUMERO
                        @ LIN,21 SAY NOMBRE
                        @ LIN,52 SAY SALDO PICTURE "#,###,###.##"
                        TP = TP + SALDO
                        @ 23,52 SAY TP PICTURE "#,###,###.##"
                        LIN = LIN + 1
                        IF LIN = 22
                                STORE " " TO FH
                                SET COLOR TO N/BG
                                @ 23,2 CLEAR TO 23,50
                                @ 23,39 SAY "Sub-Total =>"
                                SET COLOR TO W/R
                                @ 23,0 SAY "PARA CONTINUAR DAR TECLA <=ENTER=> " GET FH
                                READ
                        ENDIF
                ENDIF
                SKIP 
              ENDDO
    ENDIF
//ENDDO
STORE " " TO FH
SET COLOR TO N/BG
@ 23,2 CLEAR TO 23,50
@ 23,43 SAY "Total =>"
SET COLOR TO W/B
@ 23,52 SAY TP PICTURE "#,###,###.##"
SET COLOR TO W/R
@ 23,0 SAY "PARA FINALIZAR DAR TECLA <=ENTER=> " GET FH
READ
STORE 84 TO JJ
CASE PMENU = 2
STORE LEN(QNOM) * 2 TO RM0
STORE 94 - RM0 TO RM1
RM1 = ROUND((RM1 / 2),0)
STORE 94 - LEN(QDOM) TO RM2
RM2 = ROUND((RM2 / 2),0)
SET DEVICE TO PRINTER
@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
@ 2,1 SAY CHR(27)+CHR(77)+CHR(18)
@ 2,RM1 SAY CHR(14)+QNOM
@ 3,RM2 SAY QDOM
@ 4,1 SAY CHR(18)
@ 5,31 SAY CHR(14)+"LISTADO DE SALDOS"
STORE 1 TO HOJA
@ 7,65 SAY "Pagina N§"
@ 7,75 SAY HOJA PICTURE "9999"
@ 8,1 SAY REPLICATE("-",78)
@ 9,1 SAY "CUENTA"
@ 9,14 SAY "APELLIDO Y NOMBRE"
@ 9,49 SAY "DOMICILIO"
//@ 9,71 SAY "TELEFONO"
@ 9,72 SAY "SALDO"
@ 10,1 SAY REPLICATE("-",78)
STORE 11 TO LIN
//IF RPARC = "N"
//SET FILTER TO SALDO <> 0
//ELSE
//SET FILTER TO 
//ENDIF
GO TOP
STORE 0 TO TP
LOCATE FOR LEFT(NOMBRE,1)=DESDE
        IF FOUND()
        DO WHILE .NOT. EOF() .AND. LEFT(NOMBRE,1) <= HASTA
             IF RPARC <> "N" .OR. (RPARC = "N" .AND. SALDO <> 0)
                @ LIN,1 SAY NUMERO PICTURE "######"
                @ LIN,8 SAY NOMBRE
                @ LIN,39 SAY DOMICILIO
                //@ LIN,70 SAY TELEFONO
                @ LIN,70 SAY SALDO PICTURE "##,###.##"
                TP = TP + SALDO
                LIN = LIN + 1
                
                IF LIN > 67
                        @ 1,1 SAY CHR(27)+CHR(77)+CHR(18)
                        @ 1,RM1 SAY CHR(14)+QNOM
                        @ 2,RM2 SAY QDOM
                        @ 3,1 SAY CHR(18)
                        @ 4,31 SAY CHR(14)+"LISTADO DE SALDOS"
                        STORE HOJA + 1 TO HOJA
                        @ 6,65 SAY "Pagina N§"
                        @ 6,75 SAY HOJA PICTURE "9999"
                        @ 7,1 SAY REPLICATE("-",78)
                        @ 8,1 SAY "CUENTA"
                        @ 8,14 SAY "APELLIDO Y NOMBRE"
                        @ 8,49 SAY "DOMICILIO"
                        //@ 8,71 SAY "TELEFONO"
                        @ 8,72 SAY "SALDO"
                        @ 9,1 SAY REPLICATE("-",78)
                        STORE 10 TO LIN
                ENDIF
        ENDIF
        SKIP 
      ENDDO
        ELSE
                DESDE = CHR(ASC(DESDE) + 1)
                CONTINUE
ENDIF

@ LIN,66 SAY "---------------"
LIN = LIN + 1
@ LIN,57 SAY "TOTAL =>"
@ LIN,66 SAY TP PICTURE "###,###,###.##"
LIN = LIN + 1
@ LIN,66 SAY "==============="
LIN = LIN + 1
@ LIN,1 SAY CHR(27)+CHR(80)
EJECT
SET DEVICE TO SCREEN
STORE 84 TO JJ
ENDCASE
ENDIF
ENDDO
CLOSE ALL
RETURN
