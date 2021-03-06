define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
			do case
				CASE UPPER(xmetodo) == 'USR_INIT'
					
					Thisformset.p_auditoria = ''
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					xalias = alias()
					
					PUBLIC caixa,pedido
					
					caixa = ''
					pedido = ''

				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_faturamento_05 
					sele v_faturamento_05  
					xalias_faturam=alias()

	  				oCur = getcursoradapter(xalias_faturam)
					oCur.addbufferfield("FILIAL_ESTOQUE", "C(25)",.T., "FILIAL_ESTOQUE", "FATURAMENTO.FILIAL_ESTOQUE")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
					
					* Declara Variaveis xRomaneiosProd ( armazena os romaneios selecionados) e xSaiFabrica ( verifica se a nota eh uma saida para fabrica)
					PUBLIC 	xSaiFabrica,xRomaneiosProd
						xRomaneiosProd = "''"
						xSaiFabrica = 0
				
				* adiciona botao de selecionar romaneios	
				thisformset.lx_form1.lx_PAGEFRAME1.page2.addobject("bt_estoque_entradas","bt_estoque_entradas")

				* Adiciona bot�o incluir data saida - Lucas Miranda - 03/09/2014
				with thisformset.lx_form1.lx_PAGEFRAME1.page1
					.lx_pageframe1.page1.addobject("bt_altera_data", "bt_altera_data")
				endwith									
				
				if !f_vazio(xalias)
					sele &xalias
				endif				
				
				thisformset.l_limpa()
				o_toolbar.Botao_limpa.Click() 	
				
				***** VERIIFICA SE O TIPO DE CAIXA � COMPATIVEL COM A FILIAL ***********************************************
				IF upper(xnome_obj)=='CMD_FATURA'
					
					xalias=alias()
					SELE v_faturamento_05
					
					f_select("select valor_propriedade from propriedade_valida where propriedade = '00060' AND valor_propriedade=?v_faturamento_05.clifor","CurSelFilial",ALIAS())			
						
					IF ALLTRIM(CurSelFilial.valor_propriedade) == v_faturamento_05.clifor
						
						SELE v_faturamento_05_reservados
						GO TOP
						If !EMPTY(v_faturamento_05_reservados.caixa)
							SCAN
							f_select("select anm_tipo_faturamento,convert(numeric(1,0),anm_fatura_fab) as anm_fatura_fab from faturamento_caixas where caixa =?v_faturamento_05_reservados.caixa and nome_clifor =?v_faturamento_05.nome_clifor","CurSeleTipoCx",ALIAS()) 

								IF (v_faturamento_05.cod_filial = '000990' OR v_faturamento_05.cod_filial = '000987' OR v_faturamento_05.cod_filial = '000895') AND ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento) <> 'FABRICA'
									MESSAGEBOX("A Filial "+ALLTRIM(v_faturamento_05.filial)+" n�o � compativel com o tipo da Caixa ("+ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento)+") use a Filial RBX DISTRIBUIDORA")
									RETURN .f.								
								ELSE
									IF (v_faturamento_05.cod_filial = '000991' OR v_faturamento_05.cod_filial = '000988' OR v_faturamento_05.cod_filial = '000999' OR v_faturamento_05.cod_filial = '000898') AND ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento) <> 'DISTRIBUIDORA'
										MESSAGEBOX("A Filial "+ALLTRIM(v_faturamento_05.filial)+" n�o � compativel com o tipo da Caixa ("+ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento)+") use a Filial RBX FABRICA")
										RETURN .f.
									ELSE
										IF (v_faturamento_05.cod_filial = '000990' OR v_faturamento_05.cod_filial = '000987' OR v_faturamento_05.cod_filial = '000895') AND CurSeleTipoCx.anm_fatura_fab = 0
											MESSAGEBOX("A Caixa ("+ALLTRIM(v_faturamento_05_reservados.caixa)+") n�o foi retornada para sua Filial de FABRICA. Usar a Tela de consum�veis !!!",0+64)							
											RETURN .F.
										ENDIF
									ENDIF			
								ENDIF
							ENDSCAN
						Endif
					endif
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				ENDIF
				****************************** FIM DA VERIFICA��O**************************************************************************
				
				case upper(xmetodo) == 'USR_ALTER_BEFORE'
					xalias = alias()
					**** Verifica se NF teve baixa de devolucao (aviso de debito), caso tenha bloqueia o cancelamento da NF e informa o numero da baixa ***
					TEXT TO xVerifBaixa TEXTMERGE NOSHOW
						SELECT LANCAMENTO 
							FROM CTB_AVISO_LANCAMENTO_MOV 
							WHERE LANCAMENTO_MOV = REPLACE('<<V_FATURAMENTO_05.CTB_LANCAMENTO>>', '...', '')
					ENDTEXT
					
					f_select(xVerifBaixa, "VerifBaixa", ALIAS())
					
					SELECT VerifBaixa
					GO top
					IF	RECCOUNT() > 0	
						MESSAGEBOX("Imposs�vel Cancelar, Favor Solicitar ao Financeiro Cancelamento da Baixa: " + ALLTRIM(STR(VerifBaixa.LANCAMENTO)),0+48)
						RETURN .F.
					ENDIF
			
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
*!*					CASE UPPER(XMETODO) == 'USR_INCLUDE_AFTER'
*!*						xalias=alias()
*!*						f_update("Exec lx_anm_ajusta_preco_caixa_varejo")

