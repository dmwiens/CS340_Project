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
INSERT INTO gardener (fname, lname) VALUES ([gardener_first_name_from_form],[gardener_last_name_from_form])

-- Update gardeners data, given gardener id
UPDATE gardener SET fname=[gardener_first_name_from_update_form], lname=[gardener_last_name_from_update_form]
WHERE id=[gardener_id_from_update_button]

-- Delete Garderner (id from delete button)
DELETE FROM gardener WHERE id = [gardener_id_from_delete_button]


--
-- SITE QUERIES
--

-- Get all SITE data for populating a complete list 
-- (also used for populating selection lists on ACCESS, WORKSHIFT, and GARDEN BED pages)
SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site

-- Get single SITE data (for initializing SITE update page)
SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site WHERE id = [site_id_from_update_button]

-- Insert data for new SITE
INSERT INTO site (name, length, width, addr_street, addr_city, addr_state, addr_zip) 
VALUES ([site_name_from_form],[site_length_from_form],[site_width_from_form],[site_addr_street_from_form],
        [site_addr_city_from_form],[site_addr_state_from_form],[site_addr_zip_from_form])

-- Update SITEs data, given SITE id
UPDATE site SET name=[site_name_from_update_form], length=[site_length_from_update_form], width=[site_width_from_update_form],
                    addr_street=[site_addr_street_from_update_form], addr_city=[site_addr_city_from_update_form], 
                    addr_state=[site_addr_state_from_update_form], addr_zip=[site_addr_zip_from_update_form] 
WHERE id=[site_id_from_update_button]

-- Delete SITE (id from delete button)
DELETE FROM site WHERE id = [site_id_from_delete_button]



--
-- GARDERNER-SITE ACCESS QUERIES
--

-- Get all GARDERNER-SITE ACCESS data for populating a complete list, joining with `gardender` and `site`
SELECT GS.id, GS.gardener, GS.site, G.id AS gid, G.fname, G.lname,
                        S.id AS sid, S.name FROM `gardener_site` GS
                        INNER JOIN gardener G ON G.id = GS.gardener
                        INNER JOIN site S ON S.id = GS.site

-- Get single GARDERNER-SITE ACCESS data (for initializing access update page)
SELECT id, gardener, site FROM gardener_site WHERE id = [access_id_from_update_button]

-- Insert data for new GARDERNER-SITE ACCESS
INSERT INTO gardener_site (gardener, site) VALUES ([gardener_id_from_form],[site_id_from_form])

-- Update ACCESS's data, given ACCESS id
UPDATE gardener_site SET gardener=[gardener_id_from_update_form], site=[site_id_from_update_form] 
WHERE id=[access_id_from_update_button]

-- Delete GARDERNER-SITE ACCESS (id from delete button)
DELETE FROM gardener_site WHERE id = [access_id_from_delete_button]



--
-- WORKSHIFT QUERIES
--

-- Get all WORKSHIFT data for populating a complete list (inner joining with gardeners and sites)
SELECT W.id, W.gardener, W.site, DATE_FORMAT(W.date, "%Y-%m-%d") AS date, W.hours_worked,
                        G.id AS gid, G.fname, G.lname, S.id AS sid, S.name
                        FROM `workshift` W
                        INNER JOIN gardener G ON G.id = W.gardener
                        INNER JOIN site S ON S.id = W.site

-- Get single WORKSHIFT data (for initializing WORKSHIFT update page)
SELECT id, gardener, site, DATE_FORMAT(date, "%Y-%m-%d") AS date, hours_worked 
FROM workshift WHERE id = [workshift_id_from_update_button]

-- Insert data for new WORKSHIFT
INSERT INTO workshift (gardener, site, date, hours_worked) 
VALUES ([workshift_gardener_id_from_form],[workshift_site_id_from_form],
        [workshift_date_from_form],[workshift_hours_worked_from_form])

-- Update WORKSHIFTs data, given WORKSHIFT id
UPDATE workshift SET gardener=[workshift_gardener_id_from_update_form], site=[workshift_site_id_from_update_form], 
                    date=[workshift_date_from_update_form], hours_worked=[workshift_hours_worked_from_update_form]
WHERE id=[workshift_id_from_update_button]

-- Delete WORKSHIFTs (id from delete button)
DELETE FROM workshift WHERE id = [workshift_id_from_delete_button]


--
-- GARDEN BED QUERIES
--

-- Get all BED data for populating a complete list (inner joining with SITE)
SELECT B.id, B.name, B.site, S.name AS sname, B.length, B.width, B.location_x, B.location_y 
FROM bed B INNER JOIN site S ON B.site = S.id

-- Get single BED data (for initializing BED update page)
SELECT id, name, site, length, width, location_x, location_y 
FROM bed WHERE id = [bed_id_from_update_button]

-- Insert data for new BED
INSERT INTO bed (name, site, length, width, location_x, location_y) 
VALUES ([bed_name_from_form],[bed_site_from_form],[bed_length_from_form],[bed_width_from_form],
        [bed_location_x_from_form],[bed_location_y_from_form])

-- Update BEDs data, given BED id
UPDATE bed SET  name=[bed_name_from_update_form], site=[bed_site_from_update_form], 
                length=[bed_length_from_update_form], width=[bed_width_from_update_form], 
                location_x=[bed_location_x_from_update_form], location_y=[bed_location_y_from_update_form] 
WHERE id=[bed_id_from_update_button]

-- Delete BEDs (id from delete button)
DELETE FROM bed WHERE id = [bed_id_from_delete_button]



--
-- QUERIES SUPPORTING THE FILTERING of GARDEN BEDS BY SITE 
-- and DISPLAYING TOPVIEW GRAPHIC REPRESENTATION OF BEDS
--

SELECT B.id, B.name, B.site, S.name AS sname, B.length, B.width, B.location_x, B.location_y
FROM bed B INNER JOIN site S ON B.site = S.id WHERE B.site = [bed_id_selected_from_dropdown]


-- Note: other queries listed above for selecting all SITEs and selecting a single SITE were
--      used for this feature