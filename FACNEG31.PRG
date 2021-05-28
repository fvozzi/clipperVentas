SET SCOREBOARD ON
SET CONFIRM OFF
SET DATE BRITISH
SET CENTURY ON
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
PUBLIC Handler, Port, Se, LINEA, IND, POSPANT
PRIVATE RESP, NRO, TECLA     // Donde RESP es para almacenar la respuesta y NRO el numero de comprobante abierto
DECLARE campos[2], MATRIZ[30,15]
** Separador de Campos
Se= CHR(28)   

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
@ 11,19 SAY "Dise¤o y Programaci¢n: Depto. Sistemas"
@ 12,19 SAY "Casa Vozzi de `G.Vozzi y R.Fij'"
@ 13,19 SAY "General Paz 151"
@ 14,19 SAY "6000 Jun¡n(Bs.As.)     Tel. 02362-421407"
STORE 1 TO VMENU
STORE "" TO POS
SET COLOR TO W+/BG
@ 23,2 CLEAR TO 23,78
STORE 1 TO VCBTE
@ 23,7 PROMPT "FACTURA"
@ 23,20 PROMPT "NOTA DE CREDITO"
@ 23,40 PROMPT "NOTA DE DEBITO"
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
        STORE "NOTA DE DEBITO" TO TCBTE
        STORE "N.D." TO XCBTE
  CASE VCBTE=4
        EXIT
ENDCASE

//STORE 1 TO VCBTE
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
        STORE SPACE(1) TO RCLI_TDOC
        @ 3,10 GET RCLI_NOM
        @ 4,10 GET RCLI_DOM
        @ 5,10 GET RCLI_LOC
        @ 4,51 GET RCLI_CIVA VALID(RCLI_CIVA$"INEACBMT")
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

STORE "C" TO ZCBTE
        

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
STORE NUMEROA + 1 TO NCBTE
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
  @ 24,2 CLEAR TO 24,78
  CASE VMENU=2
  SET COLOR TO W/B
  @ 24,2 CLEAR TO 24,78
  @ 24,2 SAY "NUEVO NUMERO DE COMPROBANTE:"
  @ 24,31 GET NCBTE
  READ
  @ 24,2 CLEAR TO 24,78
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
ELSE
        RCLI_VEN = NUMERO
ENDIF
@ 2,37 SAY RCLI_VEN PICTURE "999"


