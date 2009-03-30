-- creates triggers for comments table

CREATE OR REPLACE FUNCTION on_comments_insert() RETURNS TRIGGER AS $$
  DECLARE 
    c integer;
    s varchar;
  BEGIN
    s := 'SELECT id FROM ' || NEW.parent_table || ' WHERE id = ' || NEW.parent_id;
    EXECUTE s INTO c;
    IF c IS NOT NULL
    THEN 
      RETURN NEW;
    ELSE
      RAISE EXCEPTION 'Comment must reference parent';
    END IF;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER comments_insert_trigger BEFORE INSERT OR UPDATE ON comments
  FOR EACH ROW EXECUTE PROCEDURE on_comments_insert();
