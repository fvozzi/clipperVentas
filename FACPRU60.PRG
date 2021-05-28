******************************************************************************
*       EN ESTA VERSION ELIMINE TODOS LOS COPY + PARA VER SI PODIA
*       SOLUCIONAR EL PROBLEMA DE MAGGI
*
******************************************************************************

SET SCOREBOARD ON
SET CONFIRM OFF
SET DATE BRITISH
SET CENTURY ON
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
PUBLIC LINEA:= SPACE(1), IND, POSPANT
PRIVATE RESP, NRO, TECLA     // Donde RESP es para almacenar la respuesta y NRO el numero de comprobante abierto
DECLARE campos[2], MATRIZ[100,15]
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
SELECT 14
USE FISCAL
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
@ 11,19 SAY "Dise¤o y Programaci¢n: Dep. Sistemas"
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
                  @ 14,29 SAY PRECIO PICTURE "##,###.##"
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
        STORE "F" TO RCLI_CIVA
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
IF LASTREC() > 1
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
ENDIF
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
GO 1
****                          *****  
* INICIALIZA LA MATRIZ DE TRABAJO*
****                          *****
IND = 1
DO WHILE IND < 100
        MATRIZ[IND,1]= SPACE(14)        //CODIGO
        MATRIZ[IND,2]= SPACE(28)        //DETALLE
        MATRIZ[IND,3]= 0                //PLISTA
        MATRIZ[IND,4]= 0                //CANT
        MATRIZ[IND,5]= 0                //PVENTA
        MATRIZ[IND,6]= 0                //CONIVA
        MATRIZ[IND,7]= 0                //SINIVA
        MATRIZ[IND,8]= 0                //CONTABLE
        MATRIZ[IND,9]= 0                //CODIVA
        MATRIZ[IND,10]= 0                //INTERNO
        MATRIZ[IND,11]= 0                //GRAVADO
        MATRIZ[IND,12]= 0                //EXENTO
        MATRIZ[IND,13]= 0                //IVA
        MATRIZ[IND,14]= 0                //IVANO
        MATRIZ[IND,15]= 0                //IMP_INT
        IND = IND + 1           
ENDDO
STORE 0 TO TFAC
IND = 1
POSPANT = 8
STORE 0 TO CTR
STORE 1 TO CC
DO WHILE IND < 100
        IF POSPANT < 21 .AND. CTR = 0 .AND. CC = 1
                POSPANT = POSPANT + 1
        ENDIF
        IF POSPANT = 21
                POSPANT = 20
                CTR = 1
        ENDIF
        IF POSPANT = 20 .AND. CTR = 1
                BAJA()
        ENDIF
        STORE SPACE(11) TO BUSCAR
        @ POSPANT,2 GET BUSCAR
        READ
        IF LASTKEY() = 27
                @ POSPANT ,2 SAY SPACE(11)
                POSPANT = POSPANT - 1
                IND = IND - 1
                EXIT
        ENDIF
        C = AGREGARITEM()
ENDDO
STORE 0 TO PAGO
IF XCBTE = "FACT"
        @ 22,72 GET PAGO PICTURE "#####.##"
        READ
