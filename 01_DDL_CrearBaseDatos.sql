-- PostgreSQL: LDD/DDL = lenguaje de definición de datos.
-- Ejecutar conectado a la base postgres en DBeaver, con autocommit.
-- No volver a ejecutar si ya existe la base de datos.
-- Este script debe ejecutarse SEPARADAMENTE: CREATE DATABASE no admite bloque transaccional.
CREATE DATABASE centro_comunitario
    WITH ENCODING = 'UTF8'
         TEMPLATE = template0;
-- En DBeaver: crear una conexión nueva a la base centro_comunitario,
-- o cambiar la base activa ANTES de ejecutar el siguiente archivo.
