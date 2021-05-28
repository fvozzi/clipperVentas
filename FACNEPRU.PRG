//SET SCOREBOARD ON
SET CONFIRM OFF
SET DATE BRITISH
SET EXCLUSIVE OFF
SET CENTURY ON
RESTORE FROM FISCAL.MEM
DECLARE campos[2]
campos[1]="NUMERO"
campos[2]="NOMBRE"
SELECT 1
USE DEUDORES INDEX DEU_NUM, DEU_NOM
SELECT 2 
USE ARTICULO INDEX ART_NUM
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
SELECT 14
USE MCONTABI INDEX MCO_CLA1, MCO_CLA2
STORE DATE() TO RFECHA
STORE 83 TO JJ
DO WHILE JJ = 83
RESTORE SCREEN FROM PANT2
SET COLOR TO W+/BG
@ 2,22 SAY "EMISION DE FACTURAS Y NOTAS DE CREDITO"
SET COLOR TO W+/RB
@ 10,17 CLEAR TO 14,63
@ 9,17,16,63 BOX @caja1
@ 10,19 SAY "ARMANDO FARINA"
@ 11,19 SAY "Dise¤o y Programaci¢n: Facundo Vozzi"
@ 12,19 SAY "Casa Vozzi de `G.Vozzi y R.Fij'"
@ 13,19 SAY "General Paz 151 "
@ 14,19 SAY "6000 Jun¡n(Bs.As.)     Tel. 02362-421407"
@ 15,18 SAY " e-mail: casavozzi@infovia.com.ar            "
STORE 1 TO VMENU
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
  STORE "REMITO" TO TCBTE
  STORE "REMI" TO XCBTE
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
RESTORE SCREEN FROM PANTF
SET COLOR TO W/B
@ 2,48 SAY RFECHA
@ 2,48 GET RFECHA
READ
@ 2,48 SAY RFECHA
SAVE SCREEN TO MP1
SELECT 1
STORE SPACE(30) TO RCLI_NOM
@ 3,10 GET RCLI_NOM
READ
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
ENDIF
RESTORE SCREEN FROM MP1
@ 2,10 GET BUSCAR
READ
STORE VAL(BUSCAR) TO CLAVE
@ 2,10 SAY CLAVE PICTURE "999999"
STORE SPACE(24) TO RCLI_TCRE
IF CLAVE = 8888
STORE 8888 TO RCLI_NUM
STORE SPACE(30) TO RCLI_NOM, RCLI_DOM, RCLI_LOC
STORE SPACE(1) TO RCLI_CIVA
STORE SPACE(11) TO RCLI_CUIT
@ 3,10 GET RCLI_NOM
@ 4,10 GET RCLI_DOM
@ 5,10 GET RCLI_LOC
@ 4,51 GET RCLI_CIVA VALID(RCLI_CIVA$"INFRE")
READ
IF RCLI_CIVA <> "I"
STORE "NO SE POSEE" TO RCLI_CUIT
IF LEFT(RCLI_NOM,1) = " "
STORE "VENTA DE CONTADO" TO RCLI_NOM
@ 3,10 SAY RCLI_NOM
ENDIF
@ 4,64 SAY RCLI_CUIT
ENDIF
@ 4,64 GET RCLI_CUIT
@ 5,55 GET RCLI_TCRE
READ
STORE RCLI_CUIT TO RCUIT
ELSE
STORE NUMERO TO RCLI_NUM
STORE NOMBRE TO RCLI_NOM
STORE DOMICILIO TO RCLI_DOM
STORE LOCALIDAD TO RCLI_LOC
STORE CIVA TO RCLI_CIVA
STORE CUIT TO RCLI_CUIT, RCUIT
ENDIF
//IF RCLI_CIVA = "I" .OR. RCLI_CIVA = "N"
STORE "C" TO ZCBTE
//ELSE
//STORE "B" TO ZCBTE
//ENDIF
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
//IF XCBTE = "REMI"
STORE NUMEROA + 1 TO NCBTE
//ELSE
//STORE NUMEROB + 1 TO NCBTE
//ENDIF
MCBTE=XCBTE + " " + ZCBTE + " " + CFAC + "-" + RIGHT("00000000" + LTRIM(STR(NCBTE)),8)
@ 3,54 SAY MCBTE
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
SET COLOR TO W/R
@ 24,1 CLEAR TO 24,79
@ 24,1 SAY "PARA FINALIZAR: TECLA <=ESC=>"
SET COLOR TO W/B
SELECT 3
GO 1
DO WHILE RECNO() < 26 
RLOCK()
REPLACE DETALLE WITH SPACE(30), CODIGO WITH SPACE(14), LINEA WITH 0, CANT WITH 0, PLISTA WITH 0, PVENTA WITH 0, CONIVA WITH 0, SINIVA WITH 0, CONTABLE WITH 0, CODIVA WITH 0
UNLOCK
SKIP
ENDDO
STORE 0 TO TFAC
SAVE SCREEN TO VISTA0
SAVE SCREEN TO VISTA1
SAVE SCREEN TO VISTA2
SAVE SCREEN TO VISTA3
STORE 1 TO VISTA
STORE 9 TO LIN
STORE 0 TO TOTAL

GO 1
DO WHILE RECNO() < 26
        STORE RECNO() TO MFG
        STORE MFG + 8 TO LIN
        IF LIN = 20 .OR. LIN = 31
                RESTORE SCREEN FROM VISTA0
                //@ 2,10 SAY RCLI_NUM PICTURE "999999"
                //@ 2,48 SAY RFECHA
                //@ 3,10 SAY RCLI_NOM
                //@ 3,54 SAY MCBTE
                //@ 4,10 SAY RCLI_DOM
                //@ 5,10 SAY RCLI_LOC
                //@ 4,51 SAY RCLI_CIVA
                //@ 4,64 SAY RCLI_CUIT
                //@ 5,55 SAY RCLI_TCRE
                //@ 21,69 SAY TFAC PICTURE "###,###.##"
                //SET COLOR TO W/R
                //@ 24,1 CLEAR TO 24,79
                //@ 24,1 SAY "PARA FINALIZAR: TECLA <=ESC=>"
                //SET COLOR TO W/B
                
        ENDIF
                ****** CONTROLA SI COMPLETO LA PRIMER PANTALLA ******
                IF RECNO() < 12
                  SAVE SCREEN TO VISTA1
                 ELSE               
                  IF RECNO() = 12
                        SAVE SCREEN TO VISTA1
                        LIN = 9
                        RESTORE SCREEN FROM VISTA0
                        VISTA=2
                    ELSE
                        **** CONTROLA SI SE COMPLETA LA SEGUNDA PANTALLA ****
                        IF (RECNO() > 12) .AND. (RECNO() < 23)
                                SAVE SCREEN TO VISTA2
                                LIN = LIN - 12
                         ELSE
                           IF RECNO() = 23
                                SAVE SCREEN TO VISTA3
                                LIN = 9
                                RESTORE SCREEN FROM VISTA0
                                VISTA=3
                              ELSE
                                IF RECNO() > 23
                                        SAVE SCREEN TO VISTA3
                                ENDIF
                            ENDIF
                          ENDIF
                 ENDIF
              ENDIF
        STORE SPACE(14) TO BUSCAR
        @ LIN,2 GET BUSCAR
        READ

//  *************** CONTROLA SI SE INGRESO EL CODIGO ESPECIAL NUMERAL DELANTE DEL CODIGO**************************

        IF LEFT(ALLTRIM(BUSCAR),1)="#"
                STORE SPACE(20) TO RPRO_NOM
                STORE 0.00 TO RPRO_PRE
                STORE 1 TO RPRO_LIN
                STORE 1 TO RPRO_CIV
                SELECT 3
                RLOCK()
                REPLACE CODIGO WITH BUSCAR, PLISTA WITH RPRO_PRE, CONTABLE WITH RPRO_LIN, CANT WITH 1
                UNLOCK
                @ LIN,2 SAY CODIGO
                @ LIN,17 SAY DETALLE
                @ LIN,17 GET RPRO_NOM
                READ
                @ LIN,48 SAY PLISTA PICTURE "####.##"
                RLOCK()
                @ LIN,56 GET CANT PICTURE "####"
                @ LIN,61 GET PVENTA PICTURE "####.##"RANGE 0,9999
                READ
                UNLOCK
                IF PVENTA = 0              &&si no colocamos nada en el precio de venta asume el precio de lista
                        RLOCK()
                        REPLACE PVENTA WITH PLISTA
                        UNLOCK
                ENDIF
                RLOCK()
                REPLACE DETALLE WITH RPRO_NOM
                UNLOCK
                STORE 0 TO VALOR
                VALOR = PVENTA * CANT
                RLOCK()
                REPLACE CONIVA WITH ROUND(VALOR,2)
                @ LIN,56 SAY CANT PICTURE "####"
                @ LIN,61 SAY PVENTA PICTURE "####.##"  
                @ LIN,69 SAY CONIVA PICTURE "###,###.##"
                SELECT 6
                GO RPRO_CIV
                STORE TASA1 + 100 TO ALIC
                STORE TASA1 TO RCLI_ALIC
                SELECT 3
                REPLACE SINIVA WITH CONIVA * 100 / ALIC, CODIVA WITH RPRO_CIV, LINEA WITH 1
                UNLOCK
                TFAC = TFAC + CONIVA
                @ 21,69 SAY TFAC PICTURE "###,###.##"
                SKIP




        ELSE
        IF LASTKEY() = 27
                @ LIN,2 SAY SPACE(14)
                EXIT
        ENDIF
        IF LASTKEY() = 18
                SAVE SCREEN TO MP1
                SELECT 2
                SEEK BUSCAR
             DO WHILE EOF()
                SET ORDER TO 2
                GO TOP
                KEYBOARD CHR(4)
                SET COLOR TO W/R
                @ 4,40 CLEAR TO 21,70
                @ 4,40,21,71 BOX &caja9
                DBEDIT(5,41,20,70,campos,"finc")
                RESTORE SCREEN FROM MP1
                SET COLOR TO W/B
                IF LASTKEY() = 13
                        STORE NUMERO TO BUSCAR
                ENDIF
                IF LASTKEY() = 27
                        STORE SPACE(14) TO BUSCAR
                        EXIT
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
                STORE CONTABLE TO RPRO_LIN
                STORE CIVA TO RPRO_CIV
                STORE PRECIO TO RPRO_PRE
                SELECT 3
                RLOCK()
                REPLACE CODIGO WITH BUSCAR, DETALLE WITH RPRO_NOM, PLISTA WITH RPRO_PRE, CONTABLE WITH RPRO_LIN, CANT WITH 1
                UNLOCK
                @ LIN,2 SAY CODIGO
                @ LIN,17 SAY DETALLE
                @ LIN,48 SAY PLISTA PICTURE "####.##"
                RLOCK()
                @ LIN,56 GET CANT PICTURE "####"
                @ LIN,61 GET PVENTA PICTURE "####.##"RANGE 0,9999
                READ
                UNLOCK
                IF PVENTA = 0              &&si no colocamos nada en el precio de venta asume el precio de lista
                        RLOCK()
                        REPLACE PVENTA WITH PLISTA
                        UNLOCK
                ENDIF
                STORE 0 TO VALOR
                VALOR = PVENTA * CANT
                RLOCK()
                REPLACE CONIVA WITH ROUND(VALOR,2)
                @ LIN,56 SAY CANT PICTURE "####"
                @ LIN,61 SAY PVENTA PICTURE "####.##"  
                @ LIN,69 SAY CONIVA PICTURE "###,###.##"
                SELECT 6
                GO RPRO_CIV
                STORE TASA1 + 100 TO ALIC
                STORE TASA1 TO RCLI_ALIC
                SELECT 3
                REPLACE SINIVA WITH CONIVA * 100 / ALIC, CODIVA WITH RPRO_CIV, LINEA WITH 1
                UNLOCK
                TFAC = TFAC + CONIVA
                @ 21,69 SAY TFAC PICTURE "###,###.##"
                SKIP
        ENDIF
ENDIF
ENDDO
************* ALMACENA LA POSICION DEL ULTIMO ARTICULO INGRESADO ****************
STORE RECNO() TO ARTS

// Bonificaci¢n
STORE TFAC TO SUBTOTAL
STORE 0 TO BONIF        // Almacena el porcentaje de descuento
@22,69 SAY BONIF
@22,69 GET BONIF
READ
@22,69 SAY RIGHT((STR(BONIF)),8) + " %"
IF BONIF <> 0
        TFAC = TFAC - (BONIF * TFAC /100)
ENDIF
@23,69 SAY TFAC PICTURE "###,###.##"

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

 // STORE 0 TO NAVEGA
 // SET COLOR TO W+/R
 // @24,1 SAY "<<PagUp>> Anterior           Siguiente <<PagDown>>           <<ESC>> Finaliza"
 // @50,1 GET NAVEGA
 // READ
 // SET COLOR TO W/B
        
//****************CODIGO PARA CORREGIR FACTURAS***********************
        //SET KEY -1 TO ABAJO
        SET COLOR TO W/R
        @ 24,1 CLEAR TO 24,79
        @ 24,1 SAY "ARRIBA: Pg.Up   ABAJO: Pg.Dn   CORREGIR: Enter   ELIMINAR: Ctrl W   SALIR: Esc"
        SET COLOR TO W/B
        SELECT 3
        GO 1
        DO WHILE RECNO() < 25
                IF LINEA = 0
                        SKIP
                ENDIF
                IF LINEA = 1
                        SET COLOR TO W*/B
                        STORE RECNO() TO MFG
                        STORE RECNO() + 8 TO LIN
                        //IF MFG = 11 
                          //      SAVE SCREEN TO PAG1
                        //ENDIF
                        IF MFG > 11 .AND. MFG < 23
                                LIN = LIN - 11
                        ENDIF
                        IF MFG > 23
                                LIN = LIN - 21
                        ENDIF
                                  
                    
                        @ LIN,2 SAY CODIGO
                        KEYBOARD CHR(4)
                        KEYBOARD CHR(19)
                        SET COLOR TO W/B
                        RLOCK()
                        @ LIN,2 GET CODIGO
                        @10,10 SAY VISTA
                        READ
                        UNLOCK
                        TECLA=LASTKEY()
                        **************** CODIGO PARA NAVEGAR ENTRE FACTURAS *************
                        IF TECLA = 18   // CODIGO ASCII DE CTRL-R
                                IF VISTA=2
                                        RESTORE SCREEN FROM VISTA1
                                        @ 21,69 SAY SUBTOTAL PICTURE "###,###.##"
                                        @ 22,69 SAY BONIF
                                        @ 23,69 SAY TFAC PICTURE "###,###.##"
                                        VISTA=1
                                    ELSE
                                IF VISTA=3
                                        RESTORE SCREEN FROM VISTA2
                                        @ 21,69 SAY SUBTOTAL PICTURE "###,###.##"
                                        @ 22,69 SAY BONIF
                                        @ 23,69 SAY TFAC PICTURE "###,###.##"
                                        VISTA=2
                                ENDIF
                               ENDIF
                        ENDIF
                 IF TECLA = 3   // CODIGO ASCII DE CRTL-C
                        IF VISTA=1
                                RESTORE SCREEN FROM VISTA2
                                @ 21,69 SAY SUBTOTAL PICTURE "###,###.##"
                                @ 22,69 SAY BONIF
                                @ 23,69 SAY TFAC PICTURE "###,###.##"
                                VISTA=2
                         ELSE
                                IF VISTA = 2
                                        RESTORE SCREEN FROM VISTA3
                                        @ 21,69 SAY SUBTOTAL PICTURE "###,###.##"
                                        @ 22,69 SAY BONIF
                                        @ 23,69 SAY TFAC PICTURE "###,###.##"
                                        VISTA=3
                                ENDIF
                        ENDIF
                ENDIF        
            
            //SET COLOR TO W+/R
            //@24,1 SAY "<<PagUp>> Anterior           Siguiente <<PagDown>>           <<ESC>> Finaliza"
            //SET COLOR TO W/B
            //@50,1 GET NAVEGA
            //READ


     ************ FIN CODIGO PARA NAVEGAR *************************
                IF TECLA = 3 .AND. RECNO() < ARTS
                        @ LIN,2 SAY CODIGO
                        SKIP
                ENDIF
                IF TECLA = 18 .AND. RECNO() > 1
                        //IF RECNO() = 13 
                             //RESTORE SCREEN FROM PAG1
                        //ENDIF
                        @ LIN,2 SAY CODIGO
                        SKIP -1
                ENDIF
                IF TECLA = 23
                        TFAC = TFAC - CONIVA
                        RLOCK()
                        REPLACE DETALLE WITH SPACE(30), CODIGO WITH SPACE(14), LINEA WITH 0, CANT WITH 0, PLISTA WITH 0, PVENTA WITH 0, CONIVA WITH 0, SINIVA WITH 0, CONTABLE WITH 0, CODIVA WITH 0
                        UNLOCK
                        @ LIN,2 SAY SPACE(14)
                        @ LIN,17 SAY SPACE(30)
                        @ LIN,48 SAY SPACE(7)
                        @ LIN,56 SAY SPACE(4)
                        @ LIN,61 SAY SPACE(7)
                        @ LIN,69 SAY SPACE(10)
                        @ 22,69 SAY TFAC PICTURE "###,###.##"
                ENDIF
                IF TECLA = 13
                        TFAC = TFAC - CONIVA
                        @ LIN,56 SAY SPACE(4)
                        @ LIN,61 SAY SPACE(7)     //ERA 58
                        @ LIN,69 SAY SPACE(10)
                        @ 22,69 SAY TFAC PICTURE "###,###.##"
                        RLOCK()
                        @ LIN,56 GET CANT PICTURE "####" RANGE 1,9999
                        @ LIN,61 GET PVENTA PICTURE "####.##" RANGE 0,9999 //ERA 58
                        READ
                        UNLOCK
                        IF PVENTA = 0
                                RLOCK()
                                REPLACE PVENTA WITH PLISTA
                                UNLOCK
                        ENDIF
                        STORE 0 TO VALOR
                        VALOR = PVENTA * CANT
                        RLOCK()
                        REPLACE CONIVA WITH ROUND(VALOR,2)
                        @ LIN,56 SAY CANT PICTURE "####"
                        @ LIN,61 SAY PVENTA PICTURE "####.##"
                        @ LIN,69 SAY CONIVA PICTURE "###,###.##"
                        SELECT 6
                        GO RPRO_CIV
                        STORE TASA1 + 100 TO ALIC
                        SELECT 3
                        REPLACE SINIVA WITH CONIVA * 100 / ALIC, CODIVA WITH RPRO_CIV
                        UNLOCK
                        TFAC = TFAC + CONIVA
                        @ 22,69 SAY TFAC PICTURE "###,###.##"
                 ENDIF
                IF TECLA = 27
                        EXIT
                ENDIF
        ENDIF
  ENDDO
ENDDO
IF VIMP = 1
OCBTE=MCBTE
STORE 0 TO R_GRAVADO, R_IVA, R_IVANO
IF VCBTE = 2
STORE 3 TO VCBTE
ENDIF
SELECT 3
GO 1
DO WHILE RECNO() < 26
IF LINEA = 1 .AND. CANT > 0 .AND. CONIVA > 0
STORE CODIGO TO R_CODIGO
STORE CONIVA TO R_CONIVA
STORE CANT TO R_CANT
STORE SINIVA TO R_SINIVA
STORE CONTABLE TO R_CONTABLE
STORE PLISTA TO R_PLISTA
STORE PVENTA TO R_PVENTA
R_GRAVADO = R_GRAVADO + SINIVA
STORE 0 TO R_IVA, R_IVANO
IF RCLI_CIVA = "N"
SELECT 6
GO 1
R_IVANO = R_SINIVA * TASA2 / 100
ENDIF
R_IVA = R_CONIVA - R_SINIVA
SELECT 9
RLOCK()
APPEND BLANK
REPLACE PRODUCTO WITH R_CODIGO, FECHA WITH RFECHA, CBTE WITH MCBTE, CANT WITH R_CANT, VALOR WITH R_SINIVA, CONIVA WITH R_CONIVA, CLIENTE WITH RCLI_NUM, PLISTA WITH R_PLISTA, PVENTA WITH R_PVENTA
REPLACE IVA WITH R_IVA, IVANO WITH R_IVANO
IF VCBTE = 1
REPLACE TMOV WITH 5
ELSE
REPLACE TMOV WITH 2
ENDIF
UNLOCK
SELECT 10
SEEK R_CODIGO
IF EOF()
RLOCK()
APPEND BLANK
REPLACE PRODUCTO WITH R_CODIGO, UN_VEND WITH 0, VAL_VENTA WITH 0, EX_FISICA WITH 0, FU_VENTA WITH CTOD("  /  /    ")  
UNLOCK
ENDIF
IF .NOT. EOF()
RLOCK()
IF VCBTE = 1
REPLACE UN_VEND WITH UN_VEND + R_CANT, VAL_VENTA WITH VAL_VENTA + R_SINIVA, FU_VENTA WITH RFECHA, EX_FISICA WITH EX_FISICA - R_CANT
ELSE
REPLACE UN_VEND WITH UN_VEND - R_CANT, VAL_VENTA WITH VAL_VENTA - R_SINIVA, EX_FISICA WITH EX_FISICA + R_CANT
ENDIF
UNLOCK
ENDIF
SELECT 14
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
IF RCLI_CIVA = "N"
SELECT 6
GO 1
R_IVANO = R_GRAVADO * TASA2 / 100
TFAC = TFAC + R_IVANO
STORE 101 TO RM
SELECT 14
RLOCK()
APPEND BLANK
REPLACE NUMERO WITH RM, FECHA WITH RFECHA, CBTE WITH MCBTE, VALOR WITH R_IVANO
IF VCBTE = 1
REPLACE TMOV WITH 2
ELSE
REPLACE TMOV WITH 1
ENDIF
UNLOCK
SELECT 11
SEEK RM
RLOCK()
IF VCBTE = 1
REPLACE CREDITOS WITH CREDITOS + R_IVANO
ELSE
REPLACE DEBITOS WITH DEBITOS + R_IVANO
ENDIF
UNLOCK
ENDIF
R_IVA = TFAC - R_GRAVADO - R_IVANO
STORE 100 TO RM
SELECT 14
RLOCK()
APPEND BLANK
REPLACE NUMERO WITH RM, FECHA WITH RFECHA, CBTE WITH MCBTE, VALOR WITH R_IVA
IF VCBTE = 1
REPLACE TMOV WITH 2
ELSE
REPLACE TMOV WITH 1
ENDIF
UNLOCK
SELECT 11
SEEK RM
RLOCK()
IF VCBTE = 1
REPLACE CREDITOS WITH CREDITOS + R_IVA
ELSE
REPLACE DEBITOS WITH DEBITOS + R_IVA
ENDIF
UNLOCK
SELECT 5
RLOCK()
APPEND BLANK
REPLACE FECHA WITH RFECHA, NOMBRE WITH RCLI_NOM, CIVA WITH RCLI_CIVA, CUIT WITH RCLI_CUIT, CBTE WITH MCBTE, ALIC WITH RCLI_ALIC
REPLACE EXENTO WITH 0, GRAVADO WITH R_GRAVADO, IVA WITH R_IVA, IVANO WITH R_IVANO, NETO WITH TFAC, CLIENTE WITH RCLI_NUM 
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
IF RCLI_NUM <> 8888
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
ENDIF
//IF ZCBTE = "B"

