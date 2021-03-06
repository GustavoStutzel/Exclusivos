

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE



select distinct 
convert(VARchar(16),convert(char(2),case 
	when len(convert(char(4),replace(a.ddd ,'nulo','21')))=2 
	then convert(char(2),replace(a.ddd ,'nulo','21'))
	else (select convert(int,ddd1) from cadastro_cli_for where nome_clifor=a.filial)	 
end )
+
replace(a.celular,'-','')) as celular,
a.cliente,a.email

 
from 


(SELECT  upper( left( ltrim(C.CLIENTE_VAREJO), charindex(' ', ltrim(C.CLIENTE_VAREJO)))) AS CLIENTE,
case 	
		when C.DDD_CEL is null or C.DDD_CEL='' or C.DDD_CEL like '%nulo%' 
		then case	
				 when C.DDD is null  or C.DDD=''  or C.DDD like '%nulo%'
				 then (select ddd1 from cadastro_cli_for where nome_clifor=C.FILIAL)	
				 else C.DDD
			 end	
		else C.DDD_CEL	
	end as DDD,
ltrim(rtrim(C.CELULAR)) as CELULAR,
C.FILIAL,EMAIL
FROM CLIENTES_VAREJO C 
INNER JOIN   

(SELECT LV.CODIGO_CLIENTE, COUNT(LV.TICKET) AS QTD_ATD, 
SUM(LV.VALOR_PAGO) AS VALOR_COMPRA     
FROM LOJA_VENDA LV  
INNER JOIN 

	(SELECT VP.CODIGO_FILIAL, VP.TICKET, VP.DATA_VENDA, 
	COUNT(VP.PRODUTO) AS QTD_PROD
	FROM LOJA_VENDA_PRODUTO VP INNER JOIN 
	PRODUTOS P         
	ON VP.PRODUTO = P.PRODUTO  
	WHERE  P.LINHA IN ('A. BRAND') OR P.COLECAO LIKE '%ABRAND%'  OR ANM_MARCA = 'A.BRAND'
	GROUP BY VP.CODIGO_FILIAL, VP.TICKET, VP.DATA_VENDA) W     

ON LV.CODIGO_FILIAL = W.CODIGO_FILIAL 
AND        LV.TICKET = W.TICKET 
AND        Lv.DATA_VENDA = W.DATA_VENDA   
GROUP BY  LV.CODIGO_CLIENTE   ) V  
 
ON C.CODIGO_CLIENTE = V.CODIGO_CLIENTE 
WHERE C.CELULAR is not null 
AND C.CELULAR<>''
AND C.CELULAR not like '%A%'
AND C.CELULAR not like '%.%' 
AND C.FILIAL ='ABRAND'  ) A






ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\ABRAND_SMS_CLIENTES_ABRAND.XLS XLS 