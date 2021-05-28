SET SCOREBOARD ON
SET CONFIRM OFF
SET DATE BRITISH
SET CENTURY ON
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
DECLARE campos[2]
campos[1]="NUMERO"
campos[2]="NOMBRE"
SELECT 1
USE DEUDORES INDEX DEU_NUM, DEU_NOM
SELECT 2 
USE ARTICULO INDEX ART_NUM, ART_NOM
SELECT 3
USE TRABAJO
SELECT 4
USE MCTACTE INDEX MCC_CLA1, MCC_CLA2
SELECT 5
USE MOVIVA INDEX MIV_CLA1
SELECT 6
USE IVA
SELECT 7
USE NUMEROS
SELECT 8
USE VENDEDOR INDEX VEN_NUM, VEN_NOM
SELECT 9
USE MSTOCK INDEX MST_CLA1, MST_CLA2
SELECT 10
USE RSTOCK INDEX RST_CLA1
SELECT 11
USE CONTABLE INDEX CON_NUM, CON_NOM
SELECT 12
USE COMISION INDEX COM_CLA1, COM_CLA2
SELECT 13
USE MCONTABI INDEX MCO_CLA1, MCO_CLA2
STORE DATE() TO RFECHA
STORE 83 TO JJ
DO WHILE JJ = 83
RESTORE SCREEN FROM PANT2
SET COLOR TO W+/BG
@ 2,22 SAY "EMISION DE FACTURAS Y NOTAS DE CREDITO"
SET COLOR TO W+/RB
@ 10,17 CLEAR TO 14,63
@ 9,17,15,63 BOX @caja1
SELECT 7
GO 1
@ 10,19 SAY RTRIM(NOMBRE)
@ 11,19 SAY "Dise¤o y Programaci¢n: Facundo Vozzi"
@ 12,19 SAY "Casa Vozzi de `G.Vozzi y R.Fij'"
@ 13,19 SAY "General Paz 151"
@ 14,19 SAY "6000 Jun¡n(Bs.As.)     Tel. 02362-421407"
STORE 1 TO VMENU
STORE "" TO POS
SET COLOR TO W+/BG
@ 23,2 CLEAR TO 23,78
STORE 1 TO VCBTE
@ 23,7 PROMPT "FACTURA"
@ 23,19 PROMPT "NOTA DE CREDITO"
@ 23,39 PROMPT "CONSULTA DE PRECIOS"
@ 23,63 PROMPT "FIN PROCESO"
MENU TO VCBTE
DO CASE
  CASE VCBTE=1
        STORE "FACTURA" TO TCBTE
        STORE "FACT" TO XCBTE
  CASE VCBTE=2
        STORE "NOTA DE CREDITO" TO TCBTE
        STORE "N.C." TO XCBTE

  CASE VCBTE=3
          @ 23,2 CLEAR TO 23,78
          SET COLOR TO W/R
          @ 10,17 CLEAR TO 14,63
          @ 9,17,15,63 BOX @caja1
          @ 10,19 SAY "            CONSULTA DE PRECIOS"
          @ 12,19 SAY "C¢digo:"
          @ 13,19 SAY "Denominaci¢n:"
          @ 14,19 SAY "Precio: $"
          STORE SPACE(14) TO BUSCAR
          @ 12,27 GET BUSCAR
          READ
          SELECT 2
          SEEK BUSCAR
          IF .NOT. EOF()
                  @ 13,33 SAY NOMBRE
                  SELECT 2
                  SEEK BUSCAR
                  @ 14,29 SAY PRECIO PICTURE "#,###.##"
          ENDIF
          SET COLOR TO W+/BG
          STORE " " TO MM
          DO WHILE MM <> "F"
                  @ 23,2 SAY "PARA FINALIZAR DIGITE TECLA <=F=> " GET MM
                  READ
          ENDDO
          LOOP
          CASE VCBTE=4
                  EXIT
        ENDCASE
//STORE 1 TO VCBTE
RESTORE SCREEN FROM PANTFBNW
SET COLOR TO W/B
@ 2,48 SAY RFECHA
SAVE SCREEN TO MP1
SELECT 1
STORE SPACE(30) TO RCLI_NOM
@ 3,10 GET RCLI_NOM
READ

//*************** ABRE LA PANTALLA EN BUSCA DE CLIENTES **********

SET ORDER TO 2
SEEK RTRIM(RCLI_NOM)
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
IF LASTKEY() = 13
        STORE STR(NUMERO,6) TO BUSCAR
ENDIF
IF LASTKEY() = 27
        STORE SPACE(6) TO BUSCAR
        RESTORE SCREEN FROM MP1
        @ 2,10 GET BUSCAR
        READ
        SET ORDER TO 1
        GO TOP
        SEEK(VAL(BUSCAR))
