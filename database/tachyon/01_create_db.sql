-- 以下から持ってきたものを使っています
-- <https://gitlab.adways.net/appdriver/docker/-/tree/master/mysql/tachyon/init>

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP DATABASE IF EXISTS tutorial;
CREATE DATABASE IF NOT EXISTS tutorial;


DROP SCHEMA IF EXISTS `tachyon` ;
CREATE SCHEMA IF NOT EXISTS `tachyon` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
SHOW WARNINGS;
USE `tachyon` ;

-- -----------------------------------------------------
-- Table `partner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `partner` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `partner` (
  `partner_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'アカウント名' ,
  `company` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '会社名' ,
  `company_in_kana` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '会社名（カナ）' ,
  `representative` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '代表者名' ,
  `representative_in_kana` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '代表者名（カナ）' ,
  `contact` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '担当者' ,
  `contact_in_kana` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '担当者（カナ）' ,
  `mail` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'メールアドレス' ,
  `telephone` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '電話番号' ,
  `postal_code` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '郵便番号' ,
  `address1` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '住所１' ,
  `address2` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '住所２' ,
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT 'ステータス' ,
  `trade_id` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'DEPRECATED' ,
  `payee_id` INT NULL ,
  `additional_payee_id` INT NULL ,
  `identifier` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'アカウントID' ,
  `password` CHAR(32) NOT NULL DEFAULT '' COMMENT 'パスワード' ,
  `url` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'URL' ,
  `remark` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '備考' ,
  `is_intercompany` TINYINT(1) NOT NULL DEFAULT 1 ,
  `greereward_identifier` VARCHAR(10) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NULL COMMENT 'gap_nnnnnn' ,
  `global_partner_id` INT NULL ,
  `is_from_global` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'グローバルから同期されているか' ,
  `is_linkable_to_report` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'リワードレポートのプロモーション別レポートへのリンク生成の可否' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`partner_id`) )
ENGINE = InnoDB
COMMENT = 'パートナー・デベロッパー';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_identifier` ON `partner` (`identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media` (
  `media_id` INT NOT NULL AUTO_INCREMENT ,
  `site_id` INT NOT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'リワード名' ,
  `published_type` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '配信判別タイプ' ,
  `version` VARCHAR(3) NULL ,
  `identifier` VARCHAR(45) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL DEFAULT '' ,
  `is_approved` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '審査フラグ' ,
  `mode` TINYINT NOT NULL DEFAULT 0 COMMENT '稼動モード' ,
  `margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 COMMENT 'メディアマージン' ,
  `payee_id` INT NOT NULL DEFAULT 0 ,
  `additional_margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 COMMENT '代理店マージン' ,
  `additional_payee_id` INT NOT NULL DEFAULT 0 ,
  `exchange` DECIMAL(7,4) NULL COMMENT 'ポイントバック率' ,
  `rounding` VARCHAR(5) NOT NULL DEFAULT 'floor' COMMENT 'ポイント計算方法' ,
  `currency` VARCHAR(11) NULL COMMENT '通貨名称' ,
  `currency_unit` VARCHAR(8) NULL COMMENT '通貨単位' ,
  `remark` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '備考' ,
  `callback` VARCHAR(255) NULL COMMENT '成果通知URL' ,
  `role` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '成果通信タイプ' ,
  `is_api_available` TINYINT NOT NULL DEFAULT 0 COMMENT '広告APIの使用可否' ,
  `api_role` VARCHAR(32) NOT NULL DEFAULT 'Default' COMMENT '広告APIのファイル生成タイプ' ,
  `api_priority` TINYINT NOT NULL DEFAULT 0 COMMENT 'XML生成優先するか' ,
  `currency_rate` DECIMAL(7,4) NULL DEFAULT 1.000 COMMENT 'ポイントレート' ,
  `is_show_tutorial` TINYINT NOT NULL DEFAULT 0 COMMENT 'チュートリアル表示有無' ,
  `mail_of_notice` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'ポイントバックの再送処理失敗時に送信するメールアドレス' ,
  `promote_mail_type` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0:促進メールを送信しない　1:案件情報のみ 2:案件詳細情報含む' ,
  `mail` VARCHAR(45) NOT NULL DEFAULT '' ,
  `media_agency_id` TINYINT NULL COMMENT 'メディア側代理店ID' ,
  `global_media_id` INT NULL ,
  `is_from_global` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'グローバルから同期されているか' ,
  `contents_restriction` INT(11) NOT NULL DEFAULT 18 COMMENT 'メディアのコンテンツレーティング' ,
  `is_ssl` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '案件提供API時に、iconのURLをhttpsで提供するかのフラグ' ,
  `is_location_ssl` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '案件提供API時に、locationのURLをhttpsで提供するかのフラグ' ,
  `eight_range_id` INT(11) NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`media_id`) )
ENGINE = InnoDB
COMMENT = 'メディア - site_as_payee';

SHOW WARNINGS;
CREATE INDEX `i_site` ON `media` (`site_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `advertisement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `advertisement` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `advertisement` (
  `advertisement_id` INT NOT NULL AUTO_INCREMENT ,
  `campaign_id` INT NOT NULL ,
  `identifier` VARCHAR(255) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' COMMENT 'サンクスID' ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'サンクス名' ,
  `requisite_id` INT NOT NULL ,
  `period` TINYINT NOT NULL DEFAULT 0 COMMENT '認証期間' ,
  `offer` INT NOT NULL DEFAULT 0 COMMENT 'グロス単価' ,
  `is_available` TINYINT(1) NOT NULL DEFAULT 1 ,
  `global_advertisement_id` INT NULL ,
  `is_from_global` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'グローバルから同期されているか' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `identifier_smartc` VARCHAR(32) NULL COMMENT 'Smart-CサンクスID' ,
  `estimated_minute_to_achieve` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT '成果条件達成までの目安時間' ,
  `required_minute_from_install` INT NOT NULL DEFAULT 0 COMMENT 'インストールから成果までの最低時間' ,
  PRIMARY KEY (`advertisement_id`) )
ENGINE = InnoDB
COMMENT = 'サンクス';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_campaign_identifier` ON `advertisement` (`campaign_id` ASC, `identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign` (
  `campaign_id` INT NOT NULL AUTO_INCREMENT ,
  `site_id` INT NOT NULL ,
  `campaign_type` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '案件の種類',
  `name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'プロモーション名' ,
  `location` VARCHAR(4096) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL DEFAULT '' COMMENT 'プロモーションの飛び先' ,
  `start_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `end_time` DATETIME NOT NULL DEFAULT '2020-12-31 23:59:59' ,
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT 'ステータス' ,
  `is_authenticate_by_sms` TINYINT(1) NOT NULL DEFAULT 0 ,
  `budget` INT NOT NULL DEFAULT 0 COMMENT '予算' ,
  `budget_is_unlimited` TINYINT NOT NULL DEFAULT 0 COMMENT '予算上限の有無' ,
  `staff` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '社内担当者' ,
  `auth_user_id` INT NULL COMMENT 'プロモーション社内担当者' ,
  `allowance` INT NOT NULL DEFAULT 0 COMMENT '掲載停止残高' ,
  `additional_margin` DECIMAL(5,4) NULL COMMENT '代理店マージン' ,
  `additional_payee_id` INT NULL ,
  `media_margin` DECIMAL(5,4) NULL COMMENT 'メディアマージン' ,
  `draft` TEXT NULL COMMENT '原稿' ,
  `remark` TEXT NULL COMMENT '備考' ,
  `advertisement_id` INT NOT NULL DEFAULT 0 COMMENT '主サンクス' ,
  `identifier` VARCHAR(64) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL DEFAULT '' COMMENT 'サードパーティプロモの識別子' ,
  `is_updatable` TINYINT(1) NULL COMMENT 'サードパーティにより更新可能か' ,
  `reward` INT(11) NULL DEFAULT NULL COMMENT 'インセンティブ上限額（円）' ,
  `weight` TINYINT NOT NULL DEFAULT 0 COMMENT '表示用重み' ,
  `has_banner` TINYINT NOT NULL DEFAULT 0 COMMENT 'インターステイシャルバナー画像' ,
  `market_app_id` VARCHAR(100) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NULL COMMENT 'GreeRewardAsp連携用。Android:パッケージ名, iOS:AppStoreId' ,
  `is_recognize_promote_mail` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0:促進メール送信非承認　1:促進メール送信承認' ,
  `is_ow_publishable` TINYINT(4) NOT NULL DEFAULT 1 COMMENT 'オファーウォール掲載可否のフラグ' ,
  `global_campaign_id` INT NULL ,
  `is_from_global` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'グローバルから同期されているか' ,
  `is_check_publishable` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0:掲載関係を参照しない　1:掲載関係を参照する' ,
  `is_ow_label` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'OW5.1の広告一覧画面にラベルを表示させるかどうか 0:非表示 1:表示' ,
  `platform_id_for_web` SET('2', '3') NOT NULL DEFAULT '' ,
  `carrier` SET('1','2','3') NOT NULL DEFAULT '' ,
  `is_blocking_country` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '国制限を行うかどうか 0:行わない,1:行う' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`campaign_id`) )
ENGINE = InnoDB
COMMENT = 'プロモーション - site_as_payor';

SHOW WARNINGS;
CREATE INDEX `i_identifier` ON `campaign` (`identifier` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_site` ON `campaign` (`site_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `partner_as_payor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `partner_as_payor` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `partner_as_payor` (
  `partner_id` INT(11) NOT NULL ,
  `agency` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '代理店' ,
  `contact` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '代理店担当者' ,
  `contact_in_kana` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '代理店担当者（カナ）' ,
  `staff` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '社内担当者' ,
  `auth_user_id` INT(11) NOT NULL DEFAULT '0' COMMENT 'プロモーション社内担当者' ,
  `remark` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '備考' ,
  `trader_identifier` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '取引先ID' ,
  `trader_contact_identifier` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '取引先担当者ID' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`partner_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'パートナー･クライアントとして';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `partner_as_payee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `partner_as_payee` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `partner_as_payee` (
  `partner_id` INT(11) NOT NULL ,
  `agency` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '代理店' ,
  `contact` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '代理店担当者' ,
  `contact_in_kana` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '代理店担当者（カナ）' ,
  `staff` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '社内担当者' ,
  `auth_user_id` INT(11) NOT NULL DEFAULT '0' COMMENT 'リワード社内担当者' ,
  `remark` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '備考' ,
  `bank` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '銀行名' ,
  `branch` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '支店名' ,
  `branch_in_kana` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '支店名（カナ）' ,
  `account_type` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '口座種別・１（普通）・2（当座）' ,
  `account_number` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '口座番号' ,
  `name_in_kana` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '口座名義（カナ）' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`partner_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'パートナー・メディアとして';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `category` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `category` (
  `category_id` INT NOT NULL AUTO_INCREMENT ,
  `platform_id` TINYINT NOT NULL ,
  `name` VARCHAR(128) NOT NULL ,
  PRIMARY KEY (`category_id`) )
ENGINE = InnoDB
COMMENT = 'アプリカテゴリ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_category` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_category` (
  `campaign_id` INT NOT NULL ,
  `category_id` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`, `category_id`) )
ENGINE = InnoDB
COMMENT = 'プロモーションの配信カテゴリ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_campaign`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_campaign` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_campaign` (
  `media_id` INT NOT NULL ,
  `campaign_id` INT NOT NULL ,
  `is_affiliated` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '掲載するか' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `campaign_id`) )
ENGINE = InnoDB
COMMENT = 'メディアのプロモーション掲載可否設定';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_media` (
  `campaign_id` INT NOT NULL ,
  `media_id` INT NOT NULL ,
  `is_affiliated` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '掲載するか' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`, `media_id`) )
ENGINE = InnoDB
COMMENT = 'プロモーションのアプリ掲載可否設定';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_category` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_category` (
  `media_id` INT NOT NULL ,
  `category_id` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `category_id`) )
ENGINE = InnoDB
COMMENT = 'メディアの掲載カテゴリ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_statistic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_statistic` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_statistic` (
  `campaign_id` INT NOT NULL ,
  `spending` INT NOT NULL DEFAULT 0 COMMENT '消化した予算金額' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`) )
ENGINE = InnoDB
COMMENT = 'プロモーションの集計データ（リアルタイム）';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `user` (
  `user_id` INT NOT NULL AUTO_INCREMENT ,
  `model` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '機種' ,
  `identifier` CHAR(64) NOT NULL DEFAULT '' COMMENT 'sha256_hex(固体番号)' ,
  `user_agent` VARCHAR(255) NOT NULL DEFAULT '' ,
  `ip` VARCHAR(15) NOT NULL DEFAULT '' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`user_id`) )
ENGINE = InnoDB
COMMENT = 'ユーザー';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_identifier` ON `user` (`identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `click`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `click` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `click` (
  `click_id` BIGINT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `media_id` INT NOT NULL ,
  `campaign_id` INT NOT NULL ,
  `user_id` INT NULL ,
  `session` CHAR(40) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NULL ,
  `identifier` VARCHAR(255) NULL COMMENT 'アプリのユーザー識別子' ,
  `user_agent` VARCHAR(255) NOT NULL DEFAULT '' ,
  `ip` VARCHAR(15) NOT NULL DEFAULT '' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`click_id`, `date`) )
ENGINE = InnoDB
COMMENT = 'クリック履歴';

SHOW WARNINGS;
CREATE INDEX `i_campaign_user` ON `click` (`campaign_id` ASC, `user_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_session_campaign` ON `click` (`session` ASC, `campaign_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_media_identifier` ON `click` (`media_id` ASC, `identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve` (
  `achieve_id` CHAR(36) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL ,
  `date` DATE NOT NULL ,
  `site_id` INT(11) NOT NULL DEFAULT 0 ,
  `advertisement_identifier` VARCHAR(255) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' ,
  `identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' ,
  `session` CHAR(40) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NULL DEFAULT NULL ,
  `click_id` BIGINT NULL DEFAULT NULL ,
  `advertisement_id` INT(11) NOT NULL ,
  `earnings` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 COMMENT '収入' ,
  `additional_earnings` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 ,
  `expenses` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 COMMENT '支出' ,
  `additional_expenses` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 ,
  `user_agent` VARCHAR(255) NOT NULL DEFAULT '' ,
  `ip` VARCHAR(15) NOT NULL DEFAULT '' ,
  `occurred_time` DATETIME NULL DEFAULT NULL COMMENT '初回起動時間' ,
  `traced_time` DATETIME NULL DEFAULT NULL ,
  `is_accepted` TINYINT(1) NULL DEFAULT NULL COMMENT '認証したか' ,
  `accepted_time` DATETIME NULL DEFAULT NULL COMMENT '認証時間' ,
  `point` INT(11) NULL DEFAULT NULL COMMENT '付与ポイント' ,
  `is_forwarded` TINYINT(1) NULL DEFAULT NULL COMMENT 'ポイント・アイテムを付与したか' ,
  `forwarded_time` DATETIME NULL DEFAULT NULL COMMENT 'メディアに成果を通知した時間' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `user_id` INT(11) NULL DEFAULT NULL ,
  `media_id` INT(11) NULL DEFAULT NULL ,
  `campaign_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`achieve_id`, `date`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = '成果履歴';

SHOW WARNINGS;
CREATE INDEX `i_click` ON `achieve` (`click_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_site_identifier` ON `achieve` (`site_id` ASC, `identifier` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_user_site` ON `achieve` (`user_id` ASC, `site_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_to_forward`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_to_forward` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_to_forward` (
  `achieve_to_forward_id` INT NOT NULL AUTO_INCREMENT ,
  `achieve_id` CHAR(36) NOT NULL ,
  `media_id` INT(11) NULL ,
  `forward_time` TIMESTAMP NULL ,
  `attempted` TINYINT NULL COMMENT '通知失敗回数' ,
  `message` VARCHAR(45) NULL ,
  PRIMARY KEY (`achieve_to_forward_id`) )
ENGINE = InnoDB
COMMENT = '成果履歴（通知待ち）';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_achieve` ON `achieve_to_forward` (`achieve_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_forward_time` ON `achieve_to_forward` (`forward_time` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `report`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `report` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `report` (
  `report_id` BIGINT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `media_id` INT NOT NULL ,
  `campaign_id` INT NOT NULL ,
  `view` INT NOT NULL DEFAULT 0 ,
  `click` INT NOT NULL DEFAULT 0 ,
  `achieve` INT NOT NULL DEFAULT 0 ,
  `earnings` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 COMMENT '収入' ,
  `additional_earnings` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 COMMENT '支出（メディア分）' ,
  `additional_expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 COMMENT '支出（代理店分）' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`report_id`) )
