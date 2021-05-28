SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE OFF
SET CENTURY ON
SET EXCLUSIVE OFF
SET DATE BRITISH
RESTORE FROM FISCAL.MEM
PRIVATE IND, POSPANT
DECLARE campos[2], MATRIZ[30,6]
campos[1]="NUMERO"
campos[2]="NOMBRE"
SELECT 1
USE ARTICULO INDEX ART_NUM, ART_NOM
SELECT 6
USE MSTOCK INDEX MST_CLA1, MST_CLA2, MST_CBTE
SELECT 7
USE RSTOCK INDEX RST_CLA1
SELECT 8
USE NUMEROS
SELECT 9
USE PROVEEDO INDEX PROV_NUM, PROV_NOM
SELECT 10
USE MPROVEED INDEX MPRO_NUM, MPRO_FEC
SELECT 11
USE MIVAPROV INDEX MIV_PRO1
SELECT 8
STORE 83 TO JJ
STORE "" TO POS
DO WHILE JJ = 83
        RESTORE SCREEN FROM PANT2
        SET COLOR TO W+/BG
        SELECT 8
        @ 2,22 SAY "COMPRAS Y DEVOLUCIONES DE PRODUCTOS"
        SET COLOR TO W+/RB
        @ 10,17 CLEAR TO 14,63
        @ 9,17,15,63 BOX @caja1
        @ 10,19 SAY RTRIM(NOMBRE)
        @ 11,19 SAY "Dise¤o y Programaci¢n: Sistemas Casa Vozzi"
        @ 12,19 SAY "Casa Vozzi de Pedro Vozzi"
        @ 13,19 SAY "General Paz 159"
        @ 14,19 SAY "6000 Jun¡n(Bs.As.)     Tel. 02362-421407"
        STORE 1 TO VMENU
        STORE "" TO POS
        SET COLOR TO W+/BG
        @ 23,2 CLEAR TO 23,78
        @ 23,10 PROMPT "ING. COMPRAS"
        @ 23,32 PROMPT "ING. DEVOLUCIONES"
        @ 23,63 PROMPT "FIN PROCESO"
        MENU TO VMENU
        DO CASE
                CASE VMENU = 1
                        STORE "FACT" TO XCBTE
                CASE VMENU = 2
                        STORE "N.C." TO XCBTE
                CASE VMENU = 3
                        EXIT
        ENDCASE                                        
        GO 1
        RESTORE SCREEN FROM PANTCOM1
        SET COLOR TO W+/B
        @ 0,10 CLEAR TO 0,80 
        IF XCBTE = "FACT"
                @ 0,25 SAY "INGRESO DE COMPRAS DE PRODUCTOS"
        ELSE
                @ 0,22 SAY "INGRESO DE DEVOLUCIONES DE PRODUCTOS"
        ENDIF
        STORE DATE() TO RFECHA
        STORE SPACE(10) TO RCBTE
        SET COLOR TO W/B
        @ 2,48 GET RFECHA
        READ
        @ 2,48 SAY RFECHA
        @ 3,54 SAY XCBTE
        @ 3,58 GET RCBTE
        READ
        RCBTE = XCBTE + " " + STRZERO(VAL(RCBTE),9)
        @ 3,54 SAY RCBTE

        STORE SPACE(30) TO RCLI_NOM
        @ 3,10 GET RCLI_NOM
        READ
        SAVE SCREEN TO MP1
        //*************** ABRE LA PANTALLA EN BUSCA DE PROVEEDORES **********
        SELECT 9
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
                STORE SPACE(30) TO RCLI_NOM
                STORE SPACE(11) TO RCLI_CUIT
                @ 3,10 GET RCLI_NOM
                READ
        ELSE
                STORE NUMERO TO RCLI_NUM
                STORE NOMBRE TO RCLI_NOM
                STORE CUIT TO RCLI_CUIT
        ENDIF

        IF LEFT(RCLI_NOM,1) = " "
                STORE 888888 TO RCLI_NUM
                STORE "PROVEEDOR OCACIONAL" TO RCLI_NOM
        ENDIF
        @ 2,10 SAY RCLI_NUM PICTURE "999999"
        @ 3,10 SAY RCLI_NOM
        SET COLOR TO W+/RB
        @ 24,2 SAY "FINALIZAR: TECLA <=ESC=>"
        @ 24,55 SAY "CONSULTA: TECLA <=PgUp=>"
        SET COLOR TO W/B
        FOR I = 1 TO 30
                MATRIZ[I,1] = SPACE(14)        //CODIGO
                MATRIZ[I,2] = SPACE(30)        //DETALLE
                MATRIZ[I,3] = 1                //CANT
                MATRIZ[I,4] = 10                //DESCUENTO
                MATRIZ[I,5] = 0                //PCOMPRA
                MATRIZ[I,6] = 0                //IMPORTE COMPRA
        NEXT 
        POSPANT = 6
        IND = 1
        TFAC = 0
        STORE 0 TO CTR
        SELECT 1
        DO WHILE IND < 30
                IF POSPANT < 21 .AND. CTR = 0
                        POSPANT = POSPANT + 1
                ENDIF
                IF POSPANT = 21
                        POSPANT = 20
                        CTR = 1
                ENDIF
                IF POSPANT = 20 .AND. CTR = 1
                        BAJA1()
                ENDIF
                STORE SPACE(14) TO BUSCAR
                @ POSPANT,2 GET BUSCAR
                READ
                IF LASTKEY() = 27
                        @ POSPANT ,2 SAY SPACE(14)
                        POSPANT = POSPANT - 1
                        IND = IND - 1
                        EXIT
                ENDIF
                IF LASTKEY() = 18 
                        SAVE SCREEN TO MP1
                        SELECT 1
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
                SELECT 1
                SEEK BUSCAR
                IF EOF() 
                        POSPANT = POSPANT - 1
                        CTR = 0
                        LOOP
                ENDIF
                IF .NOT. EOF()
                        STORE NOMBRE TO RPRO_NOM
                        IF VAL(BUSCAR) = 8888
                                STORE SPACE(28) TO RPRO_NOM
                                @ POSPANT,17 GET RPRO_NOM
                                READ
                        ENDIF
                        STORE CIVA TO RPRO_CIV
                        STORE INTERNO TO RPRO_INT
                        MATRIZ[IND,1] = BUSCAR
                        MATRIZ[IND,2] = RPRO_NOM
                        MATRIZ[IND,3] = 1
                        MATRIZ[IND,5] = PRECOMP         // CARGA EL PRECIO DE COMPRA
                        @ POSPANT,2 SAY MATRIZ[IND,1]
                        @ POSPANT,17 SAY MATRIZ[IND,2]
                        @ POSPANT,47 SAY MATRIZ[IND,5] PICTURE "#####.##"
                        DO WHILE MATRIZ[IND,5] = 0
                                @ POSPANT,47 GET MATRIZ[IND,5] PICTURE "#####.##"
                                READ
                        ENDDO
                        @ POSPANT,55 GET MATRIZ[IND,3] PICTURE "###.###"
                        @ POSPANT,63 GET MATRIZ[IND,4] PICTURE "##.##"
                        READ
                        MATRIZ[IND,6] = MATRIZ[IND,3] * (MATRIZ[IND,5] - ((MATRIZ[IND,5] * MATRIZ[IND,4]) / 100))
                        @ POSPANT,70 SAY MATRIZ[IND,6] PICTURE "###,###.##"
                        @ POSPANT,47 SAY MATRIZ[IND,5] PICTURE "#####.##"
                        @ POSPANT,55 SAY MATRIZ[IND,3] PICTURE "###.###"
                        @ POSPANT,63 SAY MATRIZ[IND,4] PICTURE "##.##"
                ENDIF           
                TFAC = TFAC + MATRIZ[IND,6]
                SET COLOR TO W+/B
                @ 22,36 SAY "IVA (21 %) ="
                @ 22,49 SAY ALLTRIM(STR(TFAC * 0.21,8,2))
                SET COLOR TO W/B
                ***ACUMULO EL IVA EN EL TOTAL
                @ 22,69 SAY TFAC * 1.21 PICTURE "###,###.##"
                IND = IND + 1