ENDIF
STORE VAL(BUSCAR) TO CLAVE
@ 2,10 SAY CLAVE PICTURE "999999"
STORE SPACE(24) TO RCLI_TCRE
IF CLAVE = 888888
        STORE 888888 TO RCLI_NUM
        STORE SPACE(30) TO RCLI_NOM, RCLI_DOM, RCLI_LOC
        STORE SPACE(1) TO RCLI_CIVA
        STORE SPACE(11) TO RCLI_CUIT
        STORE SPACE(4) TO RCLI_TDOC
        @ 3,10 GET RCLI_NOM
        @ 4,10 GET RCLI_DOM
        @ 5,10 GET RCLI_LOC
        @ 4,51 GET RCLI_CIVA VALID(RCLI_CIVA$"IRNEMF")
        READ
        IF RCLI_CIVA <> "N" .AND. RCLI_CIVA <> "F"
                STORE "CUIT" TO RCLI_TDOC
                @ 4,64 GET RCLI_CUIT
                READ
        ENDIF
        ELSE
        STORE NUMERO TO RCLI_NUM
        STORE NOMBRE TO RCLI_NOM
        STORE DOMICILIO TO RCLI_DOM
        STORE LOCALIDAD TO RCLI_LOC     
        STORE CIVA TO RCLI_CIVA
        STORE TDOC TO RCLI_TDOC
        STORE CUIT TO RCLI_CUIT, RCUIT
ENDIF
@ 5,55 GET RCLI_TCRE
READ
IF RCLI_CIVA = "I" .OR. RCLI_CIVA = "N"
STORE "A" TO ZCBTE
ELSE
STORE "B" TO ZCBTE
ENDIF
IF LEFT(RCLI_NOM,1) = " "
        STORE "VENTA CONTADO" TO RCLI_NOM
ENDIF
@ 2,10 SAY RCLI_NUM PICTURE "999999"
@ 3,10 SAY RCLI_NOM
@ 4,10 SAY RCLI_DOM
@ 5,10 SAY RCLI_LOC
@ 4,51 SAY RCLI_CIVA
@ 4,64 SAY RCLI_CUIT
@ 5,55 SAY RCLI_TCRE
SELECT 7
GO 1
STORE PREFIJO TO CFAC
IF XCBTE = "N.C."
        STORE NOTCRED + 1 TO NCBTE
ELSE
        IF ZCBTE = "A"
                STORE NUMEROA + 1 TO NCBTE
        ENDIF
        IF ZCBTE = "B"
                STORE NUMEROB + 1 TO NCBTE
        ENDIF
ENDIF
MCBTE=XCBTE + " " + ZCBTE + " " + CFAC + "-" + RIGHT("00000000" + LTRIM(STR(NCBTE)),8)
@ 3,54 SAY MCBTE

//**************** CONFIRMA EL NUMERO DE COMPROBANTE CON EL DE EL IMPRESOR ****

STORE 1 TO VMENU
SET COLOR TO W/R
@ 24,2 CLEAR TO 23,78
@ 24,2 SAY "CONFIRMA NUMERO DE COMPROBANTE:"
@ 24,47 PROMPT "SI"
@ 24,63 PROMPT "NO"
MENU TO VMENU
DO CASE
  CASE VMENU=1
  SET COLOR TO W/B
  @ 24,2 CLEAR TO 23,78
  CASE VMENU=2
  SET COLOR TO W/B
  @ 24,2 CLEAR TO 23,78
  @ 24,2 SAY "NUEVO NUMERO DE COMPROBANTE:"
  @ 24,31 GET NCBTE
  READ
  @ 23,2 CLEAR TO 23,78
  MCBTE=XCBTE + " " + ZCBTE + " " + CFAC + "-" + RIGHT("00000000" + LTRIM(STR(NCBTE)),8)
  @ 3,54 SAY MCBTE
ENDCASE
SAVE SCREEN TO MP1

//**************** ABRE LA PANTALLA DE SELECION DE VENDEDORES ************

SELECT 8
STORE 0 TO RCLI_VEN
SEEK RCLI_VEN
DO WHILE EOF()
        SET ORDER TO 2
        GO TOP
        KEYBOARD CHR(4)
        SET COLOR TO W/R
        @ 4,30 CLEAR TO 21,70
        @ 4,30,21,71 BOX &caja9
        DBEDIT(5,31,20,70,campos,"finc")
        RESTORE SCREEN FROM MP1
        SET COLOR TO W/B
        IF LASTKEY() = 13
                STORE STR(NUMERO,3) TO BUSCAR
        ENDIF
        IF LASTKEY() = 27
                STORE SPACE(3) TO BUSCAR
        ENDIF
        STORE VAL(BUSCAR) TO CLAVE
        @ 2,37 SAY CLAVE PICTURE "999"
        STORE CLAVE TO RCLI_VEN
        SET ORDER TO 1
        SEEK RCLI_VEN
