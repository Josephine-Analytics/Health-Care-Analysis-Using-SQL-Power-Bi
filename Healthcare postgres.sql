CREATE TABLE Appointments (
appointment_id INT,	
patient_id BIGINT,	
doctor_id	BIGINT,
appointment_date date,	
status	VARCHAR,
visit_reason VARCHAR)
SELECT * FROM appointments;

CREATE TABLE billing (
bill_id	INT,
appointment_id INT,	
amount	NUMERIC,
insurance_covered NUMERIC,	
patient_paid NUMERIC
)
SELECT * FROM billing;

CREATE TABLE diagnoses (
diagnosis_id	INT,
appointment_id	INT,
diagnosis_code	VARCHAR,
diagnosis_description VARCHAR
)
SELECT * FROM diagnoses;

CREATE TABLE doctors (
doctor_id	INT,
doctor_name	VARCHAR,
specialty	VARCHAR,
clinic_location VARCHAR
) 
SELECT * FROM doctors;

CREATE TABLE medications (
med_id	INT,
patient_id	BIGINT,
medication_name	VARCHAR,
dosage VARCHAR,
start_date	DATE,
end_date DATE)
SELECT * FROM medications;

CREATE TABLE patients (
patient_id BIGINT,
first_name VARCHAR,
last_name	VARCHAR,
gender	CHAR,
date_of_birth	DATE,
city	VARCHAR,
insurance_provider VARCHAR)

SELECT CO

SELECT * FROM patients;

--1. List all patients who live in Seattle.--

SELECT CONCAT(first_name,' ',last_name)AS Full_name, city
FROM patients
WHERE city = 'Seattle';

--2. Find all medications where the dosage is greater than 50mg---

 SELECT medication_name, dosage
FROM medications
WHERE CAST(TRIM(REPLACE(dosage,'mg','')) AS INT) > 50
ORDER BY dosage DESC;
 
--3. Get all completed appointments in February 2025.--

SELECT * FROM appointments;
SELECT appointment_id, appointment_date
FROM appointments
WHERE status = 'Completed' AND appointment_date BETWEEN '2025-02-01' AND '2025-02-28';

 ---4. Show each doctor and how many appointments they completed.--

SELECT D.doctor_name,COUNT(A.appointment_id)AS Appointments
FROM doctors D
JOIN appointments A
ON A.doctor_id = D. doctor_id
WHERE status = 'Completed'
GROUP BY doctor_name
ORDER BY Appointments DESC;
 
---5. Find the most common diagnosis in the database.--
SELECT * FROM diagnoses;

SELECT COUNT(diagnosis_code) AS Total_diagnoses, diagnosis_description
FROM diagnoses
GROUP BY  diagnosis_description
ORDER BY Total_diagnoses DESC
LIMIT 5;


--6. List the total billing amount per patient.--

SELECT CONCAT(P.first_name,' ',P.last_name) AS Patients, SUM(B.amount) AS Total_billing_amount
FROM patients P
JOIN appointments A
ON P.patient_id = A.patient_id
JOIN billing B
ON B.appointment_id = A.appointment_id
GROUP BY Patients
ORDER BY Total_billing_amount DESC;

--7. Which clinic location has the highest number of appointments?--

SELECT D.clinic_location, COUNT(A.appointment_id) AS Appointments
FROM doctors D
JOIN appointments A
ON A.doctor_id = D.doctor_id
GROUP BY D.clinic_location
ORDER BY Appointments DESC
LIMIT 5;

SELECT * FROM appointments
---8. Identify patients who have more than one diagnosis in 2024.--

WITH Patient_diagnosis_count AS (

			SELECT CONCAT(P.first_name,' ',P.last_name)AS Patient_name, COUNT(D.diagnosis_code) AS Diagnosis
				FROM patients P
				JOIN appointments A
				ON A.patient_id = P.patient_id
				JOIN diagnoses D
				ON A.appointment_id= D.appointment_id
				WHERE EXTRACT(YEAR FROM appointment_date) = 2024
				GROUP BY Patient_name)
				
SELECT Patient_name, Diagnosis
FROM Patient_diagnosis_count 
WHERE Diagnosis > 1
ORDER BY Diagnosis DESC;

---OR---

SELECT CONCAT(P.first_name,' ',P.last_name)AS Patient_name, COUNT(D.diagnosis_code) AS Diagnosis
				FROM patients P
				JOIN appointments A
				ON A.patient_id = P.patient_id
				JOIN diagnoses D
				ON A.appointment_id= D.appointment_id
				WHERE EXTRACT(YEAR FROM appointment_date) = 2024
				GROUP BY Patient_name