//**********PANTALLA PARA INGRESAR PRODUCTOS A VENDER *****************
SET COLOR TO W/B
@ 24,40 CLEAR TO 24,66
@ 24,40 SAY REPLICATE("Ä",27)
SET COLOR TO W/R
@ 24,1 CLEAR TO 24,79
@ 24,1 SAY "PARA FINALIZAR: TECLA <=ESC=>"
SET COLOR TO W/B
SELECT 3
GO 1
****                          *****  
* INICIALIZA LA MATRIZ DE TRABAJO*
****                          *****
IND = 1
DO WHILE IND < 30
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
DO WHILE IND < 30
        IF POSPANT < 20 .AND. CTR = 0
                POSPANT = POSPANT + 1
        ENDIF
        IF POSPANT = 20
                POSPANT = 19
                CTR = 1
        ENDIF
        IF POSPANT = 19 .AND. CTR = 1
                BAJA()
        ENDIF
        STORE SPACE(14) TO BUSCAR
        @ POSPANT,2 GET BUSCAR
        READ
        IF LASTKEY() = 27
                @ POSPANT ,2 SAY SPACE(11)
                POSPANT = POSPANT - 1
                IND = IND - 1
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
                        @ POSPANT,2 SAY BUSCAR
                        SET ORDER TO 1
                        SEEK BUSCAR
                ENDDO
                RESTORE SCREEN FROM MP1
                @ POSPANT,2 SAY BUSCAR
        ENDIF
        SELECT 2
        SEEK BUSCAR
        IF EOF() .AND. LEFT(BUSCAR,1) <> "#" 
                POSPANT = POSPANT - 1
                CTR = 0
                LOOP
        ENDIF
        
        IF .NOT. EOF() .OR. LEFT(BUSCAR,1) = "#" 
                IF .NOT. EOF()
                        STORE NOMBRE TO RPRO_NOM
                        IF VAL(BUSCAR) = 888888
                                STORE SPACE(28) TO RPRO_NOM
                                @ POSPANT,17 GET RPRO_NOM
                                READ
                        ENDIF
                        STORE CONTABLE TO RPRO_LIN
                        STORE CIVA TO RPRO_CIV
                        STORE PRECIO TO RPRO_PRE
                        STORE INTERNO TO RPRO_INT
                ELSE
                        IF LEFT(BUSCAR,1) = "#"
                                STORE SPACE(28) TO RPRO_NOM
                                @ POSPANT,17 GET RPRO_NOM
                                READ
                                STORE 1 TO RPRO_LIN
                                STORE 1 TO RPRO_CIV
                                STORE 0 TO RPRO_PRE
                                STORE 0 TO RPRO_INT
                        ENDIF
                ENDIF
                SELECT 3
                MATRIZ[IND,1] = BUSCAR
                MATRIZ[IND,2] = RPRO_NOM
                MATRIZ[IND,3] = RPRO_PRE
                MATRIZ[IND,8] = RPRO_LIN
                MATRIZ[IND,4] = 1
                MATRIZ[IND,10] = RPRO_INT
                @ POSPANT,2 SAY MATRIZ[IND,1]
                @ POSPANT,17 SAY MATRIZ[IND,2] PICTURE "AAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                @ POSPANT,48 SAY MATRIZ[IND,3] PICTURE "####.##"
                @ POSPANT,56 GET MATRIZ[IND,4] PICTURE "####"
                @ POSPANT,61 GET MATRIZ[IND,5] PICTURE "####.##" RANGE 0,9999
                READ
                ***********************
                * CONTROLA EL NIVEL DE STOCK EN LA FACTURA
                ***********************
                SELECT 10
                SEEK(BUSCAR)
                IF MATRIZ[IND,5] = 0
                        MATRIZ[IND,5] = MATRIZ[IND,3]
                ENDIF

                **************************** CONTROLA LOS CENTAVOS CON EL IMPRESOR FISCAL **************
                STORE 0 TO VALOR
                VALOR = MATRIZ[IND,5] * MATRIZ[IND,4]
                ****************************FIN*********************************

                MATRIZ[IND,6] = ROUND(VALOR,2)
                @ POSPANT,56 SAY MATRIZ[IND,4] PICTURE "####"
                @ POSPANT,61 SAY MATRIZ[IND,5] PICTURE "####.##"
                @ POSPANT,69 SAY MATRIZ[IND,6] PICTURE "##,###.##"
                SELECT 6
                GO RPRO_CIV
                STORE TASA1 + 100 TO ALIC
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
                @ 21,69 SAY TFAC PICTURE "###,###.##"
                IND = IND + 1
        ENDIF
ENDDO
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
                        CFISCAL = 2
                        EXIT
                ENDIF
                SET COLOR TO W/R
                @ 24,1 CLEAR TO 24,79
                @ 24,1 SAY "ARRIBA: Pg.Up   ABAJO: Pg.Dn   CORREGIR: Enter   ELIMINAR: Ctrl W   SALIR: Esc"
                SET COLOR TO W/B
                DO WHILE IND < 30
                     IF MATRIZ[IND,4] > 0
                        STORE MATRIZ[IND,1] TO R_CODIGO
                        SET COLOR TO B/G
                        @ POSPANT,2 SAY MATRIZ[IND,1]
                        SET COLOR TO W/B

                        TECLA = INKEY(0)
                        IF TECLA = 24 .AND. IND < 30
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
                                @ 21,69 SAY TFAC PICTURE "###,###.##"
                        ENDIF
                        IF TECLA = 13
                                TFAC = TFAC - MATRIZ[IND,6]
                                @ POSPANT,56 SAY SPACE(3)
                                @ POSPANT,61 SAY SPACE(7)
                                @ POSPANT,69 SAY SPACE(10)
                                @ 21,69 SAY TFAC PICTURE "###,###.##"
                                @ POSPANT,56 GET MATRIZ[IND,4] PICTURE "####" RANGE 1,9999
                                @ POSPANT,61 GET MATRIZ[IND,5] PICTURE "####.##" RANGE 0,9999
                                READ
                                IF MATRIZ[IND,5] = 0
                                        MATRIZ[IND,5] = MATRIZ[IND,3]
                                ENDIF
                                STORE 0 TO VALOR
                                VALOR = MATRIZ[IND,5] * MATRIZ[IND,4]
                                MATRIZ[IND,6] = ROUND(VALOR,2)
                                @ POSPANT,56 SAY MATRIZ[IND,4] PICTURE "####"
                                @ POSPANT,61 SAY MATRIZ[IND,5] PICTURE "####.##"
                                @ POSPANT,69 SAY MATRIZ[IND,6] PICTURE "##,###.##"
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
                                SET COLOR TO W+/B
                                @ 21,69 SAY TFAC PICTURE "###,###.##"
                        ENDIF
                        IF TECLA = 27
                                @22,69 SAY BONIF
                                @22,69 GET BONIF
                                READ
                                @22,69 SAY RIGHT((STR(BONIF)),8) + " %"
                                IF BONIF <> 0
                                        TFAC = TFAC - (BONIF * TFAC /100)
                                ENDIF
                                @23,69 SAY TFAC PICTURE "###,###.##"
                                EXIT
                        ENDIF
                ENDIF
        ENDDO
