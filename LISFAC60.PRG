SET SCOREBOARD ON
SET CONFIRM OFF
SET DATE BRITISH
SET EXCLUSIVE OFF
SET CENTURY ON
SET COLOR TO W/B
RESTORE FROM FISCAL.MEM
******* CREA UNA INDICE SOBRE EL NUMRO DEL COMPROBANTE **************
USE MSTOCK
INDEX ON CBTE TO FAC_NUM
CLOSE DATABASE
******* CREA UN INDICE SOBRE EL NUMERO DEL COMPROBANTE *************
USE MCTACTE
INDEX ON CBTE TO COMP_NUM
CLOSE DATABASE
STORE 83 TO JJ
DO WHILE JJ = 83
SELECT 1
        USE ARTICULO INDEX ART_NUM
SELECT 2
        USE MSTOCK INDEX FAC_NUM
SELECT 3          
        USE DEUDORES INDEX DEU_NUM
RESTORE SCREEN FROM PANT1
*** SI SU VALOR SIGUE EN UNO ES PORQUE LA ENCONTRE ***
STORE 1 TO LAENCONTRE
SELECT 4
        USE TRABAJO
SELECT 5
        USE MCTACTE INDEX COMP_NUM
SELECT 6
        USE NUMEROS

SELECT 4
**************INICIALIZA TRABAJO.DBF PARA COMENZAR ********************
        GO 1
        DO WHILE RECNO() < 13 
                RLOCK()
                REPLACE DETALLE WITH SPACE(30), CODIGO WITH SPACE(14), LINEA WITH 0, CANT WITH 0, PLISTA WITH 0, PVENTA WITH 0, CONIVA WITH 0, SINIVA WITH 0, CONTABLE WITH 0, CODIVA WITH 0, CANT WITH 0, VALOR1 WITH 0
                UNLOCK
                SKIP
        ENDDO
*****************POSICIONA TRABAJO EN EL PRIMER REGISTRO***********
GO 1
***************** LEE EL NUMERO DE FACTURA A MOSTRAR ******************
STORE 0 TO NUM
SET COLOR TO W+/RB
@2,30 SAY "REGISTRO DE FACTURAS"
SET COLOR TO W+/B
@ 12,19 CLEAR TO 15,62
@ 9,19,15,62 BOX &caja9       &&dibuja una caja con los parametros de FISCAL.MEM
@ 11,22 SAY "TIPO DE COMPROBANTE:"
STORE 1 TO XMENU
SET COLOR TO W/B
@ 10,46 PROMPT "FACT A"
@ 12,46 PROMPT "FACT B"
MENU TO XMENU
DO CASE
        CASE XMENU = 1
                STORE "FACT A" TO FACT
        CASE XMENU = 2
                STORE "FACT B" TO FACT
ENDCASE
SET COLOR TO W+/B
@ 13,22 SAY "NUMERO DE FACTURA: "
@ 13,41 GET NUM PICTURE 999999
READ
SELECT 6
STORE FACT + " " + PREFIJO + "-" + STRZERO(NUM, 8) TO BUSCA 
IF LASTKEY() = 27
        CLOSE ALL
        EXIT
ENDIF
***************** FIN LEE NUMERO ********************

******************BUSCA EL NUMERO DE FACTURA EN MSTOCK.DBF *************
SELECT 2
        SEEK(BUSCA)
        IF .NOT. EOF()
                STORE FECHA TO FACFECHA
                STORE CLIENTE TO NUMCLI
        ELSE
                STORE 0 TO NUMCLI
        ENDIF
****************** BUSCA DATOS DEL CLIENTE EN DEUDORES.DBF **************
SELECT 3
        IF NUMCLI <> 0
                SEEK(NUMCLI)
                IF .NOT. EOF()
                        STORE NOMBRE TO NOMCLI
                        STORE DOMICILIO TO DOMCLI
                        STORE LOCALIDAD TO LOCCLI
                        STORE CIVA TO CIVACLI
                        STORE CUIT TO CUITCLI
                ENDIF
        ENDIF
******* ALMACENA EL VALOR DE LA FACT. DE MCTACTE.DBF EN VALFAC *********
SELECT 5
        SEEK(BUSCA)
        STORE VALOR TO VALFAC
        STORE CBTE TO CBTEFAC
*******************SELECCIONA TODOS LOS ARTICULOS FACTURADOS**************
SELECT 2
        IF .NOT. EOF ()
        DO WHILE (BUSCA=CBTE)
                STORE PRODUCTO TO NUMPROD
                STORE FECHA TO FECHFAC
                STORE PVENTA TO PREVENTA
                STORE VALOR TO PREVALOR
                STORE CANT TO CANTPROD
                *********** BUSCA EL NOMBRE DEL PRODUCTO EN ARTICULO.DBF ****
                SELECT 1
                        SEEK(NUMPROD)
                        STORE NOMBRE TO NOMPROD
                        STORE PRECIO TO PRELISTA
                *********** CARGA LOS ARTICULOS EN TRABAJO.DBF ************
                SELECT 4
                        RLOCK()
                                REPLACE CODIGO WITH NUMPROD
                                REPLACE DETALLE WITH NOMPROD
                                REPLACE CANT WITH CANTPROD
                                REPLACE PVENTA WITH PREVENTA
                                REPLACE PLISTA WITH PRELISTA
                                REPLACE VALOR1 WITH PREVALOR
                        UNLOCK
                        SKIP
                SELECT 2
                SKIP
        ENDDO
        ELSE
                STORE 0 TO LAENCONTRE
        ENDIF
