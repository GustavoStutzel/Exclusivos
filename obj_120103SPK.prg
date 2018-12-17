define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj

		do CASE  
			case UPPER(xmetodo) == 'USR_INIT'
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				* 13/06/2014 - Leandro Rocha (SS): Verifica se e o par�mentro "SS_ACERTO_APENAS_DE_GRADE" est� definido com "SIM", se tiver s� permite fazer acerto de grade.
				IF TYPE('THISFORMSET.PP_SS_ACERTO_APENAS_DE_GRADE') == 'L'
					* Se existir o par�metro cadastrado e estiver como "SIM", verifica se todos os produtos da entrada estao com quantidade total zerada, isso indica que � acerto apenas de grade.
					IF THISFORMSET.PP_SS_ACERTO_APENAS_DE_GRADE 
						select V_ESTOQUE_PROD_ENT_00_PRODUTOS
						SCAN
							IF V_ESTOQUE_PROD_ENT_00_PRODUTOS.QTDE <> 0 
								Messagebox( 'Voc� s� tem acesso para acerto de grade, o produto:' + alltrim(V_ESTOQUE_PROD_ENT_00_PRODUTOS.produto) + ', est� com total diferente de zero.' + CHR(10) +;
											'Verifique antes de continuar.', 16, 'ATEN��O (SS)')
								RETURN .F.
							ENDIF					
						ENDSCAN		
					ENDIF
				ENDIF 
	
			OTHERWISE
				RETURN .t.				
		endcase
	endproc
ENDDEFINE