ENDDO
ENDDO
IF VIMP = 3
        EXIT
ENDIF
IF VIMP = 1
        TFAC  = 0
        SELECT 3
        IND = 1
        DO WHILE IND < 30
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
        
*****************************
*
        
*
*******************************

        //INITFISCAL(HANDLER)
        SELECT 3
        IND = 1
        DO WHILE IND < 30 
                IF MATRIZ[IND,4] > 0
                        STORE MATRIZ[IND,2] TO MP
                        STORE SPACE(1) TO MK1, MK2, MK3, MK4, MK5
                        //MK1 = RIGHT("0000" + LTRIM(STR(MM)),4)
                        *******************
                        * ALMACENA LA MATRIZ[IND,4] REAL EN MK6 PARA MOSTRARLA DELANTE DE LA DESCRIPCION DEL PRODUCTO
                        ********************
                        STORE ALLTRIM(STR(MATRIZ[IND,4],13,10)) TO MK6
                        STORE MATRIZ[IND,6] / MATRIZ[IND,4] TO RCANT

                        **** ALMACENA EL VALOR SIN MATRIZ[IND,13] A ENVIAR
                        MK3 = ALLTRIM(STR(RCANT,11,4))

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
                        IF TASA1 = 0
                                STORE "0000" TO MK4
                        ELSE
                                RCANT = ROUND(RCANT,0)
                                MK4 = RIGHT("0000" + LTRIM(STR(RCANT)),4)
                        ENDIF
                        IF ZCBTE = "B"
                                MK5 = "00000000"
                        ENDIF

                        //REPLACE NUMERO WITH MK1, PRODUCTO WITH (LEFT((MK6+"/"+MP),20)), MATRIZ[IND,4] WITH "00001000", PRECIO WITH MK3, MATRIZ[IND,13] WITH MK4, AJUSTE WITH MK5
                        SELECT 3
        ENDIF
        IND = IND + 1
