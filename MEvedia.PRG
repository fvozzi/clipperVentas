SET SCOREBOARD ON
SET BELL ON
SET CONFIRM OFF
SET DELETE ON
SET DATE BRITISH
STORE .T. TO MM
DO WHILE MM
STORE 1 TO XMENU
RESTORE FROM FISCAL.MEM
RESTORE SCREEN FROM PANT1
USE NUMEROS
STORE RTRIM(NOMBRE) TO TNOMBRE          &&ELIMINA LOS BLANCOS A LA DERECHA DEL STRING
STORE "SISTEMA DE VENTAS - " + TNOMBRE TO CNOMBRE  &&ALMACENA EN CNOMBRE LA SUMA
SET COLOR TO W+/RB
STORE LEN(CNOMBRE) TO COL    &&CALCULA EL ANCHO TOTAL DEL TITULO Y LO ALMACENA EN COL
STORE 80 - COL TO LIN        &&CALCULA LA DIFERENCIA DEL TOTAL DE COLUMNAS DE LA PANTALLA Y LO QUE OCUPA EL TITULO
LIN = LIN / 2                &&DIVIDE POR 2 EL ESPACIO EN BLANCO Y LO GUARDA EN LIN
STORE ROUND(LIN,0) TO COL    &&REDONDEA LA DIVISION Y LA almacena en COL
@ 2,COL SAY CNOMBRE          &&ubica CNOMBRE  al centro de la pantalla
@ 23,2 CLEAR TO 23,78
@ 23,2 SAY "Dise�o y Programaci�n:    Facundo Vozzi por Casa Vozzi"
SET COLOR TO W/B
@ 8,19 CLEAR TO 19,62
@ 7,19,19,62 BOX &caja9       &&dibuja una caja con los parametros de FISCAL.MEM
@ 8,24 PROMPT "Altas y Modificaciones de Archivos"
@ 9,24 PROMPT "Emisi�n de Facturas"
@ 10,24 PROMPT "Ingreso de Cobranza"
@ 11,24 PROMPT "Ingreso de Notas de Credito (No F.)"
@ 12,24 PROMPT "Ingreso de Compras de Mercader�a"
@ 13,24 PROMPT "Consultas de Cuentas Corrientes"
@ 14,24 PROMPT "Consultas de Productos"
//@ 15,24 PROMPT "Consultas de Pagos"
@ 15,24 PROMPT "Listado de Clientes"
@ 16,24 PROMPT "Cierre Impresora Fiscal"
@ 17,24 PROMPT "Salida"
MENU TO XMENU   &&almacena la eleccion del prompt en XMENU
DO CASE
  CASE XMENU=1
  DO ABMARC33 
  CASE XMENU=2
  DO FACTUR60
  CASE XMENU=3
  DO INGCOB33
  CASE XMENU=4
  DO INGNDC60
  CASE XMENU=5
  DO INGCPA33
  CASE XMENU=6
  DO MENUCC31
  CASE XMENU=7
  DO MENUPR33
  //CASE XMENU=8
  //DO LISTPAGO
  CASE XMENU=8
  DO LISCLI31
  CASE XMENU=9
  DO CIERRE33
  CASE XMENU=10
  EXIT       
ENDCASE
STORE .T. TO MM
ENDDO
RETURN

FUNCTION finc              && no se lo que hace
PARAMETERS mode,i
PRIVATE campo_act
campo_act=campos[i]
DO CASE
   CASE mode < 4
     RETURN(1)
   CASE LASTKEY() = 27
     RETURN(0)
   CASE LASTKEY() = 13
     RETURN(0)
   OTHERWISE
     RETURN(1)
ENDCASE
RETURN

FUNCTION arts              && no se lo que hacE
PARAMETERS mode,i
PRIVATE campo_act
campo_act=campos[i]
DO CASE
   CASE mode < 4
     RETURN(1)
   CASE LASTKEY() = 27
     RETURN(0)
   CASE LASTKEY() = 13
     RETURN(0)
   CASE (LASTKEY()>64 .AND. LASTKEY()<97) .OR. (LASTKEY()>96 .AND. LASTKEY()<123)
        POS = POS + CHR(LASTKEY())
        SELECT 2
        SET ORDER TO 2
        SEEK(UPPER(POS))
        KEYBOARD CHR(4)
        //IF LEN(POS) > 2
        //        RETURN(0)
        //ENDIF
   OTHERWISE
     RETURN(1)
ENDCASE
RETURN
