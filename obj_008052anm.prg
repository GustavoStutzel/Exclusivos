* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  14/02/2010                                                                                      *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Filial Estoque em funcao das entradas RBX/TRIMIX
*TRATAMENTO PARA FATURAMENTO RBX/TRIMIX E MOVIMENTACAO ESTOQUE ATAACDO/ESTOQUE CENTRAL						                    *
********************************************************************************************************************* 
******************************************************
*- Programa Base de Cria��o de Objeto de Entrada
********************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos 
*******************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:  
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento
*********************************************************************************
  

*********************************************************************************
* - Atencao !!!!!!!!!!!														   -*
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP -*
*********************************************************************************

*
*                 Abaixo segue Programa objeto sem Codigo 
*
*
*- Definindo a classe do objeto de entrada que sera criado na Form.
define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.
	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT
		*	USR_ALTER_BEFORE  ->Return .f. Para o Metodo
		*	USR_ALTER_AFTER    
		*	USR_INCLUDE_AFTER
		*	USR_SEARCH_BEFORE ->Return .f. Para o Metodo
		*	USR_SEARCH_AFTER
		*	USR_CLEAN_AFTER
		*	
		*	USR_SAVE_BEFORE   ->Return .f. Para o Metodo 
		*	USR_SAVE_AFTER
		*	USR_ITEN_DELETE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_DELETE_AFTER
		*	USR_ITEN_INCLUDE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_INCLUDE_AFTER
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form
			
 
				case UPPER(xmetodo) == 'USR_INIT' 
				
					xalias=alias()
			     	
			     	sele v_producao_geracao_01_programacao
					xalias_pai=alias()

					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRODUCAO_PROGRAMA.FILIAL AS FILIAL_ESTOQUE" , "C(25)",.T., "FILIAL_ESTOQUE", "FILIAL_ESTOQUE")
					oCur.confirmstructurechanges()  		
					
					Thisformset.L_limpa()
					o_toolbar.Botao_limpa.Click()  
					 
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
				    
				case UPPER(xmetodo) == 'USR_BTO_AVANCA_ANTES' AND upper(xnome_obj) == 'CMDAVANCA'
								if Thisformset.LX_FORM1.LX_PAGEFRAME1.page4.LX_PAGEFRAME1.ActivePage = 1 
									f_select("select * from prop_producao_programa where propriedade ='00038' and programacao =?v_producao_ordem_01.programacao","xVerTipoProg")
									sele xVerTipoProg
									
									if xVerTipoProg.valor_propriedade = 'MOSTRUARIO'
										Sele v_producao_geracao_00_programacao
										Scan
											f_select("select * from anm_tb_bloq_ficha_tecnica_pa where produto = ?v_producao_geracao_00_programacao.produto","xVerFinMost")
											TEXT TO xVerFinMost NOSHOW TEXTMERGE
												select b.revenda, a.* 
												from anm_tb_bloq_ficha_tecnica_pa a
												join produtos b
												ON a.produto = b.produto
												where a.produto = ?v_producao_geracao_00_programacao.produto
												and b.revenda = 0
											ENDTEXT
											F_SELECT(xVerFinMost, 'Cur_VerFinMost')
											
											Sele Cur_VerFinMost
											
											TEXT TO xVerFinRede NOSHOW TEXTMERGE
												select b.produto from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA') A
												JOIN PRODUTOS B
												ON A.REDE_LOJAS = B.REDE_LOJAS
												WHERE A.VALOR_ATUAL ='SIM'
												AND B.PRODUTO = ?v_producao_geracao_00_programacao.produto
											ENDTEXT
											F_SELECT(xVerFinRede, 'Cur_VerFinRede')
											
											Sele Cur_VerFinRede
											
											If !F_VAZIO(Cur_VerFinMost.produto) and !F_VAZIO(Cur_VerFinRede.produto)
												If xVerFinMost.ft_most_pronto = .f. and v_producao_geracao_00_programacao.marca = 1
													xProd = xVerFinMost.produto
													Messagebox("O Produto "+alltrim(xProd)+" n�o est� finalizado !!!",0+16,"Bloqueio Mostru�rio")
													Release xVerFinMost
													Return .F. 
												Endif
											Endif
										Endscan
										Sele v_producao_geracao_00_programacao
										Go Top
									endif
									
									**** Lucas Miranda - 16/03/2017 - Bloqueia Programa��o *****
										Sele V_Producao_Geracao_00_Programacao
										Go Top 
											xMsgBloq = ''
											Scan
												If V_Producao_Geracao_00_Programacao.marca = 1
													
													TEXT TO xBloqProg NOSHOW TEXTMERGE
														SELECT DISTINCT A.PRODUTO
														FROM PRODUTOS (nolock) A 
														JOIN PRODUTO_OPERACOES_ROTAS (nolock) B
														ON A.TABELA_OPERACOES = B.TABELA_OPERACOES
														JOIN PRODUCAO_RECURSOS (nolock) C
														ON B.RECURSO_PRODUTIVO = C.RECURSO_PRODUTIVO
														JOIN CADASTRO_CLI_FOR (nolock) D
														ON C.NOME_CLIFOR = D.NOME_CLIFOR
														JOIN PROP_FORNECEDORES (nolock) E
														ON D.NOME_CLIFOR = E.FORNECEDOR
														AND E.PROPRIEDADE = '00465'
														AND E.VALOR_PROPRIEDADE = 'SIM'
														WHERE A.PRODUTO =?V_Producao_Geracao_00_Programacao.produto
													ENDTEXT
													
													F_SELECT(xBloqProg,"Cur_BloqProd")
													
													If !F_VAZIO(Cur_BloqProd.Produto)
														xMsgBloq = xMsgBloq + ALLTRIM(V_Producao_Geracao_00_Programacao.produto)+'\'+ALLTRIM(V_Producao_Geracao_00_Programacao.cor_produto) +', '
													Endif
												Endif
											Endscan
											
											If !F_Vazio(xMsgBloq)
												MESSAGEBOX('Existe(m) produto(s) na rota com o fornecedor bloqueado programa��o !!! '+CHR(13)+CHR(13)+"Refer�ncias\Cor: "+LEFT(xMsgBloq,LEN(xMsgBloq)-2),0+16,"Bloqueia Programa��o")
												Return .F.
											Endif
									**** Bloqueia Programa��o *****
								
								Endif		  
			otherwise
			return .t.				
		endcase
	endproc
enddefine
