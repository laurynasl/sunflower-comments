
CREATE OR REPLACE FUNCTION on_#{table}_delete_bc() RETURNS TRIGGER AS $$
  DECLARE 
    c integer;
    s varchar;
  BEGIN
    SELECT INTO c COUNT(*) FROM comments WHERE parent_table = '#{table}' AND parent_id = OLD.id;
    IF c > 0
    THEN
      RAISE EXCEPTION 'There are comments referencing #{table}';
    ELSE
      RETURN OLD;
    END IF;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER #{table}_delete_bc_trigger BEFORE DELETE ON #{table}
  FOR EACH ROW EXECUTE PROCEDURE on_#{table}_delete_bc();
