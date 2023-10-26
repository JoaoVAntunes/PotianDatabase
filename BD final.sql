-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema potian_final
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema potian_final
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `potian_final` DEFAULT CHARACTER SET utf8 ;
USE `potian_final` ;

-- -----------------------------------------------------
-- Table `potian_final`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`endereco` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(45) NOT NULL,
  `número` INT NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `cep` INT NOT NULL,
  `complemento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`pessoa` (
  `cpf` CHAR(11) NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `rg` INT NOT NULL,
  `sexo` ENUM('Masculino', 'Feminino', 'Outro') NOT NULL,
  `e-mail` VARCHAR(345) NOT NULL,
  `endereco_id1` INT NOT NULL,
  `id_pessoa` INT NOT NULL AUTO_INCREMENT,
  INDEX `fk_pessoa_endereco_idx` (`endereco_id1` ASC) VISIBLE,
  PRIMARY KEY (`id_pessoa`),
  CONSTRAINT `fk_pessoa_endereco`
    FOREIGN KEY (`endereco_id1`)
    REFERENCES `potian_final`.`endereco` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_criacao` DATETIME NOT NULL,
  `pessoa_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk clientes pessoa_idx` (`pessoa_id` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_pessoa`
    FOREIGN KEY (`pessoa_id`)
    REFERENCES `potian_final`.`pessoa` (`id_pessoa`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`modalidade_pag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`modalidade_pag` (
  `idmodalidade_pag` INT NOT NULL AUTO_INCREMENT,
  `parcelado_avista` ENUM('A vsta', 'Parcelado') NOT NULL,
  `modo` ENUM('Cartão de Crédito', 'Boleto', 'PIX', 'Dinheiro') NOT NULL,
  PRIMARY KEY (`idmodalidade_pag`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`cobranca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`cobranca` (
  `idcobranca` INT NOT NULL AUTO_INCREMENT,
  `valor_total` FLOAT NOT NULL,
  `data_cobranca` DATETIME NOT NULL,
  `id_modalidad` INT NOT NULL,
  PRIMARY KEY (`idcobranca`),
  INDEX `fk_cobranca_modalidade_idx` (`id_modalidad` ASC) VISIBLE,
  CONSTRAINT `fk_cobranca_modalidade`
    FOREIGN KEY (`id_modalidad`)
    REFERENCES `potian_final`.`modalidade_pag` (`idmodalidade_pag`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`transportadora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`transportadora` (
  `id_transportadora` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cnpj` CHAR(14) NOT NULL,
  PRIMARY KEY (`id_transportadora`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`frete`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`frete` (
  `id_frete` INT NOT NULL AUTO_INCREMENT,
  `tempo` VARCHAR(45) NOT NULL,
  `valor` FLOAT NOT NULL,
  `id_compra` INT NOT NULL,
  `id_transportadora` INT NOT NULL,
  PRIMARY KEY (`id_frete`),
  INDEX `fk_frete_compra_idx` (`id_compra` ASC) VISIBLE,
  INDEX `fk_frete_transportadora_idx` (`id_transportadora` ASC) VISIBLE,
  CONSTRAINT `fk_frete_compra`
    FOREIGN KEY (`id_compra`)
    REFERENCES `potian_final`.`compra` (`id_compra`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_frete_transportadora`
    FOREIGN KEY (`id_transportadora`)
    REFERENCES `potian_final`.`transportadora` (`id_transportadora`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`categoria` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `tipo` TINYTEXT NOT NULL,
  PRIMARY KEY (`id_categoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`produto` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT NOT NULL,
  `estoque` SMALLINT NOT NULL,
  `valor` FLOAT NOT NULL,
  `id_categoria` INT NOT NULL,
  PRIMARY KEY (`id_produto`),
  INDEX `fk_produto_categoria_idx` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_produto_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `potian_final`.`categoria` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`compra` (
  `id_compra` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `valor_final` FLOAT NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_cobranca` INT NOT NULL,
  `id_frete` INT NOT NULL,
  `id_produto` INT NOT NULL,
  PRIMARY KEY (`id_compra`),
  INDEX `fk_compra_cliente_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_compra_cobranca_idx` (`id_cobranca` ASC) VISIBLE,
  INDEX `fk_compra_frete_idx` (`id_frete` ASC) VISIBLE,
  INDEX `fk_compra_produto_idx` (`id_produto` ASC) VISIBLE,
  CONSTRAINT `fk_compra_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `potian_final`.`clientes` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_cobranca`
    FOREIGN KEY (`id_cobranca`)
    REFERENCES `potian_final`.`cobranca` (`idcobranca`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_frete`
    FOREIGN KEY (`id_frete`)
    REFERENCES `potian_final`.`frete` (`id_frete`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_produto`
    FOREIGN KEY (`id_produto`)
    REFERENCES `potian_final`.`produto` (`id_produto`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `potian_final`.`contato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `potian_final`.`contato` (
  `condigo_pais` TINYINT(3) NOT NULL,
  `codigo_area` TINYINT NOT NULL,
  `numero` SMALLINT NOT NULL,
  `id_pessoa` INT NOT NULL,
  INDEX `fk_contato_pessoa_idx` (`id_pessoa` ASC) VISIBLE,
  CONSTRAINT `fk_contato_pessoa`
    FOREIGN KEY (`id_pessoa`)
    REFERENCES `potian_final`.`pessoa` (`id_pessoa`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
