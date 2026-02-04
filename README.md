** Healthcare Analytics Project**

**SQL-Driven Healthcare Analytics & BI Reporting**

This project is a healthcare analytics solution built using PostgreSQL and Power BI. It focuses on transforming structured healthcare data into actionable operational, clinical, and financial insights through advanced SQL analysis and interactive dashboards.

The project simulates a real-world clinical and billing environment using prepared relational datasets covering patients, doctors, appointments, diagnoses, medications, and billing records.

As an operations data analyst, I designed this project to demonstrate practical, business-focused analytics skills — from relational schema usage and advanced SQL querying to decision-support dashboard development in Power BI.

 **Project Objectives**

This project demonstrates the ability to:

.Query and analyze relational healthcare datasets

.Apply advanced SQL techniques to business scenarios

.Generate operational and financial insights

.Translate reporting needs into analytical queries

.Build decision-support dashboards in Power BI

.Present insights in a stakeholder-friendly format

📁 Project Structure
Healthcare-Analytics/
├── SQL/
│   ├── schema.sql
│   ├── analysis_queries.sql
│   ├── billing_cte_analysis.sql
│   ├── additional_queries.sql
│
├── PowerBI/
│   ├── Doctors_Appointments.pbix
│   ├── Patients_Diagnoses.pbix
│   ├── Medication_Billing.pbix
│
└── README.md

 **Database Schema**

The analysis is built on six normalized tables:

.patients

.doctors

.appointments

.diagnoses

.medications

.billing

Together, they support multi-dimensional reporting across clinical activity, provider performance, and financial outcomes.

 **SQL Analytics Work**

The SQL layer includes 17 analytical queries covering operational, clinical, and billing intelligence.

Analysis areas include:

.Patient demographics and segmentation

.Appointment volume and trend analysis

.Doctor performance and revenue contribution

.Diagnosis frequency patterns

.Medication dosage analysis

.Insurance coverage behavior

.Hypertension incidence by age group

.Peak appointment days

.Most recent patient visits

.No-show rate analysis

Queries use production-style SQL patterns aligned with real reporting and decision-support needs.

💰 **Advanced Billing Analysis (CTE Pipeline)**

A multi-step Common Table Expression (CTE) pipeline was developed to model enterprise-style billing analysis.

Metrics calculated include:

.Total billed amounts

.Insurance coverage totals

.Patient payments

.Coverage percentages

.Final outstanding balances

**CTE Flow**

PatientTotals → aggregates billing metrics

Coverage → calculates coverage ratios

FinalBalance → computes outstanding balances

An optimized single-query version is also included to demonstrate query efficiency and alternative approaches.

📊 **Power BI Dashboard Suite**

SQL outputs were imported into Power BI to build a three-page interactive dashboard suite.

 **Doctors & Appointments Dashboard**

Focus: Operational performance

Includes:

.Total doctors, appointments, and revenue KPIs

.No-show rate tracking

.Doctor revenue rankings

.Clinic appointment volume comparison

.Peak appointment days

.Multi-diagnosis patient indicators

Supports staffing and scheduling decisions.

 **Patient & Diagnosis Dashboard**

Focus: Population health trends

Includes:

.Patient counts and location filters

.Diagnosis distribution

.Age-group hypertension analysis

.Most common diagnoses

.Latest appointment per patient

.Gender and month slicers

Supports demographic and clinical trend analysis.

 **Medication & Billing Dashboard**

Focus: Financial and medication insights

Includes:

.Total billing and insurance coverage KPIs

.High-dosage medication flags

.Diabetic patient medication tracking

.Top billing patients

.Insurance provider coverage comparisons

.Under-coverage risk indicators

Supports financial monitoring and cost-burden analysis.

🛠 **Skills Demonstrated**
SQL

.Multi-table joins

.Advanced aggregations

.CTE pipelines

.Window functions (RANK)

.CASE expressions

.Date/time analysis

.Financial calculations

.Query structuring for readability

.Power BI

.Multi-page dashboard design

.KPI reporting

.Interactive slicers and filters

.Analytical storytelling with visuals

.Clean metric layout and hierarchy

Project Scope Note:
The dataset used in this project was pre-structured. The primary focus was on analytical SQL querying, multi-table analysis, financial logic, and BI reporting rather than raw data cleaning and preprocessing.

🚀 **How to Use This Repository**

.Clone the repository

.Run the SQL scripts in PostgreSQL

.Generate the analytical result tables

.Load results into Power BI

.Open the .pbix files to explore the dashboards

🔮 **Future Enhancements**

-Add DAX measures for deeper Power BI modeling

-Introduce predictive models (e.g., no-show risk scoring)

-Redesign into a star schema for BI optimization

-Add stored procedures for automated reporting

-Expand healthcare KPI coverage

👤 **Author**

Josephine Namyalo
Data Analytics | SQL | Power BI | Operations & Healthcare Analytics
Focused on turning structured data into practical business insight and decision support.
