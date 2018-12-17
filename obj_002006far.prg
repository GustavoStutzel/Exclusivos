* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  01-03-2014                                                                                      *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                               			*
* OBJETIVO.: 					                    																*
********************************************************************************************************************* 

* Altera��o ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Cria��o de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT  												=> NA INICIALIZACAO DA TELA 
		*	USR_ALTER_BEFORE  -> Return .f. Para o Metodo 			=> ANTES DA ALTERACAO ,AO CLICKAR ANTES DE LIBERAR OS CAMPOS
		*	USR_ALTER_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO   
		*	USR_INCLUDE_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
		*	USR_SEARCH_BEFORE -> Return .f. Para o Metodo PESQUISA	=> ANTES DE FAZER A PESQUISA NO BANCO
		*	USR_SEARCH_AFTER										=> APOS FAZER A PESQUISA NO BANCO
		*	USR_CLEAN_AFTER 										=> APOS LIMPAR A TELA 
		*	USR_REFRESH                                             => 
		*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
		*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
		*	USR_ITEN_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
		*	USR_ITEN_DELETE_AFTER                                   => APOS DELETAR UM ITEM NA TABELA FILHA '-' 
		*	USR_ITEN_INCLUDE_BEFORE -> Return .f. Para o Metodo 	=> ANTES DE INCLUIR ITEM NA TABELA FILHA
		*	USR_ITEN_INCLUDE_AFTER									=> APOS INCLUIR ITEM NA TABELA FILHA 
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback ANTES DE EXECUTAR UMA TRIGGER
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_INIT'
				**** Documenta��o ****
				*** #GS01 - 09/11/2017 - Lucas Miranda (Grupo Soma): Inclus�o da coluna GS_NOTA_PROD - Solicitante Roberto Fonseca *** 
				*** #GS02 - 20/12/2017 - Lucas Miranda (Grupo Soma): Inclus�o do bot�o para importar tempo de produ��o para a propriedade 00528
				**** Fim Documenta��o ****	

				* 16/12/2014 - Leandro Rocha (SS): Adiciona bot�o para importar o cadastro de produtos
		        Thisformset.lx_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page1.AddObject('btn_Importa_Cadatro', 'cls_botao_importar')
				
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT

				*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
				Public xValorparAntes, xRedeLojasCod, xValorParNovo
				 
				xValorparAntes = ''		
				xRedeLojasCod = ''
				xValorParNovo = ''
				*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
				
				*** #GS01 ***
				xOldValueNota=''
				*** Fim - #GS01 ***
				
					xalias=alias()
						*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***
						sele v_produtos_00  
						xalias_pai=alias()
		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("PRODUTOS.ANM_DATA_STATUS_CAD", "D",.T., "Status Cad", "PRODUTOS.ANM_DATA_STATUS_CAD")
						oCur.addbufferfield("PRODUTOS.ANM_DATA_STATUS_MOST", "D",.T., "Status Most", "PRODUTOS.ANM_DATA_STATUS_MOST")
						oCur.confirmstructurechanges() 
	  					*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***	
						
						**** #1# - INICIO ****
						thisformset.lx_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page1.Lx_combobox4.ColumnWidths="600,50"
						**** #1# - FIM ****
						
						**** #2# - INICIO ****
						thisformset.LX_FORM1.LX_PAGEFRAME1.PAge1.PGDADOSPRODUTOS.Page1.TV_REDE_LOJAS.P_Valida_where=;
						thisformset.LX_FORM1.LX_PAGEFRAME1.PAge1.PGDADOSPRODUTOS.Page1.TV_REDE_LOJAS.P_Valida_where+;
						" and rede_lojas < 9 AND rede_lojas IN (SELECT CONVERT(CHAR(6),VALOR_PROPRIEDADE) AS REDE_LOJAS FROM WPROPUSERS WHERE PROPRIEDADE='01000' AND USUARIO=SYSTEM_USER)"
						**** #2# - FIM ****
												
						*** Altera o valor do Label ***
						if type("thisformset.lx_FORM1.lx_PAGEFRAME1.page7.lX_PAGEFRAME1.page1.lx_label14")<>"U"
							
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page4.Lx_label14.Caption="Composi��o 2"
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page4.Lx_label13.Caption="Composi��o 3"
						
						endif	
						*** Altera o valor do Label *** FIM ***
						
						**Adiciona Botao Composi��o - Lucas Miranda 29/07/2015***
						With thisformset.LX_FORM1.LX_PAGEFRAME1.PAGE1.PgDadosProdutos.Page1
							.AddObject("btn_ccomposicao","btn_ccomposicao")
						Endwith
						
						*** Filtra griffe que tenha o valor royalties > 0 ***
						if type("thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page1.tvGriffe")<>"U"
							
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page1.tvGriffe.p_valida_where="  and ROYALTIES > 0.00001 "
						*** Filtra rede lojas < codigo 9 ***	
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.page1.Tv_rede_lojas.p_valida_where = ' and rede_lojas < 9'
						
						endif	
						*** Filtra griffe que tenha o valor royalties > 0 *** FIM ***
						
						
						*** Inativa opcoes nao usados na gerar de codigo de barras	*** 		
						WITH thisformset.lx_FORM1.lx_pageframe1.page3.OPT_PADRAO
							.option1.enabled = .F.
							.option2.enabled = .F.
							.option3.enabled = .F.
							.option5.enabled = .F.
							.option6.enabled = .F.
						endwith
						*** Inativa opcoes nao usados na gerar de codigo de barras	*** FIM ***
						
					
						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_produtos_tamanho_00 
						sele v_produtos_tamanho_00
						xalias_pai=alias()


		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("PRODUTOS_TAMANHOS.INATIVO as INATIVO", "L",.F., "INATIVO", "INATIVO")				
						oCur.confirmstructurechanges() 	
						**-Fim Inclusao Campos Novos de Tickets no Cursor Pai 		
						
						with thisformset.lx_form1.lx_PAGEFRAME1.page5
							.addobject("bt_tabPreco","bt_tabPreco")								
						endwith	
						
						**** PERIODO COR ** DANIEL FREITAS ***
						Sele v_produtos_00_cores_mat
						xalias_pai=Alias()

							oCur = Getcursoradapter(xalias_pai)
							oCur.addbufferfield("PRODUTO_CORES.ANM_PERIODO_COR", "C(25)",.T., "ANM_PERIODO_COR", "PRODUTO_CORES.ANM_PERIODO_COR")
							oCur.addbufferfield("PRODUTO_CORES.LIBERAR_GRADE_WEB", "L",.F., "LIBERAR_GRADE_WEB", "PRODUTO_CORES.LIBERAR_GRADE_WEB")
							*** #GS01
							oCur.addbufferfield("PRODUTO_CORES.GS_NOTA_PROD", "N(16,2)",.T., "Nota Produto", "PRODUTO_CORES.GS_NOTA_PROD")
							*** Fim - #GS01
							
							*** #GS03
							oCur.addbufferfield("PRODUTO_CORES.GS_ETAPA", "C(25)",.T., "Etapa Atacado", "PRODUTO_CORES.GS_ETAPA")	
							oCur.addbufferfield("PRODUTO_CORES.GS_QTDE_VENDIDA_ETAPA", "I",.T., "Qtde Vendida Etapa 1", "PRODUTO_CORES.GS_QTDE_VENDIDA_ETAPA")
							*** Fim - #GS03
							
							oCur.confirmstructurechanges()
						**-Fim Inclusao Campos Novos de Produtos no Cursor Pai
					**** PERIODO COR ** DANIEL FREITAS ***
					**** PERIODO COR ** DANIEL FREITAS ***	
					f_select("select PERIODO_PCP from PRODUTOS_PERIODOS_PCP (nolock)","xperiodo_pcp")
					
					WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
							lcColumnCount = .ColumnCount
							lcColumnCount = lcColumnCount + 1
							.AddColumn(lcColumnCount )
							.Columns[lcColumnCount].Name = 'col_periodo_cor'
								.col_periodo_cor.Width = 150
								*.col_periodo_cor.BackColor = 15399423
								.col_periodo_cor.ColumnOrder = 7
								.col_periodo_cor.header1.Caption = 'Periodo Cor'
								.col_periodo_cor.header1.Alignment = 2
								.col_periodo_cor.header1.FontSize = 8
								.col_periodo_cor.RemoveObject('text1')
								.col_periodo_cor.AddObject('cmb_periodo_cor','cmb_periodo_cor')
								.col_periodo_cor.Sparse = .F.
								.col_periodo_cor.Refresh()
								.col_periodo_cor.cmb_periodo_cor.RowSource="xperiodo_pcp"
								.col_periodo_cor.ControlSource="v_produtos_00_cores_mat.anm_periodo_cor"
					ENDWITH
					**** PERIODO COR ** DANIEL FREITAS ***
					
					*** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
				WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
						.AddColumn(1)
						.Column1.Name='cl_Liberar_Grade'
						WITH .cl_Liberar_Grade
								.BackColor = RGB(251,245,220)
								.Header1.Name='h_Liberar_Grade'
								.h_Liberar_Grade.Caption='Liberar Grade'
								.AddObject('ck_Liberar_Grade_Web','CheckBox')
								.Sparse= .F.
								.CurrentControl = 'ck_Liberar_Grade_Web'
								.ck_Liberar_Grade_Web.Caption=""
								.ColumnOrder = 1
								.CK_LIBERAR_GRADE_WEB.BackStyle = 0
								.ck_Liberar_Grade_web.Visible = .T.
								.ck_Liberar_Grade_web.Enabled = .F.
								.RemoveObject("text1") 
								.ControlSource="V_PRODUTOS_00_CORES_MAT.LIBERAR_GRADE_WEB"
						ENDWITH	
				ENDWITH						
				***FIM - #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
				
				ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.AddObject("btn_importa_nota","btn_importa_nota")
				*** #GS02
				ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.AddObject("btn_import_tmp_producao","btn_import_tmp_producao")
				*** #GS02
				
				*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***
					with Thisformset.lx_form1.lx_pageframe1.page1.pgDadosProdutos.page4
						.addobject("lb_status_cad","lb_status_cad")
						.addobject("anm_txt_status_cad","anm_txt_status_cad")
						.addobject("lb_status_most","lb_status_most") 
						.addobject("anm_txt_status_most","anm_txt_status_most") 						
					endwith
				*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***
				
				*** #GS01 
				WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
						lcColumnCount = .ColumnCount
						lcColumnCount = lcColumnCount + 1
						.AddColumn(lcColumnCount )
						.Columns[lcColumnCount].Name = 'cl_gs_nota_prod'
						WITH .cl_gs_nota_prod
								.BackColor = RGB(251,245,220)
								.Header1.Name='h_gs_nota_prod'
								.h_gs_nota_prod.Caption='Nota Produto'
								.h_gs_nota_prod.FontSize=8
								.h_gs_nota_prod.Alignment = 2
								.h_gs_nota_prod.FontName='Tahoma'
								.AddObject('tx_gs_nota_prod','tx_gs_nota_prod')
								.Sparse= .F.
								.CurrentControl = 'tx_gs_nota_prod'
								*.tx_gs_nota_prod.Caption=""
