USE `essentialmode`;
CREATE TABLE `miav2_accounts` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` varchar(255) NOT NULL,
	`name` varchar(255) NOT NULL,
    `steam` varchar(255),
    `discord` varchar(255),
    `ip` varchar(255),
    `ping` varchar(255),
    `wl` int(11) DEFAULT 0,
    `banned` boolean,
    `banBy` varchar(255) NOT NULL,
    `banDate` varchar(255) NOT NULL,
    `banReason` varchar(255) NOT NULL,
	PRIMARY KEY (`id`)
);