ENDDO
RESTORE SCREEN FROM MP1
@ 2,37 SAY RCLI_VEN PICTURE "999"


//**********PANTALLA PARA INGRESAR PRODUCTOS A VENDER *****************
SET COLOR TO W/B
@ 24,40 CLEAR TO 24,66
@ 24,40 SAY REPLICATE("Ä",27)
SET COLOR TO W/R
@ 24,1 CLEAR TO 24,32
@ 24,1 SAY "PARA FINALIZAR: TECLA <=ESC=>"
SET COLOR TO W/B
SELECT 3
GO 1
****                          *****  
* INICIALIZA EL ARCHIVO DE TRABAJO*
****                          *****
DO WHILE RECNO() < 13
        RLOCK()
        REPLACE DETALLE WITH SPACE(30), CODIGO WITH SPACE(14), LINEA WITH 0, CANT WITH 0, PLISTA WITH 0, PVENTA WITH 0, CONIVA WITH 0
        REPLACE SINIVA WITH 0, CONTABLE WITH 0, CODIVA WITH 0, INTERNO WITH 0, GRAVADO WITH 0, EXENTO WITH 0, IVA WITH 0, IVANO WITH 0, IMP_INT WITH 0
        UNLOCK
        SKIP
ENDDO
STORE 0 TO TFAC
GO 1
DO WHILE RECNO() < 13
        STORE RECNO() TO MFG
        STORE MFG + 8 TO LIN
        STORE SPACE(14) TO BUSCAR
        @ LIN,2 GET BUSCAR
        READ
        IF LASTKEY() = 27
                @ LIN,2 SAY SPACE(14)
                EXIT
        ENDIF
        IF LASTKEY() = 18 
                SAVE SCREEN TO MP1
                SELECT 2
                SEEK BUSCAR
                STORE 0 TO CONTROL
                DO WHILE EOF() .AND. CONTROL = 0
                        SET ORDER TO 2
                        GO TOP
                        KEYBOARD CHR(4)
                        SET COLOR TO W/R
                        @ 4,40 CLEAR TO 21,70
                        @ 4,40,21,71 BOX &caja9
                        DBEDIT(5,41,20,70,campos,"arts")
                        IF LEN(POS) >= 1
                                POS= ""
                        ENDIF
                        RESTORE SCREEN FROM MP1
                        SET COLOR TO W/B
                        IF LASTKEY() = 13
                                STORE NUMERO TO BUSCAR
                        ENDIF
                        IF LASTKEY() = 27
                                STORE SPACE(14) TO BUSCAR
                                CONTROL=1
                        ENDIF
                        @ LIN,2 SAY BUSCAR
                        SET ORDER TO 1
                        SEEK BUSCAR
                ENDDO
                RESTORE SCREEN FROM MP1
                @ LIN,2 SAY BUSCAR
ENDIF
SELECT 2
SEEK BUSCAR
IF EOF()
        SELECT 3
        LOOP
ENDIF
IF .NOT. EOF()
        STORE NOMBRE TO RPRO_NOM
        IF VAL(BUSCAR) = 8888
                STORE SPACE(20) TO RPRO_NOM
                @ LIN,17 GET RPRO_NOM
                READ
        ENDIF
        STORE CONTABLE TO RPRO_LIN
        STORE CIVA TO RPRO_CIV
        STORE PRECIO TO RPRO_PRE
        STORE INTERNO TO RPRO_INT
        SELECT 3
        RLOCK()
        REPLACE CODIGO WITH BUSCAR, DETALLE WITH RPRO_NOM, PLISTA WITH RPRO_PRE, CONTABLE WITH RPRO_LIN, CANT WITH 1, INTERNO WITH RPRO_INT
        UNLOCK
        @ LIN,2 SAY CODIGO
        @ LIN,17 SAY DETALLE
        @ LIN,46 SAY PLISTA PICTURE "####.##"
        RLOCK()
        @ LIN,54 GET CANT PICTURE "###.##"
        @ LIN,61 GET PVENTA PICTURE "####.##" RANGE 0,9999
        READ
        UNLOCK
        IF PVENTA = 0
                RLOCK()
                REPLACE PVENTA WITH PLISTA
                UNLOCK
        ENDIF

**************************** CONTROLA LOS CENTAVOS CON EL IMPRESOR FISCAL **************
        STORE 0 TO VALOR
        VALOR = (((ROUND(((PVENTA * CANT)/ 1.21),2)) * 1.21) )