*								.ColumnOrder = 1
								.tx_gs_nota_prod.BackStyle = 0
								.tx_gs_nota_prod.Visible = .T.
								.tx_gs_nota_prod.Enabled = .F.
								.tx_gs_nota_prod.InputMask="99.99"
								.RemoveObject("text1")
								.ControlSource="V_PRODUTOS_00_CORES_MAT.gs_nota_prod"
						ENDWITH	
				ENDWITH		
				
				*** #GS03
								F_SELECT("SELECT valor_propriedade FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE = '00554' AND DATA_DESATIVACAO IS NULL","xEtapaVend")
				WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
						lcColumnCount = .ColumnCount
						lcColumnCount = lcColumnCount + 1
						.AddColumn(lcColumnCount )
						.Columns[lcColumnCount].Name = 'col_gs_etapa'
							.col_gs_etapa.Width = 150
							.col_gs_etapa.BackColor = RGB(251,245,220)
							*.col_gs_etapa.ColumnOrder = 9
							.col_gs_etapa.header1.Caption = 'Etapa Atacado'
							.col_gs_etapa.header1.Alignment = 2
							.col_gs_etapa.header1.FontName='Tahoma'
							.col_gs_etapa.header1.FontSize = 8
							.col_gs_etapa.RemoveObject('text1')
							.col_gs_etapa.AddObject('cmb_gs_etapa','cmb_gs_etapa')
							.col_gs_etapa.Sparse = .F.
							.col_gs_etapa.Refresh()
							.col_gs_etapa.cmb_gs_etapa.RowSource="xEtapaVend"
							.col_gs_etapa.ControlSource="v_produtos_00_cores_mat.gs_etapa"
				ENDWITH
				
				WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
						lcColumnCount = .ColumnCount
						lcColumnCount = lcColumnCount + 1
						.AddColumn(lcColumnCount )
						.Columns[lcColumnCount].Name = 'cl_gs_qtde_vendida_etapa'
						WITH .cl_gs_qtde_vendida_etapa
								.Width = 115
								.BackColor = RGB(251,245,220)
								.Header1.Name='h_gs_qtde_vendida_etapa'
								.h_gs_qtde_vendida_etapa.Caption='Qtde Vendida Etapa 1'
								.h_gs_qtde_vendida_etapa.FontSize=8
								.h_gs_qtde_vendida_etapa.Alignment = 2
								.h_gs_qtde_vendida_etapa.FontName='Tahoma'
								.AddObject('tx_gs_qtde_vendida_etapa','tx_gs_qtde_vendida_etapa')
								.Sparse= .F.
								.CurrentControl = 'tx_gs_qtde_vendida_etapa'
								*.tx_gs_nota_prod.Caption=""
*								.ColumnOrder = 1
								.tx_gs_qtde_vendida_etapa.BackStyle = 0
								.tx_gs_qtde_vendida_etapa.Visible = .T.
								.tx_gs_qtde_vendida_etapa.Enabled = .F.
								.RemoveObject("text1")
								.ControlSource="V_PRODUTOS_00_CORES_MAT.GS_QTDE_VENDIDA_ETAPA"
						ENDWITH	
				ENDWITH					
				
				***Fim - #GS03
				
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
						THISFORMSET.L_LIMPA()
				** #1 - LUCAS MIRANDA - 23/03/2016 - CORRE��O DO OBJETO PRODUTOS_001 PARA PRODUTOS_999		
				case UPPER(xmetodo) == 'USR_ALTER_BEFORE' AND upper(xnome_obj)== 'PRODUTOS_999'
				thisformset.p_bloqueia_alteracoes=.f.
				** FIM - #1 - LUCAS MIRANDA - 23/03/2016 - CORRE��O DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
				*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
					f_select("SELECT * FROM FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_CODIGO_PRODUTO') WHERE REDE_LOJAS = ?v_produtos_00.rede_lojas","curValorParAntes")
					xValorparAntes = curValorParAntes.valor_atual
					xRedeLojasCod = v_produtos_00.rede_lojas
				*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
				
				case UPPER(xmetodo) == 'USR_ALTER_AFTER' AND upper(xnome_obj)== 'PRODUTOS_999' 
				
					*** #GS01 
					xOldValueNota=''
					*** Fim - #GS01
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE'
				
					xalias=alias()										
					
					*** N�o aceitar que o campo rede lojas seja vazio ***********
					IF EMPTY(NVL(Thisformset.LX_FORM1.LX_pageframe1.PAge1.pgDadosProdutos.page1.Tv_rede_lojas.Value,''))
						MESSAGEBOX("Obrigat�rio o preenchimento do Campo Rede Lojas !!!",0+64)
						Thisformset.LX_FORM1.LX_pageframe1.PAge1.pgDadosProdutos.page1.Tv_rede_lojas.SetFocus()
						RETURN .F.
					ENDIF	
					*** N�o aceitar que o campo rede lojas seja vazio *** FIM ***
					****** PERIODO_COR ** DANIEL FREITAS
					IF THISFORMSET.PP_anm_bloq_periodo_cor = .T.
						SELE V_PRODUTOS_00_CORES_MAT
						GO TOP
							SCAN
								IF F_VAZIO(V_PRODUTOS_00_CORES_MAT.anm_periodo_cor) AND V_PRODUTOS_00.STATUS_PRODUTO = '04'
									MESSAGEBOX("FAVOR INFORMAR UM PER�ODO COR PARA A COR: "+V_PRODUTOS_00_CORES_MAT.cor_produto,0+16)
									RETURN .F.
								ENDIF	
							SELE V_PRODUTOS_00_CORES_MAT
							ENDSCAN
						SELE V_PRODUTOS_00_CORES_MAT
					ENDIF
					****** PERIODO_COR ** DANIEL FREITAS
					if	!f_vazio(xalias)	
						sele &xalias 
					endif

				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
							
				
					xalias=alias()
						
						f_select("select produto from produtos where produto=?v_produtos_00.produto","xProduto")
						xCodProduto=xProduto.produto
						f_update("EXEC SOMA.DBO.LX_ANM_GERA_CUSTO_OP_TRANSFORMACAO ?xCodProduto")
						
				
					if !f_vazio(xalias)
						sele &xalias
					endif					
					
					case UPPER(xmetodo) == 'USR_WHEN' AND (THISFORMSET.P_tool_status == 'I' OR THISFORMSET.P_tool_status == 'A')
						
						xalias=alias()
						
							IF upper(xnome_obj)== 'CMB_PROPRIEDADE'
								***#6 - LUCAS MIRANDA - 05/05/2016 - PROBLEMA AO CLICAR NA ABA PROPRIEDADE DE PA
								*** TROCADO NO IF
									IF 	ALLTRIM(THISFORMSET.lx_FORM1.lx_PAGEFRAME1.page_pROPS.pageframe_grupos.page_xyz.grid_produtos.col_tx_valor_propriedade.cmb_propriedade.value) = 'PRODU�AO'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL.value = '113301'&&'1.1.3.01.08'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_COMPRA.value = '353104'&&'3.2.1.08.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_COMPRA.value = '353105'&&'3.2.1.08.02'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_VENDA.value = '311101'&&'3.1.1.01.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_VENDA.value = '321101'&&'3.1.2.02.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tx_indicador_CFOP.value = '10'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.cmb_tipo_item_sped.value = '04'
									ELSE
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL.value = '113302'&&'1.1.3.01.06'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_COMPRA.value = '352102'&&'3.2.1.06.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_COMPRA.value = '352103'&&'3.2.1.06.02'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_VENDA.value = '311101'&&'3.1.1.01.03'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_VENDA.value = '321101'&&'3.1.2.02.02'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tx_indicador_CFOP.value = '11'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.cmb_tipo_item_sped.value = '00'
									ENDIF					
							ENDIF		
						if !f_vazio(xalias)
							sele &xalias
						endif					

					
					case upper(xmetodo) == 'USR_REFRESH'
				
					xalias=alias()
						
						If TYPE('thisformset.lx_form1.lx_PAGEFRAME1.page5.bt_tabPreco')<>'U'
							If ThisFormset.p_tool_status $ "AI"
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.caption = "Gerar Tabelas de Pre�o"
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.enabled = .t.	
							ELSE
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.caption = "Calcula Custo CT e CA"
								If ThisFormset.p_tool_status = "L"
									Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.enabled = .f.
								ELSE
									Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.enabled = .t.			
								ENDIF
							Endif
						Endif
						
					
							*** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES  
						If TYPE('thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.CL_LIBERAR_GRADE.ck_liberar_grade_web')<>'U'
							If THISFORMSET.P_tool_status == 'A'
								thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.CL_LIBERAR_GRADE.ck_liberar_grade_web.Enabled=.t.
							Else	
								thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.CL_LIBERAR_GRADE.ck_liberar_grade_web.Enabled=.F.
							Endif	
						Endif
						***FIM - #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
						*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***
						If TYPE('o_002006.lx_form1.lx_pageframe1.page1.pgDadosProdutos.page4.anm_txt_status_cad')<>'U'						
							If thisformset.p_tool_status = 'L'
								thisformset.lx_form1.lx_pageframe1.page1.pgDadosProdutos.page4.anm_txt_status_cad.Enabled = .T.
								thisformset.lx_form1.lx_pageframe1.page1.pgDadosProdutos.page4.anm_txt_status_most.Enabled = .T.	
							Else 
								thisformset.lx_form1.lx_pageframe1.page1.pgDadosProdutos.page4.anm_txt_status_cad.Enabled = .F.
								thisformset.lx_form1.lx_pageframe1.page1.pgDadosProdutos.page4.anm_txt_status_most.Enabled = .F.	
							Endif	
						Endif
						*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***
						
						*** #GS01 
						If TYPE('thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.Btn_importa_nota')<>'U'
							If ThisFormset.p_tool_status $ "AI"
								thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.Btn_importa_nota.enabled=.f.
							Else
								If ThisFormset.p_tool_status $ "P"
									thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.Btn_importa_nota.enabled=.f.
								Else
									thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.Btn_importa_nota.enabled=.t.
								Endif
							Endif
						Endif
						
						If TYPE('thisformset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.cl_gs_nota_prod.tx_gs_nota_prod')<>'U'
							If ThisFormset.p_tool_status $ "AI"
								thisformset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.cl_gs_nota_prod.tx_gs_nota_prod.enabled=.t.
							Else
								If ThisFormset.p_tool_status $ "P"
									thisformset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.cl_gs_nota_prod.tx_gs_nota_prod.enabled=.f.
								Else
									thisformset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.cl_gs_nota_prod.tx_gs_nota_prod.enabled=.t.
								Endif
							Endif
						Endif
						*** Fim - #GS01 ** 
						  
						*** #GS02
						If TYPE('thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.btn_import_tmp_producao')<>'U'
							If ThisFormset.p_tool_status $ "AI"
								thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.btn_import_tmp_producao.enabled=.f.
							Else
								If ThisFormset.p_tool_status $ "P"
									thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.btn_import_tmp_producao.enabled=.f.
								Else
									thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.btn_import_tmp_producao.enabled=.t.
								Endif
							Endif
						Endif
						*** Fim - #GS02
						
						*** #GS03
						If TYPE('thisformset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.col_gs_etapa.cmb_gs_etapa')<>'U'
							If ThisFormset.p_tool_status $ "AI"
								ThisFormset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.col_gs_etapa.cmb_gs_etapa.Enabled=.T.
								ThisFormset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.cl_GS_QTDE_VENDIDA_ETAPA.Tx_gs_qtde_vendida_etapa.Enabled=.t.
							Else
								ThisFormset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.col_gs_etapa.cmb_gs_etapa.Enabled=.F.
								ThisFormset.lx_form1.lx_pageframe1.page1.pgdadosprodutos.page2.lx_grid_filha1.cl_GS_QTDE_VENDIDA_ETAPA.Tx_gs_qtde_vendida_etapa.Enabled=.F.
							Endif
						Endif
						*** Fim - #GS03
						
						*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
						If TYPE('thisformset.LX_FORM1.LX_PAGEFRAME1.PAGE1.PGDADOSPRODUTOS.PAGE1.TV_REDE_LOJAS')<>'U'
							*******
						Endif	
						*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					
					case upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE'
				
					xalias=alias()
					** #1 - LUCAS MIRANDA - 23/03/2016 - CORRE��O DO OBJETO PRODUTOS_001 PARA PRODUTOS_999	
						If upper(xnome_obj) = 'PRODUTOS_999'
								IF thisformset.p_tool_status = 'A' AND thisformset.lx_FORM1.lx_PAGEFRAME1.ActivePage = 5
									
									SELECT V_PRODUTOS_00_PRECOS
									f_select("EXEC LX_ANM_BLOQUEIA_PRECO_PRODUTO ?V_PRODUTOS_00_PRECOS.PRODUTO,?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","CurBloqProd")
										
										f_select("Select preco1 from produtos_precos where produto = ?V_PRODUTOS_00_PRECOS.PRODUTO and codigo_tab_preco =?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","xTestPreco",ALIAS())
										IF CurBloqProd.permite = .T.
											MESSAGEBOX(NVL(CurBloqProd.MSG_RETORNO,"Tabela de pre�o sem permiss�o para altera��o!"),64)
											RETURN .F.
										ENDIF									

								ENDIF
						Endif
					** FIM - #1 - LUCAS MIRANDA - 23/03/2016 - CORRE��O DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					case UPPER(xmetodo) == 'USR_INCLUDE_AFTER' 

					xalias=alias()
					
					*** #GS01 
					xOldValueNota=''
					*** Fim - #GS01
					
					** #1 - LUCAS MIRANDA - 23/03/2016 - CORRE��O DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
					IF upper(xnome_obj)== 'PRODUTOS_999' 
				
						sele v_produtos_00
						repla envia_loja_varejo with .t.
						
					ENDIF
					** FIM #1 - LUCAS MIRANDA - 23/03/2016 - CORRE��O DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
					if	!f_vazio(xalias)	
						sele &xalias 
					endif

					case upper(xmetodo) == 'USR_VALID'

						
						*#13 - JULIO CESAR - 25/08/2016 - ATUALIZAR TABELA CA - PRODUTOS PARA REVENDA * IN�CIO *
						*Procedimento para atualizar CA quando aterar o pre�o reposi��o *				
						if	upper(xnome_obj)== 'LX_REPOSICAO1' 
							Sele v_produtos_00_precos
							LOCATE FOR codigo_tab_preco = 'CA'
							Replace preco1 WITH v_produtos_00.preco_reposicao_1
							Replace v_produtos_00.custo_reposicao1 WITH v_produtos_00.preco_reposicao_1
							
						endif
						******************************************************	
						*Procedimento para atualizar CA quando aterar o custo reposi��o *	 				
						if	upper(xnome_obj)== 'LX_TEXTBOX_BASE1' 
							Sele v_produtos_00_precos
							LOCATE FOR codigo_tab_preco = 'CA'
							Replace preco1 WITH v_produtos_00.custo_reposicao1
							Replace v_produtos_00.preco_reposicao_1 WITH v_produtos_00.custo_reposicao1
							
						endif
						******************************************************	
						*#13 - JULIO CESAR - 25/08/2016 - ATUALIZAR TABELA CA - PRODUTOS PARA REVENDA * FIM *
						
						If upper(xnome_obj) = 'TX_PRECO1'
						
								IF thisformset.p_tool_status = 'A'
									
									SELECT V_PRODUTOS_00_PRECOS
									f_select("EXEC LX_ANM_BLOQUEIA_PRECO_PRODUTO ?V_PRODUTOS_00_PRECOS.PRODUTO,?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","CurBloqProd")
										
										f_select("Select preco1 from produtos_precos where produto = ?V_PRODUTOS_00_PRECOS.PRODUTO and codigo_tab_preco =?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","xTestPreco")
										IF CurBloqProd.permite = .T. AND xTestPreco.preco1 <> V_PRODUTOS_00_PRECOS.PRECO1 AND xTestPreco.preco1 > 0
											MESSAGEBOX(NVL(CurBloqProd.MSG_RETORNO,"Tabela de pre�o sem permiss�o para altera��o!"),64)
											SELECT V_PRODUTOS_00_PRECOS
											REPLACE PRECO1 WITH xTestPreco.preco1
											RETURN .F.
										ENDIF									

								ENDIF											
						 
								xSelCurTabBase = "SELECT COUNT(*) AS Clica FROM PROP_TABELAS_PRECO "+;
								                 "WHERE PROPRIEDADE = '00185' "+;
								                 "AND VALOR_PROPRIEDADE = '"+V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO+"'"
								f_select(xSelCurTabBase,"BotaoGeraTab")
								
								IF BotaoGeraTab.Clica > 0
									IF MESSAGEBOX("Deseja atualizar as tabelas de pre�o?",32+4)=6
										Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.Click()
									ENDIF
								ENDIF
							
						Endif
					
						*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
						If upper(xnome_obj)== 'TV_REDE_LOJAS' 
							If thisformset.p_tool_status = 'A'
								f_select("SELECT * FROM FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_CODIGO_PRODUTO') WHERE REDE_LOJAS = ?v_produtos_00.rede_lojas","curValorParNovo")
								xValorParNovo = curValorParNovo.valor_atual

								If !(LTRIM(RTRIM(xValorparAntes)) == '2' and LTRIM(RTRIM(xValorParNovo)) == '2')
									Messagebox("N�o foi poss�vel alterar Rede Lojas !!!",0+16)
									Sele v_produtos_00
									Replace rede_lojas with xRedeLojasCod
									Release xValorParNovo
								Endif
							Endif
						Endif
						*** Bloqueio Rede Loja - Lucas Miranda 02/08/2016
						  
						*** #GS01
						IF upper(xnome_obj)== 'TX_GS_NOTA_PROD'
							Sele v_produtos_00_cores_mat
							If v_produtos_00_cores_mat.gs_nota_prod < 0 OR v_produtos_00_cores_mat.gs_nota_prod > 10
								MESSAGEBOX("Nota informada menor que zero ou maior que 10, proibido !!!",0+16,"Nota Produto")
								xOldValueNota=Thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.cL_GS_NOTA_PROD.tx_gs_nota_prod.OldValue
								Thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.cL_GS_NOTA_PROD.tx_gs_nota_prod.Value=xOldValueNota
							Endif
						ENDIF
						*** Fim - #GS01
									
					xalias=alias()
					
						If upper(xnome_obj) = 'TX_DESC_PRODUTO'
						
							if	len(allt(v_produtos_00.desc_produto))>33
								messagebox("Este Campo aceita somente 33 caracteres !"+chr(13)+"Voc� registrou "+allt(str(len(allt(v_produtos_00.desc_produto))))+" caracteres ",48,"Aten��o!!!" )
								retu .f.
							endif
						
						Endif
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
									
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE


**************************************************
*-- Class:        botao_gera_tabela_produto (c:\pastas\work\classes_julio\botao_gera_tabela_produto.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   03/16/15 08:32:04 PM
*
DEFINE CLASS bt_tabPreco AS botao


	Top = 5
	Left = 495
	Height = 24
	Width = 156
	FontBold = .T.
	WordWrap = .T.
	Caption = "Gerar Tabelas de Pre�o"
	Enabled = .T.
	Visible = .T.
	TabIndex = 11
	Name = "bt_tabPreco"


	PROCEDURE Click
		IF wnivel_acesso > thisformset.pp_permite_alt_tb_preco_prod
			MESSAGEBOX("Usu�rio sem permiss�o de Alterar\Gerar Tabela de Pre�o.",64)
			RETURN .f.
		ENDIF

		IF This.Caption = "Gerar Tabelas de Pre�o"

		f_prog_bar("Executando comando, aguarde ...")

		f_select("select RTRIM(LTRIM(valores)) as ValorParam from dbo.FXANM_ConsultaVarString (?o_002006.pp_anm_tabelas_preco_produto)","pp_anm_tabelas_preco_produto")
		SELECT pp_anm_tabelas_preco_produto
		GO top
		SCAN

		xSelCurTabBase = "SELECT RTRIM(LTRIM(VALOR_PROPRIEDADE)) AS TABELA_PRECO FROM PROP_TABELAS_PRECO "+;
		                 "WHERE PROPRIEDADE = '00185' "+;
		                 "AND CODIGO_TAB_PRECO = '"+pp_anm_tabelas_preco_produto.ValorParam+"'"
		f_select(xSelCurTabBase,"CurTabBase")

		xSelCurPercBase = "SELECT RIGHT(RTRIM(LTRIM(VALOR_PROPRIEDADE)),LEN(RTRIM(LTRIM(VALOR_PROPRIEDADE)))-2) AS PERC_PRECO "+; 
						  "FROM PROP_TABELAS_PRECO "+;
		                  "WHERE PROPRIEDADE = '00186' "+;
		                  "AND CODIGO_TAB_PRECO = '"+ALLTRIM(pp_anm_tabelas_preco_produto.ValorParam)+"'"+;
		                  " AND LEFT(RTRIM(LTRIM(VALOR_PROPRIEDADE)),1)= "+ALLTRIM(V_PRODUTOS_00.REDE_LOJAS)
		f_select(xSelCurPercBase,"CurPercBase")

			
		SELECT V_PRODUTOS_00_PRECOS
		LOCATE FOR ALLTRIM(CODIGO_TAB_PRECO) == ALLTRIM(CurTabBase.tabela_preco) 
		IF FOUND()
			xPrecoVO = V_PRODUTOS_00_PRECOS.preco1*VAL(CurPercBase.PERC_PRECO)
		ELSE	
			xPrecoVO = 0
		ENDIF

		LOCATE FOR ALLTRIM(CODIGO_TAB_PRECO) == ALLTRIM(pp_anm_tabelas_preco_produto.ValorParam)
		IF ! FOUND() 
			O_TOOLBAR.Botao_filhas_inserir.Click()
			*o_002006.lx_FORM1.lx_pageframe1.page5.lx_GRID_FILHA1.column5.Tv_precos.setfocus()
			GO BOTTOM 
			o_002006.lx_FORM1.lx_pageframe1.page5.lx_GRID_FILHA1.column5.Tv_precos.Value= pp_anm_tabelas_preco_produto.ValorParam
			f_select("Select tabela from tabelas_preco where codigo_tab_preco = ?pp_anm_tabelas_preco_produto.ValorParam","CurTabPreco",alias())
			REPLACE TABELA WITH CurTabPreco.tabela 
		ENDIF

		REPLACE PRECO1 WITH xPrecoVO ;
		FOR PRECO1 = 0 AND ALLTRIM(CODIGO_TAB_PRECO) == ALLTRIM(pp_anm_tabelas_preco_produto.ValorParam)
		o_002006.lx_FORM1.lx_pageframe1.page5.lx_GRID_FILHA1.Refresh()

		SELECT pp_anm_tabelas_preco_produto
		ENDSCAN

		f_prog_bar()
		ENDIF
 

		IF this.Caption = "Calcula Custo CT e CA"

			f_prog_bar("Executando C�lculo do custo, aguarde ...")
			
			IF f_update("EXEC LX_CALCULA_CUSTO_EFETIVO_PRODUTO ?V_PRODUTOS_00_PRECOS.PRODUTO")
				Thisformset.DataEnvironment.cuRSORV_PRODUTOS_00_PRECOS.CursorFill()
				f_prog_bar()
				MESSAGEBOX("Custo calculado com sucesso.",64,"Custo Gerencial")
			Endif	
			
*!*				xseltran=[ SELECT B.MODULO, A.CONTROL_SISTEMA,B.NAVEGACAO ]+;
*!*					 [ FROM TRANSACOES AS A ]+;
*!*					 [ JOIN TRANSACOES_NAVEGA AS B ON (A.COD_TRANSACAO=B.COD_TRANSACAO) ]+;
*!*					 [ WHERE A.CONTROL_SISTEMA LIKE '040004%' ]+;
*!*					 [ ORDER BY B.MODULO, A.CONTROL_SISTEMA,B.NAVEGACAO ]

*!*				IF !f_select(xseltran,[cur_transacao])
*!*					RETURN 
*!*				ENDIF 


*!*				IF RECCOUNT('cur_transacao') = 0
*!*				  f_msg(['A transa��o lx040004%, ou alguma de suas deriva��es exclusivas, n�o est� cadastrada. Verifique!!! ',64,'Informa��o'])
*!*				  return
*!*				ENDIF 


*!*				IF !f_doform(cur_transacao.MODULO, cur_transacao.CONTROL_SISTEMA, cur_transacao.NAVEGACAO)
*!*				   RETURN .f.
*!*				ENDIF 


*!*				o_040004.lx_form1.Show() &&Ativa a tela
*!*				o_040004.lx_form1.windowstate = 0 &&Normal
*!*				o_toolbar.Botao_limpa.Click()
*!*				o_040004.lx_FORM1.tv_Produto.Value = o_002006.lx_FORM1.tv_Produto.Value
*!*				o_toolbar.botao_procura.Click()
*!*				f_prog_bar()
*!*				o_040004.lx_FORM1.Calcula_custo.Click()
*!*				Thisformset.DataEnvironment.cuRSORV_PRODUTOS_00_PRECOS.CursorFill()

		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botao_gera_tabela_produto
**************************************************
**************************************************
*-- Class:        btn_ccomposicao(c:\linx desenv\classes lucas\btn_ccomposicao.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_ccomposicao As botao


	Top = 60
	Left = 435
	Height = 15
	Width = 63
	FontBold = .F. 
	FontName = 'TAHOMA'
	Caption = "Composi��o"
	ForeColor = Rgb(0,0,0)
	Name = "btn_ccomposicao"
	Visible = .T.


	Procedure Click
		sele v_produtos_00
		
		F_SELECT("SELECT DESC_COMPOSICAO FROM MATERIAIS_COMPOSICAO (nolock) WHERE COMPOSICAO = ?v_produtos_00.composicao","xComposicao")
		_cliptext=ALLTRIM(NVL(xComposicao.Desc_Composicao,''))

Enddefine
*
*-- EndDefine: btn_ccomposicao 
**************************************************
**** PERIODO COR ** DANIEL FREITAS ***
**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_periodo_cor AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 625
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_periodo_cor"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

*	PROCEDURE Valid	
	
*	ENDPROC 

ENDDEFINE
**** PERIODO COR ** DANIEL FREITAS ***
**** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
DEFINE CLASS ck_liberar_grade_web AS lx_checkbox


	Top = 10
	Left = 18
	Height = 15
	Width = 88
	AutoSize = .T.
	Alignment = 0
	Caption = "Liberar Grade"
	ControlSource = ""
	Name = "ck_Liberar_Grade_web"


ENDDEFINE
*
*-- EndDefine: ck_liberar_grade_web
*** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
**************************************************

**************************************************
*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***
*-- Class:        lb_status_cad (c:\aplica��es\lb_status_cad.vcx)
*-- ParentClass:  lx_label (c:\linx spk novo lucas\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   07/14/16 12:55:09 PM
*
DEFINE CLASS lb_status_cad AS lx_label


	AutoSize = .F.
	Caption = "Status CAD"
	Height = 15
	Left = 535
	Top = 367
	Width = 58
	TabIndex = 46
	ZOrderSet = 59
	Name = "lb_status_cad"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lb_status_cad
**************************************************
**************************************************
*-- Class Library:  c:\aplica��es\txt_status_cad.vcx
**************************************************


**************************************************
*-- Class:        txt_status_cad (c:\aplica��es\txt_status_cad.vcx)
*-- ParentClass:  lx_textbox_base (c:\linx spk novo lucas\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/14/16 12:55:12 PM
*
DEFINE CLASS anm_txt_status_cad AS lx_textbox_base


	ControlSource = "v_produtos_00.ANM_DATA_STATUS_CAD"
	Height = 20
	Left = 595
	TabIndex = 38
	Top = 364
	Width = 101
	ZOrderSet = 60
	Name = "anm_txt_status_cad"
	Visible = .T.


ENDDEFINE
*
*-- EndDefine: txt_status_cad
**************************************************

**************************************************
*-- Class Library:  c:\aplica��es\lb_status_most.vcx
**************************************************


**************************************************
*-- Class:        lb_status_most (c:\aplica��es\lb_status_most.vcx)
*-- ParentClass:  lx_label (c:\linx spk novo lucas\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   07/14/16 12:56:04 PM
*
DEFINE CLASS lb_status_most AS lx_label


	AutoSize = .F.
	Caption = "Status Mostru�rio"
	Height = 15
	Left = 503
	Top = 387
	Width = 91
	TabIndex = 46
	ZOrderSet = 59
	Name = "lb_status_most"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lb_status_most
**************************************************
**************************************************
*-- Class Library:  c:\aplica��es\txt_status_most.vcx
**************************************************


**************************************************
*-- Class:        txt_status_most (c:\aplica��es\txt_status_most.vcx)
*-- ParentClass:  lx_textbox_base (c:\linx spk novo lucas\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/14/16 12:56:12 PM
*
DEFINE CLASS anm_txt_status_most AS lx_textbox_base


	ControlSource = "v_produtos_00.ANM_DATA_STATUS_MOST"
	Height = 20
	Left = 595
	TabIndex = 38
	Top = 384
	Width = 101
	ZOrderSet = 60
	Name = "anm_txt_status_most"
	Visible = .T.


ENDDEFINE
*
*-- EndDefine: txt_status_most
**************************************************
*** LUCAS MIRANDA - 19/07/2016 - MELHORIA CAD ***



* 16/12/2014 - Leandro Rocha (SS): Adiciona bot�o para importar o cadastro de produtos
DEFINE CLASS cls_botao_importar AS botao
	Caption = "\<Importar Produtos"
	Name = "btn_importa_cadastro"
    Visible = .T.
    Enabled = .T.
    Height = 22
    Left = 580
    Top = 372
    Width = 120

	PROCEDURE Refresh
		this.Enabled = IIF(INLIST(thisformset.p_tool_status, 'L', 'P') AND THISFORMSET.P_ACESSO_INCLUIR, .T., .F.)
	ENDPROC
	
	PROCEDURE Click	
		bitErro = .F.
		
		* Solicita arquivo 
		strPathFile = GETFILE('XLSX;XLS', 'Arquivo:', 'IMPORTAR', 0, 'IMPORTA��O DE PRODUTOS')
		
		IF LEN(strPathFile) = 0
			RETURN .f.
		ENDIF
				
		* Cria cursor para importar planilha
		CREATE CURSOR curPlanilhaProdutos (	GRIFFE C(50) NULL, ;
											PRODUTO C(50) NULL, ;
											DESC_PRODUTO C(50) NULL, ;
											COR_PRODUTO C(50) NULL, ;
											DESC_COR C(50) NULL, ;
											TAMANHO C(50) NULL, ;
											CODIGO_BARRA C(50) NULL, ;
											LINHA C(50) NULL, ;
											GRUPO_PRODUTO C(50) NULL, ;
											SUBGRUPO_PRODUTO C(50) NULL, ;
											TIPO_PRODUTO C(50) NULL, ;
											COLECAO C(50) NULL, ;
											CLASSIF_FISCAL C(50) NULL, ;
											FABRICANTE C(50) NULL,;
											GRADE C(50) NULL, ; && Esse campo n�o vem na planilha, ser� preenchido na valida��o
											INDICA_ERRO L NULL ; && Esse campo n�o vem na planilha, ser� preenchido na valida��o
											)

		strDecimal = SET("Point")
		SET POINT TO ','

		f_wait('Consultando Planilha...')

		objExcel = CreateObject("EXCEL.Application")
		objExcel.Workbooks.Open(strPathFile)

		TRY
			intLinha = 1
			
			* Percorre planilha enquanto tiver valor na primeira coluna 
			DO WHILE !EMPTY(NVL(objExcel.Range("A" + ALLTRIM(STR(intLinha))).Value, ''))
			
				* N�o considera a primeira linha porque � cabe�alho
				IF intLinha = 1
					intLinha = intLinha + 1
					LOOP
				ENDIF
			
				strGRIFFE = NVL(objExcel.Range("A" + ALLTRIM(STR(intLinha))).Value, '')
				strGRIFFE = ALLTRIM(NVL(IIF(TYPE('strGRIFFE') == 'N', STR(strGRIFFE), strGRIFFE), ''))
				
				strPRODUTO = NVL(objExcel.Range("B" + ALLTRIM(STR(intLinha))).Value, '')
				strPRODUTO = ALLTRIM(NVL(IIF(TYPE('strPRODUTO') == 'N', STR(strPRODUTO), strPRODUTO), ''))
				
				strDESC_PRODUTO = NVL(objExcel.Range("C" + ALLTRIM(STR(intLinha))).Value, '')
				strDESC_PRODUTO = ALLTRIM(NVL(IIF(TYPE('strDESC_PRODUTO') == 'N', STR(strDESC_PRODUTO), strDESC_PRODUTO), ''))
				
				strCOR_PRODUTO = NVL(objExcel.Range("D" + ALLTRIM(STR(intLinha))).Value, '')
				strCOR_PRODUTO = ALLTRIM(NVL(IIF(TYPE('strCOR_PRODUTO') == 'N', STR(strCOR_PRODUTO), strCOR_PRODUTO), ''))
				
				strDESC_COR = NVL(objExcel.Range("E" + ALLTRIM(STR(intLinha))).Value, '')
				strDESC_COR = ALLTRIM(NVL(IIF(TYPE('strDESC_COR') == 'N', STR(strDESC_COR), strDESC_COR), ''))
				
				strTAMANHO = NVL(objExcel.Range("F" + ALLTRIM(STR(intLinha))).Value, '')
				strTAMANHO = ALLTRIM(NVL(IIF(TYPE('strTAMANHO') == 'N', STR(strTAMANHO), strTAMANHO), ''))

				strCODIGO_BARRA = NVL(objExcel.Range("G" + ALLTRIM(STR(intLinha))).Value, '')
				strCODIGO_BARRA = ALLTRIM(NVL(IIF(TYPE('strCODIGO_BARRA') == 'N', STR(strCODIGO_BARRA), strCODIGO_BARRA), ''))
				
				strLINHA = NVL(objExcel.Range("H" + ALLTRIM(STR(intLinha))).Value, '')
				strLINHA = ALLTRIM(NVL(IIF(TYPE('strLINHA') == 'N', STR(strLINHA), strLINHA), ''))
				
				strGRUPO_PRODUTO = NVL(objExcel.Range("I" + ALLTRIM(STR(intLinha))).Value, '')
				strGRUPO_PRODUTO = ALLTRIM(NVL(IIF(TYPE('strGRUPO_PRODUTO') == 'N', STR(strGRUPO_PRODUTO), strGRUPO_PRODUTO), ''))
				
				strSUBGRUPO_PRODUTO = NVL(objExcel.Range("J" + ALLTRIM(STR(intLinha))).Value, '')
				strSUBGRUPO_PRODUTO = ALLTRIM(NVL(IIF(TYPE('strSUBGRUPO_PRODUTO') == 'N', STR(strSUBGRUPO_PRODUTO), strSUBGRUPO_PRODUTO), ''))
				
				strTIPO_PRODUTO = NVL(objExcel.Range("K" + ALLTRIM(STR(intLinha))).Value, '')
				strTIPO_PRODUTO = ALLTRIM(NVL(IIF(TYPE('strTIPO_PRODUTO') == 'N', STR(strTIPO_PRODUTO), strTIPO_PRODUTO), ''))

				strCOLECAO = NVL(objExcel.Range("L" + ALLTRIM(STR(intLinha))).Value, '')
				strCOLECAO = ALLTRIM(NVL(IIF(TYPE('strCOLECAO') == 'N', STR(strCOLECAO), strCOLECAO), ''))

				strCLASSIF_FISCAL = NVL(objExcel.Range("M" + ALLTRIM(STR(intLinha))).Value, '')
				strCLASSIF_FISCAL = ALLTRIM(NVL(IIF(TYPE('strCLASSIF_FISCAL') == 'N', STR(strCLASSIF_FISCAL), strCLASSIF_FISCAL), ''))

				strFABRICANTE = NVL(objExcel.Range("N" + ALLTRIM(STR(intLinha))).Value, '')
				strFABRICANTE = ALLTRIM(NVL(IIF(TYPE('strFABRICANTE') == 'N', STR(strFABRICANTE), strFABRICANTE), ''))

				APPEND BLANK IN curPlanilhaProdutos
				
				REPLACE GRIFFE WITH strGRIFFE, ;
						PRODUTO WITH strPRODUTO, ;
						DESC_PRODUTO WITH strDESC_PRODUTO, ;
						COR_PRODUTO WITH strCOR_PRODUTO, ;
						DESC_COR WITH strDESC_COR, ;
						TAMANHO WITH strTAMANHO, ;
						CODIGO_BARRA WITH strCODIGO_BARRA, ;
						LINHA WITH strLINHA, ;
						GRUPO_PRODUTO WITH strGRUPO_PRODUTO, ;
						SUBGRUPO_PRODUTO WITH strSUBGRUPO_PRODUTO, ;
						TIPO_PRODUTO WITH strTIPO_PRODUTO, ;
						COLECAO WITH strCOLECAO, ;
						CLASSIF_FISCAL WITH strCLASSIF_FISCAL, ;
						FABRICANTE WITH strFABRICANTE IN curPlanilhaProdutos
						
				intLinha = intLinha + 1
			ENDDO 
		
			objExcel.Quit()
		CATCH TO objErro
			f_wait()
			MESSAGEBOX('Erro ao importar planilha.' + CHR(10) + NVL(objErro.Message, ''), 16, 'ATEN��O')
			objExcel.Quit()
			RETURN .F.
		ENDTRY	

		RELEASE objExcel

		SET POINT TO strDecimal
	
		f_wait()
			
		* Verifica se os registros foram importados
		IF RECCOUNT([curPlanilhaProdutos]) = 0 
			MESSAGEBOX('Nenhum registro importado, verifique o arquivo e tente novamente.', 16, 'ATEN��O')
			RETURN .F.
		ENDIF

		strErros = ''
		intLinha = 2 && Come�a na segunda linha porque a primeira � o cabe�alho na planilha 
			
		* Realiza Valida��o
		
		replace ALL curPlanilhaProdutos.INDICA_ERRO	WITH .F. IN curPlanilhaProdutos
		SELECT curPlanilhaProdutos
		GO TOP 
		SCAN
			strProduto = UPPER(ALLTRIM(curPlanilhaProdutos.PRODUTO))
		 
			* Valida informa��es
			F_wait('Validando Registros (' + ALLTRIM(STR(RECNO('curPlanilhaProdutos'))) + ' de ' + ALLTRIM(STR(RECCOUNT('curPlanilhaProdutos'))) + ')')

			* Se o tamanho anterior tiver parado em alguma valida��o j� pula para o pr�ximo registro
			IF IIF(EMPTY(NVL(curPlanilhaProdutos.INDICA_ERRO, '')), .F., curPlanilhaProdutos.INDICA_ERRO)
				LOOP
			ENDIF

			* VALIDA GRUPO E SUBGRUPO
			TEXT TO strSql TEXTMERGE NOSHOW 
				SELECT A.GRUPO_PRODUTO, B.SUBGRUPO_PRODUTO 
					FROM PRODUTOS_GRUPO A (NOLOCK) 
					LEFT JOIN PRODUTOS_SUBGRUPO B (NOLOCK) 
						ON B.GRUPO_PRODUTO = A.GRUPO_PRODUTO AND LTRIM(RTRIM(B.SUBGRUPO_PRODUTO)) = ?curPlanilhaProdutos.SUBGRUPO_PRODUTO
					WHERE LTRIM(RTRIM(A.GRUPO_PRODUTO)) = ?curPlanilhaProdutos.GRUPO_PRODUTO 
			ENDTEXT
			
			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
			
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Grupo n�o cadastrado. Grupo: ' + ALLTRIM(curPlanilhaProdutos.GRUPO_PRODUTO) + ' SubGrupo:' + ALLTRIM(curPlanilhaProdutos.SUBGRUPO_PRODUTO) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ELSE
				IF f_vazio(curValidacao.SUBGRUPO_PRODUTO)
					strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - SubGrupo n�o cadastrado. Grupo: ' + ALLTRIM(curPlanilhaProdutos.GRUPO_PRODUTO) + ' SubGrupo:' + ALLTRIM(curPlanilhaProdutos.SUBGRUPO_PRODUTO) + CHR(13) + CHR(10)
					REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
				ENDIF
			ENDIF
			
			USE IN curValidacao
			
			* VALIDA TIPO DE PRODUTO
			TEXT TO strSql TEXTMERGE NOSHOW 
				SELECT TIPO_PRODUTO 
					FROM PRODUTOS_TIPOS (NOLOCK) 
					WHERE LTRIM(RTRIM(TIPO_PRODUTO)) = ?curPlanilhaProdutos.TIPO_PRODUTO
			ENDTEXT

			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
				
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Tipo de produto n�o cadastrado. Tipo: ' + ALLTRIM(curPlanilhaProdutos.TIPO_PRODUTO) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ENDIF
			
			USE IN curValidacao
			
			* VALIDA COLE��O
			TEXT TO strSql TEXTMERGE NOSHOW 
				SELECT COLECAO 
					FROM COLECOES (NOLOCK) 
					WHERE COLECAO = ?curPlanilhaProdutos.COLECAO
			ENDTEXT

			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
			
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Cole��o n�o cadastrada. Cole��o: ' + ALLTRIM(curPlanilhaProdutos.COLECAO) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ENDIF
			
			USE IN curValidacao
			
			* VALIDA GRIFFE
			TEXT TO strSql TEXTMERGE NOSHOW
				SELECT GRIFFE 
					FROM PRODUTOS_GRIFFES (NOLOCK) 
					WHERE LTRIM(RTRIM(GRIFFE)) = ?curPlanilhaProdutos.GRIFFE
			ENDTEXT 

			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
			
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Griffe n�o cadastrada. Griffe: ' + ALLTRIM(curPlanilhaProdutos.GRIFFE) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ENDIF
			
			USE IN curValidacao

			* VALIDA LINHA
			TEXT TO strSql TEXTMERGE NOSHOW
				SELECT LINHA 
					FROM PRODUTOS_LINHAS (NOLOCK) 
					WHERE LTRIM(RTRIM(LINHA)) = ?curPlanilhaProdutos.LINHA
			ENDTEXT 

			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
				
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Linha n�o cadastrada. Linha: ' + ALLTRIM(curPlanilhaProdutos.LINHA) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ENDIF
				
			USE IN curValidacao
				
			* VALIDA CLASSIFICA��O FISCAL
			TEXT TO strSQL TEXTMERGE NOSHOW 
				SELECT CLASSIF_FISCAL 
					FROM CLASSIF_FISCAL(NOLOCK) 
					WHERE LTRIM(RTRIM(CLASSIF_FISCAL)) = ?curPlanilhaProdutos.CLASSIF_FISCAL
			ENDTEXT 
		
			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
			
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Classifica��o Fiscal n�o cadastrada. Classifica��o Fiscal: ' + ALLTRIM(curPlanilhaProdutos.CLASSIF_FISCAL) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ENDIF

			USE IN curValidacao
			
			* VALIDA FABRICANTE
			TEXT TO strSQL TEXTMERGE NOSHOW 
				SELECT FORNECEDOR 
					FROM FORNECEDORES (NOLOCK) 
					WHERE LTRIM(RTRIM(FORNECEDOR)) = ?curPlanilhaProdutos.FABRICANTE
			ENDTEXT 
		
			IF !f_select(strSql, 'curValidacao')
				MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
				f_wait()
				RETURN .f.
			ENDIF
			
			IF RECCOUNT('curValidacao') = 0
				strErros = strErros + 'Registro: ' + ALLTRIM(STR(intLinha)) + ' - Fabricante n�o cadastrado. Fabricante: ' + ALLTRIM(curPlanilhaProdutos.FABRICANTE) + CHR(13) + CHR(10)
				REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
			ENDIF

			USE IN curValidacao

			* VALIDA GRADE
			IF f_vazio(curPlanilhaProdutos.grade)
			
				SELECT TAMANHO ;
					FROM curPlanilhaProdutos ;
					WHERE UPPER(ALLTRIM(produto)) == ?strProduto ;
					INTO CURSOR curTamanhosProduto

				strTamanhos = ''
				
				CALCULATE CNT() TO intQtdeTamanhosPlanilha IN curTamanhosProduto

				* Consulta todas as grade que atendem o produto
				TEXT TO strSql TEXTMERGE NOSHOW 
					SELECT A.GRADE, A.TAMANHO, C.QTDE_TAMANHOS 
						FROM W_PRODUTOS_TAMANHOS_ORDEM A (nolock)
						INNER JOIN PRODUTOS_TAMANHOS B (nolock)
							ON B.GRADE = A.GRADE 
						INNER JOIN (SELECT GRADE, COUNT(*) AS QTDE_TAMANHOS FROM W_PRODUTOS_TAMANHOS_ORDEM (NOLOCK) GROUP BY GRADE) AS C
							ON C.GRADE = A.GRADE 
						WHERE A.GRADE IN (SELECT DISTINCT GRADE FROM W_PRODUTOS_TAMANHOS_ORDEM (nolock) WHERE LTRIM(RTRIM(TAMANHO)) = ?curPlanilhaProdutos.TAMANHO) 
							AND C.QTDE_TAMANHOS = ?intQtdeTamanhosPlanilha
						ORDER BY B.TAMANHOS_DIGITADOS DESC, A.GRADE, A.ORDEM 
				ENDTEXT 
				
				IF !f_select(strSql, 'curGrades')
					MESSAGEBOX('Erro ao validar dados, tente novamente.', 16, 'ATEN��O')
					f_wait()
					RETURN .f.
				ENDIF						
		
			
				* Percorre os tamanho do produto atual para saber qual grade ser� usada
				SELECT curTamanhosProduto
				SCAN
					strTamanhos = strTamanhos + ALLTRIM(curTamanhosProduto.TAMANHO) + ','
						
					* Deleta grades que n�o atendem ao tamanho do produto
					DELETE A ;
						FROM curGrades A ;
						where A.GRADE NOT IN (SELECT DISTINCT GRADE FROM curGrades WHERE UPPER(ALLTRIM(TAMANHO)) == UPPER(ALLTRIM(curTamanhosProduto.TAMANHO)))

					SELECT curTamanhosProduto
				ENDSCAN
					
				strTamanhos = LEFT(strTamanhos, LEN(strTamanhos) - 1)
					
				intRecCount = 0
					
				SELECT curGrades
				GO TOP IN curGrades 
				COUNT FOR !DELETED('curGrades') TO intRecCount 
					
				intRegistro = RECNO('curPlanilhaProdutos')
					
				IF intRecCount = 0
					strErros = strErros + 'N�o existe grade cadastrada para atender o produto:' + strProduto + ', nos Tamanhos:' + ALLTRIM(strTamanhos) + CHR(13) + CHR(10)
					REPLACE curPlanilhaProdutos.INDICA_ERRO WITH .T. IN curPlanilhaProdutos
				ELSE 
					GO top in curGrades
					REPLACE ALL curPlanilhaProdutos.GRADE WITH curGrades.GRADE FOR UPPER(ALLTRIM(curPlanilhaProdutos.PRODUTO)) == UPPER(ALLTRIM(strProduto)) IN curPlanilhaProdutos
				ENDIF

				USE IN curGrades
				USE IN curTamanhosProduto
				
				GO intRegistro IN curPlanilhaProdutos
			ENDIF
			
			* Se tiver parado em alguma valida��o marca todos os itens do mesmo produto como itens com erro
			IF IIF(EMPTY(NVL(curPlanilhaProdutos.INDICA_ERRO, '')), .F., curPlanilhaProdutos.INDICA_ERRO) 
				intRegistro = RECNO('curPlanilhaProdutos')
				REPLACE ALL curPlanilhaProdutos.INDICA_ERRO WITH .T. FOR UPPER(ALLTRIM(curPlanilhaProdutos.PRODUTO)) == UPPER(ALLTRIM(strProduto)) IN curPlanilhaProdutos
				GO intRegistro IN curPlanilhaProdutos
			ENDIF

			intLinha = intLinha + 1		
		ENDSCAN
		
		* Inclui produtos
		SELECT curPlanilhaProdutos
		GO TOP 
		SCAN FOR !INDICA_ERRO
		
			strProduto = UPPER(ALLTRIM(curPlanilhaProdutos.PRODUTO))
			
			F_wait('Importando Cadastro (' + ALLTRIM(STR(RECNO('curPlanilhaProdutos'))) + ' de ' + ALLTRIM(STR(RECCOUNT('curPlanilhaProdutos'))) + ')')
			
			* INSER PRODUTO 
 			TEXT TO strSql TEXTMERGE NOSHOW 
				DECLARE @PRODUTO CHAR(12) = NULL
				
				/* Se j� existir o produto cadastrado para esse licenciado utiliza o c�digo que havia sido cadastrado */
				SELECT @PRODUTO = PRODUTO FROM PRODUTOS_BARRA_LICENCIADOS WHERE PRODUTO_LICENCIADO = ?strProduto AND GRIFFE = ?curPlanilhaProdutos.GRIFFE
				
				IF @PRODUTO IS NULL
				BEGIN
					UPDATE PRODUTOS_SUBGRUPO 
						SET PRODUTOS_SUBGRUPO.CODIGO_SEQUENCIAL = LTRIM(RTRIM(RIGHT('0000' + CONVERT(VARCHAR(10), CONVERT(INT, CODIGO_SEQUENCIAL) + 1), 4))),
							@PRODUTO = LTRIM(RTRIM(PRODUTOS_GRUPO.CODIGO_GRUPO)) + '.' + LTRIm(RTRIM(PRODUTOS_SUBGRUPO.CODIGO_SUBGRUPO)) + '.' + LTRIM(RTRIM(RIGHT('0000' + CONVERT(VARCHAR(10), CONVERT(INT, CODIGO_SEQUENCIAL) + 1), 4)))
						FROM PRODUTOS_SUBGRUPO
						INNER JOIN PRODUTOS_GRUPO
							ON PRODUTOS_GRUPO.GRUPO_PRODUTO = PRODUTOS_SUBGRUPO.GRUPO_PRODUTO
						WHERE PRODUTOS_SUBGRUPO.GRUPO_PRODUTO = ?curPlanilhaProdutos.GRUPO_PRODUTO 
							AND PRODUTOS_SUBGRUPO.SUBGRUPO_PRODUTO = ?curPlanilhaProdutos.SUBGRUPO_PRODUTO 
					
					IF @PRODUTO IS NULL
					BEGIN
						RAISERROR('N�o foi poss�vel encontrar o sequencial para cadastrar o produto.', 18, 1)  	
					END
				END
				
				IF NOT EXISTS(SELECT PRODUTO FROM PRODUTOS WHERE PRODUTO = @PRODUTO)
				BEGIN 
					INSERT INTO PRODUTOS (	PRODUTO, DESC_PRODUTO, GRUPO_PRODUTO, SUBGRUPO_PRODUTO, TIPO_PRODUTO, COLECAO, GRIFFE, LINHA, UNIDADE, REVENDA, 
											DESC_PROD_NF, REFER_FABRICANTE, TRIBUT_ICMS, CLASSIF_FISCAL, TRIBUT_ORIGEM, EMPRESA, GRADE, PONTEIRO_PRECO_TAM, STATUS_PRODUTO, 
											FATOR_OPERACOES, TAMANHO_BASE, ENVIA_LOJA_VAREJO, ENVIA_LOJA_ATACADO, ENVIA_REPRESENTANTE, ENVIA_VAREJO_INTERNET, ENVIA_ATACADO_INTERNET, 
											DATA_CADASTRAMENTO, TIPO_STATUS_PRODUTO, INDICADOR_CFOP, TIPO_ITEM_SPED, CONTA_CONTABIL, CONTA_CONTABIL_COMPRA, CONTA_CONTABIL_VENDA, 
											CONTA_CONTABIL_DEV_COMPRA, CONTA_CONTABIL_DEV_VENDA, FABRICANTE, MODELAGEM, DATA_REPOSICAO, DROP_DE_TAMANHOS, PARTE_TIPO, REDE_LOJAS) 
						SELECT	PRODUTO = @PRODUTO, 
								DESC_PRODUTO = ?curPlanilhaProdutos.DESC_PRODUTO, 
								GRUPO_PRODUTO = ?curPlanilhaProdutos.GRUPO_PRODUTO, 
								SUBGRUPO_PRODUTO = ?curPlanilhaProdutos.SUBGRUPO_PRODUTO, 
								TIPO_PRODUTO = ?curPlanilhaProdutos.TIPO_PRODUTO, 
								COLECAO = ?curPlanilhaProdutos.COLECAO,
								GRIFFE = ?curPlanilhaProdutos.GRIFFE, 
								LINHA = ?curPlanilhaProdutos.LINHA, 
								UNIDADE = 'UN', 
								REVENDA = 1, 
								DESC_PROD_NF = ?curPlanilhaProdutos.DESC_PRODUTO, 
								REFER_FABRICANTE = ?strProduto, 
								TRIBUT_ICMS = '00', 
								CLASSIF_FISCAL = ?curPlanilhaProdutos.CLASSIF_FISCAL, 
								TRIBUT_ORIGEM = '0', 
								EMPRESA = 1, 
								GRADE = ?curPlanilhaProdutos.GRADE, 
								PONTEIRO_PRECO_TAM = '111111111111111111111111111111111111111111111111', 
								STATUS_PRODUTO = '04', 
								FATOR_OPERACOES = 1, 
								TAMANHO_BASE = 1, 
								ENVIA_LOJA_VAREJO = 0, 
								ENVIA_LOJA_ATACADO = 0, 
								ENVIA_REPRESENTANTE = 0, 
								ENVIA_VAREJO_INTERNET = 0, 
								ENVIA_ATACADO_INTERNET = 1, 
								DATA_CADASTRAMENTO = CONVERT(VARCHAR(8), GETDATE(), 112), 
								TIPO_STATUS_PRODUTO = '3', 
								INDICADOR_CFOP = '11', 
								TIPO_ITEM_SPED = '00', 
								CONTA_CONTABIL = (SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO = 'CONTA_PADRAO_ESTOQUE_PA'), 
								CONTA_CONTABIL_COMPRA = (SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO = 'CONTA_PADRAO_COMPRA_PA'), 
								CONTA_CONTABIL_VENDA = (SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO = 'CONTA_PADRAO_VENDA_PA'), 
								CONTA_CONTABIL_DEV_COMPRA = (SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO = 'CONTA_PADRAO_DEV_COMPRA_P'), 
								CONTA_CONTABIL_DEV_VENDA = (SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO = 'CONTA_PADRAO_DEV_VENDA_PA'),
								FABRICANTE = ?curPlanilhaProdutos.FABRICANTE,
								MODELAGEM = NULL,
								DATA_REPOSICAO = CONVERT(VARCHAR(8), GETDATE(), 112),
								DROP_DE_TAMANHOS = NULL,
								PARTE_TIPO = NULL,
								REDE_LOJAS = '29'
				END 
				
				IF NOT EXISTS(SELECT PRODUTO FROM PRODUTO_CORES WHERE PRODUTO = @PRODUTO AND COR_PRODUTO = ?curPlanilhaProdutos.COR_PRODUTO)
				BEGIN
					INSERT INTO PRODUTO_CORES (	PRODUTO, COR_PRODUTO, DESC_COR_PRODUTO, SORTIMENTO_COR, COR_SORTIDA, STATUS_VENDA_ATUAL, 
												INICIO_VENDAS, FIM_VENDAS, COR_FABRICANTE, COR, 
												CLASSIF_FISCAL, TRIBUT_ORIGEM) 
						SELECT  PRODUTO = @PRODUTO, 
								COR_PRODUTO = ?curPlanilhaProdutos.COR_PRODUTO, 
								DESC_COR = ?curPlanilhaProdutos.DESC_COR, 
								SORTIMENTO_COR = 0, 
								COR_SORTIDA = 0, 
								STATUS_VENDA_ATUAL = 1, 
								INICIO_VENDAS = '19900101', 
								FIM_VENDAS = '20201231', 
								COR_FABRICANTE = ?curPlanilhaProdutos.COR, 
								COR = '000', 
								CLASSIF_FISCAL = ?curPlanilhaProdutos.CLASSIF_FISCAL, 
								TRIBUT_ORIGEM = '0'
				END
				
				IF NOT EXISTS(SELECT PRODUTO FROM PRODUTOS_BARRA_LICENCIADOS WHERE PRODUTO = @PRODUTO AND COR_PRODUTO = ?curPlanilhaProdutos.COR_PRODUTO AND TAMANHO = ?curPlanilhaProdutos.TAMANHO)
				BEGIN 
					INSERT INTO PRODUTOS_BARRA_LICENCIADOS (GRIFFE, PRODUTO, COR_PRODUTO, TAMANHO, CODIGO_BARRA, GRADE, PRODUTO_LICENCIADO)
						SELECT 	GRIFFE = ?curPlanilhaProdutos.GRIFFE,
								PRODUTO = @PRODUTO,
								COR_PRODUTO = ?curPlanilhaProdutos.COR_PRODUTO,
								TAMANHO = ?curPlanilhaProdutos.TAMANHO,
								CODIGO_BARRA = ?curPlanilhaProdutos.CODIGO_BARRA, 
								GRADE = ?curPlanilhaProdutos.GRADE,
								PRODUTO_LICENCIADO = ?strProduto
				END
	
				EXEC PROC_SS_GERA_CODIGO_BARRAS @PRODUTO
			ENDTEXT 
			
			IF !F_INSERT(strSql)
				F_WAIT()
				MESSAGEBOX('Erro ao inserir o produto, tente novamente.', 16, 'ATEN��O')
				RETURN .F.
			ENDIF
		
		ENDSCAN 

		f_wait()

		* Se der algum erro cria e abre arquivo com os erros 
		IF f_vazio(strErros)
			MESSAGEBOX('Produtos Cadastrados com sucesso!', 64, 'ATEN��O')
		ELSE
			IF !DIRECTORY('C:\TEMP')
				MKDIR 'C:\TEMP'
			ENDIF

			intArquivo = FCREATE('C:\TEMP\LOG_IMPORTACAO_PA.LOG')
			IF intArquivo < 0 
				MESSAGEBOX('Erros encontrados na importa��o dos produtos.' + CHR(10) + strErros, 16, 'ATEN��O')
				RETURN .T.
			ENDIF
			
			IF FPUTS(intArquivo, strErros) < 0
				MESSAGEBOX('Erros encontrados na importa��o dos produtos.' + CHR(10) + strErros, 16, 'ATEN��O')
				RETURN .T.
			ENDIF
			
			IF intArquivo > 0
				FCLOSE(intArquivo)
			ENDIF
			
			IF FILE('C:\TEMP\LOG_IMPORTACAO_PA.LOG')
				RUN /N notepad 'C:\TEMP\LOG_IMPORTACAO_PA.LOG'
			ENDIF
		ENDIF 
		
		RETURN .T.
		
		ENDPROC
ENDDEFINE
**************************************************
**************************************************
*-- Class:        tx_gs_nota_prod (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_gs_nota_prod AS lx_textbox_base


	ControlSource = "V_PRODUTOS_00_CORES_MAT.gs_nota_prod"
	Height = 19
	Left = 150
	TabIndex = 11
	Top = 5
	Width = 40
	ZOrderSet = 8
	Name = "tx_gs_nota_prod"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************		

**************************************************
*-- Class:        btn_importa_prog (e:\linx_sql_fontecompleta\class pessoal\btn_importa_prog.vcx)
*-- ParentClass:  botao (e:\linx_sql_fontecompleta\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/25/17 06:02:01 PM
*
*#INCLUDE "e:\linx\exclusivos\formtool\lx_const.h"
*
DEFINE CLASS btn_importa_nota AS botao

 
	Top = 5
	Left = 150
	Height = 25
	Width = 132
	Caption = "Importar Nota Produto"
	ToolTipText = [Importar Nota Produto]
	Name = "btn_importa_nota"
	Visible = .T.

	PROCEDURE Click
		strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

		if empty(NVL(strcaminho,''))
			messagebox("Opera��o Cancelada!",0+64,"Arquivo Inv�lido!")
			return .f.
		endif

		F_wait("Importando as informa��es, Aguarde...")

		if used("CUR_IMPORT")
			use in CUR_IMPORT
		endif

		CREATE CURSOR CUR_IMPORT(PRODUTO C(12), COR_PRODUTO C(10), NOTA N(14,2))
		
		try
						objxls 			= createobject("excel.application")
						objworkbook 	= objxls.workbooks.open(strcaminho)
						objsheet 		= objworkbook.sheets(1)
						iRowsSheet 		= objsheet.Rows.Count
						iPermitido 	    = 65000
						iImatrizIni		= 2 
						iImatrizFim		= iPermitido 
						iPercorrido     = 1 

						IF (MOD(iRowsSheet , iPermitido ) > 0 )
							iPercorrer = (ROUND(iRowsSheet/iPermitido,0))+1
						ELSE 
							iPercorrer = (iRowsSheet/iPermitido)
						ENDIF

						IF  upper(alltrim(objsheet.cells(1,1).text)) <> "PRODUTO" OR ;
							upper(alltrim(objsheet.cells(1,2).text)) <> "COR_PRODUTO" OR ;
						 	upper(alltrim(objsheet.cells(1,3).text)) <> "NOTA"
							MESSAGEBOX("O Layout do Arquivo � Inv�lido, O Cabe�alho deve Conter as Seguintes Informa��es:"+CHR(10)+"PRODUTO C�lula A"+CHR(10)+;
										"COR_PRODUTO C�lula B"+CHR(10)+"NOTA C�lula C",0+16,"Obj - Layout Inv�lido")
							return .f.
							*GO to oexception
						ENDIF

						IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
							objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,3)).value
							SELECT CUR_IMPORT
							APPEND FROM array objsheetRange   
						ELSE 
							DO WHILE iPercorrer >= iPercorrido      

								objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,3)).value

								SELECT CUR_IMPORT
								APPEND FROM array objsheetRange

								iPercorrido = iPercorrido + 1
								iImatrizIni = IIF(iImatrizIni==2,1 + iPermitido,iImatrizIni + iPermitido)
								iImatrizFim = IIF((iImatrizFim + iPermitido) < iRowsSheet, iImatrizFim + iPermitido, iRowsSheet )
							ENDDO

						ENDIF


						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 


					catch to oexception

						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 
					ENDTRY


					if type("oexception") = "O"
						f_wait()
						return.f.
					ENDIF
				
				f_wait()
				
				CurCartaoNaoImportado = ""
				xCartaoNaoImportado = 0
				xGetDate = DTOS(DATE())
				xCountReg = 0
				xTRit = 0
				xMsgErro = ''
				xMsgCabe = ''
				xProduto = ''
				xCorProd = ''

				SELECT cur_import
				DELETE FROM cur_import WHERE f_vazio(PRODUTO)
				
					F_wait("Validando as informa��es do Produto, Aguarde...")
					
					*** Verifica Programa��o ***
					SELECT DISTINCT NOTA FROM cur_import where !f_vazio(NOTA) AND (NOTA < 0 OR NOTA > 10) INTO CURSOR CUR_PROG_NOTA					
					If RECCOUNT("CUR_PROG_NOTA") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe produto com nota menor que zero ou maior que 10 !"+CHR(13)
					Endif
					
					xVerNota = 0
					SELECT DISTINCT NOTA FROM cur_import INTO CURSOR CUR_VER_NOTA
					If RECCOUNT("CUR_VER_NOTA") > 0	
						Sele CUR_VER_NOTA
						Go Top
						Scan				
							If xVerNota = 0 and CUR_VER_NOTA.nota = 0
								IF MESSAGEBOX("Existe produto com valor zerado, deseja zerar ?",4+32) = 6
									xVerNota = 1
								Else	
									xVerNota = 1
									xMsgCabe = xMsgCabe + CHR(13)+"- Produto com valor zerado/informado incorreto !"+CHR(13)
								Endif
							Endif
						Sele CUR_VER_NOTA
						EndScan
					Endif
					
					If !F_Vazio(xMsgCabe)
						f_wait()
						If USED("CUR_PROG_NOTA")
							USE IN CUR_PROG_NOTA
						Endif
						
						MESSAGEBOX("N�o foi poss�vel atualizar o produto, cont�m os erros abaixo: "+CHR(13)+xMsgCabe+CHR(13)+;
								   "Favor acertar na planilha !!!",0+16,"Cabe�alho")
						Return .F.		   
					Endif
					
					If !DIRECTORY("C:\TEMP\IMPORT_PROD_NOTA") 
						MD "C:\TEMP\IMPORT_PROD_NOTA"
					ENDIF
					
					If USED("CurVerProd")
						USE IN CurVerProd
					Endif

					If USED("CurProdCor")
						USE IN CurProdCor
					Endif
					
					If USED("vErroProdCor")
						USE IN vErroProdCor
					Endif

					f_select("select produto, cor_produto from PRODUTO_CORES (nolock)","CurProdCor")
					Sele CurProdCor
					
					Sele cur_import
					DELETE FROM cur_import WHERE f_vazio(produto)
					
					
					Select a.produto, a.cor_produto, 'PRODUTO/COR INCORRETO' AS OBS;
					FROM cur_import a LEFT JOIN CurProdCor b ON a.produto = b.produto AND a.cor_produto = b.cor_produto ;
					where b.produto is null ;
					INTO cursor CurVerProd READWRITE 
					
					If RECCOUNT("CurVerProd")>0
						xMsgErro = xMsgErro + CHR(13)+"- Existe(m) produto(s)/cor informado incorreto, nome do arquivo: Erro_Produto_Cor"+CHR(13)
							
						SELECT produto, cor_produto, obs from CurVerProd WHERE !f_vazio(PRODUTO) INTO CURSOR vErroProdCor READWRITE 
						
						Sele vErroProdCor
						DELETE FROM vErroProdCor WHERE f_vazio(PRODUTO)
						COPY TO c:\temp\import_prod_nota\erro_prod_cor_nota xl5

					Endif
					
					If !F_Vazio(xMsgErro)
						IF MESSAGEBOX("FAVOR VERIFICAR NO CAMINHO: "+"'"+"C:\TEMP\import_prod_nota\"+"'"+" OS ERROS!!!"+CHR(13)+xMsgErro+CHR(13)+"Deseja abrir os arquivos ?",4+16,"Importa��o")=6								
							If RECCOUNT("CurVerProd")>0
								f_wait()
								
								system.file.FileOpen("c:\temp\import_prod_nota\erro_prod_cor_nota.xls")
								release CurVerProd
									
								If USED("CurVerProd")
									USE IN CurVerProd
								Endif

								If USED("CurProdCor")
									USE IN CurProdCor
								Endif
									
								If USED("vErroProdCor")
									USE IN vErroProdCor
								Endif
							
								Return .F.
							Endif	
						Else
							f_wait()
							Return .F.
						ENDIF
					Endif
					
					F_wait("Atualizando as notas do Produto, Aguarde...")
					SELECT cur_import
					DELETE FROM cur_import WHERE f_vazio(PRODUTO)
					
					xNota=''
					xUpNota=''
					  
					Sele cur_import					
					Go Top
					Scan
						xNota=STR(cur_import.nota,14,2)
						xUpNota=STRTRAN(ALLTRIM(xNota),",",".")

						TEXT TO xUpdateNota TEXTMERGE NOSHOW
							UPDATE PRODUTO_CORES SET GS_NOTA_PROD =  '<<xUpNota>>'
							WHERE PRODUTO = '<<cur_import.PRODUTO>>' 
							AND COR_PRODUTO = '<<cur_import.COR_PRODUTO>>'
						ENDTEXT
						
						F_UPDATE(xUpdateNota)
						
					SELECT cur_import
					ENDSCAN
					
					MESSAGEBOX("Nota dos produtos Atualizados !!!",0+16,"Nota Produto")
					f_wait()
				
					
	
	ENDPROC
	
ENDDEFINE
*
*-- EndDefine: btn_importa_prog
**************************************************
**************************************************
*-- Class:        btn_importa_tempo (e:\linx_sql_fontecompleta\class pessoal\btn_importa_prog.vcx)
*-- ParentClass:  botao (e:\linx_sql_fontecompleta\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/25/17 06:02:01 PM
*
*#INCLUDE "e:\linx\exclusivos\formtool\lx_const.h"
*
DEFINE CLASS btn_import_tmp_producao AS botao

 
	Top = 5
	Left = 300
	Height = 25
	Width = 140
	Caption = "Importar Tempo Produ��o"
	ToolTipText = [Importar Tempo Produ��o]
	Name = "btn_import_tmp_producao"
	Visible = .T.

	PROCEDURE Click
		If Thisformset.PP_GS_importar_tempo_prod = .F.
			MESSAGEBOX("Voc� n�o tem permiss�o para importar !",0+16,"Tempo Produ��o")
			Return .F.
		Endif	
		
		strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

		if empty(NVL(strcaminho,''))
			messagebox("Opera��o Cancelada!",0+64,"Arquivo Inv�lido!")
			return .f.
		endif
 
		F_wait("Importando as informa��es, Aguarde...")

		if used("CUR_IMPORT")
			use in CUR_IMPORT
		endif

		CREATE CURSOR CUR_IMPORT(PRODUTO C(12), TEMPO I)
		
		try
						objxls 			= createobject("excel.application")
						objworkbook 	= objxls.workbooks.open(strcaminho)
						objsheet 		= objworkbook.sheets(1)
						iRowsSheet 		= objsheet.Rows.Count
						iPermitido 	    = 65000
						iImatrizIni		= 2 
						iImatrizFim		= iPermitido 
						iPercorrido     = 1 

						IF (MOD(iRowsSheet , iPermitido ) > 0 )
							iPercorrer = (ROUND(iRowsSheet/iPermitido,0))+1
						ELSE 
							iPercorrer = (iRowsSheet/iPermitido)
						ENDIF

						IF  upper(alltrim(objsheet.cells(1,1).text)) <> "PRODUTO" OR ;
						 	upper(alltrim(objsheet.cells(1,2).text)) <> "TEMPO"
							MESSAGEBOX("O Layout do Arquivo � Inv�lido, O Cabe�alho deve Conter as Seguintes Informa��es:"+CHR(10)+"PRODUTO C�lula A"+CHR(10)+;
										"TEMPO C�lula B",0+16,"Obj - Layout Inv�lido")
							return .f.
							*GO to oexception
						ENDIF

						IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
							objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,2)).value
							SELECT CUR_IMPORT
							APPEND FROM array objsheetRange   
						ELSE 
							DO WHILE iPercorrer >= iPercorrido      

								objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,2)).value

								SELECT CUR_IMPORT
								APPEND FROM array objsheetRange

								iPercorrido = iPercorrido + 1
								iImatrizIni = IIF(iImatrizIni==2,1 + iPermitido,iImatrizIni + iPermitido)
								iImatrizFim = IIF((iImatrizFim + iPermitido) < iRowsSheet, iImatrizFim + iPermitido, iRowsSheet )
							ENDDO

						ENDIF


						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 


					catch to oexception

						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 
					ENDTRY


					if type("oexception") = "O"
						f_wait()
						return.f.
					ENDIF
				
				f_wait()
				
				CurCartaoNaoImportado = ""
				xCartaoNaoImportado = 0
				xGetDate = DTOS(DATE())
				xCountReg = 0
				xTRit = 0
				xMsgErro = ''
				xMsgCabe = ''
				xProduto = ''
				xCorProd = ''
 
				SELECT cur_import
				DELETE FROM cur_import WHERE f_vazio(PRODUTO)
				 
					F_wait("Validando as informa��es do Produto, Aguarde...")
					
					*** Verifica Programa��o ***
					SELECT DISTINCT TEMPO FROM cur_import WHERE !f_vazio(PRODUTO) AND f_vazio(TEMPO) INTO CURSOR CUR_PROG_TEMPO					
					If RECCOUNT("CUR_PROG_TEMPO") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe produto com nota em branco !"+CHR(13)
					Endif
					
					SELECT PRODUTO, COUNT(PRODUTO) AS QTDE_PROD FROM cur_import where !f_vazio(PRODUTO) GROUP BY PRODUTO HAVING COUNT(PRODUTO) > 1 INTO CURSOR CUR_PRODUTO_DUPLICADO
					If RECCOUNT("CUR_PRODUTO_DUPLICADO") > 0
						xMsgCabe = xMsgCabe + CHR(13)+"- Existe produto duplicado na planilha !"+CHR(13)
					Endif
					   
					If !F_Vazio(xMsgCabe)
						f_wait()
						If USED("CUR_PROG_TEMPO")
							USE IN CUR_PROG_TEMPO
						Endif
						
						If USED("CUR_PRODUTO_DUPLICADO")
							USE IN CUR_PRODUTO_DUPLICADO
						Endif
						
						MESSAGEBOX("N�o foi poss�vel atualizar o produto, cont�m os erros abaixo: "+CHR(13)+xMsgCabe+CHR(13)+;
								   "Favor acertar na planilha !!!",0+16,"Cabe�alho")
						Return .F.		   
					Endif
					
					F_wait("Atualizando o tempo de produ��o dos Produtos, Aguarde...")
					
					xUpTempo=''
					
					SELECT cur_import
					DELETE FROM cur_import WHERE f_vazio(PRODUTO)
					  
					Sele cur_import					
					Go Top
					Scan
						xUpTempo=ALLTRIM(STR(cur_import.tempo))
						
						TEXT TO xVerPropriedade TEXTMERGE NOSHOW
							SELECT * FROM PROP_PRODUTOS
							WHERE PROPRIEDADE = '00528' AND PRODUTO = '<<cur_import.PRODUTO>>' 
						ENDTEXT
						f_select(xVerPropriedade,"CurExProp")
						IF !F_VAZIO(CurExProp.produto)
							TEXT TO xUpdateTempo TEXTMERGE NOSHOW
								UPDATE PROP_PRODUTOS SET valor_propriedade = '<<xUpTempo>>'
								WHERE PROPRIEDADE = '00528' AND PRODUTO = '<<cur_import.PRODUTO>>' 
							ENDTEXT
							F_UPDATE(xUpdateTempo)
						Else
							TEXT TO xInsertTempo TEXTMERGE NOSHOW
								insert into prop_produtos(PROPRIEDADE, ITEM_PROPRIEDADE, VALOR_PROPRIEDADE, DATA_PARA_TRANSFERENCIA, PRODUTO)
								select '00528', '1', '<<xUpTempo>>', getdate(), '<<cur_import.PRODUTO>>' 
							ENDTEXT
							f_insert(xInsertTempo)
						Endif
					SELECT cur_import
					ENDSCAN
					
					f_wait()	
					MESSAGEBOX("Tempo de Produ��o dos produtos Atualizados !!!",0+16,"Nota Produto")
														
	
	ENDPROC
	
ENDDEFINE
*
*-- EndDefine: btn_importa_tempo
**************************************************
**************************************************
*-- Class:        cmb_gs_etapa (p:\tmpsid\entradas_rbx\cmb_gs_etapa.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_gs_etapa AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 625
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_gs_etapa"
	Visible = .t.
	Enabled = .t.
	Anchor = 0


ENDDEFINE
**************************************************
**************************************************
*-- Class:        tx_gs_nota_prod (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_gs_qtde_vendida_etapa AS lx_textbox_base

 
	ControlSource = "V_PRODUTOS_00_CORES_MAT.GS_QTDE_VENDIDA_ETAPA"
	Height = 19
	Left = 150
	TabIndex = 11
	Top = 5
	Width = 115
	ZOrderSet = 8
	Name = "tx_gs_qtde_vendida_etapa"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************
			