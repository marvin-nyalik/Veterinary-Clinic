/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name like '%mon';
SELECT * FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT after_2022;

UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO after_2022;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;

SELECT
    CASE
        WHEN SUM(escape_attempts) FILTER (WHERE neutered = true) > SUM(escape_attempts) FILTER (WHERE neutered = false) THEN 'Neutered'
        ELSE 'Not Neutered'
    END AS escaping_most
FROM animals;

SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts)
FROM animals
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000
GROUP BY species;

SELECT animals.name, owners.full_name
FROM animals
INNER JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

SELECT animals.name, species.name
FROM animals
INNER JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

SELECT *
FROM owners
LEFT JOIN animals
ON owners.id = animals.owner_id;

SELECT species.name, COUNT(*)
FROM animals
INNER JOIN species
ON animals.species_id = species.id
GROUP BY species.name;


SELECT animals.name, species.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id 
INNER JOIN species ON species.id = animals.species_id
WHERE owners.full_name = 'Jennifer Orwell' 
AND species.name = 'Digimon';

SELECT animals.name, owners.full_name, animals.escape_attempts 
FROM animals
INNER JOIN owners ON owners.id = animals.owner_id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.id) AS num_animals
FROM owners
JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id
ORDER BY num_animals DESC
LIMIT 1;

SELECT animals.name 
FROM visits
INNER JOIN animals ON animals.id = visits.animal_id
INNER JOIN vets ON vets.id = visits.vet_id
WHERE vets.id = 1
AND visit_date = (SELECT MAX(visit_date) FROM visits WHERE vet_id = 1);

SELECT COUNT(DISTINCT animal_id)
FROM visits 
INNER JOIN vets
ON vets.id = visits.vet_id
INNER JOIN animals ON animals.id = visits.animal_id
WHERE vets.name = 'Stephanie Mendez';


SELECT vets.id, vets.name AS vet_name, species.name AS specialty
FROM vets 
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

SELECT animals.name AS animal_name
FROM animals
INNER JOIN visits ON animals.id = visits.animal_id
INNER JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

SELECT animals.name AS animal_name, COUNT(visits.animal_id) AS visit_count
FROM animals
LEFT JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.id, animals.name
ORDER BY visit_count DESC
LIMIT 1;

SELECT animals.name
FROM vets
INNER JOIN visits ON vets.id = visits.vet_id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.visit_date ASC
LIMIT 1;

SELECT animals.name AS animal_name, vets.name AS vet_name, visits.visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.visit_date DESC
LIMIT 1;

SELECT COUNT(*)
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
LEFT JOIN specializations ON (vets.id = specializations.vet_id AND animals.species_id = specializations.species_id)
WHERE specializations.species_id IS NULL;

SELECT species.name AS suggested_specialty, COUNT(visits.animal_id) AS visit_count
FROM species
INNER JOIN specializations ON species.id = specializations.species_id
INNER JOIN vets ON specializations.vet_id = vets.id
INNER JOIN visits ON specializations.vet_id = visits.vet_id AND visits.animal_id IN (
    SELECT animal_id
    FROM visits
    INNER JOIN vets ON visits.vet_id = vets.id
    WHERE vets.name = 'Maisy Smith'
)
GROUP BY species.id, species.name
ORDER BY visit_count DESC
LIMIT 1;

EXPLAIN ANALYZE SELECT * FROM visits 
WHERE vet_id = 2;

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits 
WHERE animal_id = 4;