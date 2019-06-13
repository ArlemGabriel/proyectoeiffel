note
	description: "Progra3 application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			line: STRING
		do
			create tablas.make
			create nuevatabla.make ("")
			io.put_string ("Ingrese un comando ...")
			io.put_new_line

			from
				comandoenejecucion:="none"
				io.put_string (">>")
				io.read_line
				line := io.last_string
			until
				line.is_equal ("fin")
			loop
				execute_cmd(line)
				io.put_string ("%N>>")
				io.read_line
				line := io.last_string		end

		end

feature -- Access
	get_nuevatabla : TABLA
		do Result :=nuevatabla end

	get_tablas : LINKED_LIST[TABLA]
		do Result :=tablas end

feature -- Commands

	creartab (nombre: STRING)
		do
			create nuevatabla.make (nombre)
		ensure
			nuevatabla/=old nuevatabla
		end

	defcol (nombre, tipo: STRING)
		require
			tipocorrecto: tipo.is_equal("str") or tipo.is_equal("int")
			not get_nuevatabla.existenciadecolumna(nombre)
		do
			nuevatabla.agregarcolumna (nombre, tipo)
		end

	fincreartab
		do
			tablas.force (nuevatabla)
		ensure
			tablas.count /= old tablas.count
		end

	fincreartabcolumn (columna: STRING)
		require
			not columna.is_empty
			get_nuevatabla.existenciadecolumna(columna)
		do
			nuevatabla.nohaydatosreplicados (columna)
			tablas.force (nuevatabla)
		end

	mostrartablas
		require
			not get_tablas.is_empty
		do
			io.put_string ("%N%TTablas: [")
			from
				tablas.start
			until
				tablas.off
			loop
				io.put_string (tablas.item.get_nombre)

				if tablas.islast then
					io.put_string ("]")
				else
					io.put_string (", ")
				end

				tablas.forth
			end
		end

	mostrartabla (nombre: STRING)
		require
			not get_tablas.is_empty
		do
			from
				tablas.start
			until
				tablas.off
			loop
				if tablas.item.get_nombre.is_equal (nombre) then
					io.put_string ("%TTabla: ")
					io.put_string (tablas.item.get_nombre)
					if not tablas.item.get_id.is_empty then
						io.put_string ("  Campo Unico: ")
						io.put_string (tablas.item.get_id)
					end
					io.put_new_line
					io.put_string ("%TColumnas:[")
					mostrarcolumnasdetabla(tablas.item)
					io.put_string ("]")
					io.put_new_line
				end

				tablas.forth
			end
		end

	mostrarcolumnasdetabla (tabla: TABLA)
		local
			columnas: LINKED_LIST[COLUMNA]
		do
			columnas:=tabla.get_filas
			from
				columnas.start
			until
				columnas.off
			loop
				io.put_string (columnas.item.get_nombre)
				io.put_string (":")
				io.put_string (columnas.item.get_tipo)
				if not columnas.islast then
					io.put_string (", ")
				end
				columnas.forth
			end
		end

	 existenciadetabla (nombre: STRING) : BOOLEAN
		local
			existencia: BOOLEAN
		do
			if tablas.is_empty then
				Result:=false
			else
				from
					tablas.start
					existencia:=false
				until
					tablas.off
				loop
					if tablas.item.get_nombre.is_equal (nombre) then
						existencia:=true
					end
					tablas.forth
				end

				Result:=existencia
			end
		end

	borrartabla (nombre: STRING)
		require
			not get_tablas.is_empty
		do
			from
				tablas.start
			until
				tablas.off
			loop
				if tablas.item.get_nombre.is_equal (nombre) then
					tablas.prune (tablas.item)
				end
				if not tablas.off then
					tablas.forth
				end
			end
		end

	verificarnumerocolumnas(nombredetabla: STRING; datos : LIST[STRING]) :BOOLEAN
		local
			tabla:TABLA
			numerocolumnasvalido:BOOLEAN
		do
			from
				tablas.start
				numerocolumnasvalido:=false
			until
				tablas.off
			loop
				tabla:= tablas.item
				if tabla.get_nombre.is_equal (nombredetabla) and tabla.get_numerofilas.is_equal (datos.count) then
					numerocolumnasvalido:=true
				end

				tablas.forth
			end
			Result:=numerocolumnasvalido
		end

	ins(nombredetabla:STRING; datos : LIST[STRING])
		require
			not get_tablas.is_empty
		local
			tabla:TABLA
		do
			from
				tablas.start
			until
				tablas.off
			loop
				tabla:=tablas.item
				if tabla.get_nombre.is_equal (nombredetabla) then
					if tabla.verificardatos(datos) then
						tabla.agregarfila (datos)
						io.put_string ("%TLos datos se insertaron correctamente")
				    	io.put_new_line
				    else
				    	io.put_string ("%TEl id ingresado ya existe")
				    	io.put_new_line
					end

				end

				tablas.forth
			end
		end

	verificarexistenciadetabla(nombretabla: STRING):BOOLEAN
		local
			existencia:BOOLEAN
		do
			if tablas.count>0 then
				from
					tablas.start
					existencia:=false
				until
					tablas.off
				loop
					if tablas.item.get_filas.count>0 and tablas.item.get_nombre.is_equal (nombretabla) then
						existencia:=true
					end
					tablas.forth
				end
				Result:=existencia
			else
				Result:=false
			end
		end

	listar(nombretabla:STRING)
		require
			not get_tablas.is_empty
		do
			from
				tablas.start
			until
				tablas.off
			loop
				if tablas.item.get_nombre.is_equal (nombretabla) then
					tablas.item.mostrarcolumnas
				end
				tablas.forth
			end
		end

	listar_condicion(nombretabla,campo,operador,condicion:STRING)
		require
			not get_tablas.is_empty
		do
			from
				tablas.start
			until
				tablas.off
			loop
				if tablas.item.get_nombre.is_equal (nombretabla) then
					tablas.item.mostrarcolumnasporcondicion(campo,operador,condicion)
				end
				tablas.forth
			end
		end

	elim(nombretabla,campo,operador,condicion:STRING)
		require
			not get_tablas.is_empty
		do
			from
				tablas.start
			until
				tablas.off
			loop
				if tablas.item.get_nombre.is_equal (nombretabla) then
					tablas.item.elim(campo,operador,condicion)
				end
				tablas.forth
			end
		end


