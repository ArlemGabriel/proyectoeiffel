note
	description: "Summary description for {COLUMNA_STRING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLUMNA_STRING

inherit
	COLUMNA

create
	make_str

feature {NONE} -- Initialization

	make_str (nombre: STRING)
			-- Initialization for `Current'.			
		do
			nombrecolumna:=nombre
			tipo:= "str"
			create datocolumna.make
		end

feature -- Access
	get_datos : LINKED_LIST[STRING]
		do Result :=datocolumna end

	get_tamano: INTEGER
		do Result:=datocolumna.count end


feature -- Basic operations

	obtenerdatosdefilas(indice: INTEGER) :STRING
		local
			filatemporal:STRING
		do
			filatemporal:=datocolumna.at(indice)
			Result :=filatemporal
		end

	nohaydatosreplicados
		do
			nohayreplicados:=true
		end

	agregardatos (nuevodato: STRING)
		do
			datocolumna.extend (nuevodato)
		end

	verificardatos (nuevodato: STRING):BOOLEAN
		local
			datovalido:BOOLEAN
		do
			if nohayreplicados then
				from
					datocolumna.start
					datovalido:=true
				until
					datocolumna.off
				loop
					if datocolumna.item.is_equal (nuevodato) then
						datovalido:=false
					end
					datocolumna.forth
				end
				Result:=datovalido
			else
				Result:=true
			end
		end

	verificarcondicion(operador,condicion:STRING; conteofilas:INTEGER):BOOLEAN
		local
			datos:STRING
			valido:BOOLEAN
		do
			datos:=datocolumna.at (conteofilas)
			if operador.is_equal ("=")then
					valido:=datos.is_equal (condicion)
			elseif operador.is_equal ("!=") then
					valido:=not datos.is_equal (condicion)
			elseif operador.is_equal ("<") then
					valido:=datos.is_less (condicion)
			elseif operador.is_equal ("<=") then
					valido:=datos.is_less_equal (condicion)
			elseif operador.is_equal (">=") then
					valido:=datos.is_greater_equal (condicion)
			elseif operador.is_equal (">") then
					valido:=datos.is_greater (condicion)
			end

			Result:=valido
		end


feature
	borrardatos (indice: INTEGER)
		do
			datocolumna.go_i_th (indice)
			datocolumna.remove()

		end

feature {NONE} -- Implementation
	datocolumna: LINKED_LIST[STRING]

end