ENDIF
STORE 1 TO CFISCAL
DO WHILE CFISCAL = 1
        STORE 2 TO VIMP
        DO WHILE VIMP = 2
                SET COLOR TO W/R
                @ 24,1 CLEAR TO 24,79
                @ 24,10 PROMPT "CONFIRMAR"
                @ 24,25 PROMPT "CORREGIR"
                @ 24,40 PROMPT "CORR. CUIT"
                @ 24,65 PROMPT "ANULAR"
                MENU TO VIMP
                IF TFAC = 0
                        STORE 4 TO VIMP
                ENDIF
                IF VIMP = 1 .OR. VIMP = 4 .OR. VIMP = 3
                        EXIT
                ENDIF
                SET COLOR TO W/R
                @ 24,1 CLEAR TO 24,79
                SET COLOR TO G/R                
                @ 24,1 SAY "ARRIBA:       ABAJO:       CORREGIR:       ELIMINAR:        ADD:    SALIR:    "
                SET COLOR TO W+/R
                @ 24,8 SAY "Pg.Up"
                @ 24,21 SAY "Pg.Dn"
                @ 24,37  SAY "Enter"
                @ 24,53 SAY "Ctrl W"
                @ 24,65 SAY "F1"
                @ 24,76 SAY "Esc"
                SET COLOR TO W/B
                DO WHILE IND < 100
                     IF MATRIZ[IND,4] > 0
                        STORE MATRIZ[IND,1] TO R_CODIGO
                        SET COLOR TO B/G
                        @ POSPANT,2 SAY MATRIZ[IND,1]
                        SET COLOR TO W/B

                        TECLA = INKEY(0)
                        IF TECLA = 24 .AND. IND < 100
                                @ POSPANT,2 SAY MATRIZ[IND,1]        
                                BAJASCR()
                        ENDIF
                        IF TECLA = 5 .AND. IND > 1
                                @ POSPANT,2 SAY MATRIZ[IND,1]
                                SUBESCR()
                        ENDIF
                        IF TECLA = 23
                                TFAC = TFAC - MATRIZ[IND,6]
                                BORRAR(IND)
                                @ 23,69 SAY TFAC PICTURE "###,###.##"
                        ENDIF
                        IF TECLA = 13
                                TFAC = TFAC - MATRIZ[IND,6]
                                @ POSPANT,54 SAY SPACE(4)
                                @ POSPANT,61 SAY SPACE(7)
                                @ POSPANT,69 SAY SPACE(10)
                                @ 23,69 SAY TFAC PICTURE "###,###.##"
                                @ POSPANT,54 GET MATRIZ[IND,4] PICTURE "###.##" RANGE 0,999
                                @ POSPANT,61 GET MATRIZ[IND,5] PICTURE "#####.##" 
                                READ
                                IF MATRIZ[IND,5] = 0
                                        MATRIZ[IND,5] = MATRIZ[IND,3]
                                ENDIF
                                STORE 0 TO VALOR
                                VALOR = (((ROUND(((MATRIZ[IND,5] * MATRIZ[IND,4]) / 1.21),4)) * 1.21) )
                                MATRIZ[IND,6] = ROUND(VALOR,4)
                                @ POSPANT,54 SAY MATRIZ[IND,4] PICTURE "###.##"
                                @ POSPANT,61 SAY MATRIZ[IND,5] PICTURE "#####.##"
                                @ POSPANT,70 SAY MATRIZ[IND,6] PICTURE "##,###.##"
                                STORE MATRIZ[IND,9] TO RPRO_CIV
                                SELECT 6
                                GO RPRO_CIV
                                STORE TASA1 + 100 TO ALIC
                                STORE TASA1 TO RCLI_ALIC
                                SELECT 3
                                STORE 0 TO VAL_SINIVA, VAL_IMPINT, R_GRAVADO, R_EXENTO, R_IVA, R_IVANO
                                VAL_IMPINT =  MATRIZ[IND,4] * MATRIZ[IND,10]
                                VAL_SINIVA = (MATRIZ[IND,6] - VAL_IMPINT) * 100 / ALIC
                                IF RCLI_ALIC = 0
                                        MATRIZ[IND,1] = R_CODIGO
                                        MATRIZ[IND,12] = MATRIZ[IND,6]
                                        MATRIZ[IND,7] = MATRIZ[IND,6]
                                        MATRIZ[IND,13] = 0
                                        MATRIZ[IND,14] = 0
                                        MATRIZ[IND,11] = 0
                                        MATRIZ[IND,15] = 0
                                        MATRIZ[IND,10] = 0
                                ENDIF
                                IF RCLI_ALIC > 0
                                        R_GRAVADO = VAL_SINIVA
                                        R_EXENTO = VAL_IMPINT
                                        R_IVA = R_GRAVADO * RCLI_ALIC / 100
                                        IF RCLI_CIVA = "R"
                                                R_IVANO = R_IVA / 2
                                                MATRIZ[IND,6] = R_GRAVADO + R_EXENTO + R_IVA + R_IVANO
                                        ENDIF
                                        MATRIZ[IND,1] = R_CODIGO
                                        MATRIZ[IND,7] = VAL_SINIVA
                                        MATRIZ[IND,15] = VAL_IMPINT
                                        MATRIZ[IND,9] = RPRO_CIV
                                        MATRIZ[IND,11] = R_GRAVADO
                                        MATRIZ[IND,12] = R_EXENTO
                                        MATRIZ[IND,13] = R_IVA
                                        MATRIZ[IND,14] = R_IVANO
                                ENDIF
                                TFAC = TFAC + MATRIZ[IND,6]
                                SET COLOR TO W/B
                                @ 23,69 SAY TFAC PICTURE "###,###.##"
                        ENDIF
                        IF TECLA = 28
                                *******************
                                * CODIGO PARA AGREGAR UN ITEM
                                * LUEGO DE CERRAR LA FACTURA
                                *******************
                                *****
                                * UBICA EL CURSOR EN LA ULTIMA POSICION DE LA LISTA
                                *****
                                @ POSPANT,2 SAY MATRIZ[IND,1]
                                ULTIMAPOS()
                                STORE SPACE(11) TO BUSCAR
                                @ POSPANT,2 GET BUSCAR
                                READ
                                AGREGARITEM()
                                IND = IND - 1
                        ENDIF
                        IF TECLA = 27
                                @ 22,72 GET PAGO PICTURE "#####.##"
                                READ
                                EXIT
                        ENDIF
                ENDIF
        ENDDO   //DO WHILE IND < 100
