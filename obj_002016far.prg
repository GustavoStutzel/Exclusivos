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
				
					xalias=alias()
						xVersao = '01.1'
						f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
						f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
						WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

						WITH thisform.lx_PAGEFRAME1.page1.lx_grid_filha1
							
							.parent.parent.parent.height=475
							.parent.parent.height=470
							.top=thisform.lx_PAGEFRAME1.page1.lx_grid_filha1.top+60
							.height=thisform.lx_PAGEFRAME1.page1.lx_grid_filha1.height-40
							.anchor=0	
								
						
						ENDWITH 
						
						thisform.lx_PAGEFRAME1.page1.addobject("imprime_datamax_anm","imprime_datamax_farm") 
						thisform.lx_PAGEFRAME1.page1.addobject("imprime_datamax_animale","imprime_datamax_animale") 		
						thisform.lx_PAGEFRAME1.page1.addobject("imprime_datamax_atacado","imprime_datamax_atacado")
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				case UPPER(xmetodo)=='USR_REFRESH'
				
					If Thisformset.p_tool_status $ 'L'
						Thisformset.lx_form1.lx_pageframe1.page3.lx_textbox_base1.Value=Thisformset.pp_gs_fator_p_qtde
						Thisformset.lx_form1.lx_pageframe1.page3.lx_textbox_base1.Refresh()
					Endif					

				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

**************************************************
*-- Class:        imprime_datamax_farm (l:\implanta��o-linx\impressao_cod_barra_allegro_velha\imprime_datamax_farm.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_farm AS commandbutton


	Top = 2
	Left = 220
	Height = 27
	Width = 150
	Caption = "Etiqueta Varejo Farm"
	Name = "imprime_datamax_farm"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impress�o de etiqueta termica datamax farm.frx' NOCONSOLE TO PRINTER 


				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_farm
**************************************************




**************************************************
*-- Class:        imprime_datamax_animale (l:\implanta��o-linx\impressao_cod_barra_allegro_velha\imprime_datamax_animale.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_animale AS commandbutton

	Top = 2
	Left = 56
	Height = 27
	Width = 150
	Caption = "Etiqueta Mostruario"
	Name = "imprime_datamax_animale"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impress�o de etiqueta termica datamax animale.frx' NOCONSOLE TO PRINTER 

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_animale 
**************************************************


**************************************************
*-- Class:        imprime_datamax_animale (l:\implanta��o-linx\impressao_cod_barra_allegro_velha\imprime_datamax_animale.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_atacado AS commandbutton

	Top = 2
	Left = 400
	Height = 27
	Width = 150
	Caption = "Etiqueta Atacado"
	Name = "imprime_datamax_atacado"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impress�o de etiqueta termica datamax atacado.frx' NOCONSOLE TO PRINTER 

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_animale 
**************************************************
