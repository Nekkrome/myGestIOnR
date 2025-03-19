-- Adminer 4.8.1 MySQL 5.5.5-10.3.34-MariaDB-0+deb10u1 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `Equipement`;
CREATE TABLE `Equipement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(30) NOT NULL,
  `adMAC` varchar(17) NOT NULL,
  `adIP` varchar(15) NOT NULL,
  `CIDR` int(2) NOT NULL,
  `idT` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idT` (`idT`),
  CONSTRAINT `Equipement_ibfk_1` FOREIGN KEY (`idT`) REFERENCES `TypeE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `Equipement` (`id`, `nom`, `adMAC`, `adIP`, `CIDR`, `idT`) VALUES
(1,	'pc1',	'10:01:20:02:30:03',	'192.168.16.16',	24,	1),
(2,	'sw01',	'40:04:50:05:60:06',	'192.168.16.101',	24,	2),
(3,	'svr01',	'07:70:08:80:09:90',	'192.168.16.201',	24,	3);

DROP TABLE IF EXISTS `TypeE`;
CREATE TABLE `TypeE` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `TypeE` (`id`, `libelle`) VALUES
(1,	'Machine'),
(2,	'Switch'),
(3,	'Serveur'),
(4,	'Routeur');

-- 2022-12-08 13:56:17

