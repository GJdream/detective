-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Värd: localhost
-- Skapad: 18 dec 2013 kl 15:27
-- Serverversion: 5.5.24-log
-- PHP-version: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databas: `appserver`
--
CREATE DATABASE `appserver` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `appserver`;

-- --------------------------------------------------------

--
-- Tabellstruktur `clues`
--

CREATE TABLE IF NOT EXISTS `clues` (
  `detective` varchar(200) NOT NULL,
  `police` varchar(200) NOT NULL,
  `killer` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellstruktur `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `sessionID` int(11) NOT NULL AUTO_INCREMENT,
  `isReady` tinyint(1) NOT NULL DEFAULT '0',
  `nextSync` datetime NOT NULL,
  `playOrder` varchar(100) NOT NULL,
  PRIMARY KEY (`sessionID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=323 ;

-- --------------------------------------------------------

--
-- Tabellstruktur `sessionsinplay`
--

CREATE TABLE IF NOT EXISTS `sessionsinplay` (
  `sessionID` int(11) DEFAULT NULL,
  `playerID` int(11) DEFAULT NULL,
  `changed` tinyint(1) NOT NULL DEFAULT '0',
  `playerName` varchar(20) DEFAULT NULL,
  `playerRole` int(10) DEFAULT '0',
  `playerAlive` tinyint(1) NOT NULL DEFAULT '1',
  `clue` varchar(200) NOT NULL,
  `orderGot` tinyint(1) NOT NULL DEFAULT '0',
  `voteThisRound` int(11) NOT NULL DEFAULT '-1',
  `voteSum` int(11) NOT NULL DEFAULT '0',
  `votesForElimination` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `sessionID` (`sessionID`,`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Restriktioner för dumpade tabeller
--

--
-- Restriktioner för tabell `sessionsinplay`
--
ALTER TABLE `sessionsinplay`
  ADD CONSTRAINT `sessionsinplay_ibfk_1` FOREIGN KEY (`sessionID`) REFERENCES `sessions` (`sessionID`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
