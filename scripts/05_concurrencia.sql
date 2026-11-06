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

