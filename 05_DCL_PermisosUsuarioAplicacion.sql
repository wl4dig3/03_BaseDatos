-- ============================================================================
-- PRO205 | Semana 9 | Centro Comunitario
-- 05_DCL_PermisosUsuarioAplicacion.sql
-- OBJETIVO: Conceder a pro205_app los permisos requeridos
-- para ejecutar las aplicaciones Windows Forms C# y VB.NET.
-- EJECUTAR: en DBeaver conectado a centro_comunitario con usuario administrador
-- (por ejemplo postgres), DESPUÉS de 02_DDL_CrearTablas.sql.
-- NO copiar delimitadores Markdown como ```sql ni ``` al editor SQL.
-- Este script NO crea usuarios, NO establece contraseñas y NO altera datos.
-- ============================================================================

-- Verificar que estamos en la base requerida (evita GRANT en postgres).
DO $$
BEGIN
    IF current_database() <> 'centro_comunitario' THEN
        RAISE EXCEPTION 'Base incorrecta: %. Conéctese a centro_comunitario.', current_database();
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'pro205_app') THEN
        RAISE EXCEPTION 'No existe el rol pro205_app. Créelo primero con una contraseña segura.';
    END IF;
    IF EXISTS (
        SELECT 1 FROM (VALUES
            ('solicitantes'), ('salas'), ('equipamientos'),
            ('estados_reserva'), ('reservas'), ('reserva_equipamientos')
        ) AS t(nombre)
        WHERE to_regclass('public.' || t.nombre) IS NULL
    ) THEN
        RAISE EXCEPTION 'Faltan tablas. Ejecute antes 02_DDL_CrearTablas.sql.';
    END IF;
END $$;

-- Los permisos se aplican como una unidad.
BEGIN;

-- Permitir iniciar sesión en la base específica.
GRANT CONNECT ON DATABASE centro_comunitario TO pro205_app;

-- Permitir localizar objetos del esquema public.
GRANT USAGE ON SCHEMA public TO pro205_app;

-- Lectura de catálogos, información de salas y listado de reservas.
GRANT SELECT ON TABLE
    public.solicitantes,
    public.salas,
    public.equipamientos,
    public.estados_reserva,
    public.reservas,
    public.reserva_equipamientos
TO pro205_app;

-- La aplicación puede crear reservas y registrar los equipos solicitados.
GRANT INSERT ON TABLE public.reservas, public.reserva_equipamientos TO pro205_app;

-- Cancelar reservas cambia estado_id mediante UPDATE.
GRANT UPDATE ON TABLE public.reservas TO pro205_app;

-- PostgreSQL requiere privilegio UPDATE para SELECT ... FOR UPDATE.
-- El repositorio bloquea filas de salas y equipamientos al crear reservas.
-- NOTA DE SEGURIDAD: estos permisos también permitirían UPDATE directo
-- sobre las tablas; en producción preferir roles/funciones más restrictivos.
GRANT UPDATE ON TABLE public.salas, public.equipamientos TO pro205_app;

-- Para columnas GENERATED AS IDENTITY y otras secuencias vinculadas.
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO pro205_app;

COMMIT;

-- ============================================================================
-- VERIFICACIÓN (ejecutar una vez aplicados los permisos)
-- true en todas las columnas indica que las operaciones esperadas están
-- autorizadas. El SELECT no prueba una conexión real con las credenciales.
-- ============================================================================
SELECT
    has_database_privilege('pro205_app', 'centro_comunitario', 'CONNECT') AS conectar,
    has_schema_privilege('pro205_app', 'public', 'USAGE') AS usar_esquema,
    has_table_privilege('pro205_app', 'public.salas', 'SELECT') AS leer_salas,
    has_table_privilege('pro205_app', 'public.solicitantes', 'SELECT') AS leer_solicitantes,
    has_table_privilege('pro205_app', 'public.equipamientos', 'SELECT') AS leer_equipamientos,
    has_table_privilege('pro205_app', 'public.estados_reserva', 'SELECT') AS leer_estados,
    has_table_privilege('pro205_app', 'public.reservas', 'SELECT') AS leer_reservas,
    has_table_privilege('pro205_app', 'public.reserva_equipamientos', 'SELECT') AS leer_reserva_equipos,
    has_table_privilege('pro205_app', 'public.reservas', 'INSERT') AS insertar_reservas,
    has_table_privilege('pro205_app', 'public.reserva_equipamientos', 'INSERT') AS insertar_reserva_equipos,
    has_table_privilege('pro205_app', 'public.reservas', 'UPDATE') AS actualizar_reservas,
    has_table_privilege('pro205_app', 'public.salas', 'UPDATE') AS bloquear_salas,
    has_table_privilege('pro205_app', 'public.equipamientos', 'UPDATE') AS bloquear_equipamientos;