ENDDO

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
                DO WHILE IND < 30
                     IF MATRIZ[IND,5] > 0
                        STORE MATRIZ[IND,1] TO R_CODIGO
                        SET COLOR TO B/G
                        @ POSPANT,2 SAY MATRIZ[IND,1]
                        SET COLOR TO W/B

                        TECLA = INKEY(0)
                        IF TECLA = 24 .AND. IND < 30
                                @ POSPANT,2 SAY MATRIZ[IND,1]        
                                BAJASCR1()
                        ENDIF
                        IF TECLA = 5 .AND. IND > 1
                                @ POSPANT,2 SAY MATRIZ[IND,1]
                                SUBESCR1()
                        ENDIF
                        IF TECLA = 23
                                TFAC = TFAC - MATRIZ[IND,6]
                                BORRAR1(IND)
                                SET COLOR TO W+/B
                                @ 22,36 SAY "IVA (21 %) ="
                                @ 22,49 SAY ALLTRIM(STR(TFAC * 0.21,8,2))
                                SET COLOR TO W/B
                                @ 22,69 SAY TFAC * 1.21 PICTURE "###,###.##"
                        ENDIF
                        IF TECLA = 13
                                TFAC = TFAC - MATRIZ[IND,6]
                                @ POSPANT,48 SAY SPACE(7)
                                @ POSPANT,57 SAY SPACE(4)
                                @ POSPANT,63 SAY SPACE(3)                                
                                @ POSPANT,69 SAY SPACE(10)
                                SET COLOR TO W+/B
                                @ 22,36 SAY "IVA (21 %) ="
                                @ 22,49 SAY ALLTRIM(STR(TFAC * 0.21,8,2))
                                SET COLOR TO W/B
                                @ 22,69 SAY TFAC * 1.21 PICTURE "###,###.##"
                                @ POSPANT,47 GET MATRIZ[IND,5] PICTURE "#####.###" RANGE 0,9999
                                @ POSPANT,55 GET MATRIZ[IND,3] PICTURE "###.###" RANGE 1,9999
                                @ POSPANT,63 GET MATRIZ[IND,4] PICTURE "##.##" RANGE 0,9999
                                READ
                                MATRIZ[IND,6] = MATRIZ[IND,3] * (MATRIZ[IND,5] - ((MATRIZ[IND,5] * MATRIZ[IND,4]) / 100))
                                @ POSPANT,47 SAY MATRIZ[IND,5] PICTURE "#####.###" //RANGE 0,9999
                                @ POSPANT,55 SAY MATRIZ[IND,3] PICTURE "###.###" //RANGE 1,9999
                                @ POSPANT,63 SAY MATRIZ[IND,4] PICTURE "##.##" //RANGE 0,9999
                                @ POSPANT,69 SAY MATRIZ[IND,6] PICTURE "###,###.###"
                                TFAC = TFAC + MATRIZ[IND,6]
                                SET COLOR TO W+/B
                                SET COLOR TO W+/B
                                @ 22,36 SAY "IVA (21 %) ="
                                @ 22,49 SAY ALLTRIM(STR(TFAC * 0.21,8,2))
                                SET COLOR TO W/B
                                @ 22,69 SAY TFAC * 1.21 PICTURE "###,###.##"
                        ENDIF
                        IF TECLA = 27
                                EXIT
                        ENDIF
                ENDIF
        ENDDO
