-- metadata (table definition)
DROP TABLE IF EXISTS dummy;
CREATE TABLE IF NOT EXISTS dummy (
    id SERIAL PRIMARY KEY,
    -- UUID v4 (there's also a Postgres type)
    uuid_varchar VARCHAR ( 36 ) NOT NULL
);

-- data (rows)
INSERT INTO dummy(uuid_varchar)
VALUES
('f79c4c20-22f2-4cce-a86f-6bdf6cea452c'),
('aff41f49-8cfe-48a3-9784-c2e263677eed'),
('3e77ddb1-2a3f-43b3-b1b5-9bc28bafc80d');