ENDDO   // DO WHILE VIMP = 2
IF VIMP = 4
        EXIT
ENDIF
IF VIMP = 3
        SELECT 1
        @ 4,64 GET RCLI_CUIT
        READ
        @ 4,64 SAY RCLI_CUIT
        RLOCK()
        REPLACE CUIT WITH RCLI_CUIT
        UNLOCK
        VIMP = 1  //PARA CONTINUAR
ENDIF
IF VIMP = 1
        TFAC  = 0
        SELECT 3
        IND = 1
        DO WHILE IND < 100
                IF MATRIZ[IND,4] > 0
                        TFAC = TFAC + MATRIZ[IND,6]
                        STORE MATRIZ[IND,9] TO RPRO_CIV
                        SELECT 6
                        GO RPRO_CIV
                        STORE TASA1 + 100 TO ALIC
                        STORE TASA1 TO RCLI_ALIC
                        SELECT 3
                        STORE 0 TO VAL_SINIVA, VAL_IMPINT, R_GRAVADO, R_EXENTO, R_IVA, R_IVANO
                        VAL_IMPINT =  MATRIZ[IND,4] * MATRIZ[IND,10]
                        VAL_SINIVA = (MATRIZ[IND,6] - VAL_IMPINT) * 100 / ALIC
                        VAL_IMPINT = ROUND(VAL_IMPINT,2)
                        VAL_SINIVA = ROUND(VAL_SINIVA,2)
                        IF RCLI_ALIC = 0
                                MATRIZ[IND,12] = MATRIZ[IND,6]
                                MATRIZ[IND,7] = MATRIZ[IND,6]
                                MATRIZ[IND,13] = 0
                                MATRIZ[IND,14] = 0
                                MATRIZ[IND,11] = 0
                                MATRIZ[IND,15] = 0
                                MATRIZ[IND,10] = 0
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
                                MATRIZ[IND,12] = R_EXENTO
                                MATRIZ[IND,7] = R_GRAVADO + R_EXENTO
                                MATRIZ[IND,13] = R_IVA
                                MATRIZ[IND,14] = R_IVANO
                                MATRIZ[IND,11] = R_GRAVADO
                                MATRIZ[IND,15] = VAL_IMPINT
                        ENDIF
                ENDIF
                IND = IND + 1
        ENDDO
