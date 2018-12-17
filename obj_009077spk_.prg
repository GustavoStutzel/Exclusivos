* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar e Wallace Pacheco                                                                                               *
* DATA...........:  01/06/2011  / 07/08/2015                                                                                             *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.:  						                    *
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
											
						PUBLIC xTempValor
				
				
				case upper(xmetodo) == 'USR_ALTER_AFTER'
				
					xalias=alias()
						
						sele v_ctb_loja_venda_00
						xTempValor = v_ctb_loja_venda_00.valor_pago
					
					if !f_vazio(xalias)
						sele &xalias
					endif




					case upper(xmetodo) == 'USR_SAVE_BEFORE'
					
						xalias=alias()
						
*!*	Wallace Pacheco (07/08/2015) -> Retirado codigo abaixo criado pelo Julio, pois a regra de neg�cio foi modificada


			
*!*						IF 	!f_vazio(xTempValor)
*!*							IF UPPER(WUSUARIO) = 'VERONICA' OR UPPER(WUSUARIO) = 'SA' 
*!*								RETURN .T.
*!*							ELSE		
*!*							  	sele v_ctb_loja_venda_00
*!*								IF (v_ctb_loja_venda_00.valor_pago < (xTempValor-10)) 
*!*									MESSAGEBOX('NAO � PERMITIDO ALTERAR O VALOR LIQUIDO DO TICKET'+' VALOR DO TICKET: '+allt(str(xTempValor,10,2))+' PERMITIDO SOMENTE VARIA�AO DE 10,00 (+ ou -)',48)
*!*									RETURN .F.
*!*								ELSE
*!*									IF (v_ctb_loja_venda_00.valor_pago > (xTempValor+10))
*!*										MESSAGEBOX('NAO � PERMITIDO ALTERAR O VALOR LIQUIDO DO TICKET'+' VALOR DO TICKET: '+allt(str(xTempValor,10,2))+' PERMITIDO SOMENTE VARIA�AO DE 10,00 (+ ou -)',48)					
*!*										RETURN .F.
*!*									ENDIF	
*!*								ENDIF
*!*							ENDIF							
*!*						ENDIF
					
*!*	FIM - Wallace Pacheco (07/08/2015) -> Retirado codigo abaixo criado pelo Julio, pois a regra de neg�cio foi modificada					
					
					if !f_vazio(xalias)
						sele &xalias
					endif
					
					
					
					case upper(xmetodo) == 'USR_SAVE_AFTER'
					
						xalias=alias()
						
							xTempValor = ''
					
					
						if !f_vazio(xalias)
							sele &xalias
						endif



				
					case upper(xmetodo) == 'USR_WHEN'
						
						xalias=alias()
						
*!* Wallace Pacheco	(07/08/2015) -> C�digo incluido para n�o permitir altera��o do valor da parcela				
*!*	Wallace Pacheco (11/08/2015) -> Retorno do codigo do Julio					
*!*						IF upper(xnome_obj) = 'TX_VALOR_PARCELA' OR upper(xnome_obj) = 'TX_DESCONTO_PGTO'
*!*							
*!*							IF UPPER(WUSUARIO) = 'VERONICA' OR UPPER(WUSUARIO) = 'SA' 
*!*								thisformset.lx_form_analitico.Lx_pageframe1.page3.tx_desconto_pgto.Enabled= .T.
*!*								thisformset.lx_form_analitico.Lx_pageframe1.page4.tx_valor_parcela.Enabled= .T.
*!*							ELSE
*!*								thisformset.lx_form_analitico.Lx_pageframe1.page3.tx_desconto_pgto.Enabled= .F.
*!*								thisformset.lx_form_analitico.Lx_pageframe1.page4.tx_valor_parcela.Enabled= .F.	
*!*							ENDIF	
*!*						
*!*						ENDIF
					
*!* FIM - Wallace Pacheco (07/08/2015) -> C�digo incluido para n�o permitir altera��o do valor da parcela
					
					IF upper(xnome_obj) = 'OPT_PERGUNTA'
					
						IF UPPER(WUSUARIO) != 'SA' 	
							IF  thisformset.lx_FORM1.lx_pageframe1.page5.opt_pergunta.option5.Value=1
								thisformset.LX_FORM1.LX_pageframe1.Page5.MOVerlists.LstSelected.Enabled= .F.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdRemoveAll.Enabled = .F.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdRemove.Enabled = .F.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdAdd.Enabled = .F.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdAddAll.Enabled = .F.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.LstSource.Enabled = .F.
							ELSE				
								thisformset.LX_FORM1.LX_pageframe1.Page5.MOVerlists.LstSelected.Enabled= .T.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdRemoveAll.Enabled = .T.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdRemove.Enabled = .T.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdAdd.Enabled = .T.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.CmdAddAll.Enabled = .T.
								thisformset.LX_FORM1.LX_pageframe1.Page5.Moverlists.LstSource.Enabled = .T.
							ENDIF
						ENDIF
						
					
					ENDIF
					
					
						
					IF upper(xnome_obj) = 'CMD_AVANCAR'
							
							xTempValor = ''
								
							IF thisformset.lx_FORM1.lx_pageframe1.page5.opt_pergunta.option5.Value=1 OR thisformset.lx_FORM1.lx_pageframe1.page5.opt_pergunta.option1.Value=1
								thisformset.LX_FORM1.LX_pageframe1.Page9.Ck_integrar.Enabled=.T.
							ELSE
								thisformset.lx_FORM1.lx_pageframe1.page9.Ck_integrar.Value=.F.
								thisformset.LX_FORM1.LX_pageframe1.Page9.Ck_integrar.Enabled=.F.	
							ENDIF
							
							
					ENDIF
					
	
	
				if !f_vazio(xalias)
						sele &xalias
				endif
							
							
											
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE