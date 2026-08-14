SELECT *
FROM prescriber;



SELECT * 
FROM prescription;



SELECT total_claim_count, drug_name
FROM prescription
ORDER BY total_claim_count DESC;



SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC;


  
SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC
LIMIT 1;


SELECT  prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, 
prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescription INNER JOIN prescriber ON prescription.npi = prescriber.npi 
GROUP BY prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name, 
prescriber.specialty_description
ORDER BY total_claims DESC;




SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescription INNER JOIN prescriber ON prescription.npi = prescriber.npi 
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC;



SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescription INNER JOIN prescriber ON prescription.npi = prescriber.npi 
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC
LIMIT 1;



SELECT drug.drug_name,prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescription INNER JOIN prescriber ON prescription.npi = prescriber.npi
                  INNER JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY prescriber.specialty_description, drug.drug_name
ORDER BY total_claims DESC;



SELECT opioid_drug_flag, prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescription INNER JOIN prescriber ON prescription.npi = prescriber.npi
                  INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE drug.opioid_drug_flag = 'Y'				  
GROUP BY prescriber.specialty_description, opioid_drug_flag,  prescription.total_claim_count
ORDER BY prescription.total_claim_count DESC;




SELECT DISTINCT prescriber.specialty_description
FROM prescriber LEFT JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescription.npi IS NULL;











SELECT generic_name, SUM(prescription.total_drug_cost) AS total_drug_cost
FROM drug INNER JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY drug.generic_name
ORDER BY total_drug_cost DESC;



SELECT DISTINCT drug.generic_name, ROUND(SUM(prescription.total_drug_cost)/SUM( prescription.total_day_supply),2) AS cost_per_day
FROM drug INNER JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY DISTINCT drug.generic_name, prescription.total_day_supply
ORDER BY cost_per_day DESC;




SELECT drug_name,
       CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	        WHEN antibiotic_drug_flag = 'Y' THEN  'antibiotic' ELSE 'neither' END AS drug_type
FROM drug;



SELECT '$' || ROUND(SUM(prescription.total_drug_cost),2), drug.opioid_drug_flag, drug.antibiotic_drug_flag, drug.drug_name,
      CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	        WHEN antibiotic_drug_flag = 'Y' THEN  'antibiotic' ELSE 'neither' END AS drug_type
FROM drug INNER JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY drug.drug_name, prescription.total_drug_cost, opioid_drug_flag, antibiotic_drug_flag
ORDER BY drug_type DESC;
       



SELECT 
    CASE WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
         WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic' ELSE 'neither' END AS drug_type,
    '$' || ROUND(SUM(prescription.total_drug_cost), 2) AS total_cost
FROM drug INNER JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY 
    CASE WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
         WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic' ELSE 'neither' END
ORDER BY total_cost DESC;