@ 23,69 SAY TFAC PICTURE "###,###.##"
SAVE SCREEN TO PANTAUX

        SELECT 14
        *USE FISCAL2
        *GO 1
        *RLOCK()
        *REPLACE LETRA WITH ZCBTE, CIVAC WITH RCLI_CIVA, NOMBRE WITH RCLI_NOM, TDOC WITH RCLI_TDOC, CUIT WITH RCLI_CUIT, DOMICILIO WITH RCLI_DOM, LOCALIDAD WITH RCLI_LOC
        *UNLOCK
        *COPY TO TEXTO1.TXT SDF
        
        ******************************************
        *  SELECCIONA EL ARCHIVO DE DETALLE DEL TXT Y BORRA TODO LO ANTERIOR
        ******************************************
        SELECT 14
        GO 1
        FOR I=1 TO 35
            RLOCK()
            REPLACE DETALLE WITH " "
            SKIP
        NEXT
        INDICE = 1
        GO INDICE
        ************************************
        * CARGA LA LINEA 1 (DATOS DEL CLIENTE)
        ************************************
        RLOCK()
        REPLACE DETALLE WITH "@FACTABRE|00001|T|C|" + ZCBTE + "|" + "2" + "|" + "P" + "|" + "10" + "|" + "I" + "|" + RCLI_CIVA + "|" + RCLI_NOM + "||" + RCLI_TDOC  + "|" + RCLI_CUIT + "|" + "N" + "|" + RCLI_DOM + "|" + RCLI_LOC + "||1||C"
        UNLOCK
        SKIP

        *USE FISCAL3
        STORE 0 TO MM
        *SELECT 3
        IND = 1
        DO WHILE IND < 100 .AND. MATRIZ[IND,4] <> 0
                MM = MM + 1
                STORE matriz[IND,2] TO MP
                STORE SPACE(1) TO MK1, MK2, MK3, MK4, MK5
                MK1 = RIGHT("0000" + LTRIM(STR(MM)),4)
                *******************
                * ALMACENA LA CANT REAL EN MK6 PARA MOSTRARLA DELANTE DE LA DESCRIPCION DEL PRODUCTO
                ********************
                STORE ALLTRIM(STR(MATRIZ[IND,4],5,1)) TO MK6
                STORE MATRIZ[IND,4] * 1000 TO RCANT
                RCANT = ROUND(RCANT,0)
                MK2 = RIGHT("00000000" + LTRIM(STR(RCANT)),8)
                IF ZCBTE = "A"
                        STORE MATRIZ[IND,7] * 100 TO RCANT
                ELSE
                        STORE MATRIZ[IND,6] * 100 TO RCANT
                ENDIF
                        RCANT = ROUND(RCANT,0)
                        MK3 = RIGHT("000000000" + LTRIM(STR(RCANT)),9)
                        STORE "00000000" TO MK5
                        IF MATRIZ[IND,10] > 0
                                RCANT = 100 - ((MATRIZ[IND,10] * 100) / (MATRIZ[IND,10] + MATRIZ[IND,7]))
                                RCANT = RCANT * 1000000
                                RCANT = ROUND(RCANT,0)
                                MK5 = RIGHT("00000000" + LTRIM(STR(RCANT)),8)
                        ENDIF
                        STORE MATRIZ[IND,9] TO RPRO_CIV
                        SELECT 6
                        GO RPRO_CIV
                        STORE TASA1 * 100 TO RCANT

                        *****************************
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
                        RLOCK()
                        *REPLACE NUMERO WITH MK1, PRODUCTO WITH (LEFT((MK6+"/"+MP),20)), CANT WITH "00001000", PRECIO WITH MK3, IVA WITH MK4, AJUSTE WITH MK5
                        REPLACE DETALLE WITH "@FACTITEM|" + MK1 + "|" + (LEFT((MK6+"/"+MP),20)) + "|" + "00001000" + "|" + MK3 + "|" + MK4 + "|" + "M" + "|" + "00001" + "|" + MK5 + "||||0000|00000000"
                        UNLOCK
                        SKIP
                        *COPY TO TEXTO2.TXT SDF
                        *RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
                        IND = IND + 1
