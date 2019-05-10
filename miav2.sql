USE `fivem`;/* <<<<<<<<<< CHANGE THIS TO YOUR DATABASE */
CREATE TABLE `_miav2Users` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` varchar(255) NOT NULL,
    `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `lastSeen` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`name` varchar(255) DEFAULT NULL,
    `steam` varchar(255) DEFAULT NULL,
    `discord` varchar(255) DEFAULT NULL,
    `ip` varchar(255) DEFAULT NULL,
    `wl` int(11) DEFAULT 0,
    `banned` INT(4) DEFAULT NULL,
    `banBy` varchar(255) DEFAULT NULL,
    `banDate` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `banReason` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `_miav2Log` (
    `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `logmsg` TEXT NOT NULL
);
CREATE TABLE `_miav2Settings` (
	`id` int(1) NOT NULL AUTO_INCREMENT,
	`acceptPlayers` BOOLEAN DEFAULT TRUE,
	`requireSteam` BOOLEAN DEFAULT FALSE,
	`requireDiscord` BOOLEAN DEFAULT FALSE,
	`requireWhitelist` BOOLEAN DEFAULT TRUE,
	`requireBanCheck` BOOLEAN DEFAULT TRUE,
    `pingThreshold` int(4) DEFAULT 750,
	`WL_Level` INT(4) DEFAULT 0,
    `regLevel` INT(4) DEFAULT 50,
    `modLevel` INT(4) DEFAULT 100,
    `AdminLevel` INT(4) DEFAULT 200,
    `kickMsgPing` TEXT NOT NULL,
    `kickMsgSteam` TEXT NOT NULL,
    `kickMsgDiscord` TEXT NOT NULL,
    `kickMsgWhitelist` TEXT NOT NULL,
    `kickMsgBanned` TEXT NOT NULL,
    PRIMARY KEY (`id`)
);
INSERT INTO _miav2Settings (kickMsgPing, kickMsgSteam, kickMsgDiscord, kickMsgWhitelist, kickMsgBanned)
VALUES (
    "Your ping is too high!",
    "No Steam. Restart Steam and Fivem",
    "No Discord. Restart Discord and Fivem",
    "Your Whitelist Level is too Low",
    "You are Banned. Contact Admins"
);