****************************FIN*********************************

        RLOCK()
        REPLACE CONIVA WITH ROUND(VALOR,2)
        UNLOCK
        @ LIN,54 SAY CANT PICTURE "###.##"
        @ LIN,61 SAY PVENTA PICTURE "####.##"
        @ LIN,69 SAY CONIVA PICTURE "###,###.##"
        SELECT 6
        GO RPRO_CIV
        STORE TASA1 + 100 TO ALIC
        STORE TASA1 TO RCLI_ALIC
        SELECT 3
        STORE 0 TO VAL_SINIVA, VAL_IMPINT, R_GRAVADO, R_EXENTO, R_IVA, R_IVANO
        VAL_IMPINT =  CANT * INTERNO
        VAL_SINIVA = (CONIVA - VAL_IMPINT) * 100 / ALIC
        IF RCLI_ALIC = 0
        RLOCK()
        REPLACE EXENTO WITH CONIVA, IVA WITH 0, IVANO WITH 0, GRAVADO WITH 0, IMP_INT WITH 0, INTERNO WITH 0
        UNLOCK
        ENDIF
        IF RCLI_ALIC > 0
                R_GRAVADO = VAL_SINIVA
                R_EXENTO = VAL_IMPINT
                R_IVA = R_GRAVADO * RCLI_ALIC / 100
                IF RCLI_CIVA = "R"
                        R_IVANO = R_IVA / 2
                        RLOCK()
                        REPLACE CONIVA WITH R_GRAVADO + R_EXENTO + R_IVA + R_IVANO
                        UNLOCK
                ENDIF
                RLOCK()
                REPLACE SINIVA WITH VAL_SINIVA, IMP_INT WITH VAL_IMPINT, CODIVA WITH RPRO_CIV, LINEA WITH 1, GRAVADO WITH R_GRAVADO, EXENTO WITH R_EXENTO, IVA WITH R_IVA, IVANO WITH R_IVANO
                UNLOCK
        ENDIF
        TFAC = TFAC + CONIVA
        @ 23,69 SAY TFAC PICTURE "###,###.##"
        SKIP