HAVING COUNT(D.diagnosis_code)>1
ORDER BY Diagnosis DESC;

--9.Rank doctors by total revenue generated.
SELECT D.doctor_name, SUM(B.amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(B.amount) DESC) AS Revenue_rank
FROM doctors D
JOIN appointments A
ON D.doctor_id = A.doctor_id
JOIN billing B
ON A.appointment_id = B.appointment_id
GROUP BY D.doctor_name
ORDER BY total_revenue DESC;
 
--10.For each patient, show their most recent appointment.
SELECT 
    CONCAT(P.first_name, ' ', P.last_name) AS full_name,
    MAX(A.appointment_date) AS latest_appointment
FROM patients P
JOIN appointments A
    ON P.patient_id = A.patient_id
GROUP BY full_name
ORDER BY latest_appointment DESC;
				
---11. Identify patients whose insurance covered less than 70% of their bill.--

SELECT CONCAT(P.first_name,' ',last_name) AS Patients,
B.amount AS Total_bill, 
B.insurance_covered AS Insurance_paid, 
B.patient_paid AS Patient_paid, 
ROUND((B.insurance_covered/B.amount)*100,2)||'%'AS Covered_percentage
FROM patients P
JOIN appointments A
ON A.patient_id = P.patient_id
JOIN billing B
ON B.appointment_id = A.appointment_id
WHERE (B.insurance_covered/B.amount)<0.70
ORDER BY (B.insurance_covered/B.amount)*100 DESC;

--12. Identify all diabetic patients and list their last medication renewal date--

SELECT 
    CONCAT(P.first_name, ' ', P.last_name) AS patient_name,
    MAX(M.end_date) AS last_renewal
FROM patients P
JOIN appointments A
    ON P.patient_id = A.patient_id
JOIN diagnoses D
    ON A.appointment_id = D.appointment_id
JOIN medications M
    ON P.patient_id = M.patient_id
WHERE D.diagnosis_code LIKE 'E1%'   -- Diabetic patients
GROUP BY patient_name
ORDER BY last_renewal ASC;


--13. Which doctor has the lowest no‑show rate?-- 

SELECT
    D.doctor_id,
    D.doctor_name,
    COUNT(CASE WHEN A.status = 'No-show' THEN 1 END) AS no_show_count,
    COUNT(A.appointment_id) AS total_appointments,
    ROUND(
        COUNT(CASE WHEN A.status = 'No-show' THEN 1 END)::numeric
        / COUNT(A.appointment_id) * 100,
        2
    ) AS no_show_rate_percentage
FROM doctors D
JOIN appointments A
    ON D.doctor_id = A.doctor_id
GROUP BY D.doctor_id, D.doctor_name
ORDER BY no_show_rate_percentage ASC;


---14. Which age group has the highest incidence of hypertension (I10)?----
SELECT 
    CASE
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, P.date_of_birth)) < 18 THEN '0-17'
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, P.date_of_birth)) BETWEEN 18 AND 29 THEN '18-29'
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, P.date_of_birth)) BETWEEN 30 AND 39 THEN '30-39'
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, P.date_of_birth)) BETWEEN 40 AND 49 THEN '40-49'
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, P.date_of_birth)) BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
END AS age_group,
COUNT(*) AS incidence
FROM patients P
JOIN appointments A 
ON P.patient_id = A.patient_id
JOIN diagnoses D 
ON A.appointment_id = D.appointment_id
WHERE D.diagnosis_code = 'I10'
GROUP BY age_group
ORDER BY incidence DESC;

---OR---

WITH PatientAge AS (
    SELECT
        P.patient_id,
        EXTRACT(YEAR FROM age(CURRENT_DATE, P.date_of_birth)) AS age
    FROM patients P
)
SELECT 
    CASE
        WHEN age < 18 THEN '0-17'
        WHEN age BETWEEN 18 AND 29 THEN '18-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS incidence
FROM PatientAge PA
JOIN appointments A ON PA.patient_id = A.patient_id
JOIN diagnoses D ON A.appointment_id = D.appointment_id
WHERE D.diagnosis_code = 'I10'
GROUP BY age_group
ORDER BY incidence DESC;


---15. Which insurance provider covers the highest average amount?--

SELECT
    P.insurance_provider,
    ROUND(AVG(B.insurance_covered), 2) AS avg_amount_covered