ENDDO
SELECT 14
*USE FISCAL4
*COPY TO TEXTO2.TXT SDF
*RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
**********************************************
* CARGA LA LINEA DE SUBTOTAL
**********************************************
RLOCK()
REPLACE DETALLE WITH "@FACTSUBTOTAL|0001|P|SUB-TOTAL"
UNLOCK
SKIP
*USE FISCAL5
*GO 1
STORE (TFAC - PAGO) * 100 TO RCANT
STORE (PAGO) * 100 TO RCANT1
RCANT = ROUND(RCANT,0)
RCANT1 = ROUND(RCANT1,0)
MK1 = RIGHT("000000000" + LTRIM(STR(RCANT)),9)
MK2 = RIGHT("000000000" + LTRIM(STR(RCANT1)),9)
************************************************
* CARGA LA LINEA DE DETALLE DE PAGO
************************************************
        RLOCK()
        REPLACE DETALLE WITH "@FACTPAGO|0001|EN EFECTIVO|" + MK2 + "|T"
        UNLOCK
        IF RCLI_NUM <> 888888
                RLOCK()
                REPLACE DETALLE WITH "@FACTPAGO|0001|EN CTA.CTE.|" + MK1 + "|T"
                UNLOCK
        ENDIF
        SKIP

        *COPY TO TEXTO2.TXT SDF
        *RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT
        *SELECT 14
        *USE FISCAL7
        *GO 1

        RLOCK()
        REPLACE DETALLE WITH "@FACTCIERRA|0001|T|" + ZCBTE + "|TOTAL ->"
        UNLOCK

        **********************************************************
        * COPIA TODO LA FACTURA A TEXTO1.TXT
        **********************************************************

        COPY TO TEXTO1.TXT SDF

        *COPY TO TEXTO2.TXT SDF
        *RUN COPY TEXTO1.TXT + TEXTO2.TXT TEXTO1.TXT

        ERASE PFISOUT.TXT

        SELECT 15
        USE ESTADO1
        COPY TO ESTADO2

        SELECT 15
        USE ESTADO2
IF VCBTE = 1
        RUN PFBATCH /C:2 /I:ESTADO.TXT /NOECHO
        APPEND FROM PFISOUT.TXT SDF
        GO 1
        IF SUBSTR(LEYENDA,31,2) <> "OK"
                RESTORE SCREEN FROM PANTAUX
                LOOP
                ENDIF
ENDIF
        IF VCBTE=2
                SELECT 15
                GO 1
                RLOCK()
                LEYENDA= "OK"
                UNLOCK
        ENDIF
        IF SUBSTR(LEYENDA,31,2) = "OK" .OR. VCBTE=2
                IF VCBTE=1
                        ERASE PFISOUT.TXT
                        RUN PFBATCH /C:2 /I:TEXTO1.TXT /NOECHO
                        SELECT 15
                        USE ESTADO1
                        COPY TO ESTADO2
                        SELECT 15
                        USE ESTADO2
                        APPEND FROM PFISOUT.TXT SDF
                        GO 2
                        IF SUBSTR(LEYENDA,31,5) = "ERROR"
                                RESTORE SCREEN FROM PANTAUX
                                LOOP
                        ENDIF
************ IF VCBTE=1*************
                ENDIF           
