USE [SOMA]
GO
/****** Object:  StoredProcedure [dbo].[LX_ANM_BLOQUEIA_PRECO_PRODUTO]    Script Date: 11/04/2016 18:24:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[LX_ANM_BLOQUEIA_PRECO_PRODUTO] @PRODUTO VARCHAR(12),@CODIGO_TAB_PRECO CHAR(2)   

AS  

	

	--- VARIÁVEIS DE RETORNO ---

	DECLARE @BLOQUEIA BIT = 0,  -- @BLOQUEIA = 0 (PERMITE), @BLOQUEIA = 1 (NÃO PERMITE)

			@MSG_RETORNO VARCHAR(50) = NULL	-- SE NULO RETORNA MSG PADRÃO: Tabela de preço sem permissão para alteração!

			                                -- SE NÃO, RETORNA MSG DA VARIÁVEL @MSG_RETORNO

	

	-- BLOQUEIO PARA AS TABELAS DE TRANSF ---

	IF @CODIGO_TAB_PRECO IN ('17','18','19','vo')

		SELECT @BLOQUEIA = 1, @MSG_RETORNO = 'Esta tabela de preço não permite alteração manual.'

	-- FIM -- BLOQUEIO PARA AS TABELAS DE TRANSF ---

	-- SOLICITAÇÃO DO OCTÁVIO ROSA
	-- #1 - LUCAS MIRANDA - 11/04/2016 - BLOQUEIO ALTERAÇÃO DE PREÇO 
	IF @CODIGO_TAB_PRECO IN ('VO')	and (SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_BLOQ_ALT_TAB_VO')) = 0
		SELECT @BLOQUEIA = 1, @MSG_RETORNO = 'Esta tabela de preço não permite alteração manual.'

	-- BLOQUEIO PARA AS TABELAS DE CUSTO --- 	

	IF @CODIGO_TAB_PRECO IN ('CT','CA')

		

		BEGIN

			

			--- BLOQUEIO POR DATA FIM DA COLECAO ---

			IF (SELECT CONVERT(CHAR(10),ISNULL(B.DATA_FINAL_META,GETDATE()),112) AS DATA_FIM 

					FROM PRODUTOS A 

						JOIN COLECOES B ON A.COLECAO = B.COLECAO 

					WHERE PRODUTO = @PRODUTO) < GETDATE()

		

				SELECT @BLOQUEIA = 1

			--- FIM -- BLOQUEIO POR DATA FIM DA COLECAO ---		

		END

	

	--- NÃO ALTERAR RETORNO ABAIXO SEM VERIFICAR OBJETO DA TELA 002006 ---			

	SELECT @BLOQUEIA AS PERMITE, @MSG_RETORNO AS MSG_RETORNO --- RETORNO DO RESULTADO ---	