ENDIF
ENDDO
STORE 0 TO PAGO
@ 22,72 GET PAGO PICTURE "####.##"
READ
STORE 1 TO CFISCAL
DO WHILE CFISCAL = 1
        STORE 2 TO VIMP
        DO WHILE VIMP = 2
                SET COLOR TO W/R
                @ 24,1 CLEAR TO 24,79
                @ 24,15 PROMPT "CONFIRMAR"
                @ 24,38 PROMPT "CORREGIR"
                @ 24,60 PROMPT "ANULAR"
                MENU TO VIMP
                IF TFAC = 0
                        STORE 3 TO VIMP
                ENDIF
                IF VIMP = 1 .OR. VIMP = 3
                        EXIT
                ENDIF
                SET COLOR TO W/R
                @ 24,1 CLEAR TO 24,79
                @ 24,1 SAY "ARRIBA: Pg.Up   ABAJO: Pg.Dn   CORREGIR: Enter   ELIMINAR: Ctrl W   SALIR: Esc"
                SET COLOR TO W/B
                SELECT 3
                GO 1
                DO WHILE RECNO() < 13
                        IF LINEA = 0
                                SKIP
                        ENDIF
                IF LINEA = 1
                        SET COLOR TO W*/B
                        STORE RECNO() TO MFG
                        STORE RECNO() + 8 TO LIN
                        @ LIN,2 SAY CODIGO
                        KEYBOARD CHR(4)
                        KEYBOARD CHR(19)
                        SET COLOR TO W/B
                        RLOCK()
                        STORE CODIGO TO R_CODIGO
                        @ LIN,2 GET CODIGO
                        READ
                        UNLOCK
                        IF LASTKEY() = 3 .AND. RECNO() < 12
                                @ LIN,2 SAY CODIGO
                                SKIP
                        ENDIF
                        IF LASTKEY() = 18 .AND. RECNO() > 1
                                @ LIN,2 SAY CODIGO
                                SKIP -1
                        ENDIF
                        IF LASTKEY() = 23
                                TFAC = TFAC - CONIVA
                                RLOCK()
                                REPLACE DETALLE WITH SPACE(30), CODIGO WITH SPACE(14), LINEA WITH 0, CANT WITH 0
                                REPLACE PLISTA WITH 0, PVENTA WITH 0, CONIVA WITH 0, SINIVA WITH 0, CONTABLE WITH 0, CODIVA WITH 0, INTERNO WITH 0, GRAVADO WITH 0, EXENTO WITH 0, IVA WITH 0, IVANO WITH 0, IMP_INT WITH 0
                                UNLOCK
                                @ LIN,2 SAY SPACE(14)
                                @ LIN,17 SAY SPACE(30)
                                @ LIN,46 SAY SPACE(7)
                                @ LIN,54 SAY SPACE(4)
                                @ LIN,61 SAY SPACE(7)
                                @ LIN,69 SAY SPACE(10)
                                @ 23,69 SAY TFAC PICTURE "###,###.##"
                        ENDIF
                        IF LASTKEY() = 13
                                TFAC = TFAC - CONIVA
                                @ LIN,54 SAY SPACE(4)
                                @ LIN,61 SAY SPACE(7)
                                @ LIN,69 SAY SPACE(10)
                                @ 23,69 SAY TFAC PICTURE "###,###.##"
                                RLOCK()
                                @ LIN,54 GET CANT PICTURE "###.##" RANGE 1,9999
                                @ LIN,61 GET PVENTA PICTURE "####.##" RANGE 0,9999
                                READ
                        UNLOCK
                        IF PVENTA = 0
                                RLOCK()
                                REPLACE PVENTA WITH PLISTA
                                UNLOCK
                        ENDIF
                        STORE 0 TO VALOR
                        VALOR = (((ROUND(((PVENTA * CANT)/ 1.21),2)) * 1.21) )
                        RLOCK()
                        REPLACE CONIVA WITH ROUND(VALOR,2)
                        UNLOCK
                        @ LIN,54 SAY CANT PICTURE "###.##"
                        @ LIN,61 SAY PVENTA PICTURE "####.##"
                        @ LIN,69 SAY CONIVA PICTURE "###,###.##"
                        STORE CODIVA TO RPRO_CIV
                        SELECT 6
                        GO RPRO_CIV
                        STORE TASA1 + 100 TO ALIC
                        STORE TASA1 TO RCLI_ALIC
                        SELECT 3
                        STORE 0 TO VAL_SINIVA, VAL_IMPINT, R_GRAVADO, R_EXENTO, R_IVA, R_IVANO
                        VAL_IMPINT =  CANT * INTERNO
                        VAL_SINIVA = (CONIVA - VAL_IMPINT) * 100 / ALIC
                        IF RCLI_ALIC = 0
                                RLOCK()
                                REPLACE CODIGO WITH R_CODIGO, EXENTO WITH CONIVA, SINIVA WITH CONIVA, IVA WITH 0, IVANO WITH 0, GRAVADO WITH 0, IMP_INT WITH 0, INTERNO WITH 0
                                UNLOCK          
                        ENDIF
                        IF RCLI_ALIC > 0
                                R_GRAVADO = VAL_SINIVA
                                R_EXENTO = VAL_IMPINT
                                R_IVA = R_GRAVADO * RCLI_ALIC / 100
                                IF RCLI_CIVA = "R"
                                        R_IVANO = R_IVA / 2
                                        RLOCK()
                                        REPLACE CONIVA WITH R_GRAVADO + R_EXENTO + R_IVA + R_IVANO
                                        UNLOCK
                                ENDIF
                                RLOCK()
                                REPLACE CODIGO WITH R_CODIGO, SINIVA WITH VAL_SINIVA, IMP_INT WITH VAL_IMPINT, CODIVA WITH RPRO_CIV, LINEA WITH 1, GRAVADO WITH R_GRAVADO, EXENTO WITH R_EXENTO, IVA WITH R_IVA, IVANO WITH R_IVANO
                                UNLOCK
                        ENDIF
                        TFAC = TFAC + CONIVA
                        @ 23,69 SAY TFAC PICTURE "###,###.##"
                        
                ENDIF
                IF LASTKEY() = 27
                        @ 22,72 GET PAGO PICTURE "####.##"
                        READ
                        EXIT
                ENDIF
        ENDIF
ENDDO
ENDDO
IF VIMP = 3
EXIT
ENDIF
IF VIMP = 1
        TFAC  = 0
        SELECT 3
        GO 1
        DO WHILE RECNO() < 13
        IF LINEA = 1
                RLOCK()
                REPLACE CONIVA WITH ROUND(((ROUND(((PVENTA * CANT) / 1.21),2)) * 1.21),2)
                UNLOCK
                TFAC = TFAC + CONIVA
                STORE CODIVA TO RPRO_CIV
                SELECT 6
                GO RPRO_CIV
                STORE TASA1 + 100 TO ALIC
                STORE TASA1 TO RCLI_ALIC
                SELECT 3
                STORE 0 TO VAL_SINIVA, VAL_IMPINT, R_GRAVADO, R_EXENTO, R_IVA, R_IVANO
                VAL_IMPINT =  CANT * INTERNO
                VAL_SINIVA = (CONIVA - VAL_IMPINT) * 100 / ALIC
                VAL_IMPINT = ROUND(VAL_IMPINT,2)
                VAL_SINIVA = ROUND(VAL_SINIVA,2)
                IF RCLI_ALIC = 0
                        RLOCK()
                        REPLACE EXENTO WITH CONIVA, SINIVA WITH CONIVA, IVA WITH 0, IVANO WITH 0, GRAVADO WITH 0, IMP_INT WITH 0, INTERNO WITH 0
                        UNLOCK
                ENDIF
                IF RCLI_ALIC > 0
                        R_GRAVADO = VAL_SINIVA
                        R_EXENTO = VAL_IMPINT
                        R_IVA = R_GRAVADO * RCLI_ALIC / 100
                        R_IVA = ROUND(R_IVA,2)
                        IF RCLI_CIVA = "R"
                                R_IVANO = R_IVA / 2
                                R_IVANO = ROUND(R_IVANO,2)
                        ENDIF
                        RLOCK()
                        REPLACE EXENTO WITH R_EXENTO, SINIVA WITH R_GRAVADO + R_EXENTO, IVA WITH R_IVA, IVANO WITH R_IVANO, GRAVADO WITH R_GRAVADO, IMP_INT WITH VAL_IMPINT
                        UNLOCK
                ENDIF
        ENDIF
