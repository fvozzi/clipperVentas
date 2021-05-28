SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE ON
SET CENTURY ON
SET DATE BRITISH
SET EXCLUSIVE OFF
RESTORE FROM FISCAL.MEM
USE NUMEROS
        STORE NOMBRE TO QNOM
        STORE DOMICILIO TO QDOM
CLOSE DATABASE
USE DEUDORES INDEX DEU_NOM
CLEAR
RESTORE SCREEN FROM PANT1
SET COLOR TO W/RB 
@2,30 SAY "LISTADO DE CLIENTES"
STORE "A" TO DESDE
STORE "Z" TO HASTA
SET COLOR TO W/B
@ 7,19,15,62 BOX &caja9
@ 10,24 SAY "DESDE : "
@ 12,24 SAY "HASTA : " 
//@ 10,33 SAY DESDE
//@ 12,33 SAY HASTA
@ 10,33 GET DESDE 
@ 12,33 GET HASTA 
READ
IF DESDE > HASTA
        @ 10,33 GET DESDE
        @ 12,33 GET HASTA
        
ENDIF
@ 10,33 SAY DESDE
@ 12,33 SAY HASTA
STORE 1 TO XMENU
SET COLOR TO W/RB
@ 23,10 PROMPT "POR PANTALLA"
@ 23,60 PROMPT "POR IMPRESORA"
MENU TO XMENU   &&almacena la eleccion del prompt en XMENU
DO CASE 
        CASE XMENU = 1 
                STORE 001 TO HOJ
                RESTORE SCREEN FROM CLIENTES
                SET COLOR TO W/B
                @1,30 SAY "LISTADO DE CLIENTES"
                @1,60 SAY "Hoja Nro. :"
                @1,72 SAY ALLTRIM(STR(HOJ))
                SET COLOR TO W
                @4,2 SAY "NRO"
                @4,11 SAY "NOMBRE"
                @4,27 SAY "LOCALIDAD"
                @4,40 SAY "DOMICILIO"
                @4,60 SAY "TELEFONOS"
                STORE 6 TO LIN
                GO TOP
                LOCATE FOR LEFT(ALLTRIM(NOMBRE),1) >= DESDE
                IF FOUND() 
                        DO WHILE .NOT. EOF() .AND. LEFT(ALLTRIM(NOMBRE),1) <= HASTA
                                @LIN,2 SAY RIGHT(ALLTRIM((STR(NUMERO))),3)
                                @LIN,6 SAY LEFT((ALLTRIM(NOMBRE)),18)
                                @LIN,25 SAY LEFT(LOCALIDAD,13)
                                @LIN,39 SAY LEFT((ALLTRIM(DOMICILIO)),15)
                                @LIN,55 SAY LEFT((ALLTRIM(TELEFONO)),23)
                                LIN = LIN +1
                                IF LIN >= 20
                                        STORE SPACE(2) TO SEGUIR
                                        SET COLOR TO W/B
                                        @ 23,6 SAY "PRESIONE ENTER PARA SEGUIR "
                                        @ 23,35 GET SEGUIR
                                        READ
                                        IF LASTKEY() = 13
                                                CLEAR 
                                                STORE 6 TO LIN
                                                HOJ= HOJ + 1
                                                RESTORE SCREEN FROM CLIENTES
                                                SET COLOR TO W/B
                                                @1,30 SAY "LISTADO DE CLIENTES"
                                                @1,60 SAY "Hoja Nro. :"
                                                @1,72 SAY ALLTRIM(STR(HOJ)) 
                                                SET COLOR TO W
                                                @4,2 SAY "NRO"
                                                @4,11 SAY "NOMBRE"
                                                @4,27 SAY "LOCALIDAD"
                                                @4,40 SAY "DOMICILIO"
                                                @4,60 SAY "TELEFONOS"

                                        ENDIF
        
                                 ENDIF
                                
                                SKIP
                                IF LEFT(ALLTRIM(NOMBRE),1) <> DESDE
                                   LIN = LIN +1
                                   DESDE = CHR((ASC(DESDE) + 1))
                                ENDIF
                            ENDDO
                            store 0 to control1
                            @-1,-1 get control1
                            read
                       ELSE
                                CONTINUE
                ENDIF
        CASE XMENU = 2
                
                STORE 001 TO HOJ
                SET DEVICE TO PRINTER
                @ 1,1 SAY CHR(27)+CHR(67)+CHR(72)
                //@ 1,2 SAY CHR(27)+CHR(80)
                STORE LEN((ALLTRIM(QNOM))) * 2 TO RM0
                STORE 83 - RM0 TO RM1
                RM1 = ROUND((RM1 / 2),0)
                STORE 83 - LEN((ALLTRIM(QDOM))) TO RM2
                RM2 = ROUND((RM2 / 2),0)
                @ 2,1 SAY CHR(27)+CHR(120)+"1"
                @ 2,RM1 SAY CHR(18)+CHR(14)+QNOM   // VA RM1 EN LUGAR DE 41
                @ 3,1 SAY CHR(18)+CHR(20)
                @ 3,(RM2+5) SAY QDOM
                @ 4,1 SAY CHR(18)+CHR(14)

                @ 5,2 SAY CHR(27)+CHR(77)
                @ 5,32 SAY CHR(18)+CHR(14)+"LISTADO DE CLIENTES"
                
                @ 7,76 SAY "Hoja Nro. :"
                @ 7,88 SAY ALLTRIM(STR(HOJ))
                @ 8,1 say REPLICATE("-",93)
                @ 9,2 SAY "NRO"
                @ 9,11 SAY "NOMBRE"
                @ 9,33 SAY "LOCALIDAD"
                @ 9,50 SAY "DOMICILIO"
                @ 9,72 SAY "TELEFONOS"
                @ 10,1 say REPLICATE("-",93)                
                @ 11,1 SAY CHR(27)+CHR(120)+"0"
                STORE 11 TO LIN
                LOCATE FOR LEFT(ALLTRIM(NOMBRE),1) >= DESDE
                IF FOUND() 
                        DO WHILE .NOT. EOF() .AND. LEFT(ALLTRIM(NOMBRE),1) <= HASTA
                                @LIN,2 SAY RIGHT(ALLTRIM((STR(NUMERO))),3)
                                @LIN,6 SAY LEFT((ALLTRIM(NOMBRE)),22)
                                @LIN,28 SAY LEFT(LOCALIDAD,19)
                                @LIN,47 SAY LEFT((ALLTRIM(DOMICILIO)),19)
                                @LIN,67 SAY LEFT((ALLTRIM(TELEFONO)),29)
                                LIN = LIN +1
                                IF LIN >= 65
                                                EJECT
                                                STORE 11 TO LIN
                                                HOJ= HOJ + 1
                                                @ 2,1 SAY CHR(27)+CHR(120)+"1"
                                                @ 2,30 SAY CHR(14)+QNOM
                                                @ 3,1 SAY CHR(18) + CHR(20)
                                                @ 3,(RM2+5) SAY QDOM
                                                @ 4,1 SAY CHR(18) + CHR(14)
                        
                                                @ 5,2 SAY CHR(27)+CHR(77)
                                                @ 5,32 SAY CHR(18)+CHR(14)+"LISTADO DE CLIENTES"
                                                
                                                @ 7,76 SAY "Hoja Nro. :"
                                                @ 7,88 SAY ALLTRIM(STR(HOJ))
                                                @ 8,1 say REPLICATE("-",93)
                                                @ 9,2 SAY "NRO"
                                                @ 9,11 SAY "NOMBRE"
                                                @ 9,33 SAY "LOCALIDAD"
                                                @ 9,50 SAY "DOMICILIO"
                                                @ 9,72 SAY "TELEFONOS"
                                                @ 10,1 say REPLICATE("-",93)                
                                                @ 11,1 SAY CHR(27)+CHR(120)+"0"
                                         ENDIF
                                         //DESDE = DESDE + 1
                                SKIP
                                IF LEFT(ALLTRIM(NOMBRE),1) <> DESDE
                                   LIN = LIN +1
                                   DESDE = CHR((ASC(DESDE) + 1))
                                ENDIF
                                
                            ENDDO
                            
                       ELSE
                                CONTINUE
                ENDIF
                EJECT
                SET DEVICE TO SCREEN
                RETURN
        ENDCASE
