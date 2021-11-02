-- metadata (table definition)
DROP TABLE IF EXISTS dummy;
CREATE TABLE IF NOT EXISTS dummy (
    id       SERIAL PRIMARY KEY,
    category VARCHAR ( 20 ) UNIQUE NOT NULL
);

-- data (rows)
INSERT INTO dummy(id, category) 
VALUES
    (1, 'foo-category'),
    (2, 'bar-category'),
    (3, 'baz-category');