**********************************
        RESTORE SCREEN FROM PANTAUX
        OCBTE=MCBTE
        STORE 0 TO T_GRAVADO, T_EXENTO, T_IVA, T_IVANO
        SELECT 3
        GO 1
        IND = 1
        DO WHILE IND < 100
                IF MATRIZ[IND,4] > 0 .AND. MATRIZ[IND,6] > 0
                        STORE MATRIZ[IND,1] TO R_CODIGO
                        STORE MATRIZ[IND,6] TO R_CONIVA
                        STORE MATRIZ[IND,4] TO R_CANT
                        STORE MATRIZ[IND,7] TO R_SINIVA
                        STORE MATRIZ[IND,8] TO R_CONTABLE
                        STORE MATRIZ[IND,3] TO R_PLISTA
                        STORE MATRIZ[IND,5] TO R_PVENTA
                        STORE MATRIZ[IND,10] TO VAL_IMPINT
                        STORE MATRIZ[IND,9] TO RPRO_CIV
                        STORE MATRIZ[IND,11] TO R_GRAVADO
                        STORE MATRIZ[IND,12] TO R_EXENTO
                        STORE MATRIZ[IND,13] TO R_IVA
                        STORE MATRIZ[IND,14] TO R_IVANO
                        T_GRAVADO = T_GRAVADO + R_GRAVADO 
                        T_EXENTO = T_EXENTO + R_EXENTO 
                        T_IVA = T_IVA + R_IVA
                        T_IVANO = T_IVANO + R_IVANO
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
                        SELECT 10
                        IF R_CODIGO <> "1" .AND. R_CODIGO <> "2"
                                SEEK R_CODIGO
                                IF EOF()
                                        RLOCK()
                                        APPEND BLANK
                                        REPLACE PRODUCTO WITH R_CODIGO, UN_TRANSFI WITH 0, UN_TRANSFE WITH 0, UN_VEND WITH 0, VAL_VENTA WITH 0, EX_FISICA WITH 0, FU_VENTA WITH CTOD("  /  /    ")  
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
                        ENDIF
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
                IND = IND + 1
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
ENDIF
ENDDO
ENDDO
CLOSE ALL
RETURN

PROCEDURE BAJA
        IF IND < 100
                IF POSPANT < 20
                        POSPANT = POSPANT + 1
                ELSE
                        FOR J=11 TO 0 STEP -1
                                @ POSPANT - J,2 SAY MATRIZ[IND - J,1]
                                @ POSPANT - J,17 SAY MATRIZ[IND - J,2] PICTURE REPLICATE("A",28)
                                @ POSPANT - J,46 SAY MATRIZ[IND - J,3] PICTURE "####.##"
                                @ POSPANT - J,54 SAY MATRIZ[IND - J,4] PICTURE "###.##" //RANGE 1,9999
                                @ POSPANT - J,61 SAY MATRIZ[IND - J,5] PICTURE "#####.##"// RANGE 0,9999
                                @ POSPANT - J,70 SAY MATRIZ[IND - J,6] PICTURE "##,###.##" 
                        NEXT
                        @ POSPANT,2 SAY SPACE(11)
                        @ POSPANT,17 SAY SPACE(28)
                        @ POSPANT,46 SAY SPACE(8)
                        @ POSPANT,54 SAY SPACE(7) //RANGE 1,9999
                        @ POSPANT,61 SAY SPACE(8) //RANGE 0,9999
                        @ POSPANT,70 SAY SPACE(10)
                ENDIF
        ENDIF
RETURN

PROCEDURE BAJASCR
        IF IND < 100
                IF MATRIZ[IND + 1,4] > 0
                        IND = IND + 1
                        IF POSPANT < 20
                                POSPANT = POSPANT + 1
                        ELSE
                                FOR J=11 TO 0 STEP -1
                                        @ POSPANT - J,2 SAY MATRIZ[IND - J,1]
                                        @ POSPANT - J,17 SAY MATRIZ[IND - J,2] PICTURE REPLICATE("A",28)
                                        @ POSPANT - J,46 SAY MATRIZ[IND - J,3] PICTURE "####.##"
                                        @ POSPANT - J,54 SAY MATRIZ[IND - J,4] PICTURE "###.##" //RANGE 1,9999
                                        @ POSPANT - J,61 SAY MATRIZ[IND - J,5] PICTURE "#####.##"// RANGE 0,9999
                                        @ POSPANT - J,70 SAY MATRIZ[IND - J,6] PICTURE "##,###.##" 
                                NEXT
                        ENDIF
                ENDIF
        ENDIF
RETURN