ENDDO
IF VIMP = 3
        STORE " " TO HH
        SET COLOR TO W+/RB
        @ 24,2 CLEAR TO 23,78
        @ 24, 2 SAY "ESTE MOVIMIENTO NO SE ACTUALIZO " GET HH
        READ
        EXIT
ENDIF
IF VIMP = 1
             IND = 1
             *** ACUMULA EL IVA EN EL TOTAL ***
             TFAC = TFAC * 1.21
             DO WHILE IND < 30
                IF MATRIZ[IND,6] > 0 
                     SET COLOR TO W/B
                     SELECT 7
                     SEEK MATRIZ[IND,1]
                     IF .NOT. EOF()
                             RLOCK()
                             IF XCBTE = "FACT"
                                REPLACE UN_TRANSFI WITH UN_TRANSFI + MATRIZ[IND,3], EX_FISICA WITH EX_FISICA + MATRIZ[IND,3]
                             ELSE
                                REPLACE UN_TRANSFI WITH UN_TRANSFI - MATRIZ[IND,3], EX_FISICA WITH EX_FISICA - MATRIZ[IND,3]
                             ENDIF
                             UNLOCK
                     ENDIF
                     IF EOF()
                             RLOCK()
                             APPEND BLANK
                             IF XCBTE = "FACT"
                                 REPLACE PRODUCTO WITH MATRIZ[IND,1], UN_TRANSFI WITH MATRIZ[IND,3], UN_TRANSFE WITH 0, UN_VEND WITH 0, EX_FISICA WITH MATRIZ[IND,3], VAL_VENTA WITH 0, FU_VENTA WITH CTOD("  /  /  ")
                             ELSE
                                 REPLACE PRODUCTO WITH MATRIZ[IND,1], UN_TRANSFI WITH -MATRIZ[IND,3], UN_TRANSFE WITH 0, UN_VEND WITH 0, EX_FISICA WITH -MATRIZ[IND,3], VAL_VENTA WITH 0, FU_VENTA WITH CTOD("  /  /  ")
                             ENDIF
                             UNLOCK
                     ENDIF
                     SELECT 6
                     RLOCK()
                     APPEND BLANK
                     IF XCBTE = "FACT"
                        REPLACE TMOV WITH 1
                     ELSE
                        REPLACE TMOV WITH 7
                     ENDIF
                     REPLACE PRODUCTO WITH MATRIZ[IND,1], FECHA WITH RFECHA, CBTE WITH RCBTE, CANT WITH MATRIZ[IND,3], VALOR WITH MATRIZ[IND,6]
                     REPLACE CONIVA WITH MATRIZ[IND,6] * 1.21, CLIENTE WITH 0, PLISTA WITH 0, PVENTA WITH 0
                     REPLACE PLISTA WITH MATRIZ[IND,5]
                     REPLACE PVENTA WITH (MATRIZ[IND,5] - (MATRIZ[IND,5] * MATRIZ[IND,4] / 100))
                     UNLOCK
                  ENDIF
                  IND = IND + 1
                ENDDO
                SELECT 10
                RLOCK()
                APPEND BLANK
                REPLACE NUMERO WITH RCLI_NUM, CBTE WITH RCBTE, FECHA WITH RFECHA
                REPLACE VALOR WITH TFAC, SALDO WITH TFAC
                IF XCBTE = "FACT"
                        REPLACE TMOV WITH 1
                ELSE
                        REPLACE TMOV WITH 7
                ENDIF
                SELECT 11
                RLOCK()
                APPEND BLANK
                REPLACE FECHA WITH RFECHA, NOMBRE WITH RCLI_NOM, CUIT WITH RCLI_CUIT, CBTE WITH RCBTE, ALIC WITH 21.00
                REPLACE EXENTO WITH 0, GRAVADO WITH ROUND((TFAC * 0.79),2), IVA WITH ROUND((TFAC * 0.21),2), IVANO WITH 0, NETO WITH TFAC, CLIENTE WITH RCLI_NUM 
                UNLOCK

                SELECT 9
                RLOCK()
                IF XCBTE = "FACT"
                        REPLACE SALDO WITH SALDO + TFAC
                ELSE
                        REPLACE SALDO WITH SALDO - TFAC
                ENDIF
                UNLOCK
                ********************************************************
                * FALTA AGREGAR EL MOVIMIENTO EL LA CUENTA CORRIENTE   *
                * DEL PORVEEDOR                                        *
                ********************************************************
  ENDIF
