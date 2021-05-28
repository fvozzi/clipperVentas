RESTORE FROM FISCAL.MEM
CLEAR SCREEN
STORE 0 TO JJ
        SET COLOR TO W/RG
        @ 4,19 CLEAR TO 17,62
        @ 3,19,19,62 BOX &caja9       &&dibuja una caja con los parametros de FISCAL.MEM
STORE "" TO V1,V2,V3,V4, V5, V6, V7

DO WHILE JJ= 0
        STORE 1 TO XMENU
        SET COLOR TO B/RG
        @ 4,24 PROMPT "ARCHIVO DE CTACTE"
        @ 4,49 SAY "( )"
        SET COLOR TO R/RG
        @ 6,50 SAY V1
        SET COLOR TO B/RG

        @ 6,24 PROMPT "ARCHIVO DE MOV. IVA"
        @ 6,49 SAY "( )"
        SET COLOR TO R/RG
        @ 6,50 SAY V2
        SET COLOR TO B/RG

        @ 8,24 PROMPT "ARCHIVO DE DEUDORES"
        @ 8,49 SAY "( )"
        SET COLOR TO R/RG
        @ 8,50 SAY V3
        SET COLOR TO B/RG


        @ 10,24 PROMPT "ARCHIVO DE ARTICULOS"
        @ 10,49 SAY "( )"
        SET COLOR TO R/RG
        @ 10,50 SAY V4
        SET COLOR TO B/RG
		
		@ 12,24 PROMPT "ARCHIVO DE PROVEEDORES"
        @ 12,49 SAY "( )"
        SET COLOR TO R/RG
        @ 12,50 SAY V5
        SET COLOR TO B/RG
		
		@ 14,24 PROMPT "ARCHIVO DE MOV. PROV."
        @ 14,49 SAY "( )"
        SET COLOR TO R/RG
        @ 14,50 SAY V6
        SET COLOR TO B/RG

		@ 16,24 PROMPT "ARCHIVO DE MOV.IVA PRO."
        @ 16,49 SAY "( )"
        SET COLOR TO R/RG
        @ 16,50 SAY V7
        SET COLOR TO B/RG

        @ 18,24 PROMPT "SALIDA"
        MENU TO XMENU   &&almacena la eleccion del prompt en XMENU
        DO CASE
          CASE XMENU=1
                  DO CTACTE00 
                  V1 = "*"
          CASE XMENU=2
                  DO MOVIVA00
                  V2 = "*"
          CASE XMENU=3
                  DO DEUDOR00
                  V3 = "*"
          CASE XMENU=4
				  DO ARTICU00
                  V4 = "*"
		  CASE XMENU=5
				  DO PROVEE00
                  V5 = "*"
          CASE XMENU=6
				  DO MOVPRO00
                  V6 = "*"        
		  CASE XMENU=7
				  DO IVAPRO00
                  V7 = "*"
          CASE XMENU=8
                  JJ=1
       ENDCASE
ENDDO
CLOSE ALL