PROCEDURE SUBESCR
        IF IND > 1
                IF MATRIZ[IND - 1,4] > 0
                        IND = IND - 1
                        IF POSPANT > 9
                                POSPANT = POSPANT - 1
                        ELSE
                                FOR J=0 TO 11 
                                        @ POSPANT + J,2 SAY MATRIZ[IND + J,1]
                                        @ POSPANT + J,17 SAY MATRIZ[IND + J,2] PICTURE REPLICATE("A",28)
                                        @ POSPANT + J,46 SAY MATRIZ[IND + J,3] PICTURE "####.##"
                                        @ POSPANT + J,54 SAY MATRIZ[IND + J,4] PICTURE "###.##" //RANGE 1,9999
                                        @ POSPANT + J,61 SAY MATRIZ[IND + J,5] PICTURE "#####.##"// RANGE 0,9999
                                        @ POSPANT + J,70 SAY MATRIZ[IND + J,6] PICTURE "##,###.##"
                                NEXT
                        ENDIF
                 ENDIF
        ENDIF
RETURN

PROCEDURE BORRAR
        STORE IND TO J
        DO WHILE MATRIZ[J,4] <> 0 
                MATRIZ[J,1] = MATRIZ[J+1,1]
                MATRIZ[J,2] = MATRIZ[J+1,2]
                MATRIZ[J,3] = MATRIZ[J+1,3]
                MATRIZ[J,4] = MATRIZ[J+1,4]
                MATRIZ[J,5] = MATRIZ[J+1,5]
                MATRIZ[J,6] = MATRIZ[J+1,6]
                MATRIZ[J,7] = MATRIZ[J+1,7]
                MATRIZ[J,8] = MATRIZ[J+1,8]
                MATRIZ[J,9] = MATRIZ[J+1,9]
                MATRIZ[J,10] = MATRIZ[J+1,10]
                MATRIZ[J,11] = MATRIZ[J+1,11]
                MATRIZ[J,12] = MATRIZ[J+1,12]
                MATRIZ[J,13] = MATRIZ[J+1,13]
                MATRIZ[J,14] = MATRIZ[J+1,14]
                J = J + 1
        ENDDO
        STORE IND TO J
        DO WHILE (POSPANT + (J-IND) < 21)
                @ POSPANT + (J-IND),2  SAY MATRIZ[J,1]
                @ POSPANT + (J-IND),17 SAY MATRIZ[J,2] PICTURE REPLICATE("A",28)
                @ POSPANT + (J-IND),46 SAY MATRIZ[J,3] PICTURE "####.##"
                @ POSPANT + (J-IND),54 SAY MATRIZ[J,4] PICTURE "###.##" //RANGE 1,9999
                @ POSPANT + (J-IND),61 SAY MATRIZ[J,5] PICTURE "#####.##"// RANGE 0,9999
                @ POSPANT + (J-IND),70 SAY MATRIZ[J,6] PICTURE "##,###.##"
                J = J + 1
        ENDDO
        IF MATRIZ[IND,4] = 0
                IND = IND - 1
                POSPANT = POSPANT - 1
        ENDIF
RETURN


