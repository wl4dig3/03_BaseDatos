-- LMD/DML = lenguaje de manipulación de datos.
-- Conectar a centro_comunitario antes de ejecutarlo.
-- Estos INSERT son repetibles gracias a ON CONFLICT DO NOTHING.
BEGIN; -- Agrupa datos de demostración.
INSERT INTO estados_reserva(id,nombre) VALUES (1,'Activa'),(2,'Cancelada') ON CONFLICT DO NOTHING; -- Estados fijos.
INSERT INTO solicitantes(nombre,correo) VALUES -- Personas ficticias.
 ('Camila Torres','camila.ejemplo@correo.test'), -- Datos de ejemplo, no reales.
 ('Felipe Rojas','felipe.ejemplo@correo.test'), -- Segunda persona.
 ('Daniela Pérez','daniela.ejemplo@correo.test') -- Tercera persona.
 ON CONFLICT (correo) DO NOTHING; -- Evita duplicados al reejecutar.
INSERT INTO salas(nombre,capacidad,activa) VALUES -- Espacios de centro comunitario.
 ('Sala de reuniones',12,TRUE), -- Sala pequeña.
 ('Salón multiuso',80,TRUE), -- Sala de mayor aforo.
 ('Laboratorio digital',24,TRUE) -- Espacio computacional.
 ON CONFLICT (nombre) DO NOTHING; -- Evita repeticiones.
INSERT INTO equipamientos(nombre,stock) VALUES -- Inventario total.
 ('Proyector',3), -- Tres proyectores.
 ('Notebook',15), -- Quince equipos.
 ('Micrófono',8) -- Ocho micrófonos.
 ON CONFLICT (nombre) DO NOTHING; -- Permite ejecución repetida.
COMMIT; -- Publica cambios.