*!*						if	!f_vazio(xalias)	
*!*							sele &xalias 
*!*						endif
				
				CASE UPPER(XMETODO) == 'USR_REFRESH'
					xalias = alias()
							
					
					
					*thisformset.lx_form1.Tv_filial.p_valida_where = thisformset.lx_form1.Tv_filial.p_valida_where +;
						" AND Filiais.rede_lojas IN (SELECT CONVERT(CHAR(6),VALOR_PROPRIEDADE) AS REDE_LOJAS FROM WPROPUSERS WHERE PROPRIEDADE = '01000' AND USUARIO = SYSTEM_USER) "
					*thisformset.lx_form1.Tv_cod_filial.p_valida_where = thisformset.lx_form1.Tv_cod_filial.p_valida_where +;
						" AND Filiais.rede_lojas IN (SELECT CONVERT(CHAR(6),VALOR_PROPRIEDADE) AS REDE_LOJAS FROM WPROPUSERS WHERE PROPRIEDADE = '01000' AND USUARIO = SYSTEM_USER) "
					
					IF !f_vazio(xalias)	
						sele &xalias
					endif

				
				CASE UPPER(XMETODO) == 'USR_SAVE_BEFORE'
					xalias = alias()
					
				* 17/06/2014 - TIAGO CARVALHO - SINTESE SOLU��ES - SS01 -INICIO -  BLOQUEIA O FATURAMENTO ONDE O TOTAL FATURADO POR CAIXA � DIFERENTE DO TOTAL DA CAIXA ORIGINAL DA CAIXA, OU SEJA, N�O DEIXA FATURAR CAIXA PARCIALMENTE. E ATUALIZA O NUMERO DO LACRE
				IF (thisformset.P_TOOL_STATUS == "I" OR thisformset.P_TOOL_STATUS == "A" ) AND F_VAZIO(v_faturamento_05.MOTIVO_CANCELAMENTO_NFE) AND thisformset.pp_anm_faturar_caixa_parcial = .f.
					
					SELECT CAIXA, ;
					SUM(F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+F13+F14+F15+F16+F17+F18+F19+F20+F21+F22+F23+F24+F25+F26+F27+F28+F29+F30+F31+F32+F33+F34+F35+F36+F37+F38+F39+F40+F41+F42+F43+F44+F45+F46+F47+F48) AS TOTAL_CAIXA_FATURAMENTO ;
						FROM v_faturamento_05_prod WITH (BUFFERING = .T.)  ;
						GROUP BY CAIXA ;
						INTO CURSOR curDivergencia
					
					lcObsLacre = ''
					
					SELECT curDivergencia
					GO TOP 
					SCAN FOR !F_VAZIO(ALLTRIM(curDivergencia.caixa))
						
						lcCaixa = ALLTRIM(curDivergencia.caixa)
						
						TEXT TO lcSql TEXTMERGE NOSHOW 
							SELECT	A.CAIXA, 
									NUMERO_LACRE = ISNULL(B.NUMERO_LACRE,'') , 
									TOTAL_CAIXA_ORIGINAL = SUM(E1+E2+E3+E4+E5+E6+E7+E8+E9+E10+E11+E12+E13+E14+E15+E16+E17+E18+E19+E20+E21+E22+E23+E24+E25+E26+E27+E28+E29+E30+E31+E32+E33+E34+E35+E36+E37+E38+E39+E40+E41+E42+E43+E44+E45+E46+E47+E48) 
									FROM VENDAS_PROD_EMBALADO A(NOLOCK)
									INNER JOIN FATURAMENTO_CAIXAS B(NOLOCK)
										ON A.CAIXA = B.CAIXA 
									WHERE A.CAIXA =?lcCaixa
							GROUP BY A.CAIXA,NUMERO_LACRE
							UNION ALL
							SELECT	A.CAIXA, 
									NUMERO_LACRE = '' , 
									TOTAL_CAIXA_ORIGINAL = SUM(F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+F13+F14+F15+F16+F17+F18+F19+F20+F21+F22+F23+F24+F25+F26+F27+F28+F29+F30+F31+F32+F33+F34+F35+F36+F37+F38+F39+F40+F41+F42+F43+F44+F45+F46+F47+F48) 
									FROM FATURAMENTO_PROD A(NOLOCK)
									INNER JOIN FATURAMENTO_CAIXAS B(NOLOCK)
										ON A.CAIXA = B.CAIXA 
									WHERE A.CAIXA =?lcCaixa
								GROUP BY A.CAIXA
						ENDTEXT
									
						IF !f_select(lcSql, "CurCaixaOriginal")
							MESSAGEBOX('Erro ao consultar total original da caixa, tente novamente', 0+48, 'OBJ-SS- ERRO FATURAMENTO')
							RETURN .F.
						ENDIF
						
						IF RECCOUNT([CurCaixaOriginal]) < 1
							MESSAGEBOX('Caixa n�o encontrada na origem tente novamente. Caixa:' + ALLTRIM(curDivergencia.Caixa),  0+48, 'OBJ-SS- ERRO FATURAMENTO')
							RETURN .F.				
						ENDIF
						
						IF !F_VAZIO(ALLTRIM(CurCaixaOriginal.NUMERO_LACRE))
							lcObsLacre = lcObsLacre + "CX/LACRE:"+ALLTRIM(CurCaixaOriginal.CAIXA)+"/"+ALLTRIM(CurCaixaOriginal.NUMERO_LACRE)+" "
						ENDIF
							
						lcTotalCaixaOriginal = NVL(CurCaixaOriginal.TOTAL_CAIXA_ORIGINAL, 0)
						
						SELECT CurCaixaOriginal
						USE
							
						SELECT curDivergencia
							
						IF NVL(curDivergencia.TOTAL_CAIXA_FATURAMENTO, 0) <> lcTotalCaixaOriginal
							MESSAGEBOX( 'A caixa:' + ALLTRIM(curDivergencia.caixa) + ' tem quantidade divergente da origem.' + CHR(10) + ;
										'Qtde Faturada: ' + ALLTRIM(str(curDivergencia.TOTAL_CAIXA_FATURAMENTO)) + ' Qtde Original:' + ALLTRIM(STR(lcTotalCaixaOriginal)) + CHR(10) + ;
										'Processo cancelado, Verifique a Caixa e Tente Novamente', 0+16, 'OBJ-SS- ERRO FATURAMENTO')
							SELECT curDivergencia
							USE
							RETURN .f.
						ENDIF
					ENDSCAN
					
					IF !("LACRE" $ UPPER(ALLTRIM(v_faturamento_05.OBS)) OR F_VAZIO(lcObsLacre))
					
						lcObsLacre = "Cod Destino:" + ALLTRIM(v_faturamento_05.cod_clifor) + " - " + lcObsLacre
						
						IF F_VAZIO(ALLTRIM(v_faturamento_05.OBS))
							REPLACE v_faturamento_05.OBS WITH lcObsLacre IN v_faturamento_05							
						ELSE
							REPLACE v_faturamento_05.OBS WITH ALLTRIM(v_faturamento_05.OBS) + ' ' + lcObsLacre IN v_faturamento_05
						ENDIF
					ENDIF
					
					SELECT curDivergencia
					USE
				ENDIF				
				* 17/06/2014 - TIAGO CARVALHO - SINTESE SOLU��ES SS01 - FIM -
				
				*** incluido a coluna filial para aparecer no campo obs - lucas miranda - 15/09/2016
					IF F_VAZIO(ALLTRIM(v_faturamento_05.OBS))
						REPLACE v_faturamento_05.OBS WITH ALLTRIM(v_faturamento_05.filial) IN v_faturamento_05							
					ELSE
						REPLACE v_faturamento_05.OBS WITH ALLTRIM(v_faturamento_05.filial) + '  ' + ALLTRIM(v_faturamento_05.OBS) IN v_faturamento_05
					ENDIF
				***
				* Marca automaticamente como conferido para gravar na NF o usuario que a fez.
				thisformset.LX_FORM1.Lx_pageframe1.Page7.Ck_conferido.value	= .T.
				thisformset.LX_FORM1.Lx_pageframe1.Page7.Ck_conferido.l_desenhista_recalculo()

				*****BLOQUEIA SALVAR FATURAMENTO SEM O PREENCHIMENTO DO PESO BRUTO >>> JULIO - 18/07, PARA SEGURAN�A NO GKO*****
				IF thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value = 0
					MESSAGEBOX("N�O � PERMITIDO SALVAR NOTA SEM O PESO BRUTO",48,"Aten��o!!!")
					return .f.
				ENDIF
				*****BLOQUEIA SALVAR FATURAMENTO SEM O PREENCHIMENTO DO PESO BRUTO >>> JULIO - 18/07 PARA SEGURAN�A NO GKO*****				 	
								
				*****VERIFICANDO QTDE DE FILIAIS ARMAZEM >>> NAO PODE HAVER MAIS DE UM ARMAZEM POR ENTRADA
				if	type("tmpArmazem")<>"U"
					sele tmpArmazem 
					use	
				endif	
					
				select * from v_faturamento_05_prod into cursor tmp_base1 where .f.
				
				sele tmp_base1
				=afields(xcampos)
				Create CURSOR vtmp_faturamento_05_prod From array xcampos
							
				Sele v_faturamento_05_prod 
				Go Top	
				scan	
					f_prog_bar('Verificando Qtde de Armazens...',recno(),reccount())		
					scatter to xmemvar
					sele vtmp_faturamento_05_prod 
					appe blank
					gather from xmemvar
					sele v_faturamento_05_prod 		
				endscan	
				f_prog_bar() 

				sele distinct filial_estoque from vtmp_faturamento_05_prod into cursor "tmpArmazem"
				
				sele tmpArmazem 
				if	reccount()>1
					messagebox("N�o � permitido salvar Entrada com mais de uma Filial de Armazem",48,"Aten��o!!!")
					retu .f.	
				else	
					sele v_faturamento_05
					repla filial_estoque with tmpArmazem.filial_estoque 	
				endif	
								
				*****VERIFICANDO QTDE DE FILIAIS ARMAZEM >>> NAO PODE HAVER MAIS DE UM ARMAZEM POR ENTRADA
				
				if	!f_vazio(xalias)
					sele &xalias			
				endif

				CASE UPPER(xmetodo) == 'USR_SAVE_AFTER' 
					xalias=alias()
					* Se a NF for uma tranferencia da fabrica para distribuidora vindo dem uma entrada por op, marca a entrada como transf
					* finializada marcando a coluna anm_sai_fabrica = 1
					IF  xSaiFabrica = 1
						TEXT TO xUpdtProd TEXTMERGE NOSHOW
							UPDATE ESTOQUE_PROD_ENT SET ANM_SAI_FABRICA = 1 
							WHERE ROMANEIO_PRODUTO IN (<<xRomaneiosProd>>)
						ENDTEXT
						
						f_update(xUpdtProd)
						xSaiFabrica = 0
						xRomaneiosProd = "''"
					ENDIF	
						
					if	!f_vazio(xalias)
						sele &xalias			
					endif					
				
				case upper(xmetodo) == 'USR_WHEN'
					xalias=alias()
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				case upper(xmetodo) == 'USR_VALID'
					xalias=alias()
					
					
					
					
										
					IF upper(xnome_obj)=='TV_NOME_CLIFOR'
						
						SELE v_faturamento_05
						
						** WRP - 22/03/2017 - Codigo para bloqueio da lei da moda
						** WRP - 23/03/2017 - Codigo atende necessidade do Julio Cesar apra controle de opera��es entre filiais
						PUBLIC xcod_natureza
						
						xcod_filial = v_faturamento_05.cod_filial
						xcod_clifor = v_faturamento_05.clifor
						xcod_natureza = v_faturamento_05.natureza_saida
						
							
							TEXT TO xselverifica2 TEXTMERGE NOSHOW
									SELECT natureza FROM anm_tb_lei_moda WHERE cod_emissor='<<xcod_filial>>' AND cod_destinatario='<<xcod_clifor>>'
							ENDTEXT
							f_select(xselverifica2,"Cur_XVerifica2")
							
							xcont2 = 0
							xcont_natureza2 = 0
							
							SELECT Cur_XVerifica2
								Go Top	
								xnatureza2 = ''
								scan		
									xcont2 = xcont2+1
									xnatureza2 = xnatureza2+' '+Cur_XVerifica2.natureza 
									*sele v_faturamento_05_prod		
							endscan
							
							
							IF (xcont2 <> 0)

								TEXT TO xselverifica TEXTMERGE NOSHOW
									SELECT natureza FROM anm_tb_lei_moda WHERE cod_emissor='<<xcod_filial>>' AND cod_destinatario='<<xcod_clifor>>' AND natureza='<<xcod_natureza>>'
								ENDTEXT
								
								f_select(xselverifica, "Cur_XVerifica", ALIAS())
								
								xcont = 0
								xcont_natureza = 0
								
								SELECT Cur_XVerifica
								Go Top	
								xnatureza = ''
								scan		
									xcont = xcont+1
									xnatureza = xnatureza+' '+Cur_XVerifica.natureza 
									*sele v_faturamento_05_prod
									IF (xcod_natureza ==  Cur_XVerifica.natureza)
										xcont_natureza = xcont_natureza + 1
									endif		
								endscan	
								
								IF (xcont_natureza < 1)
								
									MESSAGEBOX("Est� opera��o n�o poder� ser realizada com a natureza de opera��o "+xcod_natureza+" somente com a(s) :"+xnatureza2+"")
									RETURN .f.
								ENDIF
							
							ELSE
								IF (xcod_natureza = '120.04')
									MESSAGEBOX("Est� opera��o n�o poder� ser realizada com a natureza de opera��o 120.04")
									RETURN .f.
								endif
							Endif

						** FIM - WRP - 23/03/2017 - Codigo para bloqueio da lei da moda
						
						SELE v_faturamento_05
						
						TEXT TO xTabPreco TEXTMERGE NOSHOW
							SELECT B.FILIAL,CODIGO_TAB_PRECO 
							FROM CLIENTES_ATACADO A
						 	LEFT JOIN FILIAIS B
						 	ON A.CLIENTE_ATACADO = B.FILIAL
						 	WHERE CLIENTE_ATACADO = '<<V_FATURAMENTO_05.nome_clifor>>'
						ENDTEXT

						f_select(xTabPreco, "TabPreco", ALIAS())

						IF !f_vazio(TabPreco.filial)
							** WRP - 27/03/2017 - Codigo para setar tabela CT caso natureza de opera��o 120.04
							IF (xcod_natureza = '120.04' )
								thisformset.lx_form1.lx_PAGEFRAME1.page2.Cmb_tabela_preco.Value='CT' 
								thisformset.lx_form1.lx_pageframe1.page2.cmb_tabela_preco.Enabled=.f.
							ELSE
							** FIM - WRP - 22/03/2017 - Codigo para bloqueio da lei da moda
								thisformset.lx_form1.lx_PAGEFRAME1.page2.Cmb_tabela_preco.Value=TabPreco.CODIGO_TAB_PRECO 
								thisformset.lx_form1.lx_pageframe1.page2.cmb_tabela_preco.Enabled=.f.
							ENDIF
							
						ELSE 
							thisformset.lx_form1.lx_pageframe1.page2.cmb_tabela_preco.Enabled=.T.
						ENDIF 	
												
					ENDIF
					
					IF upper(xnome_obj)=='CMB_PEDIDOS'
					
						SELECT V_FATURAMENTO_05_PEDIDOS
						GO TOP
						
						f_select("SELECT TIPO FROM VENDAS WHERE CLIENTE_ATACADO NOT IN (SELECT FILIAL FROM FILIAIS) AND PEDIDO = ?V_FATURAMENTO_05_PEDIDOS.PEDIDO","xPedidos")
						
						Sele xPedidos
						If RECCOUNT()>0
							
							Thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.Enabled=.F.
							Thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_transportadora.Enabled= .F.
							Thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_transp_redespacho.Enabled= .F.
							
							sele V_FATURAMENTO_05
							replace tipo_faturamento WITH xPedidos.tipo
							
						Endif						
					ENDIF					
					
					IF upper(xnome_obj)=='CMB_CAIXAS'
					
					SELECT V_FATURAMENTO_05_RESERVADOS
					GO TOP
					
					f_select("SELECT TIPO FROM VENDAS WHERE CLIENTE_ATACADO NOT IN (SELECT FILIAL FROM FILIAIS) AND PEDIDO = ?V_FATURAMENTO_05_RESERVADOS.PEDIDO","xPedidoTipo")
					
					Sele xPedidoTipo
					If RECCOUNT()>0
						
						Thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.Enabled=.F.
						Thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_transportadora.Enabled= .F.
						Thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_transp_redespacho.Enabled= .F.
						
						sele V_FATURAMENTO_05
						replace tipo_faturamento WITH xPedidoTipo.tipo
						
					Endif	

					xalias=alias()
					SELE v_faturamento_05
					
					f_select("select valor_propriedade from propriedade_valida where propriedade = '00060' AND valor_propriedade=?v_faturamento_05.clifor","CurSelFilial",ALIAS())			

					if ALLTRIM(CurSelFilial.valor_propriedade) == v_faturamento_05.clifor
					
						SELE v_faturamento_05_reservados
						GO TOP
						If !EMPTY(v_faturamento_05_reservados.caixa) 
								
							f_select("select anm_tipo_faturamento,convert(numeric(1,0),anm_fatura_fab) as anm_fatura_fab from faturamento_caixas where caixa =?v_faturamento_05_reservados.caixa and nome_clifor =?v_faturamento_05.nome_clifor","CurSeleTipoCx",ALIAS()) 

								IF (v_faturamento_05.cod_filial = '000990' OR v_faturamento_05.cod_filial = '000987' OR v_faturamento_05.cod_filial = '000895') AND ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento) <> 'FABRICA'
									MESSAGEBOX("A Filial "+ALLTRIM(v_faturamento_05.filial)+" n�o � compativel com o tipo da Caixa ("+ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento)+") use a Filial RBX DISTRIBUIDORA")
									RETURN .f.
								ELSE
									IF (v_faturamento_05.cod_filial = '000991' OR v_faturamento_05.cod_filial = '000988' OR v_faturamento_05.cod_filial = '000999' OR v_faturamento_05.cod_filial = '000898') AND ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento) <> 'DISTRIBUIDORA'
										MESSAGEBOX("A Filial "+ALLTRIM(v_faturamento_05.filial)+" n�o � compativel com o tipo da Caixa ("+ALLTRIM(CurSeleTipoCx.anm_tipo_faturamento)+") use a Filial RBX FABRICA")
										RETURN .f.
									ELSE
										IF (v_faturamento_05.cod_filial = '000990' OR v_faturamento_05.cod_filial = '000987' OR v_faturamento_05.cod_filial = '000895') AND CurSeleTipoCx.anm_fatura_fab = 0
												MESSAGEBOX("A Caixa ("+ALLTRIM(v_faturamento_05_reservados.caixa)+") n�o foi retornada para sua Filial de FABRICA. Usar a Tela de consum�veis !!!",0+64)							
												RETURN .F.
										ENDIF
									ENDIF
								ENDIF
						Endif							
					endif
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				ENDIF
				****************************** FIM DA VERIFICA��O**************************************************************************					
					IF THISFORMSET.p_tool_status = 'I' 

						* Altera filial de rateio automaticamente conforme filial selecionada
						thisformset.lx_FORM1.Tv_cod_filial.refresh()									
				        thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tv_cod_filial.VALUE	
						f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_faturamento_05.rateio_filial", "curRATEIO",alias())
						thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tx_desc_RATEIO_FILIAL.Value = curRATEIO.desc_rateio_filial
					ENDIF

					if	!f_vazio(xalias)	
						sele &xalias 
					ENDIF
					
				case UPPER(xmetodo) == 'USR_SEARCH_AFTER'
					xalias=alias()
					F_SELECT("SELECT NF_SAIDA, SERIE_NF, FILIAL, STATUS_NFE FROM FATURAMENTO WHERE NF_SAIDA =?V_FATURAMENTO_05.NF_SAIDA AND SERIE_NF =?V_FATURAMENTO_05.SERIE_NF AND FILIAL =?V_FATURAMENTO_05.FILIAL","xFat",ALIAS())
					IF F_VAZIO(v_faturamento_05.data_saida) AND xFat.STATUS_NFE = 5
						thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_pageframe1.page1.bt_altera_data.visible = .T.	
					ENDIF
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif	
			
				case upper(xmetodo) == 'USR_CLEAN_AFTER'	
					xalias=alias()
							
					IF type("thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_pageframe1.page1.bt_altera_data") <> "U"
						thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_pageframe1.page1.bt_altera_data.visible = .F.
					ENDIF
														
					if !f_vazio(xalias)
						sele &xalias
					endif	
						
									
				otherwise
				return .t.				
			endcase
	endproc
