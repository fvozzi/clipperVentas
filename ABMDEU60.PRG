SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE OFF
SET EXCLUSIVE ON
RESTORE FROM FISCAL.MEM
DECLARE campos[2]
campos[1]="NUMERO"
campos[2]="NOMBRE"
STORE 83 TO JJ
DO WHILE JJ = 83
USE DEUDORES
SET INDEX TO DEU_NUM, DEU_NOM
RESTORE SCREEN FROM PANT1

****************VARIABLE GLOBAL PARA LA BUSQUEDA RAPIDA ***********
STORE "" TO POS
*******************************************************************
SET COLOR TO W+/RB
@ 2,6 SAY "            ALTAS Y MODIFICACIONES AL ARCHIVO DE DEUDORES"
@ 23,2 SAY "FINALIZAR: TECLA <=ESC=>"
@ 23,55 SAY "CONSULTA: TECLA <=PgUp=>"
SET COLOR TO W/B
@ 8,14 CLEAR TO 16,67
@ 7,14,17,67 BOX &caja9
@ 8,15 SAY "N�mero:"
@ 9,15 SAY "Nombre:"
@ 10,15 SAY "Domicilio:"
@ 11,15 SAY "Localidad:"
@ 12,15 SAY "Tel�fono:"
@ 13,15 SAY "Condicion IVA:"
@ 14,15 SAY "Tipo Doc.:"
@ 15,15 SAY "C.U.I.T."
@ 16,15 SAY "Tipo:"
SET COLOR TO W/R
SET ORDER TO 1
GO BOTTOM
@ 6,40 SAY "Mayor N� de Cliente: "
@ 6,61 SAY NUMERO PICTURE "###,###"
SET COLOR TO W/B
STORE 0 TO CLAVE
DO WHILE CLAVE < 1 .OR. CLAVE > 999999
        STORE SPACE(6) TO BUSCAR
        @ 8,23 GET BUSCAR
        READ
        STORE 0 TO MM
        FOR I=1 TO LEN(BUSCAR)
                IF ASC(SUBSTR(BUSCAR,I,1)) < 48 .OR. ASC(SUBSTR(BUSCAR,I,1)) > 57
                        STORE 1 TO MM
                ENDIF
                IF SUBSTR(BUSCAR,I,1) = " "
                        STORE 0 TO MM
                ENDIF
        NEXT I
        IF MM = 0
                STORE VAL(BUSCAR) TO CLAVE
        ENDIF
        IF LASTKEY() = 27
                EXIT
        ENDIF
        IF LASTKEY() = 18
                SAVE SCREEN TO MP1
                SEEK BUSCAR //RTRIM(BUSCAR)
                SET ORDER TO 2
                STORE 0 TO CONTROL
                DO WHILE EOF() .AND. CONTROL = 0
                        STORE 0 TO CONTROL
                        GO TOP
                        KEYBOARD CHR(4)
                        SET COLOR TO W/R
                        @ 4,30 CLEAR TO 21,70
                        @ 4,30,21,71 BOX &caja9
                        DBEDIT(5,31,20,70,campos,"arts")
                        IF LEN(POS)>= 1
                                POS = ""
                        ENDIF
                        RESTORE SCREEN FROM MP1
                        SET COLOR TO W/B
                        IF LASTKEY() = 13
                                STORE NUMERO TO CLAVE
                        ENDIF
                        IF LASTKEY() = 27
                                STORE SPACE(6) TO BUSCAR
                                STORE 0 TO CLAVE
                                STORE 1 TO CONTROL
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
@ 9,30 SAY NOMBRE
@ 10,30 SAY DOMICILIO
@ 11,30 SAY LOCALIDAD
@ 12,30 SAY TELEFONO
@ 13,30 SAY CIVA
@ 14,30 SAY TDOC
@ 15,30 SAY CUIT
@ 16,30 SAY TIPO
@ 16,40 SAY "SALDO CTA.CTE.:"
@ 16,56 SAY SALDO PICTURE "###,###.##"
ENDIF
IF EOF()
STORE 1 TO VMENU
SET COLOR TO W+/RB
@ 23,2 CLEAR TO 23,78
@ 23,20 PROMPT "CANCELAR"
@ 23,47 PROMPT "AGREGAR CLIENTE"
MENU TO VMENU
DO CASE
  CASE VMENU=1
  LOOP
  CASE VMENU = 2
  SET COLOR TO W/B
  RLOCK()
  APPEND BLANK
  REPLACE NUMERO WITH CLAVE, NOMBRE WITH SPACE(30), DOMICILIO WITH SPACE(30), LOCALIDAD WITH SPACE(30), SALDO WITH 0
  REPLACE TELEFONO WITH SPACE(30), TDOC WITH SPACE(4), CIVA WITH SPACE(1), CUIT WITH SPACE(11), TIPO WITH SPACE(1)
  @ 8,23 SAY NUMERO
  @ 9,30 GET NOMBRE
  @ 10,30 GET DOMICILIO
  @ 11,30 GET LOCALIDAD
  @ 12,30 GET TELEFONO
  @ 13,30 GET CIVA VALID(CIVA$"IRNEMF")
  @ 14,30 GET TDOC
  @ 15,30 GET CUIT
  @ 16,30 GET TIPO
  READ
  IF CIVA = "I" .OR. CIVA = "R" .OR. CIVA = "M" .OR. CIVA = "E"
  REPLACE TDOC WITH "CUIT"
  @ 14,30 SAY TDOC
  ENDIF
  UNLOCK
