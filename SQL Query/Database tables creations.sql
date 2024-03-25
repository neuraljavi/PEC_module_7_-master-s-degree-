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
  `entorno` VARCHAR(45) NULL,
  `estado_cumplimiento_sla` VARCHAR(45) NULL,
  `duracion_dias` DECIMAL(30,25) NULL,
  PRIMARY KEY (`id`));
  
  ALTER TABLE `pec`.`raw_data` 
CHANGE COLUMN `entorno` `entorno` VARCHAR(100) NULL DEFAULT NULL ;

select * from raw_data;

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
  `fk_estado` varchar(45) NOT NULL,
  `fk_sla` varchar(45) NOT NULL,
  PRIMARY KEY (`id_estado_sla`)
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
  `id_tipo_servicio` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_servicio`),
  KEY `id_tipo_servicio_fk_idx` (`id_tipo_servicio`),
  CONSTRAINT `id_tipo_servicio_fk` FOREIGN KEY (`id_tipo_servicio`) REFERENCES `d_tipo_servicio` (`id_tipo_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

show create table d_servicio;
