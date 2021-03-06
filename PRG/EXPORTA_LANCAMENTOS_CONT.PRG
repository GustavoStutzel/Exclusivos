
XCOD_MATRIZ='000990'
XDATA_BASE ='20121231'
XVISAO_CONT ='11'



TEXT TO XSEL NOSHOW TEXTMERGE 
	--- SINTETICO

	SELECT LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO,VISAO.DESCR_CONTA,SUM(LANCAMENTOS.VALOR_PAGAR) AS 
                VALOR_ABERTO
	FROM 

		--- EM ABERTO -------
		(SELECT A.COD_MATRIZ_CONTABIL,
		A.MATRIZ_CONTABIL,
		A.CONTA_CONTABIL,A.DESC_CONTA,A.LANCAMENTO,A.ITEM,
		CONVERT(INT,NULL) AS LANCAMENTO_MOV,
                                CONVERT(INT,NULL) AS ITEM_MOV,
		A.VALOR_A_PAGAR_PADRAO AS VALOR_PAGAR,
		A.VENCIMENTO,CONVERT(VARCHAR(13),'EM ABERTO') AS EM_ABERTO 
		FROM  W_CTB_A_PAGAR_PARCELA A 
		WHERE A.COD_MATRIZ_CONTABIL='<<XCOD_MATRIZ>>'
		AND   A.DATA_LANCAMENTO BETWEEN '20110101' AND '<<XDATA_BASE>>'
		AND   A.VENCIMENTO>'20110101'
		AND   A.TIPO_MOVIMENTO=1
		AND   A.VALOR_A_PAGAR>0
		--- EM ABERTO -------

		UNION ALL

		--- PAGOS DEPOIS-----
		SELECT 
		A.COD_MATRIZ_CONTABIL,A.MATRIZ_CONTABIL,
		A.CONTA_CONTABIL,A.DESC_CONTA,A.LANCAMENTO,A.ITEM,
		A.LANCAMENTO_MOV,A.ITEM_MOV,
		A.VALOR_MOV_PADRAO AS VALOR_PAGO, 
		A.VENCIMENTO,CONVERT(VARCHAR(13),'PAGO_DEPOIS') AS EM_ABERTO 
		FROM W_CTB_A_PAGAR_PARCELA_MOV A 
		WHERE A.COD_MATRIZ_CONTABIL='<<XCOD_MATRIZ>>'
		AND A.TIPO_MOVIMENTO=1 
		AND A.DATA_LANCAMENTO BETWEEN '20110101' AND '<<XDATA_BASE>>' 
		AND A.DATA_PAGAMENTO>'<<XDATA_BASE>>' ) LANCAMENTOS
		--- PAGOS DEPOIS-----

	JOIN 

		(SELECT B.CONTA_CONTABIL,A.CLASSIFICACAO,C.DESCR_CONTA 
		FROM CTB_PLANO_VISAO A 
		JOIN CTB_CONTA_PLANO B 
		ON A.CONTA_CONTABIL=B.CONTA_CONTABIL 
		JOIN CTB_VISAO C 
		ON A.CLASSIFICACAO=C.CLASSIFICACAO 
		AND A.VISAO_CONTABIL=C.VISAO_CONTABIL
		WHERE A.VISAO_CONTABIL='<<XVISAO_CONT>>' ) VISAO 

	ON LANCAMENTOS.CONTA_CONTABIL=VISAO.CONTA_CONTABIL
	GROUP BY LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO,VISAO.DESCR_CONTA 
	ORDER BY LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO

ENDTEXT

F_SELECT(XSEL,'CUR_LANCAMENTOS_SINTETICO')

SELECT CUR_LANCAMENTOS_SINTETICO
COPY TO C:\TEMP\LANCAMENTOS_SINTETICO.XLS XLS