ENDCASE
ENDIF
STORE 1 TO PMENU
SET COLOR TO W+/RB
@ 23,2 CLEAR TO 23,78
@ 23,12 PROMPT "OTRA CONSULTA"
@ 23,35 PROMPT "MODIFICAR DATOS"
@ 23,59 PROMPT "BAJA CLIENTE"
MENU TO PMENU
DO CASE
  CASE PMENU = 1
        @ 23,2 CLEAR TO 23,78
  CASE PMENU = 2
        SET COLOR TO W/B
        RLOCK()
        @ 8,23 SAY NUMERO
        @ 9,30 GET NOMBRE
        @ 10,30 GET DOMICILIO
        @ 11,30 GET LOCALIDAD
        @ 12,30 GET TELEFONO
        @ 13,30 GET CIVA VALID(CIVA$"INFERMC")
        @ 14,30 GET TDOC
        @ 15,30 GET CUIT
        @ 16,30 GET TIPO
        READ
        IF CIVA = "I" .OR. CIVA = "R" .OR. CIVA = "M" .OR. CIVA = "E"
                REPLACE TDOC WITH "CUIT"
                @ 14,30 SAY TDOC
        ENDIF
        UNLOCK
  CASE PMENU = 3
        ***** ELIMINA EL CLIENTE Y TODA SU CUENTA *****
        *                                             *
        ***********************************************
        SET COLOR TO W/R                              
        @ 10,20 CLEAR TO 15,60
        @ 9,20,17,65 BOX &caja9
        SET COLOR TO W*/R
        @ 11,22 SAY "ADVERTENCIA:"
        SET COLOR TO W/R
        @ 11,35 SAY "ESTE PROCEMIENTO  ELIMINARA"
        @ 12,35 SAY "EL CLIENTE Y TODA SU CUENTA"
        SET COLOR TO W+/R
        @ 14,35 SAY "�ESTA SEGURO?"
        STORE 2 TO ZMENU
        @ 15,35 PROMPT "SI"
        @ 15,45 PROMPT "NO"
        MENU TO ZMENU
        DO CASE 
                CASE ZMENU = 1
                        //SET EXCLUSIVE ON
                        ** ALMACENA EL NUMERO DEL CLIENTE A ELIMINAR **
                        STORE NUMERO TO BORRAR
                        RLOCK()
                        ** BORRA LA ENTRADA DEL CLIENTE DEL REGISTRO ACTUAL **
                        DELETE RECORD RECNO()
                        UNLOCK
                        PACK
                        USE MCTACTE
                        SET INDEX TO MCC_CLA1, MCC_CLA2
                        SEEK(BORRAR)
                        RLOCK()
                        DELETE FOR CLIENTE = BORRAR
                        UNLOCK
                        PACK
                        //SET EXCLUSIVE OFF
              CASE ZMENU = 2
                        @ 23,2 CLEAR TO 23,78
       ENDCASE
ENDCASE
ENDDO
CLOSE ALL
RETURN

