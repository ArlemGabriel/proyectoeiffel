note
	description: "Summary description for {COLUMNA_INTEGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLUMNA_INTEGER

inherit
	COLUMNA

create
	make_integer

feature {NONE} -- Initialization

	make_integer (nombre: STRING)
			-- Initialization for `Current'.			
		do
			nombrecolumna:=nombre
			tipo:= "int"
			create datocolumna.make
		end

feature -- Access
	get_datos : LINKED_LIST[INTEGER]
		do Result :=datocolumna end

	get_tamano: INTEGER
		do Result:=datocolumna.count end

feature -- Basic operations
	obtenerdatosdefilas(indice: INTEGER):STRING
		local
			filatemporal: INTEGER
		do
			filatemporal:=datocolumna.at(indice)
			Result:= filatemporal.out
		end

	nohaydatosreplicados
		do
			nohayreplicados:=true
		end

	agregardatos (nuevodato: STRING)
		do
			datocolumna.extend (nuevodato.to_integer)
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
					if datocolumna.item.is_equal (nuevodato.to_integer) then
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
			datos:INTEGER
			valido:BOOLEAN
		do
			datos:=obtenerdatosdefilas (conteofilas).to_integer
			if operador.is_equal ("=")then
					valido:=datos.is_equal (condicion.to_integer)
			elseif operador.is_equal ("!=") then
					valido:=not datos.is_equal (condicion.to_integer)
			elseif operador.is_equal ("<") then
					valido:=datos < condicion.to_integer
			elseif operador.is_equal ("<=") then
					valido:=datos <= condicion.to_integer
			elseif operador.is_equal (">=") then
					valido:=datos >= condicion.to_integer
			elseif operador.is_equal (">") then
					valido:=datos > condicion.to_integer
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
	datocolumna: LINKED_LIST[INTEGER]

end
