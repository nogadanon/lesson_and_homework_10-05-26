-- 1:1+

-- Create a patients table with: patient_id (PK AUTOINCREMENT), patient_name, blood_type.
CREATE TABLE patients (
patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
patient_name TEXT,
blood_type TEXT
);

-- Create a medical_files table with: file_id (PK AUTOINCREMENT), patient_ref (UNIQUE FK to patients(patient_id)), allergies, emergency_contact.
CREATE TABLE medical_files (
file_id INTEGER PRIMARY KEY AUTOINCREMENT,
patient_ref UNIQUE, --+ INTEGER
allergies TEXT,
emergency_contact TEXT,
FOREIGN KEY (patient_ref) REFERENCES patients(patient_id) ON DELETE CASCADE
);

-- Insert 3 patients: Dr. Aisha Khan (O+), Marcus Williams (AB-), Dr. Priya Singh (B+).
INSERT INTO patients (patient_name, blood_type)
VALUES ('Dr. Aisha Khan', 'O+'),
('Marcus Williams', 'AB-'),
('Dr. Priya Singh', 'B+');

-- Insert 2 medical files: Aisha (allergies: Penicillin, contact: +1-555-0101) and Marcus (allergies: None, contact: +1-555-0202). Leave Priya without a file.
INSERT INTO medical_files (patient_ref, allergies, emergency_contact)
VALUES (1, 'Penicillin', '+1-555-0101'),
(2, NULL, '+1-555-0202');

-- Write a LEFT JOIN query to list all patients and their file data — displaying 'No medical history' for those without a file.
SELECT * , COALESCE(patient_ref, 'No medical history')
FROM patients p LEFT JOIN medical_files m ON p.patient_id = m.patient_ref;

-- Try adding a second file for the same patient_ref. Explain the error.
INSERT INTO medical_files (patient_ref, allergies, emergency_contact)
VALUES (2, 'Penicillin', '+1-222-2222');
--- ANSWR: error: 'UNIQUE constraint failed: medical_files.patient_ref'

-- Delete a patient (who has a medical file). Then query the medical_files table. What happened to their file? Why?
DELETE FROM patients
WHERE patient_id = 1;