ENDDEFINE

**************************************************
*-- Class:        lb_filial_estoque (p:\tmpsid\entradas_rbx\lb_filial_estoque.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filial_estoque AS lx_label
	Caption = "Filial Estoque"
	Height = 15
	Left = 460
	Top = 4
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filial_estoque"
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: lb_filial_estoque
**************************************************



**************************************************
*-- Class:        Estoque Entradas
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS bt_estoque_entradas AS commandbutton


	Top = 1 
	Left = 272
	Height = 32
	Width = 80
	Caption = "Entrada Estoque"
	Name = "bt_estoque_entradas"
	Visible=.t.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Seleciona Entradas Para Tranferencia de estoque"
	wordwrap = .T.
 
	PROCEDURE Click	
		IF THISFORMSET.p_tool_status != 'A' 
			DO FORM WDIR+"linx\exclusivos\sm100101_selop.scx"
		ENDIF
	ENDPROC

	FUNCTION l_Importa_itens_op STRING

			DELETE FROM  v_faturamento_05_prod
			
			DELETE FROM  v_faturamento_05_item
			  
			
		f_select("SELECT CODIGO_TAB_PRECO FROM CLIENTES_ATACADO where CLIENTE_ATACADO = ?V_FATURAMENTO_05.FILIAL","xTabPreco")
		
		** WRP - 27/03/2017 - Codigo para setar tabela CT caso natureza de opera��o 120.04
		IF (xcod_natureza = '120.04' )
			THISFORMSET.lx_form1.lx_PAGEFRAME1.page2.Cmb_tabela_preco.Value='CT'
		ELSE
		** FIM - WRP - 22/03/2017 - Codigo para bloqueio da lei da moda
			THISFORMSET.lx_form1.lx_PAGEFRAME1.page2.Cmb_tabela_preco.Value=xTabPreco.CODIGO_TAB_PRECO
		ENDIF 
		 		
		
		USE IN xTabPreco

		SELECT curOpEntrada
		GO TOP
		SCAN FOR selecione=1

			SELECT curOpEntrada	
			** MUDAN�A NO SELECT ABAIXO, ALGUEM ALTEROU COM ISSO ESTAVA PEGANDO TODAS OS TIPOS DE ENTRADAS SENDO QUE DEVERIA PEGAR SOMENTE O QUE � DE PEDIDO
			** LUCAS MIRANDA - 24/10/2016
			
				** WRP - 27/03/2017 - Codigo para setar tabela CT caso natureza de opera��o 120.04
			IF (xcod_natureza = '120.04' )
			
				TEXT TO xSelProdRomaneio TEXTMERGE NOSHOW
			
					SELECT A.ROMANEIO_PRODUTO,ISNULL(A.ORDEM_PRODUCAO,C.PEDIDO) AS ORDEM_PRODUCAO,A.PRODUTO,A.COR_PRODUTO,(B.PRECO1) as PRECO1,QTDE,
					A.EN_1,A.EN_2,A.EN_3,A.EN_4,A.EN_5,A.EN_6,A.EN_7,A.EN_8,
					A.EN_9,A.EN_10,A.EN_11,A.EN_12,A.EN_13,A.EN_14,A.EN_15,A.EN_16
					FROM ESTOQUE_PROD1_ENT A
					JOIN PRODUTOS_PRECOS B
					ON A.PRODUTO=B.PRODUTO
					JOIN ESTOQUE_PROD_ENT C
					ON A.ROMANEIO_PRODUTO = C.ROMANEIO_PRODUTO
					AND A.FILIAL = C.FILIAL
					WHERE A.ROMANEIO_PRODUTO = '<<curOpEntrada.ROMANEIO_PRODUTO>>'
					AND B.CODIGO_TAB_PRECO = 'CT'
					AND ISNULL(A.ORDEM_PRODUCAO,C.PEDIDO) IS NOT NULL
					AND C.EMISSAO >= '20160101'
					AND C.TIPO_ENTRADA IN ('2','3','4')
					
				ENDTEXT 
				
			ELSE
			** FIM - WRP - 22/03/2017 - Codigo para bloqueio da lei da moda
				
				TEXT TO xSelProdRomaneio TEXTMERGE NOSHOW
			
					SELECT A.ROMANEIO_PRODUTO,ISNULL(A.ORDEM_PRODUCAO,C.PEDIDO) AS ORDEM_PRODUCAO,A.PRODUTO,A.COR_PRODUTO,(B.PRECO1) as PRECO1,QTDE,
					A.EN_1,A.EN_2,A.EN_3,A.EN_4,A.EN_5,A.EN_6,A.EN_7,A.EN_8,
					A.EN_9,A.EN_10,A.EN_11,A.EN_12,A.EN_13,A.EN_14,A.EN_15,A.EN_16
					FROM ESTOQUE_PROD1_ENT A
					JOIN PRODUTOS_PRECOS B
					ON A.PRODUTO=B.PRODUTO
					JOIN ESTOQUE_PROD_ENT C
					ON A.ROMANEIO_PRODUTO = C.ROMANEIO_PRODUTO
					AND A.FILIAL = C.FILIAL
					WHERE A.ROMANEIO_PRODUTO = '<<curOpEntrada.ROMANEIO_PRODUTO>>'
					AND B.CODIGO_TAB_PRECO = '17'
					AND ISNULL(A.ORDEM_PRODUCAO,C.PEDIDO) IS NOT NULL
					AND C.EMISSAO >= '20160101'
					AND C.TIPO_ENTRADA IN ('2','3','4')
					
				ENDTEXT 

			ENDIF 
			
				f_select(xSelProdRomaneio,"CurProdRomaneio",ALIAS())
				
				xRomaneiosProd = xRomaneiosProd+",'"+CurProdRomaneio.ROMANEIO_PRODUTO+"',"
				xRomaneiosProd = LEFT(xRomaneiosProd,LEN(xRomaneiosProd)-1)
				
			SELECT CurProdRomaneio
			GO TOP
			SCAN
				thisformset.lx_FORM1.lx_pageframe1.page3.SetFocus()
				o_toolbar.Botao_filhas_inserir.Click()

				thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_PRODUTO.tv_PRODUTO.value= ALLTRIM(CurProdRomaneio.PRODUTO)
				thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_PRODUTO.tv_PRODUTO.valid(18)
				
				thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_cor_PRODUTO.tv_cor_PRODUTO.value = CurProdRomaneio.COR_PRODUTO
				thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_cor_PRODUTO.tv_cor_PRODUTO.valid(18)
				
				
			
				SELECT V_FATURAMENTO_05_PROD
				
				REPLACE INDICADOR_CFOP  WITH 11
				REPLACE	F1              WITH CurProdRomaneio.EN_1
				REPLACE	F2            	WITH CurProdRomaneio.EN_2
				REPLACE	F3        		WITH CurProdRomaneio.EN_3
				REPLACE	F4      	    WITH CurProdRomaneio.EN_4
				REPLACE	F5      	    WITH CurProdRomaneio.EN_5
				REPLACE	F6      	    WITH CurProdRomaneio.EN_6
				REPLACE	F7     		    WITH CurProdRomaneio.EN_7
				REPLACE	F8          	WITH CurProdRomaneio.EN_8
				REPLACE	F9          	WITH CurProdRomaneio.EN_9
				REPLACE	F10         	WITH CurProdRomaneio.EN_10
				REPLACE	F11         	WITH CurProdRomaneio.EN_11
				REPLACE	F12         	WITH CurProdRomaneio.EN_12
				REPLACE	F13         	WITH CurProdRomaneio.EN_13
				REPLACE	F14         	WITH CurProdRomaneio.EN_14
				REPLACE	F15         	WITH CurProdRomaneio.EN_15
				REPLACE	F16         	WITH CurProdRomaneio.EN_16
				REPLACE QTDE	    	WITH CurProdRomaneio.QTDE
				REPLACE PRECO	    	WITH CurProdRomaneio.PRECO1
				REPLACE VALOR       	WITH (V_FATURAMENTO_05_PROD.PRECO*CurProdRomaneio.QTDE)
				REPLACE ORDEM_PRODUCAO  WITH CurProdRomaneio.ORDEM_PRODUCAO
				
				SELECT CurProdRomaneio
				
				thisformset.lx_FORM1.lx_pageframe1.page3.SetFocus()
			ENDSCAN	
		ENDSCAN	
		
			SELECT V_FATURAMENTO_05
		
			REPLACE CONDICAO_PGTO     WITH "999"
			REPLACE TRANSPORTADORA    WITH V_FATURAMENTO_05.FILIAL
			REPLACE TRANSP_REDESPACHO WITH V_FATURAMENTO_05.FILIAL
			REPLACE PESO_BRUTO        WITH 0.001
			REPLACE VOLUMES           WITH 1
			REPLACE TIPO_FATURAMENTO  WITH "TRANSFERENCIAS"
			
		thisformset.lx_FORM1.lx_pageframe1.ActivePage=1
		thisformset.lx_FORM1.lx_pageframe1.ActivePage=2
		
		xSaiFabrica = 1
		
	ENDFUNC

ENDDEFINE
*
*-- EndDefine: Estoque Entradas	
	


**************************************************
*-- Class:        cmb_filial_estoque (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_filial_estoque AS lx_combobox


	RowSource = "xfiliais_estoque"
	Height = 22
	Left = 530
	TabIndex = 1
	Top = 1
	Width = 160
	ZOrderSet = 5
	Name = "cmb_filial_estoque"
	Visible = .t.
	Enabled = .t.

ENDDEFINE
*
*-- EndDefine: cmb_filial_estoque
**************************************************

*-- Class:        bt_altera_data (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
DEFINE CLASS bt_altera_data AS botao
	Top = 45
	Left = 580
	Height = 23
	Width = 121
	FontBold = .T.
	Caption = "Incluir Data Sa�da"
	TabIndex = 40
	Name = "bt_altera_data"
	Visible = .F.

	PROCEDURE Click
		IF F_VAZIO(v_faturamento_05.data_saida) AND thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_pageframe1.page1.bt_altera_data.caption == "Incluir Data Sa�da" 
				with thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1
					.bt_altera_data.caption = "Salvar"
				    .tx_data_saida.Enabled= .T.
				endwith    
		ELSE 		 
				f_insert("UPDATE FATURAMENTO SET DATA_SAIDA =?V_FATURAMENTO_05.DATA_SAIDA WHERE NF_SAIDA =?V_FATURAMENTO_05.NF_SAIDA AND SERIE_NF =?V_FATURAMENTO_05.SERIE_NF AND FILIAL =?V_FATURAMENTO_05.FILIAL AND STATUS_NFE = 5")
				MESSAGEBOX("Data Incluida Com Sucesso",0+64)
				
				with thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1
					.bt_altera_data.caption = "Incluir Data Sa�da"
				    .tx_data_saida.Enabled= .F.
				endwith
		ENDIF	
	ENDPROC
ENDDEFINE