ENDDO
CLOSE ALL
RETURN


PROCEDURE BAJA1
        IF IND < 30
                IF POSPANT < 20
                        POSPANT = POSPANT + 1
                ELSE
                        FOR J=13 TO 0 STEP -1
                                @ POSPANT - J,2 SAY MATRIZ[IND - J,1]
                                @ POSPANT - J,17 SAY MATRIZ[IND - J,2] PICTURE REPLICATE("A",28)
                                @ POSPANT - J,48 SAY MATRIZ[IND - J,5] PICTURE "######.##"
                                @ POSPANT - J,57 SAY MATRIZ[IND - J,3] PICTURE "####" //RANGE 1,9999
                                @ POSPANT - J,63 SAY MATRIZ[IND - J,4] PICTURE "###"// RANGE 0,9999
                                @ POSPANT - J,69 SAY MATRIZ[IND - J,6] PICTURE "###,###.###" 
                        NEXT
                        @ POSPANT,2 SAY SPACE(14)
                        @ POSPANT,17 SAY SPACE(28)
                        @ POSPANT,48 SAY SPACE(8)
                        @ POSPANT,57 SAY SPACE(4) //RANGE 1,9999
                        @ POSPANT,63 SAY SPACE(10) //RANGE 0,9999
                        @ POSPANT,69 SAY SPACE(10)
                ENDIF
        ENDIF
