-- *******************************************************************************
-- *                                                                     
-- *   GRUPA: 		               1
-- *                                 
-- *******************************************************************************
-- * 																		     
-- *   Nazwisko i imię:             Wojciech Jankowski                                                  
-- * 																		     
-- *******************************************************************************
-- * 																		     
-- *   Nr indeksu:                  96335                                             
-- * 																		     
-- *******************************************************************************

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
-- 		Elementy, które powiny pojawić się w opracowywanych programach:
-- 		- wykorzystanie %TYPE, %ROWTYPE 
-- 		- typ rekordowy, typ tablicowy
-- 		- instrukcje sterujące
-- 		- kursory
-- 		- obsługa wyjątków
-- 	
--		Należy przygotować:
--		- 1 procedurę, 
--		- 1 funkcję, 
--		- 1 procedurę lub funkcję (do wyboru)
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- *******************************************************************************
-- 								 NR 1 - PROCEDURA                                            
-- *******************************************************************************

--  PROCEDURA MA ZA ZADANIE ODCZYTAĆ Z PARAMETRU WYWOŁUJĄCEGO NUMER POZYCJI KLIENTA
--  I WYPISAĆ JEGO DANE. JEŚLI PRZEKAEMY WYWOŁANIE PROCEDURY BEZ ARGUMENTU 
--  WYJĄTEK ZAALARMUJE NAS W POSTACI BLEDU

-- -------------------------------------------------------------------------------
-- UTWORZENIE PROCEDURY                                             
-- -------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE print_contact(
    p_customer_id NUMBER 
)
IS
  r_contact klient%ROWTYPE;
BEGIN
 
  SELECT *
  INTO r_contact
  FROM klient
  WHERE id_klienta = p_customer_id;
 
  dbms_output.put_line( r_contact.imie || ' ' ||
  r_contact.nazwisko || ' Miasto: ' || r_contact.miasto ||'.' );
 
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );
      
END;
/



-- -------------------------------------------------------------------------------
-- PRZYKŁAD POLECENIA, KTÓRE PRZETESTUJE PROCEDURĘ                                              
-- -------------------------------------------------------------------------------


EXEC print_contact(1);


-- -------------------------------------------------------------------------------
-- USUNIĘCIE PROCEDURY                                             
-- -------------------------------------------------------------------------------


DROP PROCEDURE print_contact;


-- *******************************************************************************
-- 								NR 2 - FUNKCJA                                           
-- *******************************************************************************

--  FUNKCJA, KTÓRA ZLICZA SUMĘ PRZYCHODÓW ZA WYPOYCZONY SPRZĘT GDZIE WARTOŚĆ KOLUMNY
--  CZY_ZAPŁACONE JEST RÓWNY 'TAK' I WYPISUJE SUMĘ ILORAZU CENY DO ILOSCI DNI DLA 
--  WSZYSTKICH ZGODNYCH WARTOŚCI

-- -------------------------------------------------------------------------------
-- UTWORZENIE PROCEDURY                                             
-- -------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION get_total_sales(
    in_year PLS_INTEGER
) 
RETURN NUMBER
IS
    l_total_sales NUMBER := 0;
BEGIN
    SELECT SUM(CENA * ILOSC_DNI)
    INTO l_total_sales
    FROM wypozyczenie
    WHERE CZY_ZAPLACONE = 'TAK';
    
    RETURN l_total_sales;
END;
/


-- -------------------------------------------------------------------------------
-- PRZYKŁAD POLECENIA, KTÓRE PRZETESTUJE PROCEDURĘ                                              
-- -------------------------------------------------------------------------------


SELECT
    get_total_sales(2019)
FROM
    dual;


-- -------------------------------------------------------------------------------
-- USUNIĘCIE PROCEDURY                                             
-- -------------------------------------------------------------------------------


DROP FUNCTION get_total_sales;




-- *******************************************************************************
-- 								NR 3 - PROCEDURA LUB FUNKCJA                                            
-- *******************************************************************************

--  PROCEDURA AKTUALIZUJE CENĘ KAUCJI POPRZEZ ILOCZYN WPROWADZONEGO PARAMETRU Z PROCEDURY
--  efektem ROLLBACK jest to, że jeśli pierwsza instrukcja aktualizacji nie powiedzie się,
--  praca wykonana w sesji przed wywołaniem tego bloku zostanie wycofana. 

-- -------------------------------------------------------------------------------
-- UTWORZENIE                                              
-- -------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE update_employee_salary(
      p_factor IN NUMBER
    ) AS
      v_employee_count INTEGER;
    BEGIN
        UPDATE REZERWACJA
        SET KAUCJA = KAUCJA * p_factor;
        COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
       ROLLBACK;
   END;
   /

-- -------------------------------------------------------------------------------
-- PRZYKŁAD POLECENIA, KTÓRE PRZETESTUJE                                               
-- -------------------------------------------------------------------------------


SELECT * FROM REZERWACJA;
EXEC update_employee_salary(2);
SELECT * FROM REZERWACJA;


-- -------------------------------------------------------------------------------
-- USUNIĘCIE                                              
-- -------------------------------------------------------------------------------


DROP PROCEDURE update_employee_salary;

