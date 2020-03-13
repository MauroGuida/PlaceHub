CREATE OR REPLACE PROCEDURE resetPassword(INT)
LANGUAGE plpgsql
AS $$
BEGIN
  Update utente
  set codiceVerifica=(select substr(md5(random()::text), 0, 10))
  where codutente=$1;

  COMMIT;
END;
$$;