SET COLOR TO W/R
@ 9,19,15,62 BOX &caja9
@ 11,29 SAY "IMPRIMIR COMPROBANTE ?"
STORE 1 TO VMENU
@ 13,34 PROMPT "SI"
@ 13,45 PROMPT "NO"
MENU TO VMENU
DO CASE 
        CASE VMENU=1
                STORE 1 TO CLAVE
        CASE VMENU=2
                STORE 2 TO CLAVE
ENDCASE
SET DEVICE TO PRINTER
@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)

DO WHILE CLAVE < 2
SELECT 7
@ 1,22 SAY CHR(18)+CHR(14)+TCBTE+" "+PREFIJO +"-"+ STRZERO(ncbte,8) 
@ 5,45 SAY "Fecha:"
@ 5,52 SAY RFECHA
IF RCLI_NUM <> 8888
@ 10,8 SAY "Cuenta N§"
@ 10,18 SAY RCLI_NUM PICTURE "######"
ENDIF
@ 10,65 SAY "Vendedor N§"
@ 10,77 SAY RCLI_VEN PICTURE "###"
@ 11,1 say "Nombre:"
@ 11,9 SAY RCLI_NOM
@ 12,1 say "Direccion:"
@ 12,12 SAY RCLI_DOM
@ 13,1 say "Localidad:"
@ 13,12 SAY RCLI_LOC
@ 13,50 SAY ALLTRIM(RCLI_TCRE)
IF RCLI_CIVA = "F"
@ 14,8 SAY "Consumidor Final"
ENDIF
IF RCLI_CIVA = "E"
@ 14,8 SAY "Exento"
ENDIF
IF RCLI_CIVA = "R"
@ 14,8 SAY "No Responsable"
ENDIF
@ 14,60 SAY RCLI_CUIT
IF RCLI_NUM = 8888
@ 16,16 SAY "Contado"
ELSE
@ 16,16 SAY "Cuenta Corriente"
ENDIF
@ 19,5 SAY "CODIGO"
@ 19,23 SAY "NOMBRE PRODUCTO"
@ 19,46 SAY "CANT"
@ 19,52 SAY "PRECIO"
@ 19,72 SAY "IMPORTE"
STORE 21 TO LIN
@ 20,1 SAY CHR(27)+CHR(120)+"0"
SELECT 3
GO 1
DO WHILE RECNO() < 26