SKIP
ENDDO
@ 23,69 SAY TFAC PICTURE "###,###.##"
SAVE SCREEN TO PANTAUX

        SELECT 14
        USE FISCAL2
        GO 1
        RLOCK()
        REPLACE LETRA WITH ZCBTE, CIVAC WITH RCLI_CIVA, NOMBRE WITH RCLI_NOM, TDOC WITH RCLI_TDOC, CUIT WITH RCLI_CUIT, DOMICILIO WITH RCLI_DOM, LOCALIDAD WITH RCLI_LOC
        UNLOCK
        COPY TO TEXTO1.TXT SDF
        SELECT 14
USE FISCAL3
STORE 0 TO MM
SELECT 3
GO 1
DO WHILE RECNO() < 13 
        IF LINEA = 1
                MM = MM + 1
                STORE DETALLE TO MP
                STORE SPACE(1) TO MK1, MK2, MK3, MK4, MK5
                MK1 = RIGHT("0000" + LTRIM(STR(MM)),4)
                *******************
                * ALMACENA LA CANT REAL EN MK6 PARA MOSTRARLA DELANTE DE LA DESCRIPCION DEL PRODUCTO
                ********************
                STORE ALLTRIM(STR(CANT,5,1)) TO MK6
                STORE CANT * 1000 TO RCANT
                RCANT = ROUND(RCANT,0)
                MK2 = RIGHT("00000000" + LTRIM(STR(RCANT)),8)
                IF ZCBTE = "A"
                        STORE SINIVA * 100 TO RCANT
                ELSE
                        STORE CONIVA * 100 TO RCANT
                ENDIF
                
                       // IF CANT = 1
                       //         IF ZCBTE = "A"
                       //                 STORE SINIVA * 100 TO RCANT
                       //         ELSE
                       //                 STORE CONIVA * 100 TO RCANT
                       //         ENDIF
                       // ENDIF
                       // IF CANT > 1
                       //         IF ZCBTE = "A"
                       //                 STORE SINIVA / CANT TO RCANT
                       //                 RCANT = RCANT * 100
                       //         ENDIF
                       //         IF ZCBTE = "B"
                       //                 STORE CONIVA / CANT TO RCANT
                       //                 RCANT = RCANT * 100
                       //         ENDIF
                       // ENDIF
                        RCANT = ROUND(RCANT,0)
                        MK3 = RIGHT("000000000" + LTRIM(STR(RCANT)),9)
                        STORE "00000000" TO MK5
                        IF INTERNO > 0
                                RCANT = 100 - ((INTERNO * 100) / (INTERNO + SINIVA))
                                RCANT = RCANT * 1000000
                                RCANT = ROUND(RCANT,0)
                                MK5 = RIGHT("00000000" + LTRIM(STR(RCANT)),8)
                        ENDIF
                        STORE CODIVA TO RPRO_CIV
                        SELECT 6
                        GO RPRO_CIV
                        STORE TASA1 * 100 TO RCANT
                        IF TASA1 = 0
                                STORE "0000" TO MK4
                        ELSE
                                RCANT = ROUND(RCANT,0)
                                MK4 = RIGHT("0000" + LTRIM(STR(RCANT)),4)
                        ENDIF
                        IF ZCBTE = "B"
                                MK5 = "00000000"
                        ENDIF
                        SELECT 14
                        GO 1
                        RLOCK()
                        REPLACE NUMERO WITH MK1, PRODUCTO WITH (LEFT((MK6+"/"+MP),20)), CANT WITH "00001000", PRECIO WITH MK3, IVA WITH MK4, AJUSTE WITH MK5
                        UNLOCK
                        COPY TO TEXTO2.TXT SDF
                        RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
                        SELECT 3
        ENDIF
        SKIP
