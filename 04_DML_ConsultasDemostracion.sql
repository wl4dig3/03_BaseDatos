-- Consultas de apoyo docente; ejecutar sobre centro_comunitario.
SELECT * FROM solicitantes ORDER BY id; -- Verificar catálogo personas.
SELECT * FROM salas ORDER BY id; -- Verificar salas/capacidad.
SELECT * FROM equipamientos ORDER BY id; -- Verificar stock.
SELECT * FROM estados_reserva ORDER BY id; -- Verificar estados.
SELECT r.id, p.nombre AS solicitante, s.nombre AS sala, r.inicio, r.fin, er.nombre AS estado -- Vista de reservas.
FROM reservas r -- Tabla central.
JOIN solicitantes p ON p.id = r.solicitante_id -- Persona.
JOIN salas s ON s.id = r.sala_id -- Sala.
JOIN estados_reserva er ON er.id = r.estado_id -- Estado.
ORDER BY r.inicio DESC; -- Ordenar últimas primero.
SELECT r.id, e.nombre AS equipo, re.cantidad FROM reserva_equipamientos re -- Tabla puente.
JOIN reservas r ON r.id=re.reserva_id -- Reserva relacionada.
JOIN equipamientos e ON e.id=re.equipamiento_id -- Equipo relacionado.
ORDER BY r.id; -- Orden didáctico.
-- Ejercicio seguro de actualización manual: usa una ID existente, dentro de una transacción.
-- BEGIN; UPDATE reservas SET estado_id=2 WHERE id=1; ROLLBACK;
