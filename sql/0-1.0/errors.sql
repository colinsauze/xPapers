CREATE TABLE `errors` ( `id` int(10) unsigned NOT NULL AUTO_INCREMENT, `ip` varchar(15) DEFAULT NULL, `uId` int(11) DEFAULT NULL, `type` tinyint(3) unsigned DEFAULT NULL, `request_uri` varchar(1000) DEFAULT NULL, `args` text, `cookies` text, `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `info` text, `user_agent` varchar(500) DEFAULT NULL, `host` varchar(255) DEFAULT NULL, `referer` varchar(500) DEFAULT NULL, `pid` int(11) DEFAULT NULL, PRIMARY KEY (`id`), KEY `ip` (`ip`), KEY `uId` (`uId`), KEY `time` (`time`)) ENGINE=MyISAM AUTO_INCREMENT=190140 DEFAULT CHARSET=utf8