********* ABRE LA PANTALLA QUE SIMULA UNA FACTURA *********************
RESTORE SCREEN FROM PANTFB
********* RESTAURA LOS DATOS DEL CLIENTE Y LA FECHA DE LA FACTURA *******
IF LAENCONTRE = 1
@ 2,10 SAY NUMCLI PICTURE "999999"
@ 2,48 SAY FECHFAC
@ 3,10 SAY NOMCLI
@ 3,54 SAY CBTEFAC
@ 4,10 SAY DOMCLI
@ 4,51 SAY CIVACLI
@ 5,10 SAY LOCCLI
@ 5,55 SAY CUITCLI
********* IMPRIME EN PANTALLA TODOS LOS PRODUCTOS *************************
STORE 9 TO LIN
STORE 0 TO TOTAL
SELECT 4
        GO 1
        DO WHILE (RECNO()<13) .AND. (CANT<>0)
                @ LIN,2  SAY CODIGO
                @ LIN,17 SAY DETALLE
                @ LIN,48 SAY PLISTA PICTURE "####.##"
                @ LIN,56 SAY CANT PICTURE "####"
                @ LIN,61 SAY PVENTA PICTURE "####.##"
                STORE VALOR1 TO PARCIAL
                @ LIN,69 SAY ROUND((PARCIAL * 1.21),2)  PICTURE "###,###.##"
                TOTAL = TOTAL + PARCIAL
                LIN = LIN + 1
                SKIP
                ************ CONTROLA SI COMPLETO LA PRIMER PANTALLA ******
          ENDDO
     *********** IMPRIME LOS TOTALES EN PANTALLA ***********
     @ 22,69 SAY ROUND((TOTAL * 1.21),2) PICTURE "###,###.##"
ENDIF
//     @ 22,74 SAY ALLTRIM(BONIF)
//     @ 23,69 SAY VALFAC PICTURE "###,###.##"

     *********** NAVEGA ENTRE LAS PANTALLAS **************
*************** CONTROLA LA ACCION PRINCIPAL ***************************  
STORE 3 TO VMENU
SET COLOR TO W+/R
@ 24,1 CLEAR TO 24,89
@ 24,8 PROMPT "OTRA CONSULTA"
@ 24,36 PROMPT "IMPRIMIR"
@ 24,59 PROMPT "FINALIZAR"
MENU TO VMENU
SET COLOR TO W/B
DO CASE
        CASE VMENU=1
                LOOP
        CASE VMENU=3
                STORE 80 TO JJ
                CLOSE ALL
                EXIT
        CASE VMENU = 2
                STORE 1 TO CLAVE
                SET DEVICE TO PRINTER
                @ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
                DO WHILE CLAVE < 2
                        IF LEFT(CBTEFAC,4) = "REMI"
                                @ 1,22 SAY CHR(18)+CHR(14)+"REMITO"+" "+RIGHT(CBTEFAC,13)
                         ELSE
                                @ 1,22 SAY CHR(18)+CHR(14)+"NOTA DE CREDITO"+" "+RIGHT(CBTEFAC,13)
                        ENDIF
                        @ 5,45 SAY "Fecha:"
                        @ 5,52 SAY FACFECHA
                        @ 10,8 SAY "Cuenta N§"
                        @ 10,18 SAY NUMCLI PICTURE "######"
                        @ 10,65 SAY "Vendedor N§"
                        @ 10,77 SAY 1 PICTURE "###"
                        @ 11,1 say "Nombre:"
                        @ 11,9 SAY NOMCLI
                        @ 12,1 say "Direccion:"
                        @ 12,12 SAY DOMCLI
                        @ 13,1 say "Localidad:"
                        @ 13,12 SAY LOCCLI
                        IF CIVACLI = "F"
                                @ 14,8 SAY "Consumidor Final"
                        ENDIF
                        IF CIVACLI = "E"
                                @ 14,8 SAY "Exento"
                        ENDIF
                        IF CIVACLI = "R"
                                @ 14,8 SAY "No Responsable"
                        ENDIF
                        @ 14,60 SAY CUITCLI
                        IF NUMCLI = 8888
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
                        SELECT 4
                        GO 1
                        DO WHILE RECNO() < 26
                        IF CANT > 0
                                @ LIN,1 SAY CANT PICTURE "####"
                                @ LIN,11 SAY DETALLE  //ERA 16
                                @ LIN,45 SAY CODIGO    //ERA 46
                                @ LIN,59 SAY PVENTA PICTURE "#,###.##"
                                STORE (CANT * PVENTA) TO PARCIAL
                                @ LIN,70 SAY PARCIAL PICTURE "###,###.##"
                                LIN = LIN + 1
                        ENDIF
                        SKIP
ENDDO
@ 51,59 SAY "Subtotal =>" 
@ 51,70 SAY TOTAL PICTURE "###,###.##"
@ 52,55 SAY "Bonificacion =>"
@ 52,74 SAY BONIF 
@ 53,62 SAY "Total =>" 
@ 53,70 SAY VALFAC PICTURE "###,###.##"
CLAVE = CLAVE + 1
ENDDO
IF VMENU = 2
        EJECT
ENDIF
SET DEVICE TO SCREEN
ENDCASE
LOOP
ENDDO
                

