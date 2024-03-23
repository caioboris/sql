SET SERVEROUTPUT ON;

-- WHILE
DECLARE
    V_CONTADOR NUMBER(2):=1;
BEGIN
WHILE V_CONTADOR <= 20 LOOP
    DBMS_OUTPUT.PUT_LINE(V_CONTADOR);
    V_CONTADOR := V_CONTADOR + 1;
    END LOOP;
END;


-- FOR
BEGIN
FOR V_CONTADOR IN 1..20 LOOP
    DBMS_OUTPUT.PUT_LINE(V_CONTADOR);
END LOOP;
END;

-- EXERCICIO 1
DECLARE 
    VALOR NUMBER := 10; 
BEGIN 
FOR V_MULTIPLICADOR IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(VALOR * V_MULTIPLICADOR);
END LOOP;
END;

--EXERCICIO 2

DECLARE 
    NMRS_PARES NUMBER := 0;
    NMRS_IMPARES NUMBER := 0;
    INTERVALO NUMBER := 10;
BEGIN

FOR V_CONTADOR IN 1..INTERVALO LOOP
    IF MOD(V_CONTADOR,2) = 0 THEN
        NMRS_PARES := NMRS_PARES + 1;
    ELSE 
        NMRS_IMPARES := NMRS_IMPARES +1;
    END IF;

END LOOP;
    DBMS_OUTPUT.PUT_LINE('NUMEROS PARES: ' || NMRS_PARES);
    DBMS_OUTPUT.PUT_LINE('NUMEROS IMPARES: ' || NMRS_IMPARES);
END;

-- EXERCICIO 3

DECLARE 
    NMRS_PARES NUMBER := 0;
    NMRS_IMPARES NUMBER := 0;
    INTERVALO NUMBER := 10;
    TOTAL_PARES NUMBER := 0;
    TOTAL_IMPARES NUMBER := 0;
    MEDIA_PARES NUMBER;
    MEDIA_IMPARES NUMBER;    
BEGIN

FOR V_CONTADOR IN 1..INTERVALO LOOP
    IF MOD(V_CONTADOR,2) = 0 THEN
        NMRS_PARES := NMRS_PARES + 1;
        TOTAL_PARES := TOTAL_PARES + V_CONTADOR;
    ELSE 
        NMRS_IMPARES := NMRS_IMPARES +1;
        TOTAL_IMPARES := TOTAL_IMPARES + V_CONTADOR;
    END IF;
END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('MEDIA NUMEROS PARES: ' || TOTAL_PARES / NMRS_PARES);
    DBMS_OUTPUT.PUT_LINE('MEDIA NUMEROS IMPARES: ' || TOTAL_IMPARES/ NMRS_IMPARES);
END;
    
    