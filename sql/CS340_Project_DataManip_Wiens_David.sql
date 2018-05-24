-- Class:       CS340 Intro to Databases
-- Name:        David Wiens
-- Description: Data Manipulation for the Project website backend


--
-- GARDENER QUERIES
--

-- Get all gardener data for populating a complete list
-- (also used for populating selection lists on ACCESS and WORKSHIFT pages)
SELECT id, fname, lname FROM gardener

-- Get single gardener data (for initializing gardener update page)
SELECT id, fname, lname FROM gardener WHERE id = [gardener_id]

-- Insert data for new gardener
INSERT INTO gardener (fname, lname) VALUES ([gardener_first_name],[gardener_last_name])

-- Update gardeners data, given gardener id
UPDATE gardener SET fname=[gardener_first_name], lname=[gardener_last_name] WHERE id=[gardener_id]

-- Delete Garderner (id from delete button)
DELETE FROM gardener WHERE id = [gardener_id]


--
-- SITE QUERIES
--

-- Get all SITE data for populating a complete list 
-- (also used for populating selection lists on ACCESS, WORKSHIFT, and GARDEN BED pages)
SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site

-- Get single SITE data (for initializing SITE update page)
SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site WHERE id = [site_id]

-- Insert data for new SITE
INSERT INTO site (name, length, width, addr_street, addr_city, addr_state, addr_zip) 
VALUES ([site_name],[site_length],[site_width],[site_addr_street],[site_addr_city],[site_addr_state],[site_addr_zip])

-- Update SITEs data, given SITE id
UPDATE site SET name=[site_name], length=[site_length], width=[site_width], addr_street=[site_addr_street], 
                addr_city=[site_addr_city], addr_state=[site_addr_state], addr_zip=[site_addr_zip] 
WHERE id=[site_id]

-- Delete SITE (id from delete button)
DELETE FROM site WHERE id = [site_id]



--
-- GARDERNER-SITE ACCESS QUERIES
--

-- Get all GARDERNER-SITE ACCESS data for populating a complete list, joining with `gardender` and `site`
SELECT GS.id, GS.gardener, GS.site, G.id AS gid, G.fname, G.lname,
                        S.id AS sid, S.name FROM `gardener_site` GS
                        INNER JOIN gardener G ON G.id = GS.gardener
                        INNER JOIN site S ON S.id = GS.site

-- Get single GARDERNER-SITE ACCESS data (for initializing access update page)
SELECT id, gardener, site FROM gardener_site WHERE id = [access_id]

-- Insert data for new GARDERNER-SITE ACCESS
INSERT INTO gardener_site (gardener, site) VALUES ([gardener_id],[site_id])

-- Update ACCESS's data, given ACCESS id
UPDATE gardener_site SET gardener=[gardener_id], site=[site_id] WHERE id=[access_id]

-- Delete GARDERNER-SITE ACCESS (id from delete button)
DELETE FROM gardener_site WHERE id = [access_id]