ENGINE = InnoDB
COMMENT = 'レポート';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_date_media_campaign` ON `report` (`date` ASC, `media_id` ASC, `campaign_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `site`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `site` (
  `site_id` INT NOT NULL AUTO_INCREMENT ,
  `partner_id` INT NOT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'アプリ名' ,
  `app_id` VARCHAR(255) CHARACTER SET 'latin1' NULL ,
  `identifier` VARCHAR(64) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL DEFAULT '' ,
  `url` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'アプリのURL' ,
  `price` INT NOT NULL DEFAULT 0 ,
  `version_in_review` VARCHAR(16) NULL ,
  `subscription_duration` SMALLINT NOT NULL DEFAULT 0 COMMENT '0:買切り;30:月額' ,
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT 'ステータス' ,
  `duplication_type` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '重複カット期間：0:重複カットあり;1:当日;2:当月' ,
  `supplier_id` TINYINT NOT NULL ,
  `platform_id` TINYINT NOT NULL ,
  `market_id` TINYINT NULL ,
  `network_id` TINYINT NULL ,
  `category_id` INT NOT NULL DEFAULT 0 ,
  `has_icon` TINYINT(1) NOT NULL DEFAULT 0 ,
  `description` TEXT NULL ,
  `cipher` BINARY(16) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' COMMENT '暗号鍵' ,
  `tracking_method` TINYINT NOT NULL DEFAULT 0 ,
  `uri` VARCHAR(255) NOT NULL DEFAULT '' ,
  `package` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'パッケージネーム' ,
  `priority` TINYINT NOT NULL DEFAULT 0 ,
  `deny_browser` TINYINT NOT NULL DEFAULT 0 ,
  `global_site_id` INT NULL ,
  `is_from_global` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'グローバルから同期されているか' ,
  `contents_rating` INT(11) NOT NULL DEFAULT 3 COMMENT '案件のコンテンツレーティング' ,
  `site_customize_id` TINYINT(4) NOT NULL DEFAULT 0 ,
  `common_id` VARCHAR(255) NULL COMMENT 'ItemID' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`site_id`) )
ENGINE = InnoDB
COMMENT = 'アプリ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `report_by_advertisement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `report_by_advertisement` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `report_by_advertisement` (
  `report_by_advertisement_id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `media_id` INT NOT NULL ,
  `advertisement_id` INT NOT NULL ,
  `achieve` INT NOT NULL DEFAULT 0 ,
  `earnings` DECIMAL(11,4) NOT NULL DEFAULT 0.0000 ,
  `additional_earnings` DECIMAL(11,4) NOT NULL DEFAULT 0.0000 ,
  `expenses` DECIMAL(11,4) NOT NULL DEFAULT 0.0000 ,
  `additional_expenses` DECIMAL(11,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`report_by_advertisement_id`) )
ENGINE = InnoDB
COMMENT = 'レポート・サンクス別';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_date_media_campaign` ON `report_by_advertisement` (`date` ASC, `media_id` ASC, `advertisement_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `requisite`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `requisite` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `requisite` (
  `requisite_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(128) NOT NULL ,
  `is_forward` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`requisite_id`) )