ENDDO
SELECT 14
USE FISCAL4
COPY TO TEXTO2.TXT SDF
RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
SELECT 14
USE FISCAL5
GO 1
STORE (TFAC - PAGO) * 100 TO RCANT
RCANT = ROUND(RCANT,0)
MK1 = RIGHT("000000000" + LTRIM(STR(RCANT)),9)
RLOCK()
REPLACE DETALLE WITH "EN EFECTIVO", MONTO WITH MK1
UNLOCK
IF RCLI_NUM <> 888888
RLOCK()
REPLACE DETALLE WITH "EN CTA.CTE."
UNLOCK
ENDIF
COPY TO TEXTO2.TXT SDF
RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
SELECT 14
USE FISCAL7
GO 1
RLOCK()
REPLACE LETRA WITH ZCBTE
UNLOCK
COPY TO TEXTO2.TXT SDF
RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
//ERASE PFISOUT.TXT

        SELECT 14
        USE ESTADO1
        COPY TO ESTADO2

        SELECT 14
        USE ESTADO2
IF VCBTE = 1
//        RUN PFBATCH /C:2 /I:ESTADO.TXT /NOECHO
//        APPEND FROM PFISOUT.TXT SDF
//        GO 1
//        IF SUBSTR(LEYENDA,31,2) <> "OK"
//                RESTORE SCREEN FROM PANTAUX
//                LOOP
//                ENDIF
ENDIF
        IF VCBTE=2
                SELECT 14
                GO 1
                RLOCK()
                LEYENDA= "OK"
                UNLOCK
        ENDIF