TEXT TO XSEL NOSHOW TEXTMERGE 

	--- ANALITICO

	SELECT LANCAMENTOS.COD_MATRIZ_CONTABIL,LANCAMENTOS.MATRIZ_CONTABIL,
	VISAO.CLASSIFICACAO,VISAO.DESCR_CONTA,LANCAMENTOS.CONTA_CONTABIL,
	LANCAMENTOS.DESC_CONTA,LANCAMENTOS.LANCAMENTO,LANCAMENTOS.ITEM,
                LANCAMENTOS.LANCAMENTO_MOV,
	LANCAMENTOS.ITEM_MOV,LANCAMENTOS.VALOR_PAGAR,
                CONVERT(VARCHAR(13),LANCAMENTOS.VENCIMENTO,103) AS VENCIMENTO,
                CONVERT(VARCHAR(13),LANCAMENTOS.VENCIMENTO,112) as VENCIMENTO_RENATO,
                CONVERT(VARCHAR(13),LANCAMENTOS.DATA_LANCAMENTO,103) AS  
                DATA_LANCAMENTO,
	LANCAMENTOS.EM_ABERTO,CONVERT(VARCHAR(25),
                LANCAMENTOS.NOME_CLIFOR) AS NOME_CLIFOR,
	CONVERT(VARCHAR(25),
                LANCAMENTOS.NOME_CLIFOR_SACADO) AS NOME_CLIFOR_SACADO,
	CONVERT(VARCHAR(10),CASE WHEN LOJAS.FILIAL IS NOT NULL THEN 'LOJA' ELSE '' END) 
                AS LOJA
	FROM 


		--- EM ABERTO -------
		(SELECT A.COD_MATRIZ_CONTABIL,
		A.MATRIZ_CONTABIL,
		A.CONTA_CONTABIL,A.DESC_CONTA,A.LANCAMENTO,A.ITEM,
		CONVERT(INT,NULL) AS LANCAMENTO_MOV,CONVERT(INT,NULL) AS 
                                ITEM_MOV,
		A.VALOR_A_PAGAR_PADRAO AS VALOR_PAGAR,
		A.VENCIMENTO,A.DATA_LANCAMENTO,CONVERT(VARCHAR(13),'EM ABERTO') 
                                AS EM_ABERTO, 
		A.NOME_CLIFOR ,A.NOME_CLIFOR_SACADO 
		FROM  W_CTB_A_PAGAR_PARCELA A 
		WHERE A.COD_MATRIZ_CONTABIL='<<XCOD_MATRIZ>>'
		AND   A.DATA_LANCAMENTO BETWEEN '20110101' AND '<<XDATA_BASE>>'
		AND   A.VENCIMENTO>'20110101'
		AND   A.TIPO_MOVIMENTO=1
		AND   A.VALOR_A_PAGAR>0
		--- EM ABERTO -------

		UNION ALL

		--- PAGOS DEPOIS-----
		SELECT 
		A.COD_MATRIZ_CONTABIL,A.MATRIZ_CONTABIL,
		A.CONTA_CONTABIL,A.DESC_CONTA,A.LANCAMENTO,A.ITEM,
		A.LANCAMENTO_MOV,A.ITEM_MOV,
		A.VALOR_MOV_PADRAO AS VALOR_PAGO, 
		A.VENCIMENTO,A.DATA_LANCAMENTO,CONVERT(VARCHAR  
                               (13),'PAGO_DEPOIS') AS EM_ABERTO, 
		A.NOME_CLIFOR ,A.NOME_CLIFOR_SACADO
		FROM W_CTB_A_PAGAR_PARCELA_MOV A 
		WHERE A.COD_MATRIZ_CONTABIL='<<XCOD_MATRIZ>>'
		AND A.TIPO_MOVIMENTO=1 
		AND A.DATA_LANCAMENTO BETWEEN '20110101' AND '<<XDATA_BASE>>' 
		AND A.DATA_PAGAMENTO>'<<XDATA_BASE>>' ) LANCAMENTOS
		--- PAGOS DEPOIS-----

	JOIN 

		(SELECT B.CONTA_CONTABIL,A.CLASSIFICACAO,C.DESCR_CONTA 
		FROM CTB_PLANO_VISAO A 
		JOIN CTB_CONTA_PLANO B 
		ON A.CONTA_CONTABIL=B.CONTA_CONTABIL 
		JOIN CTB_VISAO C 
		ON A.CLASSIFICACAO=C.CLASSIFICACAO 
		AND A.VISAO_CONTABIL=C.VISAO_CONTABIL
		WHERE A.VISAO_CONTABIL='<<XVISAO_CONT>>' ) VISAO 

	ON LANCAMENTOS.CONTA_CONTABIL=VISAO.CONTA_CONTABIL


	LEFT JOIN LOJAS_VAREJO LOJAS
	ON LANCAMENTOS.NOME_CLIFOR_SACADO = LOJAS.FILIAL

	ORDER BY VISAO.CLASSIFICACAO

ENDTEXT 


F_SELECT(XSEL,'CUR_LANCAMENTOS_ANALITICO')

SELECT CUR_LANCAMENTOS_ANALITICO
COPY TO C:\TEMP\LANCAMENTOS_ANALITICO.XLS XLS