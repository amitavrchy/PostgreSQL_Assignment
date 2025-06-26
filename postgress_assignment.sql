-- Active: 1749496686076@@127.0.0.1@5432@assignment@public
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    region VARCHAR(100) NOT NULL
);
INSERT INTO rangers (name,region) VALUES('Alice Green','Northern Hills'),('Bob White','River Delta'),('Carol King','Mountain Range');

SELECT * FROM rangers

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(100) NOT NULL
);

INSERT INTO species(common_name,scientific_name,discovery_date,conservation_status) VALUES('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');

SELECT * FROM species;

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER NOT NULL REFERENCES "rangers"(ranger_id),
    species_id INTEGER NOT NULL REFERENCES "species"(species_id),
    sighting_time TIMESTAMP NOT NULL,
    "location" TEXT NOT NULL,
    notes TEXT

)

INSERT INTO sightings(species_id,ranger_id,"location",sighting_time,notes) VALUES (1,1,'Peak Ridge','2024-05-10 07:45:00','Camera trap image captured'),
(2,2,'Bankwood Area','2024-05-12 16:20:00','Juvenile seen'),
(3,3,'Bamboo Grove East','2024-05-15 09:10:00','Feeding observed'),
(1,2,'Snowfall Pass','2024-05-18 18:30:00',NULL)

SELECT * FROM sightings


-- Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers(name,region) VALUES('Derek Fox','Coastal Plains');

-- Count unique species ever sighted.

SELECT COUNT(DISTINCT common_name) as unique_species_count FROM species

-- Find all sightings where the location includes "Pass".

SELECT * FROM sightings WHERE "location" LIKE '%Pass%';

-- List each ranger's name and their total number of sightings.

SELECT "name", COUNT(*) AS total_sightings FROM sightings JOIN rangers USING(ranger_id) GROUP BY "name"

-- List species that have never been sighted.

SELECT s.common_name FROM species s LEFT JOIN sightings si ON s.species_id = si.species_id WHERE si.species_id IS NULL;

--Show the most recent 2 sightings.

SELECT s.common_name, si.sighting_time, r.name FROM sightings si JOIN species s ON si.species_id = s.species_id JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC LIMIT 2;

-- Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species SET conservation_status = 'Historic' WHERE discovery_date < '1800-01-01';

-- Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT 
  sighting_id,
  CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;

-- Delete rangers who have never sighted any species

DELETE FROM rangers WHERE ranger_id NOT IN (
  SELECT DISTINCT ranger_id FROM sightings
);