feature -- User input
	execute_cmd (s:STRING)
		local
			cantidadletras: LIST[STRING]
			insertardatos: LIST[STRING]
			posicion, nombre, tipo, campo, operador, condicion: STRING

		do
			cantidadletras := s.split (' ')

			cantidadletras.start
			posicion := cantidadletras.item
			if comandoenejecucion.is_equal ("creartab") then
				if posicion.is_equal ("defcol") then
				    if cantidadletras.count<3 then
				    	io.put_string ("%TError: Ingrese nombre y tipo de columna")
				    	io.put_new_line
				    else
				    	cantidadletras.forth
						nombre:=cantidadletras.item
						cantidadletras.forth
						tipo:=cantidadletras.item

						if tipo.is_equal ("str") or tipo.is_equal ("int") then
							if nuevatabla.existenciadecolumna(nombre) then
								io.put_string ("%TError: Columna repetida")
				    			io.put_new_line
				    		else
				    			defcol (nombre,tipo)
							end
						else
							io.put_string ("%TError: Tipo de dato invalido")
				    		io.put_new_line
						end
				    end
				elseif posicion.is_equal ("fincreartab") then
					if nuevatabla.get_filas.is_empty then
						io.put_string ("%TError: Tabla vacía")
				    	io.put_new_line
					else
						if cantidadletras.count<2 then
							fincreartab
							comandoenejecucion:="none"
						else
							cantidadletras.forth
							nombre:=cantidadletras.item
							if nuevatabla.existenciadecolumna(nombre) then
								fincreartabcolumn(nombre)
								comandoenejecucion:="none"
							else
								io.put_string ("%TError: Columna inexistente")
				    			io.put_new_line
							end
						end
					end
				else
				    io.put_string ("%TIngrese un comando valido%N")
				end
			else
				if posicion.is_equal ("creartab") then
				    comandoenejecucion:="creartab"
				    if cantidadletras.count<2 then
				    	comandoenejecucion:="none"
				    	io.put_string ("%TError: Ingrese un nombre para la tabla")
				    	io.put_new_line
				    else
				    	cantidadletras.forth
				    	nombre:=cantidadletras.item
				    	if existenciadetabla(nombre) then
				    		comandoenejecucion:="none"
				    		io.put_string ("%TError: Nombre de tabla duplicado")
				    		io.put_new_line
				    	else
				    		creartab(nombre)
				    	end

				    end

				elseif posicion.is_equal ("desc") then
					if tablas.is_empty then
						io.put_string ("%TError: No se han creado tablas")
				    	io.put_new_line
					else
						if cantidadletras.count<2 then
							mostrartablas
						else
							cantidadletras.forth
							nombre:= cantidadletras.item
							if existenciadetabla(nombre) then
								mostrartabla(nombre)
							else
								io.put_string ("%TError: No existe una tabla con ese nombre")
				    			io.put_new_line
							end
						end
					end
				elseif posicion.is_equal ("borrartab") then
					if tablas.is_empty then
						io.put_string ("%TError: No se han creado tablas")
				    	io.put_new_line
					else
						if cantidadletras.count<2 then
							io.put_string ("%TError: Ingrese el nombre de la tabla")
				    		io.put_new_line
						else
							cantidadletras.forth
							nombre:=cantidadletras.item
							borrartabla(nombre)
						end
					end
				elseif posicion.is_equal ("ins") then
				if tablas.is_empty then
					io.put_string ("%TError: No se han creado tablas")
			    	io.put_new_line
				else
					if cantidadletras.count<3 then
						io.put_string ("%TError: Formato invalido para ingresar datos")
			    		io.put_new_line
					else
						cantidadletras.forth
						nombre:=cantidadletras.item
						from
							cantidadletras.forth
							campo:=""
						until
							cantidadletras.off
						loop
							if cantidadletras.item.is_equal(cantidadletras.last) then
								campo:=campo+cantidadletras.item
							else
								campo:=campo+cantidadletras.item+" "
							end
							cantidadletras.forth
						end

						insertardatos:= campo.split (';')
						if verificarnumerocolumnas(nombre,insertardatos) then
							ins(nombre, insertardatos)
						else
							io.put_string ("%TError: Cantidad de datos no concuerda con la cantidad de columnas")
			    			io.put_new_line
						end

					end
				end
				elseif posicion.is_equal ("listar") then
				if tablas.is_empty then
					io.put_string ("%TError: No se han creado tablas")
			    	io.put_new_line
				else
					if cantidadletras.count<2 then
						io.put_string ("%TError: Ingrese el nombre de la tabla")
			    		io.put_new_line
					elseif cantidadletras.count<3  then
						cantidadletras.forth
						nombre:=cantidadletras.item
						if verificarexistenciadetabla(nombre) then
							listar(nombre)
						else
							io.put_string ("%TError: No se han agregado datos en la tabla")
			    			io.put_new_line
						end
					elseif cantidadletras.count>4 then
						cantidadletras.forth
						nombre:=cantidadletras.item
						cantidadletras.forth
						campo:=cantidadletras.item
						cantidadletras.forth
						operador:=cantidadletras.item
						cantidadletras.forth
						condicion:=cantidadletras.item
						if verificarexistenciadetabla(nombre) then
							listar_condicion(nombre,campo,operador,condicion)
						else
							io.put_string ("%TError: No hay datos en la tabla")
			    			io.put_new_line
						end
					end
				end
				elseif posicion.is_equal ("elim") then
							if tablas.is_empty then
								io.put_string ("%TError: No se han creado tablas")
						    	io.put_new_line
							else
								if cantidadletras.count>4 then
									cantidadletras.forth
									nombre:=cantidadletras.item
									cantidadletras.forth
									campo:=cantidadletras.item
									cantidadletras.forth
									operador:=cantidadletras.item
									cantidadletras.forth
									condicion:=cantidadletras.item
									if verificarexistenciadetabla(nombre) then
										elim(nombre,campo,operador,condicion)
									else
										io.put_string ("%TError: No hay datos en las tablas")
						    			io.put_new_line
									end
								else
									io.put_string ("%TError: Ingrese nombre de tabla y condicion para eliminar")
						    		io.put_new_line
								end
							end
				else
					comandoenejecucion:="none"
				    io.put_string ("%TIngrese un comando válido%N")
				end
			end
		end

feature {NONE} --Implementation
	tablas: LINKED_LIST[TABLA]
	comandoenejecucion: STRING
	nuevatabla: TABLA

end
