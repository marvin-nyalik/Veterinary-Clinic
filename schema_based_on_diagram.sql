CREATE DATABASE clinic;
\c clinic;

CREATE TABLE patients(
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150),
    date_of_birth date
);

CREATE TABLE medical_histories(
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    admitted_at timestamp,
    patient_id integer,
    status VARCHAR(50),
    CONSTRAINT fk_patient FOREIGN KEY(patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

CREATE TABLE invoices (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    total_amount decimal(10, 2),
    generated_at timestamp,
    payed_at timestamp,
    medical_history_id integer,
    CONSTRAINT fk_medical_history FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id) ON DELETE CASCADE
);