RETURN

PROCEDURE BAJASCR1
        IF IND < 30
                IF MATRIZ[IND + 1,5] > 0
                        IND = IND + 1
                        IF POSPANT < 20
                                POSPANT = POSPANT + 1
                        ELSE
                                FOR J=13 TO 0 STEP -1
                                        @ POSPANT - J,2 SAY MATRIZ[IND - J,1]
                                        @ POSPANT - J,17 SAY MATRIZ[IND - J,2] PICTURE REPLICATE("A",28)
                                        @ POSPANT - J,48 SAY MATRIZ[IND - J,5] PICTURE "######.##"
                                        @ POSPANT - J,57 SAY MATRIZ[IND - J,3] PICTURE "####" //RANGE 1,9999
                                        @ POSPANT - J,63 SAY MATRIZ[IND - J,5] PICTURE "###"// RANGE 0,9999
                                        @ POSPANT - J,69 SAY MATRIZ[IND - J,6] PICTURE "###,###.###" 
                                NEXT
                        ENDIF
                ENDIF
        ENDIF
RETURN

PROCEDURE SUBESCR1
        IF IND > 1
                IF MATRIZ[IND - 1,5] > 0
                        IND = IND - 1
                        IF POSPANT > 7
                                POSPANT = POSPANT - 1
                        ELSE
                                FOR J=0 TO 13 
                                        @ POSPANT + J,2 SAY MATRIZ[IND + J,1]
                                        @ POSPANT + J,17 SAY MATRIZ[IND + J,2] PICTURE REPLICATE("A",28)
                                        @ POSPANT + J,48 SAY MATRIZ[IND + J,5] PICTURE "######.##"
                                        @ POSPANT + J,57 SAY MATRIZ[IND + J,3] PICTURE "####" //RANGE 1,9999
                                        @ POSPANT + J,63 SAY MATRIZ[IND + J,4] PICTURE "###"// RANGE 0,9999
                                        @ POSPANT + J,69 SAY MATRIZ[IND + J,6] PICTURE "###,###.###"
                                NEXT
                        ENDIF
                 ENDIF
        ENDIF
RETURN

PROCEDURE BORRAR1
        STORE IND TO J
        DO WHILE MATRIZ[J,5] <> 0 .AND. (POSPANT + (J-IND) < 21)
                MATRIZ[J,1] = MATRIZ[J+1,1]
                MATRIZ[J,2] = MATRIZ[J+1,2]
                MATRIZ[J,3] = MATRIZ[J+1,3]
                MATRIZ[J,4] = MATRIZ[J+1,4]
                MATRIZ[J,5] = MATRIZ[J+1,5]
                MATRIZ[J,6] = MATRIZ[J+1,6]

                @ POSPANT + (J-IND),2  SAY MATRIZ[J,1]
                @ POSPANT + (J-IND),17 SAY MATRIZ[J,2] PICTURE REPLICATE("A",28)
                @ POSPANT + (J-IND),48 SAY MATRIZ[J,5] PICTURE "######.##"
                @ POSPANT + (J-IND),57 SAY MATRIZ[J,3] PICTURE "####" //RANGE 1,9999
                @ POSPANT + (J-IND),63 SAY MATRIZ[J,4] PICTURE "###"// RANGE 0,9999
                @ POSPANT + (J-IND),69 SAY MATRIZ[J,6] PICTURE "###,###.###"
                J = J + 1
        ENDDO
        IF MATRIZ[IND,5] = 0
                IND = IND - 1
                POSPANT = POSPANT - 1
        ENDIF
RETURN

