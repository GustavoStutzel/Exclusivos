Define Class obj_GS_classes As Custom
	*!* Criar Fun��o e chamar no Obj de entrada *!*

	** Fun��o abaixo criada para executar em todos os metodos da tela **
	Function l_marca_todos string

		Lparam xCursor, xColuna, xValor
		*!* Aqui escrever o c�digo a ser executado pela fun��o *!*
			nOldSele = Select()
			
 			SELE &xCursor
 			GO Top
			Replace ALL &xColuna WITH &xValor
			
			GO Top
			Select(nOldSele)
			
	Endfunc
	** Fim da Fun��o ***************************************************
	
	
	** Fim da classe **
Enddefine
