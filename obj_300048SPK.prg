define class obj_entrada as custom
*- Nome do metodo/fun��o que os objetos linx v�o chamar.
	procedure metodo_usuario
	lparam xmetodo, xobjeto ,xnome_obj
	do case
	
		case UPPER(xmetodo) == 'USR_INIT'	
			WAIT WINDOW 'OBJ' NOWAIT

		case UPPER(xmetodo) == 'USR_ALTER_BEFORE'
			* 04/04/2013 - Leandro Rocha (SS): Exibe descri��o dos m�dulos filtro ao incluir / alter um registro para facilitar o cadastro dos filtros
			MESSAGEBOX( 'Descri��o dos m�dulos filtro:' + CHR(10) +;
						'1  - Vendas acima de R$ 10.000,00 e Vendas j� registradas atrav�s do ECF' + CHR(10) +;
						'2  - Trocas' + CHR(10) +;
						'3  - Sa�das' + CHR(10) +;
						'4  - Consum�veis' + CHR(10) +;
						'6  - Remessas de Consigna��o' + CHR(10) +;
						'7  - Cancelamentos' + CHR(10) +;
						'8  - Trocas do dia' + CHR(10) +;
						'9  - Retornos de Consigna��o' + CHR(10) +;
						'10 - Vendas menores que R$ 10.000,00 (Ao consumidor, modelo 2)' + CHR(10) +;
						'11 - Entrada para conserto' + CHR(10) +;
						'12 - Remessa do conserto' + CHR(10) +;
						'13 - Devolu��o do conserto' + CHR(10) +;
						'15 - Notas Fiscais Complementares', 64, 'MODULOS FILTRO')

		case UPPER(xmetodo) == 'USR_INCLUDE_AFTER'
			* 04/04/2013 - Leandro Rocha (SS): Exibe descri��o dos m�dulos filtro ao incluir / alter um registro para facilitar o cadastro dos filtros
			MESSAGEBOX( 'Descri��o dos m�dulos filtro:' + CHR(10) +;
						'1  - Vendas acima de R$ 10.000,00 e Vendas j� registradas atrav�s do ECF' + CHR(10) +;
						'2  - Trocas' + CHR(10) +;
						'3  - Sa�das' + CHR(10) +;
						'4  - Consum�veis' + CHR(10) +;
						'6  - Remessas de Consigna��o' + CHR(10) +;
						'7  - Cancelamentos' + CHR(10) +;
						'8  - Trocas do dia' + CHR(10) +;						
						'9  - Retornos de Consigna��o' + CHR(10) +;
						'10 - Vendas menores que R$ 10.000,00 (Ao consumidor, modelo 2)' + CHR(10) +;
						'11 - Entrada para conserto' + CHR(10) +;
						'12 - Remessa do conserto' + CHR(10) +;
						'13 - Devolu��o do conserto' + CHR(10) +;
						'15 - Notas Fiscais Complementares', 64, 'MODULOS FILTRO')
		otherwise
			return .t.
	endcase
	endproc
enddefine
