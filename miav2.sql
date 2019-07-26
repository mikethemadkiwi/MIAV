USE `fivem`;/* <<<<<<<<<< CHANGE THIS TO YOUR DATABASE */
CREATE TABLE `_MIAV2Users` (
	`identifier` varchar(64) NOT NULL PRIMARY KEY,
    `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `lastSeen` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `identifiers` LONGTEXT DEFAULT NULL,
    `groups` LONGTEXT DEFAULT NULL,
    `trustlvl` int(11) DEFAULT 0,
    `wl` int(11) DEFAULT 0,
    `banned` INT(4) DEFAULT NULL
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2GroupPerms` (
	`id` int(1) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`groupname` varchar(64) NOT NULL,
    `permissions` LONGTEXT
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2SteamBan` (
    `identifier` varchar(64) NOT NULL PRIMARY KEY,
	`steamid` varchar(255) NOT NULL,
    `banBy` varchar(255) DEFAULT NULL,
    `banDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `banReason` varchar(255) DEFAULT NULL,
	FOREIGN KEY (identifier) REFERENCES _MIAV2Users (identifier)
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2DiscordBan` (
	`identifier` varchar(64) NOT NULL PRIMARY KEY,
	`discordid` varchar(255) NOT NULL,
    `banBy` varchar(255) DEFAULT NULL,
    `banDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `banReason` varchar(255) DEFAULT NULL,
	FOREIGN KEY (identifier) REFERENCES _MIAV2Users (identifier)
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2XblBan` (
	`identifier` varchar(64) NOT NULL PRIMARY KEY,
	`xblid` varchar(255) NOT NULL,
    `banBy` varchar(255) DEFAULT NULL,
    `banDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `banReason` varchar(255) DEFAULT NULL,
    FOREIGN KEY (identifier) REFERENCES _MIAV2Users (identifier)
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2LiveBan` (
    `identifier` varchar(64) NOT NULL PRIMARY KEY,
	`liveid` varchar(255) NOT NULL,
    `banBy` varchar(255) DEFAULT NULL,
    `banDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `banReason` varchar(255) DEFAULT NULL,
	FOREIGN KEY (identifier) REFERENCES _MIAV2Users (identifier)
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2IPBan` (
	`identifier` varchar(64) NOT NULL PRIMARY KEY,
	`ip` varchar(255) NOT NULL,
    `banBy` varchar(255) DEFAULT NULL,
    `banDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `banReason` varchar(255) DEFAULT NULL,
    FOREIGN KEY (identifier) REFERENCES _MIAV2Users (identifier)
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2TicketSystem` (
	`id` int(4) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `dateOpened` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `lastInteraction` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `msgLog` LONGTEXT NOT NULL,
    `ticketState` LONGTEXT NOT NULL,
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2Log` (
    `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `logmsg` LONGTEXT NOT NULL
) ENGINE = InnoDB;
CREATE TABLE `_MIAV2Settings` (
	`id` int(4) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`acceptPlayers` BOOLEAN DEFAULT TRUE,
	`maxPlayers` INT(4) DEFAULT 32,
	`requireWhitelist` BOOLEAN DEFAULT TRUE,
	`requireConnQueue` BOOLEAN DEFAULT FALSE,
	`requireBanCheck` BOOLEAN DEFAULT TRUE,
	`requireSteam` BOOLEAN DEFAULT FALSE,
	`requireDiscord` BOOLEAN DEFAULT FALSE,
	`requireLive` BOOLEAN DEFAULT FALSE,
	`requireXbl` BOOLEAN DEFAULT FALSE,
    `pingThreshold` int(4) DEFAULT 750,
    `pingInterval` int(4) DEFAULT 120,
	`WL_Level` INT(4) DEFAULT 0,
    `regLevel` INT(4) DEFAULT 50,
    `modLevel` INT(4) DEFAULT 100,
    `AdminLevel` INT(4) DEFAULT 250,
    `DevLevel` INT(4) DEFAULT 500,
    `kickMsgPing` TEXT NOT NULL,
    `kickMsgSteam` TEXT NOT NULL,
    `kickMsgDiscord` TEXT NOT NULL,
    `kickMsgWhitelist` TEXT NOT NULL,
    `kickMsgLive` TEXT NOT NULL,
    `kickMsgXbl` TEXT NOT NULL,
    `kickMsgBanned` TEXT NOT NULL,
    `kickMsgDefault` TEXT NOT NULL
) ENGINE = InnoDB;
INSERT INTO _MIAV2Settings (kickMsgPing, kickMsgSteam, kickMsgDiscord, kickMsgXbl, kickMsgLive, kickMsgWhitelist, kickMsgBanned, kickMsgDefault)
VALUES (
    "Your ping is too high!",
    "No Steam. Restart Steam and Fivem",
    "No Discord. Restart Discord and Fivem",
    "No Live/XBL. Restart Xbl/Live app and FiveM",
    "No Live/XBL. Restart Xbl/Live app and FiveM",
    "Your Whitelist Level is too Low",
    "You are Banned. Contact Admins",
    "You were kicked from the server"
);