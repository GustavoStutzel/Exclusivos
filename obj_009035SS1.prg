define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.
	procedure metodo_usuario
	lparam xmetodo, xobjeto ,xnome_obj
	do case
		case UPPER(xmetodo) == 'USR_INIT'
			WAIT WINDOW 'OBJ' NOWAIT
	
		
		case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
			* 23/03/2017 - Leandro Rocha (SS): Desativa LOG da tela. Solicitado pelo Sidnei.
			Thisformset.p_auditoria = ''

				
		otherwise
			return .t.
	endcase
	endproc
enddefine
