SET EXCLUSIVE ON
PRIVATE AUXCLIENTE,AUXFECHA,AUXTMOV,AUXCBTE,AUXVALOR,AUXSALDO
SELECT 1
        USE MCTACTE
SELECT 2
        USE AUXMCTE
SELECT 1
GO TOP
DO WHILE .NOT. EOF()
        AUXCLIENTE= CLIENTE
        AUXFECHA = FECHA
        AUXTMOV= TMOV
        AUXCBTE= CBTE
        AUXVALOR= VALOR
        AUXSALDO= SALDO
        SELECT 2
        APPEND BLANK
        REPLACE CLIENTE WITH AUXCLIENTE, FECHA WITH AUXFECHA, TMOV WITH AUXTMOV
        REPLACE CBTE WITH AUXCBTE,VALOR WITH AUXVALOR, SALDO WITH AUXSALDO
        SELECT 1
        SKIP
ENDDO
CLOSE ALL

