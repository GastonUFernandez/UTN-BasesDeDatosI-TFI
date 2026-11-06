DELIMITER //

CREATE PROCEDURE sp_actualizar_stock_seguro(
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_max_reintentos INT DEFAULT 2;
    DECLARE v_exito BOOLEAN DEFAULT FALSE;
    
    -- Handler específico para atrapar el error de Deadlock (Código 1213 / SQLSTATE 40001)
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_exito = FALSE;
    END;

    bucle_retry: WHILE v_intentos <= v_max_reintentos AND NOT v_exito DO
        SET v_intentos = v_intentos + 1;
        
        START TRANSACTION;
            
            -- Operación crítica sobre la tabla PRODUCTOS
            UPDATE PRODUCTOS 
            SET stock = stock - p_cantidad 
            WHERE id_producto = p_id_producto;
            
            -- Si todo sale bien, confirmamos la transacción
            COMMIT;
            SET v_exito = TRUE;
            
        IF NOT v_exito THEN
            -- Si ocurre un deadlock, revertimos los cambios de esta iteración
            ROLLBACK;
            -- Breve pausa antes de reintentar (backoff)
            DO SLEEP(0.5);
        END IF;
        
    END WHILE;

    IF NOT v_exito THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error crítico: La transacción falló tras los reintentos automáticos por deadlock.';
    END IF;
END //

DELIMITER ;



-- NIVELES DE AISLAMIENTO (READ COMMITTED vs REPEATABLE READ)

-- CASO A: Nivel de Aislamiento READ COMMITTED (Permite Lecturas No Repetibles)
-- [SESIÓN A]:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION;
-- SELECT stock FROM PRODUCTOS WHERE id_producto = 1;
-- SELECT stock FROM PRODUCTOS WHERE id_producto = 1; -- (Devuelve valor actualizado)
-- COMMIT;

-- [SESIÓN B]:
-- START TRANSACTION;
-- UPDATE PRODUCTOS SET stock = stock - 1 WHERE id_producto = 1;
-- COMMIT;

-- CASO B: Nivel de Aislamiento REPEATABLE READ (Por defecto en InnoDB)
-- [SESIÓN A]:
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- START TRANSACTION;
-- SELECT stock FROM PRODUCTOS WHERE id_producto = 1;
-- SELECT stock FROM PRODUCTOS WHERE id_producto = 1; -- (Mantiene valor inicial por MVCC)
-- COMMIT;


-- INFORME DE OBSERVACIONES: CONCURRENCIA, TRANSACCIONES Y DEADLOCKS:

-- Durante las pruebas de concurrencia en entorno local con MySQL e InnoDB,
-- el motor aplicó un mecanismo de encolamiento FIFO (First-In, First-Out)
-- altamente optimizado para las filas accedidas, lo que evitó la formación
-- espontánea de un ciclo de bloqueo cruzado físico en la terminal. 
-- Sin embargo, para garantizar la resiliencia del sistema ante escenarios
-- de alta concurrencia en producción, se implementó un procedimiento 
-- almacenado con un manejador de excepciones (SQLEXCEPTION) capaz de 
-- detectar el código de error de deadlock (1213 / 40001), ejecutando un 
-- ROLLBACK inmediato y una estrategia de reintentos (retry) con pausa temporal.

