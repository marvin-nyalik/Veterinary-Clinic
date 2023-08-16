/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;
\c vet_clinic;

CREATE TABLE animals(
id INT GENERATED BY DEFAULT AS IDENTITY,
name VARCHAR(50) NOT NULL,
date_of_birth date,
escape_attempts INT,
neutered boolean,
weight_kg decimal(4,2));

ALTER TABLE animals ADD COLUMN species varchar(50);

CREATE TABLE owners (
id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
full_name VARCHAR(255),
age integer
);

CREATE TABLE species(
id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name VARCHAR(255)
);

ALTER TABLE animals
DROP COLUMN species,
ADD COLUMN species_id integer,
ADD COLUMN owner_id integer,
ADD CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_owner FOREIGN KEY(owner_id) REFERENCES owners(id) ON DELETE CASCADE;

CREATE TABLE vets (
  id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  age integer,
  date_of_graduation date
);

CREATE TABLE specializations (
  species_id integer,
  vet_id integer,
  CONSTRAINT species_fk FOREIGN KEY (species_id) REFERENCES species(id) ON DELETE CASCADE,
  CONSTRAINT vets_fk FOREIGN KEY (vet_id) REFERENCES vets(id) ON DELETE CASCADE
);

CREATE TABLE visits (
    animal_id integer,
    vet_id integer,
    visit_date date,
    CONSTRAINT animals_fk FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE,
    CONSTRAINT vets_fk FOREIGN KEY (vet_id) REFERENCES vets(id) ON DELETE CASCADE
);

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
