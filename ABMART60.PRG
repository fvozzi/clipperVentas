SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE OFF
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
DECLARE campos[2]
campos[1]="NUMERO"
campos[2]="NOMBRE"
USE ARTICULO 
SET INDEX TO ART_NUM, ART_NOM, ART_LIN
STORE 83 TO JJ
STORE "" TO POS
DO WHILE JJ = 83
RESTORE SCREEN FROM PANT1
SET COLOR TO W+/RB
@ 2,6 SAY "            ALTAS Y MODIFICACIONES AL ARCHIVO DE PRODUCTOS"
@ 23,2 SAY "FINALIZAR: TECLA <=ESC=>"
@ 23,55 SAY "CONSULTA: TECLA <=PgUp=>"
SET COLOR TO W/B
@ 8,14 CLEAR TO 14,67
@ 7,14,16,67 BOX &caja9
@ 8,15 SAY "N£mero:"
@ 9,15 SAY "Nombre:"
@ 10,15 SAY "C¢digo IVA:"
@ 11,15 SAY "C¢digo Contable:"
@ 12,15 SAY "C¢digo L¡nea:"
@ 13,15 SAY "Precio de Venta:"
@ 14,15 SAY "Precio de Compra:"
@ 15,15 SAY "Imp.Internos:"
SET COLOR TO W/R

SET ORDER TO 1
GO BOTTOM
@ 6,38 SAY "Mayor N§ de Producto: "
@ 6,60 SAY NUMERO PICTURE "#######"

SET COLOR TO W/B
STORE SPACE(14) TO CLAVE
DO WHILE CLAVE = "              "
        STORE SPACE(14) TO CLAVE
        @ 8,23 GET CLAVE
        READ
        IF LASTKEY() = 27
                EXIT
        ENDIF
        *************** ABRE LA VENTANA DE BUSCA RAPIDA *****************
        IF LASTKEY() = 18
                SAVE SCREEN TO MP1
                SEEK CLAVE
                SET ORDER TO 2
                STORE 0 TO CONTROL
                ******** LA MANTIENE ABIERTA HASTA QUE PRESIONAMOS ESC *******
                DO WHILE EOF() .AND. CONTROL = 0
                        STORE 0 TO CONTROL
                        GO TOP
                        KEYBOARD CHR(4)
                        SET COLOR TO W/R
                        @ 4,30 CLEAR TO 21,70
                        @ 4,30,21,71 BOX &caja9
                        DBEDIT(5,31,20,70,campos,"arts")
                        ******* RESETA EL CONTADOR DE BUSQUEDA **************
                        IF LEN(POS)>= 1
                                POS = ""
                        ENDIF

                        RESTORE SCREEN FROM MP1
                        SET COLOR TO W/B
                        IF LASTKEY() = 13
                                STORE NUMERO TO CLAVE
                        ENDIF
                        IF LASTKEY() = 27
                                STORE SPACE(14) TO CLAVE
                                CONTROL = 1
                        ENDIF
                ENDDO
                RESTORE SCREEN FROM MP1
        ENDIF
ENDDO
IF LASTKEY() = 27 
EXIT
ENDIF
SET ORDER TO 1
SEEK CLAVE
IF .NOT. EOF()
@ 8,23 SAY NUMERO
@ 9,23 SAY NOMBRE
@ 10,27 SAY CIVA
@ 11,32 SAY CONTABLE
@ 12,32 SAY LINEA
@ 13,32 SAY PRECIO PICTURE "###,###.##"
@ 14,32 SAY PRECOMP PICTURE "###,###.##"
@ 15,32 SAY INTERNO PICTURE "#,###.####"
ENDIF
IF EOF()
STORE 1 TO VMENU
SET COLOR TO W+/RB
@ 23,2 CLEAR TO 23,78
@ 23,20 PROMPT "CANCELAR"
@ 23,47 PROMPT "AGREGAR PRODUCTO"
MENU TO VMENU
DO CASE
  CASE VMENU=1
  LOOP
  CASE VMENU = 2
  SET COLOR TO W/B
  RLOCK()
  APPEND BLANK
  REPLACE NUMERO WITH CLAVE, NOMBRE WITH SPACE(20), CIVA WITH 0, CONTABLE WITH 0, LINEA WITH 0, PRECIO WITH 0, INTERNO WITH 0 
  @ 9,23 GET NOMBRE
  @ 10,27 GET CIVA
  @ 11,32 GET CONTABLE
  @ 12,32 GET LINEA
  @ 13,32 GET PRECIO PICTURE "###,###.##"
  @ 14,32 GET PRECOMP PICTURE "###,###.##"
  @ 15,32 GET INTERNO PICTURE "#,###.####"
  READ
  UNLOCK
ENDCASE
ENDIF
STORE 1 TO PMENU
SET COLOR TO W+/RB
@ 23,2 CLEAR TO 23,78
@ 23,19 PROMPT "OTRA CONSULTA"
@ 23,50 PROMPT "MODIFICAR DATOS"
MENU TO PMENU
DO CASE
  CASE PMENU = 1
  @ 23,2 CLEAR TO 23,78
  CASE PMENU = 2
  SET COLOR TO W/B
  RLOCK()
  @ 8,23 SAY NUMERO
  @ 9,23 GET NOMBRE
  @ 10,27 GET CIVA
  @ 11,32 GET CONTABLE
  @ 12,32 GET LINEA
  @ 13,32 GET PRECIO PICTURE "###,###.##"
  @ 14,32 GET PRECOMP PICTURE "###,###.##"
  @ 15,32 GET INTERNO PICTURE "#,###.####"
  READ
  UNLOCK
ENDCASE
ENDDO
CLOSE ALL
RETURN