FROM patients P
JOIN appointments A
    ON P.patient_id = A.patient_id
JOIN billing B
    ON B.appointment_id = A.appointment_id
GROUP BY P.insurance_provider
ORDER BY avg_amount_covered DESC;



---16. Determine peak days of the week for appointments.----
SELECT 
    TO_CHAR(appointment_date, 'Day') AS DayOfWeek,
    CASE WHEN EXTRACT(DOW FROM appointment_date) = 0 THEN 7 ELSE EXTRACT(DOW FROM appointment_date) END AS DayNumber,
    COUNT(*) AS TotalAppointments
FROM appointments
GROUP BY TO_CHAR(appointment_date, 'Day'), CASE WHEN EXTRACT(DOW FROM appointment_date) = 0 THEN 7 ELSE EXTRACT(DOW FROM appointment_date) END
ORDER BY DayNumber;



/*17. From this data set, write out 3 other queries based on what was taught in class but the 
queries should not be part of what has been asked already.*/

--a.most diagnosed conditions--

WITH DiagnosisCounts AS (
	SELECT 
		D.diagnosis_code,
		COUNT (*) AS Total_count
	FROM diagnoses D
	GROUP BY D.diagnosis_code
)
SELECT *
FROM DiagnosisCounts
ORDER BY Total_count DESC
LIMIT 5;

--d.Total bills,coverage,patient balance--
WITH PatientTotals AS (
	SELECT P.patient_id,
		   CONCAT(P.first_name,' ',P.last_name) AS Patient,
		   SUM(B.amount) AS Total_amount,
		   SUM(B.insurance_covered) AS Total_insurance,
		   SUM(B.patient_paid) AS Total_paid
	FROM patients P
	JOIN appointments A ON a.patient_id = P.patient_id
	JOIN billing B ON B.appointment_id = A.appointment_id
	GROUP BY P.patient_id, Patient
),
Coverage AS (
		 SELECT patient_id,
		 		Patient,
				Total_amount,
				Total_insurance,
				Total_paid,
			ROUND((Total_insurance/Total_amount)*100,2) AS Coverage_percentage
		FROM PatientTotals
		GROUP BY  patient_id, Patient
),
FinalBalance AS (
			 SELECT patient_id,
			 	    Patient,
					Total_amount,
					Total_insurance,
					Total_paid,
					Coverage_percentage,
					(Total_insurance-Total_amount-Total_paid) AS Balance_due
			FROM Coverage
)
SELECT * 
FROM FinalBalance
GROUP BY  patient_id, Patient
ORDER BY Balance_due DESC;

	SELECT P.patient_id,
		   CONCAT(P.first_name,' ',P.last_name) AS Patient,
		   SUM(B.amount) AS Total_amount,
		   SUM(B.insurance_covered) AS Total_insurance,
		   SUM(B.patient_paid) AS Total_paid,
	 ROUND(SUM(B.insurance_covered)/SUM(amount)*100,2) AS Coverage_percentage,
	 ROUND(SUM(B.amount)-SUM(B.insurance_covered)- SUM(B.patient_paid))AS Balance_due
	FROM patients P
	JOIN appointments A ON a.patient_id = P.patient_id
	JOIN billing B ON B.appointment_id = A.appointment_id
	GROUP BY P.patient_id, Patient
	HAVING SUM(B.amount) IS NOT NULL
	ORDER BY Balance_due DESC;


--b.paitients with the highest patient_paid amount--

WITH Paid AS (
    SELECT 
        P.patient_id,
        CONCAT(P.first_name, ' ', P.last_name) AS Patient,
        SUM(B.patient_paid) AS Total_Patient_Paid
    FROM patients P
    JOIN appointments A 
	ON P.patient_id = A.patient_id
    JOIN billing B 
	ON B.appointment_id = A.appointment_id
    GROUP BY P.patient_id, Patient
)
SELECT *
FROM Paid
ORDER BY Total_Patient_Paid DESC;

---c.Patients who paid more than insurance covered--

    SELECT 
        CONCAT(P.first_name, ' ', P.last_name) AS Patient,
        SUM(B.patient_paid) AS Total_Patient_Paid,
        SUM(B.insurance_covered) AS Total_Insurance_Paid
    FROM patients P
    JOIN appointments A ON P.patient_id = A.patient_id
    JOIN billing B ON B.appointment_id = A.appointment_id
    GROUP BY Patient

HAVING SUM(B.patient_paid)  >SUM(B.insurance_covered)
ORDER BY SUM(B.patient_paid) DESC;