ENDDO

        RESTORE SCREEN FROM PANTAUX
        OCBTE=MCBTE
        STORE 0 TO T_GRAVADO, T_EXENTO, T_IVA, T_IVANO
        SELECT 3
        IND = 1
        DO WHILE IND < 30
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

                        T_GRAVADO = T_GRAVADO + MATRIZ[IND,11]
                        T_EXENTO = T_EXENTO + MATRIZ[IND,12] 
                        T_IVA = T_IVA + MATRIZ[IND,13]
                        T_IVANO = T_IVANO + MATRIZ[IND,14]
                        SELECT 9
                        RLOCK()
                        APPEND BLANK
                        REPLACE PRODUCTO WITH R_CODIGO, FECHA WITH RFECHA, CBTE WITH MCBTE, CANT WITH R_CANT, VALOR WITH R_SINIVA, CONIVA WITH R_CONIVA, CLIENTE WITH RCLI_NUM, PLISTA WITH R_PLISTA, PVENTA WITH R_PVENTA
                        REPLACE GRAVADO WITH R_GRAVADO, EXENTO WITH R_EXENTO, IVA WITH R_IVA, IVANO WITH R_IVANO
                        IF VCBTE = 1 .OR. VCBTE = 3
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
                                REPLACE PRODUCTO WITH R_CODIGO, UN_TRANSFI WITH 0, UN_TRANSFE WITH 0, UN_VEND WITH 0, VAL_VENTA WITH 0, EX_FISICA WITH 0, FU_VENTA WITH CTOD("  /  /    ")  
                                UNLOCK
                        ENDIF
                        IF .NOT. EOF()
                                RLOCK()
                                IF VCBTE = 1 .OR. VCBTE = 3
                                        REPLACE UN_VEND WITH UN_VEND + R_CANT
                                        REPLACE VAL_VENTA WITH VAL_VENTA + R_SINIVA
                                        REPLACE FU_VENTA WITH RFECHA
                                        REPLACE EX_FISICA WITH EX_FISICA - R_CANT
                                ELSE
                                        REPLACE UN_VEND WITH UN_VEND - R_CANT, VAL_VENTA WITH VAL_VENTA - R_SINIVA, EX_FISICA WITH EX_FISICA + R_CANT
                                ENDIF
                                UNLOCK
                        ENDIF
                        SELECT 13
                        RLOCK()
                        APPEND BLANK
                        REPLACE NUMERO WITH R_CONTABLE, FECHA WITH RFECHA, CBTE WITH MCBTE, VALOR WITH R_SINIVA
                        IF VCBTE = 1 .OR. VCBTE = 3
                                REPLACE TMOV WITH 2
                        ELSE
                                REPLACE TMOV WITH 1
                        ENDIF
                        UNLOCK
                        SELECT 11
                        SEEK R_CONTABLE
                        RLOCK()
                        IF VCBTE = 1 .OR. VCBTE = 3
                                REPLACE CREDITOS WITH CREDITOS + R_SINIVA
                        ELSE
                                REPLACE DEBITOS WITH DEBITOS + R_SINIVA
                        ENDIF
                        UNLOCK
                ENDIF
                SELECT 3
                SKIP
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
        IF VCBTE = 1 .OR. VCBTE = 3
                REPLACE TMOV WITH 1
        ELSE
                REPLACE TMOV WITH 2
        ENDIF
        UNLOCK
        IF RCLI_NUM <> 888888
                SELECT 4
                RLOCK()
                APPEND BLANK
                REPLACE CLIENTE WITH RCLI_NUM, FECHA WITH RFECHA, CBTE WITH MCBTE, VALOR WITH TFAC, SALDO WITH TFAC
                IF VCBTE = 1 .OR. VCBTE = 3
                        REPLACE TMOV WITH 1
                ELSE
                        REPLACE TMOV WITH 2
                ENDIF
                UNLOCK
                SELECT 1
                RLOCK()
                IF VCBTE = 1 .OR. VCBTE = 3
                        REPLACE SALDO WITH SALDO + TFAC
                ELSE
                        REPLACE SALDO WITH SALDO - TFAC
                ENDIF
                UNLOCK
        ENDIF
ENDIF


//SET COLOR TO W/R
//@ 9,19,15,62 BOX &caja9
//@ 11,29 SAY "IMPRIMIR COMPROBANTE ?"
//STORE 1 TO VMENU
//@ 13,34 PROMPT "SI"
//@ 13,45 PROMPT "NO"
//MENU TO VMENU
//DO CASE 
//        CASE VMENU=1
//                STORE 1 TO CLAVE
//        CASE VMENU=2
//                STORE 2 TO CLAVE
//ENDCASE
//SET DEVICE TO PRINTER
//@ 1,1 SAY CHR(27)+CHR(67)+CHR(72)

STORE 2 TO CLAVE
IF CLAVE < 2
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
@ 19,3 SAY "CANT"
@ 19,19 SAY "NOMBRE PRODUCTO"  // ERA 19,23
@ 19,46 SAY "CODIGO"             // ERA 19,46
@ 19,61 SAY "PRECIO"
@ 19,72 SAY "IMPORTE"
STORE 21 TO LIN
@ 20,1 SAY CHR(27)+CHR(120)+"0"
IND = 1
DO WHILE IND < 30 
        IF MATRIZ[IND,4] > 0 .AND. MATRIZ[IND,6] > 0
                @ LIN,1 SAY MATRIZ[IND,4] PICTURE "####"
                @ LIN,11 SAY MATRIZ[IND,2]  //ERA 16
                @ LIN,45 SAY MATRIZ[IND,1]    //ERA 46
                @ LIN,59 SAY MATRIZ[IND,5] PICTURE "#,###.##"
                @ LIN,70 SAY MATRIZ[IND,6] PICTURE "###,###.##"
                LIN = LIN + 1
        ENDIF
        IND = IND + 1
ENDDO
@ 51,59 SAY "Subtotal =>" 
@ 51,70 SAY SUBTOTAL PICTURE "###,###.##"
@ 52,55 SAY "Bonificacion =>"
@ 52,70 SAY BONIF PICTURE "###,###.##"
@ 53,62 SAY "Total =>" 
@ 53,70 SAY TFAC PICTURE "###,###.##"
CLAVE = CLAVE + 1
ENDIF

          //si fue una factura acumula el numero
        SELECT 7
        GO 1
        RLOCK()
                REPLACE NUMEROA WITH NCBTE
        UNLOCK