ENGINE = InnoDB
COMMENT = 'サンクスカテゴリ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `item_of_click`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `item_of_click` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `item_of_click` (
  `click_id` INT NOT NULL ,
  `identifier` VARCHAR(45) NOT NULL DEFAULT '' ,
  `price` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`click_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `platform`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `platform` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `platform` (
  `platform_id` TINYINT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(9) NOT NULL ,
  PRIMARY KEY (`platform_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `platform_compatibility`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `platform_compatibility` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `platform_compatibility` (
  `platform_id_of_media` TINYINT NOT NULL COMMENT 'platform_id' ,
  `platform_id_of_campaign` TINYINT NOT NULL COMMENT 'platform_id' ,
  PRIMARY KEY (`platform_id_of_media`, `platform_id_of_campaign`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `supplier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `supplier` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `supplier` (
  `supplier_id` TINYINT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(128) NOT NULL ,
  `role` VARCHAR(64) NULL ,
  PRIMARY KEY (`supplier_id`) )
ENGINE = InnoDB
COMMENT = 'アプリ（プロモ）の提供元';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_platform`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_platform` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_platform` (
  `media_id` INT NOT NULL ,
  `platform_id` TINYINT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `platform_id`) )
ENGINE = InnoDB
COMMENT = 'メディアの掲載プラットフォーム';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_supplier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_supplier` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_supplier` (
  `media_id` INT NOT NULL ,
  `supplier_id` TINYINT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `supplier_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_continent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_continent` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_continent` (
  `analytics_continent_id` TINYINT NOT NULL AUTO_INCREMENT ,
  `code` CHAR(2) NOT NULL ,
  `name` VARCHAR(13) NOT NULL ,
  PRIMARY KEY (`analytics_continent_id`) )
ENGINE = InnoDB
COMMENT = '大陸';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_code` ON `analytics_continent` (`code` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_country` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_country` (
  `analytics_country_id` SMALLINT NOT NULL AUTO_INCREMENT ,
  `analytics_continent_id` TINYINT NOT NULL ,
  `code` CHAR(2) NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`analytics_country_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_analytics_continent` ON `analytics_country` (`analytics_continent_id` ASC) ;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_code` ON `analytics_country` (`code` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_region` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_region` (
  `analytics_region_id` SMALLINT NOT NULL AUTO_INCREMENT ,
  `analytics_country_id` SMALLINT NOT NULL ,
  `code` VARCHAR(3) NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`analytics_region_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_analytics_country_code` ON `analytics_region` (`analytics_country_id` ASC, `code` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_city` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_city` (
  `analytics_city_id` MEDIUMINT NOT NULL AUTO_INCREMENT ,
  `analytics_region_id` SMALLINT NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`analytics_city_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_analytics_region_name` ON `analytics_city` (`analytics_region_id` ASC, `name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `market`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `market` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `market` (
  `market_id` TINYINT NOT NULL ,
  `platform_id` TINYINT NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  `refund_period` MEDIUMINT NOT NULL DEFAULT 0 COMMENT '返品期限（秒）' ,
  PRIMARY KEY (`market_id`, `platform_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `carrier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carrier` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `carrier` (
  `carrier_id` TINYINT NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`carrier_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `market_compatibility`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `market_compatibility` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `market_compatibility` (
  `market_id` TINYINT NOT NULL ,
  `platform_id` TINYINT NOT NULL ,
  `carrier_id` TINYINT NOT NULL ,
  PRIMARY KEY (`market_id`, `carrier_id`, `platform_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_isp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_isp` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_isp` (
  `analytics_isp_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`analytics_isp_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `name_UNIQUE` ON `analytics_isp` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `role` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `role` (
  `role_id` INT NOT NULL AUTO_INCREMENT ,
  `role` TEXT NOT NULL ,
  PRIMARY KEY (`role_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `partner_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `partner_role` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `partner_role` (
  `partner_id` INT NOT NULL ,
  `role_id` INT NOT NULL ,
  PRIMARY KEY (`partner_id`, `role_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_receipt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_receipt` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_receipt` (
  `analytics_receipt_id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `site_id` INT NOT NULL ,
  `transaction` VARCHAR(128) NOT NULL ,
  `price` DECIMAL(11,2) NOT NULL COMMENT '合計金額' ,
  `currency_id` CHAR(3) NOT NULL ,
  `analytics_country_id` INT NOT NULL ,
  `user_id` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`analytics_receipt_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_site_transaction` ON `analytics_receipt` (`site_id` ASC, `transaction` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_user_id` ON `analytics_receipt` (`user_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_site_date` ON `analytics_receipt` (`date` ASC, `site_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_product` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_product` (
  `analytics_product_id` INT NOT NULL AUTO_INCREMENT ,
  `site_id` INT NOT NULL ,
  `identifier` VARCHAR(128) NOT NULL ,
  `name` VARCHAR(45) NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`analytics_product_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_site_identifier` ON `analytics_product` (`site_id` ASC, `identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `currency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `currency` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `currency` (
  `currency_id` CHAR(3) NOT NULL COMMENT 'i.e. USD' ,
  `name` VARCHAR(45) NOT NULL COMMENT 'i.e. USドル' ,
  `symbol` VARCHAR(4) NOT NULL COMMENT 'i.e. $' ,
  PRIMARY KEY (`currency_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `exchange`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exchange` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `exchange` (
  `quote` CHAR(3) NOT NULL ,
  `base` CHAR(3) NOT NULL ,
  `rate` DECIMAL(13,9) NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`quote`, `base`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_receipt_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_receipt_item` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_receipt_item` (
  `analytics_receipt_item_id` INT NOT NULL AUTO_INCREMENT ,
  `analytics_receipt_id` INT NOT NULL ,
  `analytics_product_id` INT NOT NULL ,
  `quantity` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`analytics_receipt_item_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_receipt_product` ON `analytics_receipt_item` (`analytics_receipt_id` ASC, `analytics_product_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `partner_setting`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `partner_setting` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `partner_setting` (
  `partner_setting_id` INT NOT NULL AUTO_INCREMENT ,
  `currency` CHAR(3) NULL ,
  `language` CHAR(2) NULL ,
  `timezone` TINYINT NULL ,
  PRIMARY KEY (`partner_setting_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_receipt_price_level`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_receipt_price_level` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_receipt_price_level` (
  `analytics_receipt_price_level_id` INT NOT NULL AUTO_INCREMENT ,
  `currency_id` CHAR(3) NULL ,
  `name` VARCHAR(45) NULL ,
  `min` INT NULL ,
  PRIMARY KEY (`analytics_receipt_price_level_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_currency` ON `analytics_receipt_price_level` (`currency_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `analytics_receipt_num_level`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `analytics_receipt_num_level` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `analytics_receipt_num_level` (
  `analytics_receipt_num_level_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  `min` INT NULL ,
  PRIMARY KEY (`analytics_receipt_num_level_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `cache`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cache` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `cache` (
  `id` CHAR(36) NOT NULL ,
  `cache_data` TEXT NULL ,
  `expires` INT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'キャッシュ・システム用';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_alternative_to_partner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_alternative_to_partner` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_alternative_to_partner` (
  `media_id` INT NOT NULL ,
  `partner_id` INT NOT NULL ,
  `margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `additional_margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `partner_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `alternative`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `alternative` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `alternative` (
  `advertisement_id` INT NOT NULL ,
  `offer` INT NOT NULL DEFAULT 0 ,
  `media_id` INT NOT NULL ,
  `margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `additional_margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`advertisement_id`, `media_id`) )
ENGINE = InnoDB
COMMENT = '出稿単価×媒体料率一覧';

SHOW WARNINGS;
CREATE INDEX `i_media` ON `alternative` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payment` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `payment` (
  `date` DATE NOT NULL ,
  `payee_id` INT NOT NULL ,
  `balance` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 ,
  `amount` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`date`, `payee_id`) )
ENGINE = InnoDB
COMMENT = '支払データ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `payee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payee` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `payee` (
  `payee_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL DEFAULT '' ,
  `means` TINYINT NOT NULL DEFAULT 1 COMMENT '支払方法：1（銀行振込）' ,
  `bank_code` VARCHAR(4) NULL COMMENT '銀行コード\n' ,
  `bank_name` VARCHAR(35) NOT NULL DEFAULT '' COMMENT '銀行名' ,
  `branch_code` VARCHAR(4) NULL COMMENT '支店コード' ,
  `branch_name` VARCHAR(15) NOT NULL DEFAULT '' COMMENT '支店名' ,
  `account_type` TINYINT NOT NULL DEFAULT 1 COMMENT '口座種別：1（普通）2（当座）' ,
  `account_number` VARCHAR(7) NOT NULL DEFAULT '' ,
  `account_name_in_kana` VARCHAR(45) NOT NULL DEFAULT '' ,
  `remark` TEXT NULL ,
  `global_payee_id` INT NULL ,
  `is_from_global` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'グローバルから同期されているか' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`payee_id`) )
ENGINE = InnoDB
COMMENT = '支払先';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `charge`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `charge` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `charge` (
  `date` DATE NOT NULL ,
  `advertisement_id` INT NOT NULL ,
  `offer` DECIMAL(9,4) NOT NULL ,
  `amount` INT NOT NULL DEFAULT 0 ,
  `earnings` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `additional_expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`date`, `advertisement_id`, `offer`) )
ENGINE = InnoDB
COMMENT = '請求データ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_proxy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_proxy` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_proxy` (
  `achieve_proxy_id` INT NOT NULL AUTO_INCREMENT ,
  `query_params` TEXT NULL ,
  `forward_time` TIMESTAMP NULL ,
  `attempted` INT NULL DEFAULT 0 ,
  `status` TINYINT NOT NULL DEFAULT 0 ,
  `message` VARCHAR(45) NULL ,
  PRIMARY KEY (`achieve_proxy_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `network`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `network` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `network` (
  `network_id` TINYINT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`network_id`) )
ENGINE = InnoDB
COMMENT = 'openfeint, plus+, GREE Platform for smartphone and etc.';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `distributor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `distributor` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `distributor` (
  `distributor_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(128) NOT NULL ,
  `role` VARCHAR(32) NULL ,
  PRIMARY KEY (`distributor_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_distributor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_distributor` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_distributor` (
  `campaign_id` INT NOT NULL ,
  `distributor_id` INT NOT NULL ,
  `identifier` VARCHAR(45) NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`, `distributor_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `preference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `preference` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `preference` (
  `name` VARCHAR(30) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' COMMENT '機能名' ,
  `value` BIGINT NULL COMMENT '設定値' ,
  PRIMARY KEY (`name`) )
ENGINE = InnoDB
COMMENT = '各種設定値';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_campaign_identifier` ON `preference` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_alternative_to_advertisement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_alternative_to_advertisement` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_alternative_to_advertisement` (
  `media_id` INT NOT NULL ,
  `advertisement_id` INT NOT NULL ,
  `margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `additional_margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `advertisement_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `auth_user_page`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `auth_user_page` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `auth_user_page` (
  `auth_user_id` INT(11) NOT NULL ,
  `auth_page_id` INT(11) NOT NULL ,
  `auth_role_id` INT(11) NOT NULL ,
  PRIMARY KEY (`auth_user_id`, `auth_page_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `auth_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `auth_user` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `auth_user` (
  `auth_user_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `auth_group_id` INT(11) NOT NULL ,
  `account` VARCHAR(128) NOT NULL ,
  `fullname` VARCHAR(32) NOT NULL ,
  `mail` VARCHAR(128) NULL ,
  `del_flg` TINYINT(4) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`auth_user_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 124
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_account` USING BTREE ON `auth_user` (`account` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `auth_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `auth_role` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `auth_role` (
  `auth_role_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `role_name` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`auth_role_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_role_name` USING BTREE ON `auth_role` (`role_name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `auth_page`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `auth_page` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `auth_page` (
  `auth_page_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `page_name` VARCHAR(255) NOT NULL ,
  `url` VARCHAR(255) NOT NULL ,
  `privacy` TINYINT(4) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`auth_page_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 44
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_url` USING BTREE ON `auth_page` (`url` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `auth_group_page`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `auth_group_page` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `auth_group_page` (
  `auth_group_id` INT(11) NOT NULL ,
  `auth_page_id` INT(11) NOT NULL ,
  `auth_role_id` INT(11) NOT NULL ,
  PRIMARY KEY (`auth_group_id`, `auth_page_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `auth_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `auth_group` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `auth_group` (
  `auth_group_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `group_name` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`auth_group_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `group_name` USING BTREE ON `auth_group` (`group_name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `menu` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `menu` (
  `menu_id` TINYINT NOT NULL AUTO_INCREMENT ,
  `type` VARCHAR(9) NOT NULL ,
  `name` VARCHAR(128) NOT NULL ,
  `description` VARCHAR(102) NOT NULL DEFAULT '' ,
  `role` VARCHAR(32) NULL COMMENT '案件取得の条件設定' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`menu_id`) )
ENGINE = InnoDB
COMMENT = 'リワードのユーザー向けメニュー';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_menu` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_menu` (
  `media_id` INT NOT NULL ,
  `position` TINYINT NOT NULL ,
  `menu_id` TINYINT NOT NULL ,
  `is_use_original_img` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0:使用しない 1:使用する' ,
  `default_img_num` TINYINT NOT NULL DEFAULT 1 ,
  `url` VARCHAR(255) NULL ,
  `url_role` VARCHAR(32) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`media_id`, `position`) )
ENGINE = InnoDB
COMMENT = 'メディアごとのメニュー設定';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_history` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_history` (
  `campaign_history_id` INT NOT NULL AUTO_INCREMENT ,
  `updated_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `campaign_id` INT NOT NULL ,
  `auth_user_id` INT NOT NULL ,
  `budget` INT NULL DEFAULT NULL ,
  `allowance` INT NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_history_id`) )
ENGINE = InnoDB
COMMENT = '予算変更履歴';

SHOW WARNINGS;
CREATE INDEX `i_campaign` ON `campaign_history` (`campaign_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `compensation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `compensation` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `compensation` (
  `compensation_id` INT NOT NULL AUTO_INCREMENT ,
  `auth_user_id` INT(11) NOT NULL ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`compensation_id`) )
ENGINE = InnoDB
COMMENT = '補填情報';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `compensation_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `compensation_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `compensation_job` (
  `compensation_job_id` INT NOT NULL AUTO_INCREMENT ,
  `compensation_id` INT NOT NULL ,
  `media_id` INT NOT NULL ,
  `identifier` VARCHAR(255) NOT NULL ,
  `media_param` TEXT NULL DEFAULT NULL ,
  `expenses` INT NULL DEFAULT NULL ,
  `point` INT NULL DEFAULT NULL ,
  `campaign_id` INT NOT NULL ,
  `advertisement_identifier` VARCHAR(255) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' ,
  `status` TINYINT NULL DEFAULT NULL COMMENT 'NULL:未処理 0:失敗 1:処理済' ,
  `achieve_id` VARCHAR(45) NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`compensation_job_id`) )
ENGINE = InnoDB
COMMENT = '補填ジョブ情報';

SHOW WARNINGS;
CREATE INDEX `i_compensation` ON `compensation_job` (`compensation_id` ASC) ;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_media_identifier_campaign_advertisement` ON `compensation_job` (`media_id` ASC, `identifier` ASC, `campaign_id` ASC, `advertisement_identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `job` (
  `target_id` INT NOT NULL ,
  `role` VARCHAR(32) NOT NULL ,
  `priority` TINYINT NOT NULL ,
  `execute_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`target_id`, `role`) )
ENGINE = InnoDB
COMMENT = 'ジョブキュー';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `tag_client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tag_client` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `tag_client` (
  `tag_client_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NULL DEFAULT '' COMMENT 'クライアント名' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`tag_client_id`) )
ENGINE = InnoDB
COMMENT = 'クライアント';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `tag_site`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tag_site` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `tag_site` (
  `tag_site_id` INT NOT NULL AUTO_INCREMENT ,
  `tag_client_id` INT NULL ,
  `name` VARCHAR(255) NULL DEFAULT '' COMMENT 'サイト名' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`tag_site_id`) )
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';

SHOW WARNINGS;
CREATE INDEX `i_tag_client` ON `tag_site` (`tag_client_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `tag_page`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tag_page` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `tag_page` (
  `tag_page_id` INT NOT NULL AUTO_INCREMENT ,
  `tag_site_id` INT NOT NULL ,
  `name` VARCHAR(255) NULL DEFAULT '' COMMENT 'ページ名' ,
  `use_appdriver` TINYINT NULL DEFAULT NULL ,
  `redirect` VARCHAR(255) NULL DEFAULT NULL ,
  `file_name` VARCHAR(69) NULL DEFAULT NULL ,
  `paste_url` VARCHAR(255) NULL DEFAULT NULL ,
  `paste_data` TEXT NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`tag_page_id`) )
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';

SHOW WARNINGS;
CREATE INDEX `i_tag_site` ON `tag_page` (`tag_site_id` ASC) ;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_file_name` ON `tag_page` (`file_name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `logcheck`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `logcheck` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `logcheck` (
  `logcheck_id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `auth_user_id` INT(11) NOT NULL ,
  `site_id` INT NOT NULL ,
  `params` VARCHAR(255) NULL ,
  `role` VARCHAR(32) NOT NULL ,
  `status` TINYINT NULL COMMENT '0:未処理 1:処理完了 2:削除済' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`logcheck_id`) )
ENGINE = InnoDB
COMMENT = 'ログチェック情報';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `payment_for_campaign`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payment_for_campaign` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `payment_for_campaign` (
  `date` DATE NOT NULL ,
  `campaign_id` INT NOT NULL ,
  `additional_payee_id` INT NULL ,
  `additional_earnings` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`date`, `campaign_id`) )
ENGINE = InnoDB
COMMENT = '支払データ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `payment_for_partner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payment_for_partner` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `payment_for_partner` (
  `date` DATE NOT NULL ,
  `partner_id` INT NOT NULL ,
  `payee_id` INT NULL ,
  `expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `additional_payee_id` INT NULL ,
  `additional_expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`date`, `partner_id`) )
ENGINE = InnoDB
COMMENT = '支払データ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `alternative_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `alternative_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `alternative_job` (
  `alternative_job_id` INT NOT NULL AUTO_INCREMENT ,
  `partner_id` INT NULL DEFAULT NULL ,
  `site_id` INT NULL DEFAULT NULL ,
  `campaign_id` INT NULL DEFAULT NULL ,
  `advertisement_id` INT NULL DEFAULT NULL ,
  `media_id` INT NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`alternative_job_id`) )
ENGINE = InnoDB
COMMENT = 'alternativeジョブ情報';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `exception_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exception_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `exception_media` (
  `media_id` INT NOT NULL ,
  `expire` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`media_id`) )
ENGINE = InnoDB
COMMENT = 'ポイントバック除外メディア';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `cross_campaign`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cross_campaign` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `cross_campaign` (
  `cross_campaign_id` INT NOT NULL AUTO_INCREMENT ,
  `site_id` INT NOT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'クロスプロモ名' ,
  `location` VARCHAR(255) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL DEFAULT '' COMMENT 'プロモーションの飛び先' ,
  `start_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `end_time` DATETIME NOT NULL DEFAULT '2020-12-31 23:59:59' ,
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT 'ステータス' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`cross_campaign_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモーション';

SHOW WARNINGS;
CREATE INDEX `i_site` ON `cross_campaign` (`site_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `cross_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cross_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `cross_media` (
  `cross_media_id` INT NOT NULL AUTO_INCREMENT ,
  `media_id` INT NOT NULL ,
  `type` SET('wall','splash') NOT NULL DEFAULT '' COMMENT 'クロスプロモ名' ,
  PRIMARY KEY (`cross_media_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプメディア';

SHOW WARNINGS;
CREATE INDEX `i_media` ON `cross_media` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `cross_campaign_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cross_campaign_category` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `cross_campaign_category` (
  `cross_campaign_id` INT NOT NULL ,
  `category_id` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cross_campaign_id`, `category_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモーションの配信カテゴリ';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `cross_campaign_cross_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cross_campaign_cross_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `cross_campaign_cross_media` (
  `cross_campaign_id` INT NOT NULL ,
  `cross_media_id` INT NOT NULL ,
  `is_affiliated` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '掲載するか' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cross_campaign_id`, `cross_media_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモーションのアプリ掲載可否設定';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `cross_media_cross_campaign`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cross_media_cross_campaign` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `cross_media_cross_campaign` (
  `cross_media_id` INT NOT NULL ,
  `cross_campaign_id` INT NOT NULL ,
  `is_affiliated` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '掲載するか' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cross_media_id`, `cross_campaign_id`) )
ENGINE = InnoDB
COMMENT = 'メディアのクロスプロモーション掲載可否設定';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `stock_impression_of_offer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stock_impression_of_offer` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `stock_impression_of_offer` (
  `campaign_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `default_impression` INT NOT NULL ,
  `stock_impression` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`, `date`) )
ENGINE = InnoDB
COMMENT = '入札枠在庫imp数';

SHOW WARNINGS;
CREATE INDEX `i_date` ON `stock_impression_of_offer` (`date` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `stock_impression`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stock_impression` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `stock_impression` (
  `cross_campaign_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `cross_media_id` INT NOT NULL ,
  `stock_impression` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cross_campaign_id`, `date`, `cross_media_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモ枠在庫imp数';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `impression`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `impression` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `impression` (
  `cross_media_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `wall_id` INT NOT NULL ,
  `impression` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cross_media_id`, `date`, `wall_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモimp数';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `click_of_crosswall`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `click_of_crosswall` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `click_of_crosswall` (
  `click_of_crosswall_id` BIGINT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `cross_media_id` INT NOT NULL ,
  `cross_campaign_id` INT NOT NULL ,
  `identifier` VARCHAR(255) NULL COMMENT 'アプリのユーザー識別子' ,
  `user_agent` VARCHAR(255) NOT NULL DEFAULT '' ,
  `ip` VARCHAR(15) NOT NULL DEFAULT '' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`click_of_crosswall_id`, `date`) )
ENGINE = InnoDB
COMMENT = 'クリック履歴';

SHOW WARNINGS;
CREATE INDEX `i_media_identifier` ON `click_of_crosswall` (`cross_media_id` ASC, `identifier` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `report_by_wall`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `report_by_wall` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `report_by_wall` (
  `report_id` BIGINT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `media_id` INT NOT NULL ,
  `campaign_id` INT NOT NULL ,
  `wall_id` INT NOT NULL ,
  `view` INT NOT NULL DEFAULT 0 ,
  `click` INT NOT NULL DEFAULT 0 ,
  `achieve` INT NOT NULL DEFAULT 0 ,
  `earnings` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 COMMENT '収入' ,
  `additional_earnings` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 ,
  `expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 COMMENT '支出（メディア分）' ,
  `additional_expenses` DECIMAL(13,4) NOT NULL DEFAULT 0.0000 COMMENT '支出（代理店分）' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`report_id`) )
ENGINE = InnoDB
COMMENT = 'レポート・ウォール別';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_date_media_campaign_wall` ON `report_by_wall` (`date` ASC, `media_id` ASC, `campaign_id` ASC, `wall_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_campaign` ON `report_by_wall` (`campaign_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `report_of_crosswall`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `report_of_crosswall` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `report_of_crosswall` (
  `report_id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATE NOT NULL ,
  `cross_media_id` INT NOT NULL ,
  `cross_campaign_id` INT NOT NULL ,
  `impression` INT NOT NULL DEFAULT 0 ,
  `stock_impression` INT NOT NULL DEFAULT 0 COMMENT '配信imp' ,
  `click` INT NOT NULL DEFAULT 0 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`report_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモーションレポート';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_date_media_campaign` ON `report_of_crosswall` (`date` ASC, `cross_media_id` ASC, `cross_campaign_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_to_forward_backup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_to_forward_backup` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_to_forward_backup` (
  `achieve_to_forward_id` INT NOT NULL AUTO_INCREMENT ,
  `achieve_id` CHAR(36) NOT NULL ,
  `forward_time` TIMESTAMP NULL ,
  `attempted` TINYINT NULL COMMENT '通知失敗回数' ,
  `message` VARCHAR(45) NULL ,
  PRIMARY KEY (`achieve_to_forward_id`) )
ENGINE = InnoDB
COMMENT = '成果履歴（通知待ちで再送回数が上限に達したもの）';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_achieve` ON `achieve_to_forward_backup` (`achieve_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_forward_time` ON `achieve_to_forward_backup` (`forward_time` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `alternative_of_crosswall`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `alternative_of_crosswall` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `alternative_of_crosswall` (
  `cross_campaign_id` INT NOT NULL ,
  `cross_media_id` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cross_campaign_id`, `cross_media_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモ掲載';

SHOW WARNINGS;
CREATE INDEX `i_cross_media` ON `alternative_of_crosswall` (`cross_media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `alternative_of_crosswall_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `alternative_of_crosswall_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `alternative_of_crosswall_job` (
  `alternative_of_crosswall_job_id` INT NOT NULL AUTO_INCREMENT ,
  `partner_id` INT NULL DEFAULT NULL ,
  `site_id` INT NULL DEFAULT NULL ,
  `cross_campaign_id` INT NULL DEFAULT NULL ,
  `cross_media_id` INT NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`alternative_of_crosswall_job_id`) )
ENGINE = InnoDB
COMMENT = 'alternative_of_crosswallジョブ情報';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `stock_impression_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stock_impression_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `stock_impression_job` (
  `stock_impression_job_id` INT NOT NULL AUTO_INCREMENT ,
  `cross_campaign_id` INT NULL DEFAULT NULL ,
  `cross_media_id` INT NULL DEFAULT NULL ,
  `target_date` DATE NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`stock_impression_job_id`) )
ENGINE = InnoDB
COMMENT = 'stock_impressionジョブ情報';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `impression_of_offer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `impression_of_offer` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `impression_of_offer` (
  `campaign_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `wall_id` INT NOT NULL ,
  `impression` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`, `date`, `wall_id`) )
ENGINE = InnoDB
COMMENT = '入札枠imp数';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `stock_impression_of_offer_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stock_impression_of_offer_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `stock_impression_of_offer_job` (
  `stock_impression_of_offer_job_id` INT NOT NULL AUTO_INCREMENT ,
  `campaign_id` INT NULL DEFAULT NULL ,
  `target_date` DATE NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`stock_impression_of_offer_job_id`) )
ENGINE = InnoDB
COMMENT = 'stock_impression_of_offerジョブ情報';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `click_of_wall`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `click_of_wall` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `click_of_wall` (
  `click_id` BIGINT NOT NULL ,
  `date` DATE NOT NULL ,
  `wall_id` INT NOT NULL ,
  PRIMARY KEY (`click_id`, `date`) )
ENGINE = InnoDB
COMMENT = 'クリック履歴';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `wall`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `wall` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `wall` (
  `wall_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`wall_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `stock_impression_of_partner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stock_impression_of_partner` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `stock_impression_of_partner` (
  `partner_id` INT NOT NULL ,
  `stock_impression` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`partner_id`) )
ENGINE = InnoDB
COMMENT = 'クロスプロモ枠在庫imp数';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `advertisement_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `advertisement_history` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `advertisement_history` (
  `advertisement_history_id` INT NOT NULL AUTO_INCREMENT ,
  `advertisement_id` INT NOT NULL ,
  `auth_user_id` INT NOT NULL ,
  `offer` INT NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`advertisement_history_id`) )
ENGINE = InnoDB
COMMENT = 'グロス単価変更履歴';

SHOW WARNINGS;
CREATE INDEX `i_advertisement` ON `advertisement_history` (`advertisement_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `map_by_cookie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `map_by_cookie` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `map_by_cookie` (
  `cookie_identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL ,
  `site_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL COMMENT 'identifier of first achieve' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`cookie_identifier`, `site_id`, `date`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'map data from cookie identifier';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `map_by_identifier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `map_by_identifier` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `map_by_identifier` (
  `subsequent_identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL ,
  `site_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL COMMENT 'identifier of first achieve' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`subsequent_identifier`, `site_id`, `date`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'map data from subsequent identifier';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_distributor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_distributor` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_distributor` (
  `media_id` INT NOT NULL ,
  `distributor_id` INT NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `promote_mail_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `promote_mail_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `promote_mail_job` (
  `promote_mail_job_id` INT NOT NULL AUTO_INCREMENT ,
  `campaign_id` INT NOT NULL ,
  `auth_user_id` INT(11) NOT NULL ,
  `executed_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `results` TEXT NULL ,
  `snapshot` TEXT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`promote_mail_job_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_as_payor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_as_payor` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_as_payor` (
  `campaign_id` INT NOT NULL ,
  `trader_identifier` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '取引先ID' ,
  `trader_contact_identifier` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '取引先担当者ID' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`campaign_id`) )
ENGINE = InnoDB
COMMENT = 'プロモーション毎の取引先';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `logcheck_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `logcheck_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `logcheck_job` (
  `logcheck_id` INT NOT NULL ,
  `execute_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`logcheck_id`) )
ENGINE = InnoDB
COMMENT = 'ログチェックのジョブキュー';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_agency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_agency` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_agency` (
  `media_agency_id` TINYINT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(15) NOT NULL ,
  PRIMARY KEY (`media_agency_id`) )
ENGINE = InnoDB
COMMENT = 'メディア側代理店';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `extract_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `extract_detail` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `extract_detail` (
  `extract_detail_id` INT NOT NULL AUTO_INCREMENT ,
  `auth_user_id` INT(11) NOT NULL ,
  `start_date` DATE NOT NULL ,
  `end_date` DATE NOT NULL ,
  `role` VARCHAR(32) NOT NULL ,
  `campaign_id` INT NULL DEFAULT NULL ,
  `media_id` INT NULL DEFAULT NULL ,
  `accept_state` TINYINT(1) NULL DEFAULT NULL ,
  `params` TEXT NULL ,
  `output_columns` TEXT NULL ,
  `status` TINYINT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`extract_detail_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `extract_detail_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `extract_detail_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `extract_detail_job` (
  `extract_detail_id` INT NOT NULL ,
  `execute_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`extract_detail_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `summary_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `summary_detail` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `summary_detail` (
  `summary_detail_id` INT NOT NULL AUTO_INCREMENT ,
  `auth_user_id` INT(11) NOT NULL ,
  `start_datetime` DATETIME NOT NULL ,
  `end_datetime` DATETIME NOT NULL ,
  `name` VARCHAR(32) NULL ,
  `role` VARCHAR(32) NOT NULL ,
  `params` TEXT NULL DEFAULT NULL ,
  `output_columns` TEXT NULL DEFAULT NULL ,
  `status` TINYINT NULL DEFAULT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`summary_detail_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `job_for_summary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `job_for_summary` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `job_for_summary` (
  `summary_detail_id` INT NOT NULL ,
  `execute_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`summary_detail_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_change_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_change_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_change_job` (
  `achieve_change_job_id` INT NOT NULL AUTO_INCREMENT ,
  `is_searched` TINYINT NULL DEFAULT 0 ,
  `is_executed` TINYINT NULL DEFAULT 0 ,
  `search_time` DATETIME NULL ,
  `execute_time` DATETIME NULL ,
  PRIMARY KEY (`achieve_change_job_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_change_condition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_change_condition` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_change_condition` (
  `achieve_change_job_id` INT(11) NOT NULL ,
  `site_id` INT(11) NOT NULL ,
  `advertisement_identifier` VARCHAR(255) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' ,
  `achieve_change_search_type_id` INT(11) NOT NULL ,
  `auth_user_id` INT(11) NOT NULL ,
  `is_earnings` TINYINT(1) NULL DEFAULT 0 ,
  `is_expenses` TINYINT(1) NULL DEFAULT 0 ,
  `change_earnings` DECIMAL(9,4) NULL ,
  `change_additional_earnings` DECIMAL(9,4) NULL ,
  `change_expenses` DECIMAL(9,4) NULL ,
  `start_accepted_time` DATETIME NOT NULL ,
  `end_accepted_time` DATETIME NOT NULL ,
  `file_name` VARCHAR(255) NOT NULL ,
  `search_data` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`achieve_change_job_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_change_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_change_data` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_change_data` (
  `achieve_change_job_id` INT(11) NOT NULL ,
  `achieve_id` CHAR(36) NOT NULL ,
  `status` TINYINT(1) NULL DEFAULT 0 ,
  `before_earnings` DECIMAL(9,4) NULL ,
  `before_additional_earnings` DECIMAL(9,4) NULL ,
  `before_expenses` DECIMAL(9,4) NULL ,
  `after_earnings` DECIMAL(9,4) NULL ,
  `after_expenses` DECIMAL(9,4) NULL ,
  `after_additional_earnings` DECIMAL(9,4) NULL ,
  PRIMARY KEY (`achieve_change_job_id`, `achieve_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_change_search_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_change_search_type` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_change_search_type` (
  `achieve_change_search_type_id` INT NOT NULL ,
  `name` VARCHAR(45) NULL ,
  `value` VARCHAR(45) NULL ,
  PRIMARY KEY (`achieve_change_search_type_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `premium_for_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `premium_for_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `premium_for_media` (
  `media_id` INT(11) NOT NULL COMMENT '景表法対応メディア' ,
  `premium_id` TINYINT(4) NOT NULL COMMENT '景表法ID' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '記入時間' ,
  PRIMARY KEY (`media_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `premium`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `premium` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `premium` (
  `premium_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '景表法ID' ,
  `name` VARCHAR(32) NOT NULL COMMENT '景表法名前' ,
  `role` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`premium_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `api_access`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `api_access` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `api_access` (
  `media_id` INT NOT NULL ,
  `platform_id` INT NOT NULL DEFAULT 0 ,
  `ip` VARCHAR(15) NOT NULL ,
  `date_time` DATETIME NOT NULL ,
  `number_of_accesses` INT NOT NULL DEFAULT 0 ,
  `request_available_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`media_id`, `ip`, `date_time`, `platform_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `model`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `model` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `model` (
  `model_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `carrier_id` INT NOT NULL ,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`model_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_name_carrier` ON `model` (`name` ASC, `carrier_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `holiday`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `holiday` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `holiday` (
  `date` DATE NOT NULL ,
  PRIMARY KEY (`date`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `map_by_media_identifier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `map_by_media_identifier` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `map_by_media_identifier` (
  `subsequent_identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL ,
  `identifier` VARCHAR(64) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL COMMENT 'identifier of first achieve' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`subsequent_identifier`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci
COMMENT = 'map data from cookie identifier';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `param_of_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `param_of_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `param_of_media` (
  `param_of_media_id` INT NOT NULL AUTO_INCREMENT ,
  `media_id` INT NOT NULL ,
  `name` VARCHAR(255) NOT NULL COMMENT '受け取る個別パラメータ名' ,
  `is_pointback_available` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'ポイントバッグ時のURLにパラメータをつけるかのフラグ' ,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '登録パラメータの論理削除' ,
  PRIMARY KEY (`param_of_media_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_media` ON `param_of_media` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `click_param_of_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `click_param_of_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `click_param_of_media` (
  `click_id` BIGINT NOT NULL ,
  `param_of_media_id` INT NOT NULL ,
  `value` VARCHAR(255) NULL COMMENT '個別パラメータの値' ,
  PRIMARY KEY (`click_id`, `param_of_media_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sms_authentication`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sms_authentication` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `sms_authentication` (
  `sms_authentication_id` INT NOT NULL AUTO_INCREMENT ,
  `tel` VARCHAR(64) NOT NULL ,
  `is_accepted` TINYINT(1) NOT NULL DEFAULT 0 ,
  `code` VARCHAR(4) NOT NULL ,
  PRIMARY KEY (`sms_authentication_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `i_tel` ON `sms_authentication` (`tel` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sms_authentication_times`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sms_authentication_times` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `sms_authentication_times` (
  `sms_authentication_id` INT NOT NULL ,
  `date` DATE NOT NULL ,
  `times_by_sms` TINYINT NOT NULL DEFAULT 0 ,
  `times_by_tel` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`sms_authentication_id`, `date`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `job_for_achieve_finalize`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `job_for_achieve_finalize` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `job_for_achieve_finalize` (
  `job_for_achieve_finalize_id` INT NOT NULL AUTO_INCREMENT ,
  `achieve_id` CHAR(36) NOT NULL ,
  `date` DATE NOT NULL ,
  `execute_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`job_for_achieve_finalize_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_achieve` ON `job_for_achieve_finalize` (`achieve_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_execute_time` ON `job_for_achieve_finalize` (`execute_time` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `job_for_report`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `job_for_report` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `job_for_report` (
  `target_id` INT NOT NULL COMMENT 'ターゲットID' ,
  `role` VARCHAR(32) NOT NULL COMMENT '実行するジョブのロール名(実行されるのはTachyon::Schema::Role::JobForReport::ロール名)' ,
  `priority` TINYINT NOT NULL COMMENT '優先度（高いほど高い数値になる）\n' ,
  `status` TINYINT(1) NULL DEFAULT 0 COMMENT 'ステータス(0:未実行 2:失敗)\n' ,
  `execute_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '実行時間' ,
  PRIMARY KEY (`target_id`, `role`) )
ENGINE = InnoDB
COMMENT = 'レポート専用ジョブキュー';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `notice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `notice` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `notice` (
  `category` VARCHAR(32) NOT NULL ,
  `text` TEXT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`category`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `budget`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `budget` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `budget` (
  `budget_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `campaign_id` INT(11) NOT NULL ,
  `start_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `end_time` DATETIME NOT NULL DEFAULT '2030-12-31 23:59:59' ,
  `budget` INT(11) NOT NULL DEFAULT 0 COMMENT '予算' ,
  `spending` INT(11) NOT NULL DEFAULT 0 COMMENT '消化した予算' ,
  `allowance` INT(11) NOT NULL DEFAULT 0 COMMENT '掲載停止残高' ,
  `is_available` TINYINT(1) NOT NULL DEFAULT 1 ,
  `last_achieve_time` DATETIME NULL COMMENT '最終アクション日時' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`budget_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_campaign` ON `budget` (`campaign_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `budget_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `budget_history` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `budget_history` (
  `budget_history_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `budget_id` INT(11) NOT NULL ,
  `campaign_id` INT(11) NOT NULL ,
  `start_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `end_time` DATETIME NOT NULL DEFAULT '2030-12-31 23:59:59' ,
  `budget` INT(11) NULL DEFAULT NULL ,
  `allowance` INT(11) NULL DEFAULT NULL ,
  `auth_user_id` INT(11) NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`budget_history_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_campaign` ON `budget_history` (`campaign_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_budget` ON `budget_history` (`budget_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `eight_range`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eight_range` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `eight_range` (
  `eight_range_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `minimum_gross_rate` INT(11) NOT NULL COMMENT '最小換金単位' ,
  `provider_key` VARCHAR(255) NOT NULL ,
  `secret_key` VARCHAR(255) NOT NULL COMMENT 'HMAC-SHA1で使うシークレットキー' ,
  `access_key_id` VARCHAR(255) NOT NULL COMMENT 'Amazon S3のAccessKeyID' ,
  `secret_access_key` VARCHAR(255) NOT NULL COMMENT 'Amazon S3のSecretAccessKey' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '入力成果データの処理が完了したときに更新される。' ,
  PRIMARY KEY (`eight_range_id`) )
ENGINE = InnoDB
COMMENT = 'Eight案件の換金単位を表す。';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_type` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_type` (
  `ow_type_id` INT NOT NULL AUTO_INCREMENT COMMENT 'OWタイプID' ,
  `name` VARCHAR(255) NOT NULL COMMENT 'OWタイプ名（ただし、APPDRIVERというキーワードは使わないでください。リジェクトされます。）' ,
  `url_path` TEXT NOT NULL COMMENT '遷移先の相対パス(パラメータで入れたい場合は[site_id]という形で区切る)' ,
  PRIMARY KEY (`ow_type_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `name_UNIQUE` ON `ow_type` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `param_of_ow_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `param_of_ow_type` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `param_of_ow_type` (
  `ow_type_id` INT NOT NULL ,
  `param_of_ow_type_id` INT NOT NULL COMMENT 'パラメータOWID' ,
  `name` VARCHAR(255) NOT NULL COMMENT 'パラメータ名' ,
  PRIMARY KEY (`ow_type_id`, `param_of_ow_type_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `feature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `feature` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `feature` (
  `feature_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '特集ID' ,
  `name` VARCHAR(255) NOT NULL COMMENT '特集名' ,
  `person_in_charge` VARCHAR(255) NULL DEFAULT NULL COMMENT '担当者' ,
  `layout_pattern` TINYINT(3) NOT NULL DEFAULT '1' COMMENT '1：通常、2：特殊' ,
  `special_point_name` VARCHAR(255) NULL DEFAULT NULL COMMENT 'layout_pattern=2の場合のみ' ,
  `display_pattern` TINYINT(3) NOT NULL DEFAULT '1' COMMENT '1：複数案件、2：1案件' ,
  `start_time` DATETIME NOT NULL COMMENT '配信From' ,
  `end_time` DATETIME NOT NULL COMMENT '配信To' ,
  `is_disabled_text` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1：非表示、0：表示' ,
  `text_content` VARCHAR(255) NULL DEFAULT NULL COMMENT 'テキスト広告表示テキスト' ,
  `is_disabled_special_banner` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1：非表示、0：表示' ,
  `is_disabled_tab_menu` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1：非表示、0：表示' ,
  `tab_menu_content` VARCHAR(255) NULL DEFAULT NULL COMMENT 'タブメニュー表示テキスト' ,
  `is_disabled_header_banner` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1：非表示、0：表示' ,
  `campaign_setting_type` TINYINT(3) NOT NULL DEFAULT '1' COMMENT '1：サンクスカテゴリ指定、2：プロモID指定' ,
  `requisite_id` INT(11) NOT NULL DEFAULT '0' COMMENT 'サンクスカテゴリ' ,
  `campaign_ids` TEXT NULL DEFAULT NULL COMMENT 'プロモIDリスト' ,
  `is_disabled_gross_limit` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0：OFF、1：ON' ,
  `gross_limit_from` INT(11) NULL DEFAULT NULL COMMENT 'グロス金額From' ,
  `gross_limit_to` INT(11) NULL DEFAULT NULL COMMENT 'グロス金額To' ,
  `media_setting_type` TINYINT(3) NOT NULL DEFAULT '1' COMMENT '1：メディアID指定、2：サンクスカテゴリ指定' ,
  `category_ids` TEXT NULL DEFAULT NULL COMMENT 'カテゴリIDをカンマ区切り' ,
  `media_ids` TEXT NULL DEFAULT NULL COMMENT 'メディアIDをカンマ区切り' ,
  `color_of_header` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `color_of_background` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `color_of_font` VARCHAR(255) NOT NULL DEFAULT '000000' COMMENT 'フォントカラー' ,
  `color_of_frame` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `color_of_detail_button` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1：非表示、0：表示' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`feature_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `feature_advertisement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `feature_advertisement` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `feature_advertisement` (
  `feature_id` INT(11) NOT NULL COMMENT '特集ID' ,
  `campaign_id` INT(11) NOT NULL COMMENT 'campaignID' ,
  `advertisement_id` INT(11) NOT NULL COMMENT 'advertisementID' ,
  `priority` INT(11) NOT NULL COMMENT '掲載順' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`feature_id`, `advertisement_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;
CREATE INDEX `i_campaign_id` ON `feature_advertisement` (`campaign_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `feature_alternative_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `feature_alternative_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `feature_alternative_job` (
  `feature_alternative_job_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'AlternativeID' ,
  `target_id` INT(11) NULL DEFAULT NULL COMMENT 'ターゲットID' ,
  `partner_id` INT(11) NULL DEFAULT NULL COMMENT 'パートナーID' ,
  `site_id` INT(11) NULL DEFAULT NULL COMMENT 'アプリID' ,
  `feature_id` INT(11) NULL DEFAULT NULL COMMENT '特集ID' ,
  `media_id` INT(11) NULL DEFAULT NULL COMMENT 'メディアID' ,
  `campaign_id` INT(11) NULL DEFAULT NULL COMMENT 'campaignID' ,
  `advertisement_id` INT(11) NULL DEFAULT NULL COMMENT 'advertisement_id' ,
  `priority` INT(11) NOT NULL DEFAULT '1' COMMENT '掲載順' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`feature_alternative_job_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `feature_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `feature_media` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `feature_media` (
  `feature_id` INT(11) NOT NULL COMMENT '特集ID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '1' COMMENT '1：非表示、0：表示' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`feature_id`, `media_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `feature_media_customize`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `feature_media_customize` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `feature_media_customize` (
  `feature_media_customize_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '特集メディアID' ,
  `feature_id` INT(11) NOT NULL COMMENT '特集ID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `is_custom_header_banner` TINYINT(1) NOT NULL DEFAULT '0' ,
  `is_custom_special_banner` TINYINT(1) NOT NULL DEFAULT '0' ,
  `is_custom_text_content` TINYINT(1) NOT NULL DEFAULT '0' ,
  `text_content` VARCHAR(255) NULL DEFAULT NULL COMMENT 'カスタマイズテキスト広告表示テキスト' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`feature_media_customize_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `image` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `image` (
  `image_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'イメージID' ,
  `type` VARCHAR(255) NOT NULL COMMENT 'イメージタイプ' ,
  `target_id` INT(11) NOT NULL COMMENT 'ターゲットID' ,
  `name` VARCHAR(255) NOT NULL COMMENT 'ファイル名' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1:無効、0:有効' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`image_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;
CREATE INDEX `i_target_id_type` ON `image` (`target_id` ASC, `type` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `job_for_feature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `job_for_feature` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `job_for_feature` (
  `target_id` INT(11) NOT NULL COMMENT 'ターゲットID' ,
  `priority` TINYINT(4) NOT NULL DEFAULT '1' COMMENT '優先度（高いほど高い数値になる）' ,
  `status` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0:未実行 2:失敗' ,
  `execute_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'execute_time' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`target_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow` (
  `ow_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'OW ID' ,
  `media_id` INT(11) NOT NULL COMMENT 'MediaID' ,
  `layout_pattern` TINYINT(3) NOT NULL DEFAULT '1' COMMENT '1：通常、2：特殊' ,
  `special_point_name` VARCHAR(255) NULL DEFAULT NULL COMMENT '例：100ハート回復' ,
  `is_disabled_text` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `is_disabled_special_banner` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `is_disabled_header_banner` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `is_disabled_footer_banner` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `color_of_header` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `color_of_background` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `color_of_font` VARCHAR(255) NOT NULL DEFAULT '000000' COMMENT 'フォントカラー' ,
  `color_of_frame` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `color_of_detail_button` INT(11) NOT NULL DEFAULT '1' COMMENT 'ow_template_colorのカラーナンバー' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_media_id` ON `ow` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_menu` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_menu` (
  `ow_menu_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'メニューID' ,
  `type` VARCHAR(255) NOT NULL COMMENT 'requisite, category' ,
  `name` VARCHAR(255) NOT NULL COMMENT 'メニュー名' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_menu_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_menu_order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_menu_order` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_menu_order` (
  `ow_menu_order_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'OWメニューID' ,
  `ow_menu_id` INT(11) NOT NULL COMMENT 'メニューID' ,
  `priority` INT(11) NOT NULL DEFAULT '1' COMMENT '掲載順' ,
  `target_id` INT(11) NOT NULL COMMENT 'requisite_id' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_menu_order_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_special_banner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_special_banner` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_special_banner` (
  `ow_special_banner_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'スペシャルバナーID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `type` VARCHAR(255) NOT NULL COMMENT '特集ID:feature、メニューID:menu、URL指定:url、Eight指定:eight' ,
  `target_id` INT(11) NOT NULL COMMENT 'メニューID or EightID 1:デフォルト1、2:デフォルト2, 3:オリジナル画像' ,
  `url` TEXT NULL DEFAULT NULL COMMENT 'typeがURL指定の場合、URLが入る' ,
  `start_time` DATETIME NOT NULL COMMENT '期間From' ,
  `end_time` DATETIME NOT NULL COMMENT '期間To' ,
  `priority` INT(11) NOT NULL COMMENT '掲載順' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_special_banner_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_tab_menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_tab_menu` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_tab_menu` (
  `ow_tab_menu_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'owタブメニューID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `type` VARCHAR(255) NOT NULL COMMENT '特集ID:feature、メニューID:menu' ,
  `menu_id` INT(11) NOT NULL COMMENT 'tab_typeがmenuの場合：1から10' ,
  `start_time` DATETIME NOT NULL COMMENT '期間From' ,
  `end_time` DATETIME NOT NULL COMMENT '期間To' ,
  `priority` INT(11) NOT NULL COMMENT '掲載順' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_tab_menu_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_template_color`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_template_color` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_template_color` (
  `ow_template_color_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ow_template_color_id' ,
  `color_type` VARCHAR(255) NOT NULL COMMENT 'header_frame, background, detail_button' ,
  `color_type_id` INT(11) NOT NULL DEFAULT '1' COMMENT 'カラーナンバー' ,
  `name` VARCHAR(255) NULL DEFAULT NULL COMMENT 'カラー名' ,
  `color_of_main` VARCHAR(255) NULL DEFAULT NULL COMMENT 'color_1(明るい色)' ,
  `color_of_sub` VARCHAR(255) NULL DEFAULT NULL COMMENT 'color_2(暗い色)' ,
  `color_of_shadow` VARCHAR(255) NULL DEFAULT NULL COMMENT 'color_3(影)' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_template_color_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ow_text`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ow_text` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ow_text` (
  `ow_text_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'テキスト広告ID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `content` TEXT NULL DEFAULT NULL COMMENT '広告テキスト' ,
  `type` VARCHAR(255) NOT NULL COMMENT '特集ID:feature、メニューID:menu、URL指定:url、Eight指定:eight' ,
  `target_id` INT(11) NOT NULL COMMENT 'メニューID' ,
  `url` TEXT NULL DEFAULT NULL COMMENT 'typeがURL指定の場合、URLが入る' ,
  `start_time` DATETIME NOT NULL COMMENT '期間From' ,
  `end_time` DATETIME NOT NULL COMMENT '期間To' ,
  `priority` INT(11) NOT NULL COMMENT '掲載順' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1：非表示、0：表示' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`ow_text_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_layout_custom`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_layout_custom` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_layout_custom` (
  `media_id` INT(11) NOT NULL ,
  `custom_position` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'カスタマイズする場所' ,
  `content` TEXT NOT NULL COMMENT 'カスタマイズする内容' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`media_id`, `custom_position`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'OWのカスタマイズ情報を保持するテーブル';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ip_of_supplier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ip_of_supplier` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `ip_of_supplier` (
  `ip_of_supplier_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `supplier_id` INT(11) NOT NULL COMMENT '連携先' ,
  `ip` VARCHAR(18) NOT NULL COMMENT 'IPアドレス' ,
  `is_cidr` TINYINT NOT NULL COMMENT '0:IPアドレス,1:CIDR' ,
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '0:無効,1:有効' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最終更新日時' ,
  `auth_user_id` INT(11) NOT NULL COMMENT '最終更新者' ,
  PRIMARY KEY (`ip_of_supplier_id`) )
ENGINE = InnoDB
COMMENT = 'サプライヤーIP(ホワイトリスト)';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_supplier_ip` ON `ip_of_supplier` (`supplier_id` ASC, `ip` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_history` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_history` (
  `media_history_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `exchange_reservation_id` INT(11) NULL DEFAULT NULL COMMENT 'ポイントバック率予約ID' ,
  `updated_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '変更日' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `start_time` DATETIME NULL DEFAULT NULL COMMENT 'ポイントバック率予約開始時間' ,
  `end_time` DATETIME NULL DEFAULT NULL COMMENT 'ポイントバック率予約終了時間' ,
  `auth_user_id` INT(11) NOT NULL COMMENT '変更者' ,
  `margin` DECIMAL(5,4) NULL DEFAULT NULL COMMENT 'メディアマージン' ,
  `exchange` DECIMAL(7,4) NULL DEFAULT NULL COMMENT 'ポイントバック率' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最終更新日時' ,
  PRIMARY KEY (`media_history_id`) )
ENGINE = InnoDB
COMMENT = 'メディア変更履歴';

SHOW WARNINGS;
CREATE INDEX `i_media` ON `media_history` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `request_sql`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `request_sql` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `request_sql` (
  `request_sql_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL COMMENT 'タイトル' ,
  `statement` TEXT NOT NULL COMMENT 'SQL文' ,
  `display_type` TINYINT NOT NULL COMMENT '1: プロモ側 2: リワード側' ,
  `summarize_type` TINYINT NOT NULL COMMENT '0: なし 1: 日別 2:月別' ,
  `is_available` TINYINT NOT NULL DEFAULT 1 COMMENT '0: 停止 1: 稼働 ' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最終更新日時' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成日時' ,
  PRIMARY KEY (`request_sql_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `special_margin_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `special_margin_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `special_margin_job` (
  `special_margin_job_id` INT NOT NULL AUTO_INCREMENT ,
  `target` VARCHAR(255) NOT NULL COMMENT '特別マージンを設定する対象のスキーマ名' ,
  `special_margin_id` INT(11) NOT NULL COMMENT '対象の特別マージンID' ,
  `target_id` INT(11) NOT NULL DEFAULT 0 COMMENT 'jobと紐付けるID' ,
  `execute_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `auth_user_id` INT(11) NOT NULL COMMENT 'Jobの登録者' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`special_margin_job_id`) )
ENGINE = InnoDB
COMMENT = '特マの予約･解除Job';

SHOW WARNINGS;
CREATE INDEX `i_job` ON `special_margin_job` (`target_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `special_margin_to_advertisement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `special_margin_to_advertisement` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `special_margin_to_advertisement` (
  `special_margin_to_advertisement_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `media_id` INT(11) NOT NULL ,
  `advertisement_id` INT(11) NOT NULL ,
  `margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `additional_margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `start_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `end_time` DATETIME NOT NULL DEFAULT '2030-12-31 23:59:59' ,
  `status` TINYINT(4) NOT NULL DEFAULT 1 COMMENT '1:予約, 2:反映中, 3:終了, 4:キャンセル, 5:中断' ,
  `create_user` INT(11) NOT NULL COMMENT '登録者のauth_user_id' ,
  `edit_user` INT(11) NULL COMMENT '変更者のauth_user_id' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`special_margin_to_advertisement_id`) )
ENGINE = InnoDB
COMMENT = 'サンクスに対する特マ予約兼履歴';

SHOW WARNINGS;
CREATE INDEX `i_media` ON `special_margin_to_advertisement` (`media_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_advertisement` ON `special_margin_to_advertisement` (`advertisement_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_start_time` ON `special_margin_to_advertisement` (`start_time` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_end_time` ON `special_margin_to_advertisement` (`end_time` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_status` ON `special_margin_to_advertisement` (`status` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `special_margin_to_partner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `special_margin_to_partner` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `special_margin_to_partner` (
  `special_margin_to_partner_id` INT NOT NULL AUTO_INCREMENT ,
  `media_id` INT(11) NOT NULL ,
  `partner_id` INT(11) NOT NULL ,
  `margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `additional_margin` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 ,
  `start_time` DATETIME NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `end_time` DATETIME NOT NULL DEFAULT '2030-12-31 23:59:59' ,
  `status` TINYINT(4) NOT NULL DEFAULT 1 COMMENT '1:予約, 2:反映中, 3:終了, 4:キャンセル, 5:中断' ,
  `create_user` INT(11) NOT NULL COMMENT '登録者のauth_user_id' ,
  `edit_user` INT(11) NULL COMMENT '変更者のauth_user_id' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`special_margin_to_partner_id`) )
ENGINE = InnoDB
COMMENT = 'パートナーに対する特マ予約兼履歴';

SHOW WARNINGS;
CREATE INDEX `i_media` ON `special_margin_to_partner` (`media_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_partner` ON `special_margin_to_partner` (`partner_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_start_time` ON `special_margin_to_partner` (`start_time` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_end_time` ON `special_margin_to_partner` (`end_time` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_status` ON `special_margin_to_partner` (`status` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `exchange_reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exchange_reservation` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `exchange_reservation` (
  `exchange_reservation_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `media_id` INT(11) NOT NULL ,
  `start_time` DATETIME NOT NULL COMMENT '開始日時' ,
  `end_time` DATETIME NOT NULL COMMENT '終了日時' ,
  `exchange` DECIMAL(7,4) NOT NULL COMMENT 'ポイントバック率' ,
  `auth_user_id` INT(11) NOT NULL COMMENT '登録者' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最終更新日時' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成日時' ,
  PRIMARY KEY (`exchange_reservation_id`) )
ENGINE = InnoDB
COMMENT = 'ポイントバック率予約';

SHOW WARNINGS;
CREATE INDEX `i_media_id` ON `exchange_reservation` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bonus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bonus` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `bonus` (
  `bonus_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ボーナス特集ID' ,
  `feature_id` INT(11) NOT NULL COMMENT '特集ID' ,
  `is_special_margin` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0：設定無し,1：設定有り' ,
  `banner_size_type` TINYINT(2) NOT NULL DEFAULT 1 COMMENT '1：W640 × H100px ,2：W640 × H100px' ,
  `is_original_banner` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0：スタンダード,1：オリジナル' ,
  `banner_text` VARCHAR(64) NULL COMMENT 'ボーナスバナー内紹介(スタンダードのみ使用)' ,
  `banner_under_text` VARCHAR(45) NULL COMMENT 'ボーナスバナー内紹介(スタンダードのみ使用、バナーの高さが200pxのみ使用)' ,
  `text_of_api_media` VARCHAR(255) NULL COMMENT 'APIメディア掲載用テキスト' ,
  `advertisement_ids` TEXT NULL COMMENT 'サンクスID一覧' ,
  PRIMARY KEY (`bonus_id`) )
ENGINE = InnoDB
COMMENT = 'ボーナス特集用テーブル';

SHOW WARNINGS;
CREATE INDEX `i_feature_id` ON `bonus` (`feature_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bonus_advertisement_appeal_text`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bonus_advertisement_appeal_text` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `bonus_advertisement_appeal_text` (
  `bonus_id` INT(11) NOT NULL COMMENT 'ボーナス特集ID' ,
  `advertisement_id` INT(11) NOT NULL COMMENT 'サンクスID' ,
  `bonus_appeal_text_id` INT(11) NOT NULL COMMENT 'ボーナスアピールテキストID' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`bonus_id`, `advertisement_id`) )
ENGINE = InnoDB
COMMENT = 'ボーナス特集に紐づくサンクスとアイコンの管理';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bonus_appeal_text`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bonus_appeal_text` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `bonus_appeal_text` (
  `bonus_appeal_text_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ボーナスアピールテキストID' ,
  `ow_template_color_id` INT(11) NOT NULL DEFAULT 1 COMMENT 'テキストの文字色' ,
  `name` VARCHAR(36) NOT NULL COMMENT 'ボーナスアピール名' ,
  `display_text` VARCHAR(36) NOT NULL COMMENT '表示内容' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新スタンプタイム' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`bonus_appeal_text_id`) )
ENGINE = InnoDB
COMMENT = '各サンクスのボーナス内容';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bonus_promote_mail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bonus_promote_mail` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `bonus_promote_mail` (
  `bonus_promote_mail_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ボーナス特集用促進メールID' ,
  `bonus_id` INT(11) NOT NULL COMMENT 'ボーナス特集ID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `status` TINYINT(2) NOT NULL COMMENT '0：未送信,1：送信済み' ,
  `body` TEXT NULL COMMENT 'メール本文' ,
  `last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`bonus_promote_mail_id`) )
ENGINE = InnoDB
COMMENT = 'ボーナス特集専用促進目メール';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_media_bonus` ON `bonus_promote_mail` (`bonus_id` ASC, `media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `bonus_promote_mail_job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bonus_promote_mail_job` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `bonus_promote_mail_job` (
  `bonus_promote_mail_job_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ボーナス用促進メールジョブID' ,
  `bonus_promote_mail_id` INT(11) NOT NULL COMMENT 'ボーナス特集用促進メールID' ,
  `auth_user_id` INT(11) NOT NULL COMMENT 'ジョブの登録者' ,
  `executed_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '実行時間' ,
  PRIMARY KEY (`bonus_promote_mail_job_id`) )
ENGINE = InnoDB
COMMENT = 'ボーナス専用促進メールジョブ';

SHOW WARNINGS;
CREATE INDEX `i_bonus_promote_mail` ON `bonus_promote_mail_job` (`bonus_promote_mail_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `image_reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `image_reservation` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `image_reservation` (
  `image_reservation_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'イメージ予約ID' ,
  `media_id` INT(11) NOT NULL COMMENT 'メディアID' ,
  `start_time` DATETIME NOT NULL COMMENT '配信From' ,
  `end_time` DATETIME NOT NULL COMMENT '配信To' ,
  `is_disabled` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '1:無効、0:有効' ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新タイムスタンプ' ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' COMMENT '作成タイムスタンプ' ,
  PRIMARY KEY (`image_reservation_id`) )
ENGINE = InnoDB
COMMENT = '画像配信予約';

SHOW WARNINGS;
CREATE INDEX `i_media_id` ON `image_reservation` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `site_customize`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_customize` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `site_customize` (
  `site_customize_id` TINYINT(4) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(255) NULL ,
  PRIMARY KEY (`site_customize_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `distributor_identifier_param`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `distributor_identifier_param` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `distributor_identifier_param` (
  `media_id` INT(11) NOT NULL ,
  `name` VARCHAR(20) NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`media_id`) )
ENGINE = InnoDB
COMMENT = 'ディストリビュータ連携で送られてくる識別パラメータの設定';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `achieve_to_forward_for_line`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `achieve_to_forward_for_line` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `achieve_to_forward_for_line` (
  `achieve_to_forward_id` INT NOT NULL AUTO_INCREMENT ,
  `achieve_id` CHAR(36) NOT NULL ,
  `media_id` INT(11) NULL ,
  `is_accepted` TINYINT(1) NULL ,
  `point` INT(11) NULL ,
  `forward_time` TIMESTAMP NULL ,
  `attempted` TINYINT NULL COMMENT '通知失敗回数' ,
  `message` VARCHAR(45) NULL ,
  PRIMARY KEY (`achieve_to_forward_id`) )
ENGINE = InnoDB
COMMENT = '成果履歴（通知待ち）';

SHOW WARNINGS;
CREATE INDEX `i_forward_time` ON `achieve_to_forward_for_line` (`forward_time` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `timesale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `timesale` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `timesale` (
  `timesale_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `campaign_id` INT(11) NOT NULL ,
  `media_id` INT(11) NOT NULL ,
  `priority` INT(11) NOT NULL ,
  `start_time` DATETIME NOT NULL ,
  `end_time` DATETIME NOT NULL ,
  `auth_user_id` INT(11) NOT NULL ,
  `create_at` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  `update_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`timesale_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_media` ON `timesale` (`media_id` ASC) ;

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_campaign_media_start_time` ON `timesale` (`campaign_id` ASC, `media_id` ASC, `start_time` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `gcp_access_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gcp_access_token` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `gcp_access_token` (
  `gcp_access_token_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `value` VARCHAR(2048) NOT NULL ,
  `expire_time` DATETIME NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`gcp_access_token_id`) )
ENGINE = InnoDB
COMMENT = 'GCPに対して利用するアクセストークン ';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_name` ON `gcp_access_token` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `advertisement_on_click`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `advertisement_on_click` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `advertisement_on_click` (
  `click_id` BIGINT NOT NULL ,
  `advertisement_id` INT(11) NOT NULL ,
  `date` DATE NOT NULL ,
  `campaign_id` INT(11) NOT NULL ,
  `price` INT(11) NOT NULL DEFAULT 0 COMMENT '利用料',
  `period` TINYINT NOT NULL DEFAULT 0 COMMENT '認証期間' ,
  `remark` TEXT NULL DEFAULT NULL COMMENT '備考' ,
  `campaign_advertisement_id` INT(11) NOT NULL DEFAULT 0 COMMENT 'キャンペーンのデフォルトサンクスID' ,
  `requisite_id` INT NOT NULL ,
  `point` INT(11) NOT NULL DEFAULT 0 ,
  `advertisement_identifier` VARCHAR(255) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL DEFAULT '' ,
  `advertisement_name` VARCHAR(255) NOT NULL ,
  `advertisement_offer` INT(11) NOT NULL DEFAULT 0 COMMENT 'グロス単価' ,
  `earnings` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 COMMENT '収入' ,
  `additional_earnings` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 ,
  `expenses` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 COMMENT '支出' ,
  `additional_expenses` DECIMAL(9,4) NOT NULL DEFAULT 0.0000 ,
  `priority` TINYINT NOT NULL COMMENT '表示順',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`click_id`, `advertisement_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `i_date` ON `advertisement_on_click` (`date` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `media_fraud_ip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `media_fraud_ip` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `media_fraud_ip` (
  `media_id` INT(11) NOT NULL ,
  `ip` VARCHAR(15) NOT NULL ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`media_id`, `ip`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `campaign_fraud_ip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campaign_fraud_ip` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `campaign_fraud_ip` (
  `campaign_id` INT(11) NOT NULL ,
  `ip` VARCHAR(15) NOT NULL ,
  `create_time` TIMESTAMP NOT NULL DEFAULT '2010-01-01 00:00:00' ,
  PRIMARY KEY (`campaign_id`, `ip`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `acquired_gift`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `acquired_gift` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `acquired_gift` (
  `achieve_id` CHAR(36) CHARACTER SET 'ascii' COLLATE 'ascii_general_ci' NOT NULL ,
  `media_id` INT(11) NOT NULL ,
  `identifier` VARCHAR(64) NOT NULL COMMENT 'アプリのユーザ識別子' ,
  `advertisement_id` INT(11) NOT NULL ,
  `accepted_time` DATETIME NOT NULL COMMENT '成果の認証日時' ,
  `gift_card_url` VARCHAR(255) NOT NULL ,
  `point` INT(11) NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`achieve_id`) )
ENGINE = InnoDB
COMMENT = '獲得ギフト';

SHOW WARNINGS;
CREATE INDEX `i_media_identifier` ON `acquired_gift` (`media_id` ASC, `identifier` ASC) ;

SHOW WARNINGS;
CREATE INDEX `i_accepted_time` ON `acquired_gift` (`accepted_time` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `gift_point`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gift_point` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `gift_point` (
  `gift_point_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `media_id` INT(11) NOT NULL ,
  `advertisement_id` INT(11) NOT NULL ,
  `point` INT(11) NOT NULL ,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`gift_point_id`) )
ENGINE = InnoDB
COMMENT = 'ギフトポイント';

SHOW WARNINGS;
CREATE UNIQUE INDEX `u_media_advertisement` ON `gift_point` (`media_id` ASC, `advertisement_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `simple_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `simple_list` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `simple_list` (
  `simple_list_id` INT(11) NOT NULL,
  `media_id` INT(11) NOT NULL ,
  `campaign_id` INT(11) NOT NULL ,
  `creative_id` INT(11) NOT NULL ,
  `priority` INT(11) NOT NULL DEFAULT 999,
  `ab_test_type` VARCHAR(10) NOT NULL DEFAULT 'default',
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`simple_list_id`) )
ENGINE = InnoDB
COMMENT = 'シンプルリスト';

SHOW WARNINGS;
CREATE INDEX `i_media_id` ON `simple_list` (`media_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `creative`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `creative` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `creative` (
  `creative_id` INT(11) NOT NULL,
  `type` VARCHAR(64) NOT NULL ,
  `path` VARCHAR(128) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`creative_id`) )
ENGINE = InnoDB
COMMENT = 'クリエイティブ';

SHOW WARNINGS;

-- -----------------------------------------------------

USE `tachyon` ;
USE `tachyon`;

DELIMITER $$

USE `tachyon`$$
DROP TRIGGER IF EXISTS `bu_achieve` $$
SHOW WARNINGS$$
USE `tachyon`$$


CREATE TRIGGER `bu_achieve` BEFORE UPDATE ON achieve FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
DECLARE forward TINYINT;
IF ( OLD.is_accepted IS NULL OR OLD.is_accepted != 1 ) AND NEW.is_accepted = 1 THEN
    INSERT INTO report SET
        date                = DATE( NEW.accepted_time ),
        media_id            = NEW.media_id,
        campaign_id         = NEW.campaign_id,
        achieve             = 1,
        earnings            = NEW.earnings,
        additional_earnings = NEW.additional_earnings,
        expenses            = NEW.expenses,
        additional_expenses = NEW.additional_expenses
    ON DUPLICATE KEY UPDATE
        achieve             = achieve + 1,
        earnings            = earnings + NEW.earnings,
        additional_earnings = additional_earnings + NEW.additional_earnings,
        expenses            = expenses + NEW.expenses,
        additional_expenses = additional_expenses + NEW.additional_expenses;
    INSERT INTO report_by_advertisement SET
        date                = DATE( NEW.accepted_time ),
        media_id            = NEW.media_id,
        advertisement_id    = NEW.advertisement_id,
        achieve             = 1,
        earnings            = NEW.earnings,
        additional_earnings = NEW.additional_earnings,
        expenses            = NEW.expenses,
        additional_expenses = NEW.additional_expenses
    ON DUPLICATE KEY UPDATE
        achieve             = achieve + 1,
        earnings            = earnings + NEW.earnings,
        additional_earnings = additional_earnings + NEW.additional_earnings,
        expenses            = expenses + NEW.expenses,
        additional_expenses = additional_expenses + NEW.additional_expenses;
    SELECT mode & b'1000' INTO forward FROM media WHERE media_id = NEW.media_id;
    SELECT ( forward >> 3 ) & requisite.is_forward INTO forward FROM advertisement JOIN requisite USING( requisite_id ) WHERE advertisement_id = NEW.advertisement_id;
    IF forward THEN
        INSERT INTO achieve_to_forward SET
            achieve_id   = NEW.achieve_id,
            media_id     = NEW.media_id,
            forward_time = NEW.accepted_time,
            attempted    = 0;
    END IF;
END IF;
END
$$

SHOW WARNINGS$$

USE `tachyon`$$
DROP TRIGGER IF EXISTS `bi_achieve` $$
SHOW WARNINGS$$
USE `tachyon`$$




CREATE TRIGGER `bi_achieve` BEFORE INSERT ON achieve FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
DECLARE forward TINYINT;
IF NEW.is_accepted = 1 THEN
    INSERT INTO report SET
        date                = DATE( NEW.accepted_time ),
        media_id            = NEW.media_id,
        campaign_id         = NEW.campaign_id,
        achieve             = 1,
        earnings            = NEW.earnings,
        additional_earnings = NEW.additional_earnings,
        expenses            = NEW.expenses,
        additional_expenses = NEW.additional_expenses
    ON DUPLICATE KEY UPDATE
        achieve             = achieve + 1,
        earnings            = earnings + NEW.earnings,
        additional_earnings = additional_earnings + NEW.additional_earnings,
        expenses            = expenses + NEW.expenses,
        additional_expenses = additional_expenses + NEW.additional_expenses;
    INSERT INTO report_by_advertisement SET
        date                = DATE( NEW.accepted_time ),
        media_id            = NEW.media_id,
        advertisement_id    = NEW.advertisement_id,
        achieve             = 1,
        earnings            = NEW.earnings,
        additional_earnings = NEW.additional_earnings,
        expenses            = NEW.expenses,
        additional_expenses = NEW.additional_expenses
    ON DUPLICATE KEY UPDATE
        achieve             = achieve + 1,
        earnings            = earnings + NEW.earnings,
        additional_earnings = additional_earnings + NEW.additional_earnings,
        expenses            = expenses + NEW.expenses,
        additional_expenses = additional_expenses + NEW.additional_expenses;
    SELECT mode & b'1000' INTO forward FROM media WHERE media_id = NEW.media_id;
    SELECT ( forward >> 3 ) & requisite.is_forward INTO forward FROM advertisement JOIN requisite USING( requisite_id ) WHERE advertisement_id = NEW.advertisement_id;
    IF forward THEN
        INSERT INTO achieve_to_forward SET
            achieve_id   = NEW.achieve_id,
            media_id     = NEW.media_id,
            forward_time = NEW.accepted_time,
            attempted    = 0;
    END IF;
END IF;
END
$$

SHOW WARNINGS$$

DELIMITER ;

DELIMITER $$

USE `tachyon`$$
DROP TRIGGER IF EXISTS `bi_click_of_crosswall` $$
SHOW WARNINGS$$
USE `tachyon`$$






















































CREATE DEFINER = 'tachyon-t'@'127.0.0.1' TRIGGER bi_click_of_crosswall BEFORE INSERT ON click_of_crosswall
FOR EACH ROW
INSERT INTO report_of_crosswall SET
  date              = NEW.date,
  cross_media_id    = NEW.cross_media_id,
  cross_campaign_id = NEW.cross_campaign_id,
  click             = 1
ON DUPLICATE KEY UPDATE click = click + 1;
$$

SHOW WARNINGS$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `category`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (1,2,'[iOS]マンガ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (2,2,'[削除予定][iOS]ビジネス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (3,2,'[iOS]教育/育児');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (4,2,'[削除予定][iOS]エンターテインメント');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (5,2,'[iOS]FinTech');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (6,2,'[iOS]ゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (7,2,'[iOS]ヘルスケア/フィットネス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (8,2,'[削除予定][iOS]ライフスタイル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (9,2,'[削除予定][iOS]メディカル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (10,2,'[iOS]音楽');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (11,2,'[iOS]地図');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (12,2,'[iOS]ニュース/キュレーション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (13,2,'[iOS]フォト/アルバム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (14,2,'[削除予定][iOS]仕事効率化');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (15,2,'[削除予定][iOS]レファレンス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (16,2,'[iOS]SNS');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (17,2,'[削除予定][iOS]スポーツ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (18,2,'[iOS]旅行/レジャー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (19,2,'[削除予定][iOS]ユーティリティ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (20,2,'[削除予定][iOS]天気');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (21,1,'[Universal]ポイントサイト');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (22,1,'[Universal]ゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (23,1,'[Universal]回線/Wi-Fi');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (24,1,'[Universal]旅行/レジャー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (25,1,'[Universal]教育/育児');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (26,1,'[削除予定][Universal]趣味・スポーツ・アウトドア');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (27,1,'[Universal]住まい/生活');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (28,1,'[削除予定][Universal]ファミリー・ペット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (29,1,'[Universal]投資/資産運用');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (30,1,'[削除予定][Universal]ビジネス・オフィス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (31,1,'[Universal]飲食');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (32,1,'[Universal]ファッション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (33,1,'[Universal]美容');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (34,1,'[Universal]音楽');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (35,1,'[Universal]デコメ/絵文字');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (36,1,'[Universal]着せ替え/待ち受け');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (37,1,'[削除予定][Universal]その他');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (38,3,'[Android]ゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (39,3,'[削除予定][Google Play]エンターテイメント');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (40,3,'[Android]マンガ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (41,3,'[削除予定][Google Play]ショッピング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (42,3,'[削除予定][Google Play]スポーツ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (43,3,'[Android]SNS');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (44,3,'[削除予定][Google Play]ツール');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (45,3,'[削除予定][廃止]テーマ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (46,3,'[Android]ニュース/キュレーション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (47,3,'[Android]FinTech');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (48,3,'[Android]動画/ライブ配信');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (49,3,'[削除予定][Google Play]ライフスタイル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (50,3,'[削除予定][廃止]リファレンス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (51,3,'[削除予定][Google Play]仕事効率化');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (52,3,'[Android]ヘルスケア/フィットネス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (53,3,'[Android]旅行/レジャー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (54,3,'[Android]回線/Wi-Fi');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (55,3,'[削除予定][Google Play]ソフトウェアライブラリ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (56,3,'[削除予定][廃止]デモ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (57,1,'[削除予定][Universal]懸賞サイト・ポイントサイト（換金）');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (58,1,'[Universal]占い/診断');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (59,2,'[削除予定][iOS]Newsstand');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (60,3,'[削除予定][Google Play]ウィジェット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (61,3,'[削除予定][Google Play]カスタマイズ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (62,3,'[削除予定][Google Play]ビジネス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (63,3,'[削除予定][Google Play]ライブ壁紙');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (64,3,'[Android]交通');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (65,3,'[Android]フォト/アルバム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (66,3,'[削除予定][Google Play]医療');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (67,3,'[削除予定][Google Play]天気');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (68,3,'[Android]教育/育児');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (69,3,'[削除予定][Google Play]書籍＆文献');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (70,3,'[Android]音楽');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (71,3,'[削除予定][dメニュー]天気／ニュース');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (72,3,'[削除予定][dメニュー]テレビ／ラジオ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (73,3,'[削除予定][dメニュー]銀行');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (74,3,'[削除予定][dメニュー]証券／保険／カード／マネー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (75,3,'[削除予定][dメニュー]乗換／地図・ナビ／交通');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (76,3,'[削除予定][dメニュー]旅行／ホテル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (77,3,'[削除予定][dメニュー]グルメ／レシピ／クーポン');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (78,3,'[削除予定][dメニュー]求人');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (79,3,'[削除予定][dメニュー]住まい／生活情報／恋愛／育児');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (80,3,'[削除予定][dメニュー]健康／ビューティー／医学');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (81,3,'[削除予定][dメニュー]便利ツール／写真／辞書／学習');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (82,3,'[削除予定][dメニュー]ケータイセキュリティ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (83,3,'[削除予定][dメニュー]おサイフケータイ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (84,3,'[削除予定][dメニュー]タウン情報／行政');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (85,3,'[削除予定][dメニュー]企業／ブランド');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (86,3,'[削除予定][dメニュー]ショッピング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (87,3,'[削除予定][dメニュー]ファッション／コスメ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (88,3,'[削除予定][dメニュー]デコメール／メール');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (89,3,'[削除予定][dメニュー]ＳＮＳ／投稿／Ｑ＆Ａ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (90,3,'[削除予定][dメニュー]音楽／メロディコール／ボイス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (91,3,'[削除予定][dメニュー]動画');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (92,3,'[削除予定][dメニュー]アーティスト／芸能／映画情報');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (93,3,'[削除予定][dメニュー]ゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (94,3,'[削除予定][dメニュー]コミック／書籍');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (95,3,'[削除予定][dメニュー]占い');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (96,3,'[削除予定][dメニュー]きせかえ／待受／マチキャラ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (97,3,'[削除予定][dメニュー]スポーツ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (98,3,'[削除予定][dメニュー]クルマ／バイク／趣味');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (99,3,'[削除予定][dメニュー]パチ・スロ／公営競技／くじ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (100,3,'[削除予定][au Market]ゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (101,3,'[削除予定][au Market]ニュース・天気');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (102,3,'[削除予定][au Market]ビジネス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (103,3,'[削除予定][au Market]ネット・コミュニケーション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (104,3,'[削除予定][au Market]地図・交通');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (105,3,'[削除予定][au Market]グルメ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (106,3,'[削除予定][au Market]ファイナンス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (107,3,'[削除予定][au Market]スポーツ・健康');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (108,3,'[削除予定][au Market]エンターテイメント');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (109,3,'[削除予定][au Market]書籍');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (110,3,'[削除予定][au Market]ツール');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (111,3,'[削除予定][au Market]学び');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (112,3,'[削除予定][au Market]Widget');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (113,3,'[削除予定][au Market]ショッピング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (114,2,'[iOS]ポイントサイト');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (115,3,'[Android]ポイントサイト');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (116,2,'[削除予定][iOS]auスマートパス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (117,3,'[削除予定][Google Play]auスマートパス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (118,1,'[削除予定][Universal]auスマートパス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (119,1,'[削除予定][Universal]スゴ得');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (120,2,'[削除予定][iOS]スゴ得');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (121,3,'[削除予定][Google Play]スゴ得');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (122,1,'[Universal]マンガ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (123,2,'[削除予定][iOS]ブック(その他)');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (124,3,'[Android]書籍');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (125,1,'[Universal]カード');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (126,1,'[削除予定][Universal]クレジットカード（永年無料）');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (127,1,'[削除予定][Universal]クレジットカード（有料）');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (128,2,'[iOS]VOD');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (129,2,'[iOS]動画/ライブ配信');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (130,2,'[iOS]フリマ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (131,2,'[iOS]アンケート');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (132,2,'[iOS]求人/進学');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (133,2,'[iOS]カード');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (134,2,'[iOS]書籍');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (135,2,'[iOS]投資/資産運用');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (136,2,'[iOS]懸賞');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (137,2,'[iOS]飲食');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (138,2,'[iOS]回線/Wi-Fi');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (139,2,'[iOS]レシピ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (140,2,'[iOS]クレーンゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (141,2,'[iOS]住まい/生活');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (142,2,'[iOS]占い/診断');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (143,2,'[iOS]デコメ/絵文字');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (144,2,'[iOS]公営ギャンブル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (145,2,'[iOS]着せ替え/待ち受け');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (146,2,'[iOS]チラシ/クーポン');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (147,2,'[iOS]美容');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (148,2,'[iOS]パチンコ/スロット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (149,2,'[iOS]交通');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (150,2,'[iOS]アダルト');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (151,2,'[iOS]カレンダー/年賀状');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (152,2,'[iOS]ウォーターサーバー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (153,2,'[iOS]セキュリティ/クラウド');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (154,2,'[iOS]ファッション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (155,2,'[iOS]保険');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (156,2,'[iOS]不動産');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (157,2,'[iOS]買取');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (158,2,'[iOS]仮想通貨');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (159,2,'[iOS]マッチング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (160,2,'[iOS]チケット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (161,2,'[iOS]ショッピング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (162,2,'[iOS]FX');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (163,3,'[Android]VOD');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (164,3,'[Android]フリマ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (165,3,'[Android]アンケート');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (166,3,'[Android]地図');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (167,3,'[Android]求人/進学');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (168,3,'[Android]カード');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (169,3,'[Android]投資/資産運用');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (170,3,'[Android]懸賞');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (171,3,'[Android]飲食');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (172,3,'[Android]レシピ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (173,3,'[Android]クレーンゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (174,3,'[Android]住まい/生活');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (175,3,'[Android]占い/診断');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (176,3,'[Android]デコメ/絵文字');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (177,3,'[Android]公営ギャンブル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (178,3,'[Android]着せ替え/待ち受け');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (179,3,'[Android]チラシ/クーポン');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (180,3,'[Android]美容');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (181,3,'[Android]パチンコ/スロット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (182,3,'[Android]アダルト');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (183,3,'[Android]カレンダー/年賀状');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (184,3,'[Android]ウォーターサーバー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (185,3,'[Android]セキュリティ/クラウド');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (186,3,'[Android]ファッション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (187,3,'[Android]保険');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (188,3,'[Android]不動産');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (189,3,'[Android]買取');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (190,3,'[Android]仮想通貨');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (191,3,'[Android]マッチング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (192,3,'[Android]チケット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (193,3,'[Android]ショッピング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (194,3,'[Android]FX');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (195,1,'[Universal]VOD');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (196,1,'[Universal]フォト/アルバム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (197,1,'[Universal]動画/ライブ配信');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (198,1,'[Universal]フリマ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (199,1,'[Universal]アンケート');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (200,1,'[Universal]地図');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (201,1,'[Universal]ニュース/キュレーション');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (202,1,'[Universal]求人/進学');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (203,1,'[Universal]書籍');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (204,1,'[Universal]FinTech');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (205,1,'[Universal]ヘルスケア/フィットネス');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (206,1,'[Universal]懸賞');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (207,1,'[Universal]レシピ');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (208,1,'[Universal]クレーンゲーム');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (209,1,'[Universal]公営ギャンブル');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (210,1,'[Universal]チラシ/クーポン');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (211,1,'[Universal]パチンコ/スロット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (212,1,'[Universal]交通');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (213,1,'[Universal]SNS');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (214,1,'[Universal]アダルト');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (215,1,'[Universal]カレンダー/年賀状');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (216,1,'[Universal]ウォーターサーバー');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (217,1,'[Universal]セキュリティ/クラウド');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (218,1,'[Universal]保険');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (219,1,'[Universal]不動産');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (220,1,'[Universal]買取');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (221,1,'[Universal]仮想通貨');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (222,1,'[Universal]マッチング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (223,1,'[Universal]チケット');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (224,1,'[Universal]ショッピング');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (225,1,'[Universal]FX');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (226, 2, '[iOS]停止');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (227, 3, '[Android]停止');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (228, 1, '[Universal]停止');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (229, 2, '[iOS]ネットワーク');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (230, 3, '[Android]ネットワーク');
INSERT INTO `category` (`category_id`, `platform_id`, `name`) VALUES (231, 1, '[Universal]ネットワーク');

COMMIT;

-- -----------------------------------------------------
-- Data for table `requisite`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (1, 'インストール', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (2, '無料会員登録', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (3, '有料会員登録', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (4, 'キャンペーン・懸賞応募', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (5, '商品購入', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (6, 'サンプル請求', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (7, 'アンケート・モニター登録', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (8, '資料請求', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (9, '見積・査定', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (10, 'クレジットカード申込・発券', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (11, 'キャッシング申込・成約', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (12, '口座開設', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (13, '予約・来店', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (14, 'その他', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (15, '無料アプリインストール', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (16, 'ポイントバック無し成果', '0');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (17, 'アプリ起動', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (18, 'インストール後チュートリアル完了', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (19, 'インストール後ログイン', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (20, 'インストール後会員登録', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (21, 'auID記入後のログイン', '1');
INSERT INTO `requisite` (`requisite_id`, `name`, `is_forward`) VALUES (22, 'インストール後条件達成', '1');

COMMIT;

-- -----------------------------------------------------
-- Data for table `platform`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `platform` (`platform_id`, `name`) VALUES (1, 'Universal');
INSERT INTO `platform` (`platform_id`, `name`) VALUES (2, 'iOS');
INSERT INTO `platform` (`platform_id`, `name`) VALUES (3, 'Android');

COMMIT;

-- -----------------------------------------------------
-- Data for table `platform_compatibility`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (1, 1);
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (1, 2);
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (1, 3);
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (2, 1);
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (2, 2);
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (3, 1);
INSERT INTO `platform_compatibility` (`platform_id_of_media`, `platform_id_of_campaign`) VALUES (3, 3);

COMMIT;

-- -----------------------------------------------------
-- Data for table `supplier`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (1, 'AppDriver', '');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (2, 'ポイントプラス', 'PointPlus');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (3, 'AdMaker', '');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (4, 'GREEリワード', '');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (5, 'AppAdForce', 'AppAdForce');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (6, 'AD Counter', 'ADCounter');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (7, 'HAKARU', 'HAKARU');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (8, 'ngi Ad Platform', 'NgiAdPlatform');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (9, 'Advancement', 'Advancement');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (10, 'MobADME', 'Mobadme');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (11, 'MAD', 'MAD');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (12, 'ポイントプラス(即時付与なし)', 'PointPlus');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (13, 'AdStore', 'AdStore');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (14, 'TSPAd', 'TSPAd');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (15, 'DApps', 'DApps');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (16, 'SMAAD', 'SMAAD');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (17, 'xaid', 'XAID');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (18, 'AppDriverChina', 'AppDriverChina');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (19, 'mobalyze', 'Mobalyze');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (20, 'af-share', 'AfShare');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (21, 'afte mopo', 'Afte_Mopo');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (22, 'gmomars', 'GMOMars');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (23, 'CAMP', 'CAMP');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (24, 'ポイントプラス(GREE)', 'PointPlus');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (25, 'party', 'Party');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (26, 'Smart-C', 'SmartC');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (27, 'GreeRewardAsp', 'GreeRewardAsp');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (28, 'eeline', 'Eeline');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (29, 'Zucks', 'Zucks');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (30, 'ポイントプラス(Smart-C)', 'PointPlus');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (31, 'MAT', 'MAT');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (32, 'GreeAdTracking', 'GreeAdTracking');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (33, 'ad-x', 'ADX');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (34, 'AppsFlyer', 'AppsFlyer');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (35, 'ART', 'ART');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (36, 'xrwd', 'XRWD');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (37, 'Metaps', 'Metaps');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (38, 'Aarki', 'Aarki');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (39, 'Smart-C(インセ)', 'IncentiveSmartC');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (40, 'king.com', 'King');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (41, 'Kochava', 'Kochava');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (42, 'Adjust', 'Adjust');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (43, 'ApSalar', 'ApSalar');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (44, 'Eight', 'Eight');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (45, 'Asat', 'Asat');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (46, 'HeatAppReward', 'HeatAppReward');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (47, 'SWAT', 'SWAT');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (48, 'Gameloft', 'Gameloft');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (49, 'TrackingBird', 'TrackingBird');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (50, 'JANet', 'JANet');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (51, 'SupersonicAds', 'SupersonicAds');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (52, 'AdTracking', 'AdTracking');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (53, 'Adbrix', 'Adbrix');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (54, 'NewSWAT', 'NewSWAT');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (55, 'adamas', 'Adamas');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (56, 'alibaba', 'Alibaba');
INSERT INTO `supplier` (`supplier_id`, `name`, `role`) VALUES (79, 'ResearchPlus', 'ResearchPlus');

COMMIT;

-- -----------------------------------------------------
-- Data for table `analytics_continent`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `analytics_continent` (`analytics_continent_id`, `code`, `name`) VALUES (1, 'AF', 'Africa');
INSERT INTO `analytics_continent` (`analytics_continent_id`, `code`, `name`) VALUES (2, 'AS', 'Asia');
INSERT INTO `analytics_continent` (`analytics_continent_id`, `code`, `name`) VALUES (3, 'EU', 'Europe');
INSERT INTO `analytics_continent` (`analytics_continent_id`, `code`, `name`) VALUES (4, 'NA', 'North America');
INSERT INTO `analytics_continent` (`analytics_continent_id`, `code`, `name`) VALUES (5, 'OC', 'Oceania');
INSERT INTO `analytics_continent` (`analytics_continent_id`, `code`, `name`) VALUES (6, 'SA', 'South America');

COMMIT;

-- -----------------------------------------------------
-- Data for table `market`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (1, 3, 'Google Play', 900);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (2, 3, 'Off-Market', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (3, 3, 'docomo Market', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (4, 3, 'au Market', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (5, 3, 'SoftBank Market', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (6, 3, 'andronavi', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (4, 2, 'au Market', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (7, 2, 'App Store', 0);
INSERT INTO `market` (`market_id`, `platform_id`, `name`, `refund_period`) VALUES (4, 1, 'au Market', 0);

COMMIT;

-- -----------------------------------------------------
-- Data for table `carrier`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `carrier` (`carrier_id`, `name`) VALUES (1, 'docomo');
INSERT INTO `carrier` (`carrier_id`, `name`) VALUES (2, 'au');
INSERT INTO `carrier` (`carrier_id`, `name`) VALUES (3, 'softbank');

COMMIT;

-- -----------------------------------------------------
-- Data for table `market_compatibility`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (1, 3, 1);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (1, 3, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (1, 3, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (1, 3, 4);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (2, 3, 1);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (2, 3, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (2, 3, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (2, 3, 4);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (3, 3, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 3, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (5, 3, 4);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (6, 3, 1);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (6, 3, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (6, 3, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (6, 3, 4);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (7, 2, 1);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (7, 2, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (7, 2, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (7, 2, 4);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 3, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 1, 1);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 1, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 1, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 1, 4);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 2, 1);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 2, 2);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 2, 3);
INSERT INTO `market_compatibility` (`market_id`, `platform_id`, `carrier_id`) VALUES (4, 2, 4);

COMMIT;

-- -----------------------------------------------------
-- Data for table `role`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `role` (`role_id`, `role`) VALUES (1, 'advanced_analytics');

COMMIT;

-- -----------------------------------------------------
-- Data for table `currency`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `currency` (`currency_id`, `name`, `symbol`) VALUES ('USD', '米ドル', '$');
INSERT INTO `currency` (`currency_id`, `name`, `symbol`) VALUES ('CAD', 'カナダドル', '$');
INSERT INTO `currency` (`currency_id`, `name`, `symbol`) VALUES ('EUR', '欧州ユーロ', '€');
INSERT INTO `currency` (`currency_id`, `name`, `symbol`) VALUES ('GBP', '英ポンド', '£');
INSERT INTO `currency` (`currency_id`, `name`, `symbol`) VALUES ('JPY', '日本円', '¥');
INSERT INTO `currency` (`currency_id`, `name`, `symbol`) VALUES ('AUD', '豪ドル', '$');

COMMIT;

-- -----------------------------------------------------
-- Data for table `analytics_receipt_price_level`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (1, 'JPY', '0～149円', 0);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (2, 'JPY', '150～399円', 150);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (3, 'JPY', '400～699円', 400);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (4, 'JPY', '700～999円', 700);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (5, 'JPY', '1000～1499円', 1000);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (6, 'JPY', '1500～1999円', 1500);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (7, 'JPY', '2000～4999円', 2000);
INSERT INTO `analytics_receipt_price_level` (`analytics_receipt_price_level_id`, `currency_id`, `name`, `min`) VALUES (8, 'JPY', '5000円以上', 5000);

COMMIT;

-- -----------------------------------------------------
-- Data for table `analytics_receipt_num_level`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (1, '1回', 1);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (2, '2回', 2);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (3, '3回', 3);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (4, '4～5回', 4);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (5, '6～8回', 6);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (6, '9～10回', 9);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (7, '11～13回', 11);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (8, '14～19回', 14);
INSERT INTO `analytics_receipt_num_level` (`analytics_receipt_num_level_id`, `name`, `min`) VALUES (9, '20回以上', 20);

COMMIT;

-- -----------------------------------------------------
-- Data for table `network`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `network` (`network_id`, `name`) VALUES (1, 'openfeint');
INSERT INTO `network` (`network_id`, `name`) VALUES (2, 'plus+');
INSERT INTO `network` (`network_id`, `name`) VALUES (3, 'GREE Platform for smartphone');

COMMIT;

-- -----------------------------------------------------
-- Data for table `distributor`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (1, 'アプリ', NULL);
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (2, 'ウェブ', NULL);
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (3, 'GREEリワードアプリ', NULL);
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (4, 'GREEリワードウェブ', NULL);
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (5, 'meetroid', 'Meetroid');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (6, 'metaps', 'Metaps');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (7, 'SMAAD', 'SMAAD');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (8, 'Smart-C', 'SmartC');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (9, 'ポケットアフィリエイト', 'Smaf');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (10, 'bictown', 'Bictown');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (11, 'meeti', 'Meeti');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (12, 'Mobage', 'Mobage');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (13, 'Mobadme', 'Mobadme');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (14, 'Zucks', 'Zucks');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (15, 'SponsorPay', 'SponsorPay');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (16, 'Aarki', 'Aarki');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (17, 'poncan', 'Poncan');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (18, 'ShotApp', NULL);
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (19, 'W3i', 'W3i');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (20, 'マクロライン', 'MacroLine');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (21, 'adcrops', 'Adcrops');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (22, 'GREE Reward ASP', 'GreeRewardAsp');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (23, 'Tapjoy', 'Tapjoy');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (24, 'SponsorPayGmbH', 'SponsorPayGmbH');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (25, 'HeatAppReward', 'HeatAppReward');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (26, 'Adcrops2', 'Adcrops2');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (27, 'Mobadme2', 'Mobadme2');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (28, 'Mobvista', 'Mobvista');
INSERT INTO `distributor` (`distributor_id`, `name`, `role`) VALUES (29, 'Mobadme3', 'Mobadme3');

COMMIT;

-- -----------------------------------------------------
-- Data for table `preference`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `preference` (`name`, `value`) VALUES ('ad_api', 0);
-- sources local環境でAchieveFinalizeRedisdを起動時に稼働させているため
INSERT INTO `preference` (`name`, `value`) VALUES ('redis', 1);
INSERT INTO `preference` (`name`, `value`) VALUES ('click_report', 0);

COMMIT;

-- -----------------------------------------------------
-- Data for table `auth_role`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `auth_role` (`auth_role_id`, `role_name`) VALUES (1, '参照可');
INSERT INTO `auth_role` (`auth_role_id`, `role_name`) VALUES (2, '参照可（一部）');
INSERT INTO `auth_role` (`auth_role_id`, `role_name`) VALUES (3, '使用不可');

COMMIT;

-- -----------------------------------------------------
-- Data for table `menu`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (1, 'home', 'ホーム', 'top left', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (2, 'home', 'ホーム', 'top right', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (3, 'home', 'ホーム', 'bottom left', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (4, 'home', 'ホーム', 'bottom right', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (5, 'requisite', '無料アプリインストール', '15,18,19,20,22', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (6, 'requisite', '有料アプリインストール', '1', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (7, 'requisite', '無料会員登録', '2,4,7', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (8, 'requisite', '月額会員登録', '3', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (9, 'requisite', 'カード発券/口座開設', '10,11,12', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (10, 'requisite', '商品購入', '5,6', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (11, 'requisite', 'その他', '8,9,13,14', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (12, 'category', 'ゲーム', '6,22,38,93,100', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (13, 'category', '本/雑誌', '1,40,59,69,94,109', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (14, 'category', 'ファイナンス', '5,29,47,73,74,106,125,126,127', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (15, 'category', '教育/人材/ビジネス', '2,3,25,30,62,68,78,102,111', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (16, 'category', 'エンターテインメント', '4,39,92,108', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (17, 'category', '旅行/ライフスタイル', '7,8,9,11,12,17,18,20,24,26,27,28,33,42,46,49,52,53,64,66,67,71,75,76,77,79,80,84,97,98,101,104,105,107', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (18, 'category', '動画/ミュージック', '10,34,48,70,72,90,91', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (19, 'category', 'ソーシャルネットワーキング', '16,43,89,103', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (20, 'category', 'ユーティリティー/ツール', '13,14,15,19,44,51,54,61,65,81,82,83,110', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (21, 'category', 'ショッピング', '31,32,41,86,87,113', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (22, 'category', '壁紙/デコメ', '35,36,60,63,88,96,112', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (23, 'category', '占い', '58,95', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (24, 'category', 'その他', '21,23,37,55,57,85,99', NULL, '2012-03-01 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (25, 'special', 'ガッポリ貯める!!', 'site.subscription_duration, advertisement.offer', NULL, '2012-08-22 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (26, 'special', '無料', '1,2,4,7,15', 'SoftbankMobile', '2013-04-15 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (27, 'special', '新着', 'campaign.start_time', 'SoftbankMobile', '2013-04-15 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (28, 'category', 'auスマートパス', '116,117,118', NULL, '2013-05-28 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (29, 'category', 'スゴ得', '119,120,121', NULL, '2013-05-28 00:00:00');
INSERT INTO `menu` (`menu_id`, `type`, `name`, `description`, `role`, `last_update`) VALUES (30, 'requisite', 'がっぽり', '3', 'SoftbankMobile', '2013-06-07 00:00:00');

COMMIT;

-- -----------------------------------------------------
-- Data for table `wall`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `wall` (`wall_id`, `name`) VALUES (1, 'オファーウォール');
INSERT INTO `wall` (`wall_id`, `name`) VALUES (2, 'クロスウォール');
INSERT INTO `wall` (`wall_id`, `name`) VALUES (3, 'インターステイシャル');

COMMIT;

-- -----------------------------------------------------
-- Data for table `media_agency`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `media_agency` (`media_agency_id`, `name`) VALUES (1, 'androider');

COMMIT;

-- -----------------------------------------------------
-- Data for table `achieve_change_search_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `achieve_change_search_type` (`achieve_change_search_type_id`, `name`, `value`) VALUES (1, 'achieve_id', 'achieve_id');
INSERT INTO `achieve_change_search_type` (`achieve_change_search_type_id`, `name`, `value`) VALUES (2, 'click_id', 'click_id');

COMMIT;

-- -----------------------------------------------------
-- Data for table `premium`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `premium` (`premium_id`, `name`, `role`) VALUES (1, 'Gree用', 'Gree');
INSERT INTO `premium` (`premium_id`, `name`, `role`) VALUES (2, 'DeNA用', 'DeNA');

COMMIT;

-- -----------------------------------------------------
-- Data for table `eight_range`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `eight_range` (`eight_range_id`, `minimum_gross_rate`, `provider_key`, `secret_key`, `access_key_id`, `secret_access_key`, `last_update`) VALUES (1, 1, 'adways1', 'XsWaVKc4DQ1NCeHKPvK6dMFGs16GYku5', 'AKIAICLWXD2US6DL3DDQ', 'hhvhk845zuF+ZL63TL90xWDH/cs7YWrF8SJD+DOO', '2010-01-01 00:00:00');
INSERT INTO `eight_range` (`eight_range_id`, `minimum_gross_rate`, `provider_key`, `secret_key`, `access_key_id`, `secret_access_key`, `last_update`) VALUES (2, 10, 'adways01', 'Ggond0MmDrntfGX3xMRKow3JSN056Brf', 'AKIAITOMDDOZ2XAMOANA', 'KGEm0SZFlZGkbB2gX3zPPmiM9nspD3YcxHe/BZc2', '2010-01-01 00:00:00');
INSERT INTO `eight_range` (`eight_range_id`, `minimum_gross_rate`, `provider_key`, `secret_key`, `access_key_id`, `secret_access_key`, `last_update`) VALUES (3, 100, 'adways001', '111F1PKzk7glCYONBk8mApLXu1pAXEeP', 'AKIAIP5SBZA7R2XK5GGA', '+SsTgxJ4Ok/kQ3qkbUW88mXEnBcvK9M61ypiIJQH', '2010-01-01 00:00:00');

COMMIT;

-- -----------------------------------------------------
-- Data for table `ow_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (1, 'ADA_OW', '/3.1.{site_id}i');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (2, 'ADA_OW_DETAIL', '/3.1.{site_id}r');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (3, 'ADA_OW_CATEGORY', '/3.1.{site_id}i');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (4, 'ADAC_OW', '/5/0/index/{site_id}');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (5, 'ADAC_OW_DETAIL', '/5/0/retrieve/{site_id}');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (6, 'ADAC_OW_CAMPAIGN_DETAIL', '/5/0/retrieve/{site_id}');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (7, 'ADAC_OW_LIST', '/5/0/list/{site_id}');
INSERT INTO `ow_type` (`ow_type_id`, `name`, `url_path`) VALUES (8, 'ADAC_OW_CAMPAIGN_LIST', '/5/0/list/{site_id}');

COMMIT;

-- -----------------------------------------------------
-- Data for table `param_of_ow_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (1, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (2, 8, 'campaign_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (3, 8, 'menu_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (4, 8, 'identifier');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 8, 'identifier');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (5, 9, 'campaign_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 8, 'identifier');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 9, 'campaign_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (6, 10, 'feature_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 8, 'identifier');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (7, 9, 'menu_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 1, 'app');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 2, 'model');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 3, 'privileged');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 4, 'sdk');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 5, 'system');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 6, 'site_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 7, 'media_id');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 8, 'identifier');
INSERT INTO `param_of_ow_type` (`ow_type_id`, `param_of_ow_type_id`, `name`) VALUES (8, 9, 'feature_id');

COMMIT;

-- -----------------------------------------------------
-- Data for table `ow_menu`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (1, 'requisite', '新着順', '2015-05-01 05:13:39', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (2, 'requisite', 'アプリ', '2015-05-01 05:13:39', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (3, 'requisite', 'カンタン', '2015-05-01 05:13:39', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (4, 'requisite', 'お得', '2015-05-01 05:13:39', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (5, 'requisite', 'カード発券', '2015-05-01 05:13:40', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (6, 'requisite', '口座開設', '2015-05-01 05:13:40', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (7, 'requisite', 'ショッピング', '2015-05-01 05:13:40', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (8, 'requisite', 'たくさん', '2015-05-01 05:13:40', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (9, 'special', 'おすすめ！', '2015-05-01 05:13:40', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (10, 'special', 'auスマパス', '2015-05-01 05:13:41', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (11, 'special', '人気順', '2015-05-01 05:13:41', '2010-01-01 08:00:00');
INSERT INTO `ow_menu` (`ow_menu_id`, `type`, `name`, `last_update`, `create_time`) VALUES (12, 'requisite', '無料', '2015-05-01 05:13:41', '2010-01-01 08:00:00');

COMMIT;

-- -----------------------------------------------------
-- Data for table `ow_template_color`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (1, 'header', 1, 'red', 'f22e2e', 'ce2020', '872900', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (2, 'header', 2, 'pink', 'ff7fd4', 'ff5cc8', 'cd3e9c', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (3, 'header', 3, 'purple', '7628d0', '5a0eb4', '5a0eb4', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (4, 'header', 4, 'blue', '3657e6', '0a2eca', '0a27a7', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (5, 'header', 5, 'lightblue', '00b4d5', '0093ae', '007287', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (6, 'header', 6, 'limegreen', '2ee316', '24ab05', '22660b', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (7, 'header', 7, 'green', '09ad06', '006508', '164513', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (8, 'header', 8, 'yellow', 'ffbc00', 'ed9100', '976401', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (9, 'header', 9, 'orange', 'ff9600', 'ff7200', 'a74e00', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (10, 'header', 10, 'brown', 'c88960', '975833', '764629', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (11, 'header', 11, 'black', '3f3f3f', '191919', '000000', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (12, 'header', 12, 'grey', '7c7c7c', '414141', '2b2b2b', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (13, 'header', 13, 'white', 'ffffff', 'eaeaea', 'bababa', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (14, 'frame', 1, 'red', 'f22e2e', 'ce2020', '872900', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (15, 'frame', 2, 'pink', 'ff7fd4', 'ff5cc8', 'cd3e9c', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (16, 'frame', 3, 'purple', '7628d0', '5a0eb4', '5a0eb4', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (17, 'frame', 4, 'blue', '3657e6', '0a2eca', '0a27a7', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (18, 'frame', 5, 'lightblue', '00b4d5', '0093ae', '007287', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (19, 'frame', 6, 'limegreen', '2ee316', '24ab05', '22660b', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (20, 'frame', 7, 'green', '09ad06', '006508', '164513', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (21, 'frame', 8, 'yellow', 'ffbc00', 'ed9100', '976401', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (22, 'frame', 9, 'orange', 'ff9600', 'ff7200', 'a74e00', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (23, 'frame', 10, 'brown', 'c88960', '975833', '764629', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (24, 'frame', 11, 'black', '3f3f3f', '191919', '000000', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (25, 'frame', 12, 'grey', '7c7c7c', '414141', '2b2b2b', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (26, 'frame', 13, 'white', 'ffffff', 'eaeaea', 'bababa', '2015-05-01 05:22:42', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (27, 'background', 1, 'white', 'ffffff', 'eaeaea', 'bababa', '2015-05-01 05:25:12', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (28, 'background', 2, 'lightgrey', 'e4e4e4', 'c7c7c7', 'bababa', '2015-05-01 05:25:12', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (29, 'background', 3, 'grey', '555555', '393939', '292929', '2015-05-01 05:25:12', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (30, 'detail_button', 1, 'red', NULL, NULL, NULL, '2015-05-01 05:28:13', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (31, 'detail_button', 2, 'pink', NULL, NULL, NULL, '2015-05-01 05:31:02', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (32, 'detail_button', 3, 'purple', NULL, NULL, NULL, '2015-05-01 05:45:34', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (33, 'detail_button', 4, 'blue', NULL, NULL, NULL, '2015-05-01 05:45:34', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (34, 'detail_button', 5, 'lightblue', NULL, NULL, NULL, '2015-05-01 05:45:34', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (35, 'detail_button', 6, 'limegreen', NULL, NULL, NULL, '2015-05-01 05:45:34', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (36, 'detail_button', 7, 'green', NULL, NULL, NULL, '2015-05-01 05:45:34', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (37, 'detail_button', 8, 'yellow', NULL, NULL, NULL, '2015-05-01 05:45:35', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (38, 'detail_button', 9, 'orange', NULL, NULL, NULL, '2015-05-01 05:45:35', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (39, 'detail_button', 10, 'brown', NULL, NULL, NULL, '2015-05-01 05:45:35', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (40, 'detail_button', 11, 'black', NULL, NULL, NULL, '2015-05-01 05:45:35', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (41, 'detail_button', 12, 'grey', NULL, NULL, NULL, '2015-05-01 05:45:35', '2010-01-01 08:00:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 1, 'red', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 2, 'pink', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 3, 'purple', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 4, 'blue', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 5, 'lightblue', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 6, 'limegreen', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 7, 'green', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 8, 'yellow', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 9, 'orange', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 10, 'brown', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 11, 'black', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');
INSERT INTO `ow_template_color` (`ow_template_color_id`, `color_type`, `color_type_id`, `name`, `color_of_main`, `color_of_sub`, `color_of_shadow`, `last_update`, `create_time`) VALUES (NULL, 'appeal_font', 12, 'grey', NULL, NULL, NULL, '2016-09-05 23:01:00', '2016-09-05 23:01:00');

COMMIT;

-- -----------------------------------------------------
-- Data for table `site_customize`
-- -----------------------------------------------------
START TRANSACTION;
USE `tachyon`;
INSERT INTO `site_customize` (`site_customize_id`, `name`, `description`) VALUES (1, 'LINE', 'LINE専用アプリ');

COMMIT;
