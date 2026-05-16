CREATE DATABASE Stage_TechSales
GO

USE Stage_TechSales;
GO

CREATE TABLE Admin_Log (
    id_log      UNIQUEIDENTIFIER    DEFAULT NEWID(),
    data_log    DATETIME            DEFAULT GETDATE(),
    processo    VARCHAR(100),
    status      CHAR(1),
    mensagem    VARCHAR(255),
    CONSTRAINT PK_Admin_Log PRIMARY KEY (id_log)
)
GO