FUNCTION AGREGARITEM
*************************************************************
*  PROCEDIMIENTO PARA AGREGAR ITEMS EN UNA FACTURA
*
*************************************************************
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
                                STORE SPACE(11) TO BUSCAR
                                CONTROL=1
                        ENDIF
                        @ POSPANT,2 SAY BUSCAR
                        SET ORDER TO 1
                        SEEK BUSCAR
                ENDDO
                RESTORE SCREEN FROM MP1
                @ POSPANT,2 SAY BUSCAR
        ENDIF
        SELECT 2
        SEEK BUSCAR
        IF EOF() 
                POSPANT = POSPANT - 1
                CTR = 0
                //LOOP
        ENDIF
        IF .NOT. EOF()
                STORE NOMBRE TO RPRO_NOM
                IF VAL(BUSCAR) = 1 .OR. VAL(BUSCAR) = 2
                        @ POSPANT,2 SAY BUSCAR
                        STORE SPACE(28) TO RPRO_NOM
                        @ POSPANT,17 GET RPRO_NOM
                        READ
                ENDIF
                STORE CONTABLE TO RPRO_LIN
                STORE CIVA TO RPRO_CIV
                STORE PRECIO TO RPRO_PRE
                STORE INTERNO TO RPRO_INT
                SELECT 3
                MATRIZ[IND,1] = BUSCAR
                MATRIZ[IND,2] = RPRO_NOM
                MATRIZ[IND,3] = RPRO_PRE
                MATRIZ[IND,8] = RPRO_LIN
                MATRIZ[IND,4] = 1
                MATRIZ[IND,10] = RPRO_INT
                @ POSPANT,2 SAY MATRIZ[IND,1]
                @ POSPANT,17 SAY MATRIZ[IND,2] PICTURE "AAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                @ POSPANT,46 SAY MATRIZ[IND,3] PICTURE "####.##"
                @ POSPANT,54 GET MATRIZ[IND,4] PICTURE "###.##" RANGE 0,999
                @ POSPANT,61 GET MATRIZ[IND,5] PICTURE "#####.##" //RANGE 0,9999
                READ
                IF MATRIZ[IND,5] = 0
                        MATRIZ[IND,5] = MATRIZ[IND,3]
                ENDIF

                **************************** CONTROLA LOS CENTAVOS CON EL IMPRESOR FISCAL **************
                STORE 0 TO VALOR
                VALOR = (((ROUND(((MATRIZ[IND,5] * MATRIZ[IND,4])/ 1.21),4)) * 1.21) )
                ****************************FIN*********************************

                MATRIZ[IND,6] = ROUND(VALOR,4)
                @ POSPANT,54 SAY MATRIZ[IND,4] PICTURE "###.##"
                @ POSPANT,61 SAY MATRIZ[IND,5] PICTURE "#####.##"
                @ POSPANT,70 SAY MATRIZ[IND,6] PICTURE "##,###.##"
                SELECT 6
                GO RPRO_CIV
                STORE TASA1 * 100 TO ALIC
                STORE TASA1 TO RCLI_ALIC
                SELECT 3
                STORE 0 TO VAL_SINIVA, VAL_IMPINT, R_GRAVADO, R_EXENTO, R_IVA, R_IVANO
                VAL_IMPINT =  MATRIZ[IND,4] * MATRIZ[IND,10]
                VAL_SINIVA = (MATRIZ[IND,6] - VAL_IMPINT) * 100 / ALIC
                IF RCLI_ALIC = 0
                        MATRIZ[IND,12] = MATRIZ[IND,6]
                        MATRIZ[IND,13] = 0
                        MATRIZ[IND,14] = 0
                        MATRIZ[IND,11] = 0
                        MATRIZ[IND,15] = 0
                        MATRIZ[IND,10] = 0
                ENDIF
                IF RCLI_ALIC > 0
                        R_GRAVADO = VAL_SINIVA
                        R_EXENTO = VAL_IMPINT
                        R_IVA = R_GRAVADO * RCLI_ALIC / 100
                        IF RCLI_CIVA = "R"
                                R_IVANO = R_IVA / 2
                                MATRIZ[IND,6] = R_GRAVADO + R_EXENTO + R_IVA + R_IVANO
                        ENDIF
                        MATRIZ[IND,7] = VAL_SINIVA
                        MATRIZ[IND,15] = VAL_IMPINT
                        MATRIZ[IND,9] = RPRO_CIV
                        MATRIZ[IND,11] = R_GRAVADO
                        MATRIZ[IND,12] = R_EXENTO
                        MATRIZ[IND,13] = R_IVA
                        MATRIZ[IND,14] = R_IVANO
                ENDIF           
                TFAC = TFAC + MATRIZ[IND,6]
                @ 23,69 SAY TFAC PICTURE "###,###.##"
                IND = IND + 1
        ENDIF
RETURN 1

PROCEDURE ULTIMAPOS
        CTR = 0
        DO WHILE MATRIZ[IND,4] <> 0 .AND. IND < 100
                IF POSPANT < 21 .AND. CTR = 0 .AND. CC = 1
                        POSPANT = POSPANT + 1
                ENDIF
                IF POSPANT = 21
                        POSPANT = 20
                        CTR = 1
                ENDIF
                IF POSPANT = 20 .AND. CTR = 1
                        BAJA()
                ENDIF
                IND = IND + 1
        ENDDO
        IF POSPANT = 20
                BAJA()
        ENDIF
        CTR = 0
RETURN 