//        IF SUBSTR(LEYENDA,31,2) = "OK" .OR. VCBTE=2
//                IF VCBTE=1
//                        ERASE PFISOUT.TXT
//                        RUN PFBATCH /C:2 /I:TEXTO1.TXT /NOECHO
//                        SELECT 14
//                        USE ESTADO1
//                        COPY TO ESTADO2
//                        SELECT 14
//                        USE ESTADO2
//                        APPEND FROM PFISOUT.TXT SDF
//                        GO 2
//                        IF SUBSTR(LEYENDA,31,5) = "ERROR"
//                                RESTORE SCREEN FROM PANTAUX
//                                LOOP
//                        ENDIF
//************ IF VCBTE=1*************
//                ENDIF           
//**********************************
        RESTORE SCREEN FROM PANTAUX
        OCBTE=MCBTE
        STORE 0 TO T_GRAVADO, T_EXENTO, T_IVA, T_IVANO
        SELECT 3
        GO 1
        DO WHILE RECNO() < 13
                IF LINEA = 1 .AND. CANT > 0 .AND. CONIVA > 0
                        STORE CODIGO TO R_CODIGO
                        STORE CONIVA TO R_CONIVA
                        STORE CANT TO R_CANT
                        STORE SINIVA TO R_SINIVA
                        STORE CONTABLE TO R_CONTABLE
                        STORE PLISTA TO R_PLISTA
                        STORE PVENTA TO R_PVENTA
                        STORE INTERNO TO VAL_IMPINT
                        STORE CODIVA TO RPRO_CIV
                        STORE GRAVADO TO R_GRAVADO
                        STORE EXENTO TO R_EXENTO
                        STORE IVA TO R_IVA
                        STORE IVANO TO R_IVANO
                        T_GRAVADO = T_GRAVADO + GRAVADO 
                        T_EXENTO = T_EXENTO + EXENTO 
                        T_IVA = T_IVA + IVA
                        T_IVANO = T_IVANO + IVANO
                        SELECT 9
                        RLOCK()
                        APPEND BLANK
                        REPLACE PRODUCTO WITH R_CODIGO, FECHA WITH RFECHA, CBTE WITH MCBTE, CANT WITH R_CANT, VALOR WITH R_SINIVA, CONIVA WITH R_CONIVA, CLIENTE WITH RCLI_NUM, PLISTA WITH R_PLISTA, PVENTA WITH R_PVENTA
                        REPLACE GRAVADO WITH R_GRAVADO, EXENTO WITH R_EXENTO, IVA WITH R_IVA, IVANO WITH R_IVANO
                        IF VCBTE = 1
                                REPLACE TMOV WITH 5
                        ELSE
                                REPLACE TMOV WITH 2
                        ENDIF
                        UNLOCK
                        //SELECT 10
                        ********************************************************
                        * MODIFICA EL ARCHIVO SOLO SI ES UN PRODUCTO EXISTENTE *
                        *                                                      *
                        ********************************************************
                        //IF R_CODIGO <> "8888"
                        //        SEEK R_CODIGO
                        //        IF EOF()
                        //                RLOCK()
                        //                APPEND BLANK
                        //                REPLACE PRODUCTO WITH R_CODIGO, UN_TRANSFI WITH 0, UN_TRANSFE WITH 0, UN_VEND WITH 0, VAL_VENTA WITH 0, EX_FISICA WITH 0, FU_VENTA WITH CTOD("  /  /    ")  
                        //                UNLOCK
                        //        ENDIF
                        //ENDIF
                        //IF .NOT. EOF()
                        //        RLOCK()
                        //        IF VCBTE = 1
                        //                REPLACE UN_VEND WITH UN_VEND + R_CANT, VAL_VENTA WITH VAL_VENTA + R_SINIVA, FU_VENTA WITH RFECHA, EX_FISICA WITH EX_FISICA - R_CANT
                        //        ELSE
                        //                REPLACE UN_VEND WITH UN_VEND - R_CANT, VAL_VENTA WITH VAL_VENTA - R_SINIVA, EX_FISICA WITH EX_FISICA + R_CANT
                        //        ENDIF
                        //        UNLOCK
                        //ENDIF
                        SELECT 13
                        RLOCK()
                        APPEND BLANK
                        REPLACE NUMERO WITH R_CONTABLE, FECHA WITH RFECHA, CBTE WITH MCBTE, VALOR WITH R_SINIVA
                        IF VCBTE = 1
                                REPLACE TMOV WITH 2
                        ELSE
                                REPLACE TMOV WITH 1
                        ENDIF
                        UNLOCK
                        SELECT 11
                        SEEK R_CONTABLE
                        RLOCK()
                        IF VCBTE = 1
                                REPLACE CREDITOS WITH CREDITOS + R_SINIVA
                        ELSE
                                REPLACE DEBITOS WITH DEBITOS + R_SINIVA
                        ENDIF
                        UNLOCK
                ENDIF
                SELECT 3
                SKIP
        ENDDO
        SELECT 5
        RLOCK()
        APPEND BLANK
        REPLACE FECHA WITH RFECHA, NOMBRE WITH RCLI_NOM, CIVA WITH RCLI_CIVA, CUIT WITH RCLI_CUIT, CBTE WITH MCBTE, ALIC WITH RCLI_ALIC
        REPLACE EXENTO WITH T_EXENTO, GRAVADO WITH T_GRAVADO, IVA WITH T_IVA, IVANO WITH T_IVANO, NETO WITH TFAC, CLIENTE WITH RCLI_NUM 
        STORE RECNO() TO MJL
        UNLOCK
        IF VCBTE = 2
                GO MJL
                STORE -1 TO MJM
                RLOCK()
                REPLACE GRAVADO WITH GRAVADO * MJM, IVA WITH IVA * MJM, IVANO WITH IVANO * MJM, NETO WITH NETO * MJM 
                UNLOCK
        ENDIF
        SELECT 8
        STORE 0 TO R_COMIS
        R_COMIS = TFAC * COMISION / 100
        SELECT 12
        RLOCK()
        APPEND BLANK
        REPLACE VENDEDOR WITH RCLI_VEN, FECHA WITH RFECHA, CBTE WITH MCBTE, FACTURA WITH TFAC, COMISION WITH R_COMIS
        IF VCBTE = 1
                REPLACE TMOV WITH 1
        ELSE
                REPLACE TMOV WITH 2
        ENDIF
        UNLOCK
        SELECT 7
        GO 1
        RLOCK()
        IF XCBTE = "N.C."
                REPLACE NOTCRED WITH NCBTE                
        ELSE
                IF ZCBTE = "A"
                        REPLACE NUMEROA WITH NCBTE
                ELSE
                        REPLACE NUMEROB WITH NCBTE
                ENDIF
        ENDIF
        UNLOCK
        IF RCLI_NUM <> 888888
                SELECT 4
                RLOCK()
                APPEND BLANK
                REPLACE CLIENTE WITH RCLI_NUM, FECHA WITH RFECHA, CBTE WITH MCBTE, VALOR WITH TFAC, SALDO WITH TFAC
                IF VCBTE = 1
                        REPLACE TMOV WITH 1
                ELSE
                        REPLACE TMOV WITH 2
                ENDIF
                UNLOCK
                SELECT 1
                RLOCK()
                IF VCBTE = 1
                        REPLACE SALDO WITH SALDO + TFAC
                ELSE
                        REPLACE SALDO WITH SALDO - TFAC
                ENDIF
                UNLOCK
                ********                                       ********
                * SI HUBO UN PAGO PARCIAL O TOTAL LO INGRESA COMO PAGO*
                ********                                       ********
                IF PAGO > 0
                        SELECT 4
                        RLOCK()
                        APPEND BLANK
                        REPLACE CLIENTE WITH RCLI_NUM, FECHA WITH RFECHA, CBTE WITH ("RECIBO "+ RIGHT(MCBTE,6)), VALOR WITH PAGO, SALDO WITH PAGO
                        REPLACE TMOV WITH 2
                        UNLOCK
                        SELECT 1
                        RLOCK()
                                REPLACE SALDO WITH SALDO - TFAC
                        UNLOCK
                ENDIF
        ENDIF
ENDIF
IF VIMP = 1 .OR. VIMP = 3
        EXIT
ENDIF
//ENDIF
ENDDO
ENDDO
CLOSE ALL
RETURN
