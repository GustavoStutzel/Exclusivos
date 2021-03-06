

/****** Object:  Table [dbo].[ANM_LOG_ENTREGA_AJUSTADA_PA]    Script Date: 28/10/2016 17:00:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[ANM_LOG_LJ_NF_FISCAL_STATUS_NF](
	[TIPO_TRANSACAO] [varchar](1) NOT NULL,
	[CODIGO_FILIAL] [char](6) NOT NULL,
	[NF_NUMERO] [char](15) NOT NULL,
	[SERIE_NF] [varchar](6) NOT NULL,
	[STATUS_NFE_ANTERIOR] [smallint] NULL,
	[STATUS_NFE_NOVO] [smallint] NULL,
	[DATA_ALTERACAO] [datetime] NOT NULL,
	[USUARIO] [nvarchar](128) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

