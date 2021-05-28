SET CENTURY ON
SET DATE BRITISH
USE MOVIVA
INDEX ON CBTE TO ICBTE
CLOSE DATA
SELECT 4
USE MCTACTE INDEX MCC_CLA1, MCC_CLA2
SELECT 5
USE MOVIVA INDEX ICBTE
SELECT 4
DO WHILE .NOT. EOF()
       IF FECHA > CTOD("17/07/2001")
                STORE CBTE TO XCBTE
                STORE VALOR TO XVALOR
                SELECT 5
                SEEK(XCBTE)
                IF .NOT. EOF()
                        RLOCK()
                        REPLACE GRAVADO WITH ROUND((XVALOR / 1.21),2)
                        REPLACE IVA WITH ROUND(((XVALOR /1.21) * .21),2)
                        REPLACE NETO WITH GRAVADO + IVA
                        UNLOCK
                ENDIF
        ENDIF
        SELECT 4
        SKIP
ENDDO

                        
