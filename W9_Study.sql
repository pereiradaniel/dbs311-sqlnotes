set serveroutput on

-- Simple PL/SQL Block
begin
  dbms_output.put_line('Hello');
end;
-- Anonymous block because not named!

-- DECLARE
declare
 value_1        number := 20;
 value_2        number := 10;
 addition       number;
 subtraction    number;
 multiplication number;
 division       number;
begin
addition := value_1 + value_2;
subtraction := value_1 - value_2;
multiplication := value_1 * value_2;
division := value_1 / value_2;

dbms_output.put_line ('addition: ' || addition);
dbms_output.put_line ('subtraction: ' || subtraction);
dbms_output.put_line ('multiplication: ' || multiplication);
dbms_output.put_line ('division: ' || division);
end;

-- STRING
-- Character literals are case-sensitive
-- Whitespace characters are significant!
begin
  dbms_output.put_line('This string
  breaks here.');
end;

-- EXCEPTION
-- This section handles errors that occur when a PL/SQL block executes.
declare
  value_1 number := 20;
  value_2 number := 0;
  division number;
begin
  division := value_1 / value_2; -- division by zero generates an error!
  dbms_output.put_line('division: ' || division);
end;

-- FIXING IT
declare
  value_1 number := 20;
  value_2 number := 0;
  division number;
begin
  division := value_1 / value_2; -- division by zero generates an error!
  dbms_output.put_line('division: ' || division);
exception
when others
  then
    dbms_output.put_line('Error!'); -- not a specific fix!
end;

-- FIXING IT MORE
declare
  value_1 number := 20;
  value_2 number := 0;
  division number;
begin
  division := value_1 / value_2; -- division by zero generates an error!
  dbms_output.put_line('division: ' || division);
exception
when zero_divide -- caught by error handling
  then
    dbms_output.put_line('Division by zero!');
when others -- when others must be last!
  then
    dbms_output.put_line('Error!');
end;