ENDDO
//ENDDO
CLOSE ALL
RETURN




PROCEDURE BAJA
        IF IND < 30
                IF POSPANT < 19
                        POSPANT = POSPANT + 1
                ELSE
                        FOR J=10 TO 0 STEP -1
                                @ POSPANT - J,2 SAY MATRIZ[IND - J,1]
                                @ POSPANT - J,17 SAY MATRIZ[IND - J,2] PICTURE REPLICATE("A",28)
                                @ POSPANT - J,48 SAY MATRIZ[IND - J,3] PICTURE "####.##"
                                @ POSPANT - J,56 SAY MATRIZ[IND - J,4] PICTURE "####" //RANGE 1,9999
                                @ POSPANT - J,61 SAY MATRIZ[IND - J,5] PICTURE "####.##"// RANGE 0,9999
                                @ POSPANT - J,69 SAY MATRIZ[IND - J,6] PICTURE "##,###.##" 
                        NEXT
                        @ POSPANT,2 SAY SPACE(11)
                        @ POSPANT,17 SAY SPACE(28)
                        @ POSPANT,48 SAY SPACE(7)
                        @ POSPANT,56 SAY SPACE(4) //RANGE 1,9999
                        @ POSPANT,61 SAY SPACE(7) //RANGE 0,9999
                        @ POSPANT,69 SAY SPACE(10)
                ENDIF
        ENDIF
RETURN

PROCEDURE BAJASCR
        IF IND < 30
                IF MATRIZ[IND + 1,4] > 0
                        IND = IND + 1
                        IF POSPANT < 19
                                POSPANT = POSPANT + 1
                        ELSE
                                FOR J=10 TO 0 STEP -1
                                        @ POSPANT - J,2 SAY MATRIZ[IND - J,1]
                                        @ POSPANT - J,17 SAY MATRIZ[IND - J,2] PICTURE REPLICATE("A",28)
                                        @ POSPANT - J,48 SAY MATRIZ[IND - J,3] PICTURE "####.##"
                                        @ POSPANT - J,56 SAY MATRIZ[IND - J,4] PICTURE "####" //RANGE 1,9999
                                        @ POSPANT - J,61 SAY MATRIZ[IND - J,5] PICTURE "####.##"// RANGE 0,9999
                                        @ POSPANT - J,69 SAY MATRIZ[IND - J,6] PICTURE "##,###.##" 
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
                                FOR J=0 TO 10 
                                        @ POSPANT + J,2 SAY MATRIZ[IND + J,1]
                                        @ POSPANT + J,17 SAY MATRIZ[IND + J,2] PICTURE REPLICATE("A",28)
                                        @ POSPANT + J,48 SAY MATRIZ[IND + J,3] PICTURE "####.##"
                                        @ POSPANT + J,56 SAY MATRIZ[IND + J,4] PICTURE "####" //RANGE 1,9999
                                        @ POSPANT + J,61 SAY MATRIZ[IND + J,5] PICTURE "####.##"// RANGE 0,9999
                                        @ POSPANT + J,69 SAY MATRIZ[IND + J,6] PICTURE "##,###.##"
                                NEXT
                        ENDIF
                 ENDIF
        ENDIF
RETURN

PROCEDURE BORRAR
        STORE IND TO J
        DO WHILE MATRIZ[J,4] <> 0 .AND. (POSPANT + (J-IND) < 20)
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

                @ POSPANT + (J-IND),2  SAY MATRIZ[J,1]
                @ POSPANT + (J-IND),17 SAY MATRIZ[J,2] PICTURE REPLICATE("A",28)
                @ POSPANT + (J-IND),48 SAY MATRIZ[J,3] PICTURE "####.##"
                @ POSPANT + (J-IND),56 SAY MATRIZ[J,4] PICTURE "####" //RANGE 1,9999
                @ POSPANT + (J-IND),61 SAY MATRIZ[J,5] PICTURE "####.##"// RANGE 0,9999
                @ POSPANT + (J-IND),69 SAY MATRIZ[J,6] PICTURE "##,###.##"
                J = J + 1
        ENDDO
        IF MATRIZ[IND,4] = 0
                IND = IND - 1
                POSPANT = POSPANT - 1
        ENDIF
RETURN

