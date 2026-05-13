-- i. Clientes cuyo nombre empiece con la letra R.
SELECT * FROM Cliente 
WHERE Nombre LIKE 'R%';


-- ii. Medicamentos que hayan caducado después del 20 de abril del 2026 pero antes del 07 de mayo del 2026.
-- Medicamentos comerciales caducados
SELECT 
    mc.NombreComercial, 
    emc.FechaCaducidad
FROM EntregarMedComercial emc
JOIN MedComercial mc ON emc.IdMedicamento = mc.IdMedicamento
WHERE emc.FechaCaducidad > '2026-04-20' 
  AND emc.FechaCaducidad < '2026-05-07';

--Medicamentos preparados caducados por los insumos caducaron en esa fecha
SELECT
    mp.NombreComercial,
    ei.FechaCaducidad
FROM MedPreparado mp
JOIN Contener c ON mp.IdMedicamento = c.IdMedicamento
JOIN EntregarInsumo ei ON c.IdInsumo = ei.IdInsumo
WHERE ei.FechaCaducidad > '2026-04-20' 
  AND ei.FechaCaducidad < '2026-05-07';


-- iii. Farmacéuticos que hayan nacido en el mes de noviembre.
SELECT * FROM Farmaceutico 
WHERE EXTRACT(MONTH FROM FechaNacimiento) = 11;


--iv. Medicamentos cuya forma física sea gel y vía de administración sea oral.
-- Para los Medicamentos Comerciales
SELECT * FROM MedComercial 
WHERE FormaFarmaceutica = 'Gel' AND ViaAdministracion = 'Oral';

-- Para las Fórmulas Magistrales (Medicamentos Preparados)
SELECT * FROM MedPreparado 
WHERE FormaFarmaceutica = 'Gel' AND ViaAdministracion = 'Oral';


-- v. Todos los proveedores registrados en la base de datos. 
SELECT * FROM Proveedor;

-- =================================================================
--                CONSULTAS PRACTICA 09 
-- =================================================================

-- xi.Listar a los vendedores cuyo total de medicamentos vendidos (número de productos distintos que ofrecen) sea mayor a 3.

SELECT 
    caj.RFC,
    caj.Nombre || ' ' || caj.Paterno || ' ' || caj.Materno AS NombreCompleto,
    COUNT(DISTINCT tmcm.IdMedicamento) + COUNT(DISTINCT tmp.IdMedicamento) AS TotalProductosDistintos,
    SUM(COALESCE(tmcm.CantidadComprada, 0) + COALESCE(tmp.CantidadComprada, 0)) AS TotalUnidadesVendidas
FROM Cajero caj
INNER JOIN Ticket t ON caj.IdSucursal = t.IdSucursal
LEFT JOIN TenerMedComercial tmcm ON t.FolioTicket = tmcm.FolioTicket
LEFT JOIN TenerMedPreparado tmp ON t.FolioTicket = tmp.FolioTicket
GROUP BY caj.RFC, caj.Nombre, caj.Paterno, caj.Materno
HAVING COUNT(DISTINCT tmcm.IdMedicamento) + COUNT(DISTINCT tmp.IdMedicamento) > 3
ORDER BY TotalProductosDistintos DESC;

