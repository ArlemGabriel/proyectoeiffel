note
	description: "Summary description for {TABLA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TABLA

create
	make

feature {NONE} -- Initialization

	make (nombre : STRING)
			-- Initialization for `Current'.
		do
			nombretabla:=nombre
			id:= ""
			create filas.make
		end


feature -- Access
	get_nombre : STRING
		do Result :=nombretabla end
	get_id : STRING
		do Result :=id end
	get_filas : LINKED_LIST[COLUMNA]
		do Result :=filas end
	get_numerofilas : INTEGER
		do Result :=filas.count end

feature -- Basic operations
	elim(campo,operador,condicion:STRING)
		local
			conteofilas:INTEGER
			columna:COLUMNA
			columnatemporal:COLUMNA
		do
			filas.start
			columnatemporal:=filas.item

			from
				conteofilas:=1
			until
				conteofilas.is_equal (columnatemporal.get_tamano+1)
			loop
				if verificarcondicion(campo,operador,condicion,conteofilas) then
					print ("%TFila Eliminada:")
					from
						filas.start
					until
						filas.off
					loop
						print ("%T")
						columna:=filas.item
						print(columna.obtenerdatosdefilas(conteofilas))
						columna.borrardatos (conteofilas)
						print ("%T")
						filas.forth
					end
					conteofilas:=conteofilas-1
					print ("%N")
				end
					conteofilas:=conteofilas+1
			end
		end
	verificarcondicion(campo,operador,condicion:STRING; conteofilas:INTEGER):BOOLEAN
		local
			correct:BOOLEAN
			columna:COLUMNA
		do
			from
				filas.start
			until
				filas.off
			loop
				columna:=filas.item
				if columna.get_nombre.is_equal (campo) then
					correct:=columna.verificarcondicion (operador, condicion, conteofilas)
				end
				filas.forth
			end
			Result :=correct
		end

	mostrarcolumnasporcondicion(campo,operador,condicion:STRING)
		local
			conteofilas:INTEGER
			columna:COLUMNA
			columnatemporal:COLUMNA
		do
			filas.start
			columnatemporal:=filas.item
			print("%N")
			mostrarnombrescolumnas

			from
				conteofilas:=1
			until
				conteofilas.is_equal (columnatemporal.get_tamano+1)
			loop
				if verificarcondicion(campo,operador,condicion,conteofilas) then
					from
						filas.start
					until
						filas.off
					loop
						print ("%T")
						columna:=filas.item
						print(columna.obtenerdatosdefilas(conteofilas))
						print ("%T")
						filas.forth
					end
					print ("%N")
				end
					conteofilas:=conteofilas+1
			end
		end



	mostrarcolumnas
		local
			conteofilas:INTEGER
			columna:COLUMNA
			columnatemporal:COLUMNA
		do
			filas.start
			columnatemporal:=filas.item
			print("%N")
			mostrarnombrescolumnas
			from
				conteofilas:=1
			until
				conteofilas.is_equal (columnatemporal.get_tamano+1)
			loop
				from
					filas.start
				until
					filas.off
				loop
					print ("%T")
					columna:=filas.item
					print(columna.obtenerdatosdefilas(conteofilas))
					print ("%T")
					filas.forth
				end
				print ("%N")

				conteofilas:=conteofilas+1
			end
		end

	mostrarnombrescolumnas
		do
			from
				filas.start
			until
				filas.off
			loop
				print ("%T")
				print(filas.item.get_nombre)
				print ("%T")
				filas.forth
			end
			print ("%N")
		end

	agregarcolumna (nombre, tipo: STRING)
		require
			tipovalido: tipo.is_equal ("str") or tipo.is_equal ("int")
		local
			columnastring: COLUMNA_STRING
			columnainteger: COLUMNA_INTEGER
		do
			if tipo.is_equal ("str") then
				create columnastring.make_str (nombre)
				filas.force(columnastring)
			else
				create columnainteger.make_integer (nombre)
				filas.force(columnainteger)
			end
		ensure
			filas.count/= old filas.count
		end

	nohaydatosreplicados (nombrecolumna: STRING)
		require
			not get_filas.is_empty
		do
			from
				filas.start
			until
				filas.off
			loop
				if filas.item.get_nombre.is_equal (nombrecolumna) then
					filas.item.nohaydatosreplicados
					id:= nombrecolumna
				end
				filas.forth
			end
		end

	existenciadecolumna (nombrecolumna :STRING) : BOOLEAN
		local
			existencia: BOOLEAN
		do
			if filas.is_empty then
				Result:=false
			else
				from
					filas.start
					existencia:=false
				until
					filas.off
				loop

					if filas.item.get_nombre.is_equal (nombrecolumna) then
						existencia:=true
					end
					filas.forth
				end

				Result:=existencia
			end
		end

	agregarfila (datoscolumna : LIST[STRING])
		require
			not datoscolumna.is_empty
		do
			from
				datoscolumna.start
				filas.start
			until
				datoscolumna.off
			loop
				filas.item.agregardatos (datoscolumna.item)

				datoscolumna.forth
				filas.forth
			end
		end

	verificardatos(datoscolumna: LIST[STRING]):BOOLEAN
		require
			not datoscolumna.is_empty
		local
			datovalido:BOOLEAN
		do
			from
				datoscolumna.start
				filas.start
				datovalido:=true
			until
				filas.off
			loop
				if not filas.item.verificardatos (datoscolumna.item) then
					datovalido:=false
				end

				datoscolumna.forth
				filas.forth
			end
			Result:=datovalido

		end

feature {NONE} --Implementation
	nombretabla: STRING
	filas: LINKED_LIST[COLUMNA]
	id : STRING

invariant
	invariant_clause: True -- Your invariant here

end
