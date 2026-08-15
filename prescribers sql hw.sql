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



SELECT prescriber.specialty_description, SUM(CASE WHEN drug.opioid_drug_flag = 'Y' THEN prescription.total_claim_count ELSE 0 END) AS opioid_claims,
    SUM(prescription.total_claim_count) AS total_claims, ROUND(SUM(CASE WHEN drug.opioid_drug_flag = 'Y' 
                 THEN prescription.total_claim_count ELSE 0 END) * 1.0 / SUM(prescription.total_claim_count) * 100, 2) AS opioid_percentage
FROM prescriber INNER JOIN prescription ON prescriber.npi = prescription.npi
                INNER JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY prescriber.specialty_description
ORDER BY opioid_percentage DESC;




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




SELECT cbsa.cbsaname, fips_county.state
FROM cbsa INNER JOIN fips_county ON cbsa.fipscounty = fips_county.fipscounty
WHERE state = 'TN';



SELECT COUNT(DISTINCT cbsa)
FROM cbsa INNER JOIN fips_county ON cbsa.fipscounty = fips_county.fipscounty
WHERE state = 'TN';





SELECT cbsa.cbsaname, SUM(population.population)
FROM cbsa LEFT JOIN population ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsaname, population.population
ORDER BY population.population DESC;




SELECT cbsa.cbsaname, SUM(population.population) AS total_pop
FROM cbsa LEFT JOIN population ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsaname, population.population
ORDER BY population.population;



SELECT population.fipscounty, population.population, fips_county.county, cbsa.cbsa
FROM population LEFT JOIN cbsa ON population.fipscounty = cbsa.fipscounty
                LEFT JOIN fips_county ON population.fipscounty= fips_county.fipscounty
WHERE cbsa.cbsa IS NULL 
ORDER BY population.population;




SELECT prescription.drug_name, prescription.total_claim_count
FROM prescription
WHERE prescription.total_claim_count >= 3000
ORDER BY prescription.total_claim_count DESC;



SELECT prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag
FROM prescription
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count >= 3000
ORDER BY prescription.total_claim_count DESC;



SELECT prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag, 
       prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name
FROM prescription INNER JOIN drug ON prescription.drug_name = drug.drug_name
                  INNER JOIN prescriber ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count >= 3000
ORDER BY prescription.total_claim_count DESC;



SELECT prescriber.npi, drug.drug_name
FROM prescriber CROSS JOIN drug
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y'
ORDER BY prescriber.npi, drug.drug_name;



SELECT prescriber.npi, drug.drug_name, prescription.total_claim_count
FROM prescriber CROSS JOIN drug
                LEFT JOIN prescription ON prescriber.npi = prescription.npi AND drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y'
ORDER BY prescriber.npi, drug.drug_name;




SELECT
    prescriber.npi,
    drug.drug_name,
    COALESCE(prescription.total_claim_count, 0) AS total_claim_count
FROM prescriber CROSS JOIN drug
                LEFT JOIN prescription ON prescriber.npi = prescription.npi
                AND drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y'
ORDER BY prescriber.npi, drug.drug_name;