IF LINEA = 1 .AND. CANT > 0 .AND. CONIVA > 0
@ LIN,1 SAY CODIGO 
@ LIN,16 SAY DETALLE
@ LIN,46 SAY CANT PICTURE "####"
@ LIN,51 SAY PVENTA PICTURE "#,###.##"
@ LIN,70 SAY CONIVA PICTURE "###,###.##"
LIN = LIN + 1
ENDIF
SKIP
ENDDO
@ 51,59 SAY "Subtotal =>" 
@ 51,70 SAY SUBTOTAL PICTURE "###,###.##"
@ 52,55 SAY "Bonificacion =>"
@ 52,70 SAY BONIF PICTURE "###,###.##"
@ 53,62 SAY "Total =>" 
@ 53,70 SAY TFAC PICTURE "###,###.##"
CLAVE = CLAVE + 1
ENDDO
IF VMENU = 1
        EJECT
ENDIF
SET DEVICE TO SCREEN
//ENDIF
          //si fue una factura acumula el numero
        SELECT 7
        GO 1
        RLOCK()
        //IF XCBTE = "REMI"
                REPLACE NUMEROA WITH NCBTE
        //ELSE
          //      REPLACE NUMEROB WITH NCBTE
        //ENDIF
        UNLOCK

ENDIF
ENDDO
CLOSE ALL
RETURN

PROCEDURE ABAJO
                        @ LIN,2 SAY CODIGO
                        SKIP
                        LIN = LIN + 1
RETURN

