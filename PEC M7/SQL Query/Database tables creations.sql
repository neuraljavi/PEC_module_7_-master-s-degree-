CREATE SCHEMA `pec`;

use pec;

CREATE TABLE `pec`.`raw_data` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha_creacion` DATETIME NULL,
  `numero de incidencia` VARCHAR(45) NULL,
  `descripcion` TEXT NULL,
  `servicio` VARCHAR(45) NULL,
  `tipo_servicio` VARCHAR(45) NULL,
  `prioridad` VARCHAR(45) NULL,
  `estado` VARCHAR(45) NULL,
  `torre` VARCHAR(45) NULL,
  `entorno` VARCHAR(100) NULL,
  `estado_cumplimiento_sla` VARCHAR(45) NULL,
  `duracion_dias` DECIMAL(30,25) NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `d_estado` (
  `id_estado` int(11) NOT NULL,
  `estado` varchar(45) NOT NULL,
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_sla` (
  `id_sla` int(11) NOT NULL AUTO_INCREMENT,
  `sla` varchar(45) NOT NULL,
  PRIMARY KEY (`id_sla`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_estado_sla` (
  `id_estado_sla` int(11) NOT NULL AUTO_INCREMENT,
  `id_estado` int(11) DEFAULT NULL,
  `id_sla` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_estado_sla`),
  KEY `id_estado_idx` (`id_estado`),
  KEY `id_sla_idx` (`id_sla`),
  CONSTRAINT `id_estado` FOREIGN KEY (`id_estado`) REFERENCES `d_estado` (`id_estado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_sla` FOREIGN KEY (`id_sla`) REFERENCES `d_sla` (`id_sla`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_tipo_servicio` (
  `id_tipo_servicio` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_servicio` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_servicio` (
  `id_servicio` int(11) NOT NULL AUTO_INCREMENT,
  `servicio` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_servicio_tipo` (
  `id_servicio_tipo` int(11) NOT NULL AUTO_INCREMENT,
  `fk_servicio` int(11) DEFAULT NULL,
  `fk_tipo_servicio` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_servicio_tipo`),
  KEY `id_tipo_servicio_idx` (`fk_tipo_servicio`),
  KEY `id_servicio_idx` (`fk_servicio`),
  CONSTRAINT `id_servicio` FOREIGN KEY (`fk_servicio`) REFERENCES `d_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_tipo_servicio` FOREIGN KEY (`fk_tipo_servicio`) REFERENCES `d_tipo_servicio` (`id_tipo_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_torre` (
  `id_torre` int(11) NOT NULL AUTO_INCREMENT,
  `torre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_torre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_torre_servicio` (
  `id_torre_servicio` int(11) NOT NULL AUTO_INCREMENT,
  `fk_servicio_tipo` int(11) DEFAULT NULL,
  `fk_torre` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_torre_servicio`),
  KEY `id_torre_idx` (`fk_torre`),
  KEY `id_servicio_idx` (`fk_servicio_tipo`),
  CONSTRAINT `id_servicio_tipo` FOREIGN KEY (`fk_servicio_tipo`) REFERENCES `d_servicio_tipo` (`id_servicio_tipo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_torre` FOREIGN KEY (`fk_torre`) REFERENCES `d_torre` (`id_torre`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_entorno` (
  `id_entorno` int(11) NOT NULL AUTO_INCREMENT,
  `entorno` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_entorno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `d_prioridad` (
  `id_prioridad` int(11) NOT NULL AUTO_INCREMENT,
  `prioridad` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_prioridad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `f_incidencias` (
  `id_incidencias` int(11) NOT NULL AUTO_INCREMENT,
  `n_incidencia` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT NULL,
  `duracion_dias` decimal(30,25) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fk_torre_servicio` int(11) DEFAULT NULL,
  `fk_estado_sla` int(11) DEFAULT NULL,
  `fk_prioridad` int(11) DEFAULT NULL,
  `fk_entorno` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_incidencias`),
  KEY `id_torre_idx` (`fk_torre_servicio`),
  KEY `id_estado_idx` (`fk_estado_sla`),
  KEY `fk_prioridad_idx` (`fk_prioridad`),
  KEY `fk_entorno_idx` (`fk_entorno`),
  CONSTRAINT `fk_entorno` FOREIGN KEY (`fk_entorno`) REFERENCES `d_entorno` (`id_entorno`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_estado` FOREIGN KEY (`fk_estado_sla`) REFERENCES `d_estado_sla` (`id_estado_sla`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_prioridad` FOREIGN KEY (`fk_prioridad`) REFERENCES `d_prioridad` (`id_prioridad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_torre` FOREIGN KEY (`fk_torre_servicio`) REFERENCES `d_torre_servicio` (`id_torre_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Desactivar la restricción
ALTER TABLE f_incidencias DROP FOREIGN KEY fk_estado;
-- Desactivar la restricción
ALTER TABLE d_estado_sla DROP FOREIGN KEY id_estado;

-- Truncar la tabla d_estado
TRUNCATE TABLE d_estado;

-- Truncar la tabla d_estado
TRUNCATE TABLE d_estado;


-- Volver a activar la restricción
ALTER TABLE d_estado_sla ADD CONSTRAINT id_estado FOREIGN KEY (id_estado) REFERENCES d_estado (id_estado);
-- Volver a activar la restricción
ALTER TABLE f_incidencias ADD CONSTRAINT fk_estado FOREIGN KEY (fk_estado_sla) REFERENCES d_estado_sla (id_estado_sla);


select * from raw_data;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE f_incidencias;

TRUNCATE TABLE d_estado_sla;
TRUNCATE TABLE d_torre_servicio;

TRUNCATE TABLE d_entorno;
TRUNCATE TABLE d_prioridad;
TRUNCATE TABLE d_servicio_tipo;

TRUNCATE TABLE d_tipo_servicio;
TRUNCATE TABLE d_servicio;
TRUNCATE TABLE d_torre;
TRUNCATE TABLE d_sla;
TRUNCATE TABLE d_estado;

SET FOREIGN_KEY_CHECKS = 1;

select * from f_incidencias;

